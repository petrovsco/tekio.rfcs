-- RFC 0003 step 4 (contract): the lock. NOT APPLIED.
--
-- Runs as the release sweep of the release that puts sign-in on master, and
-- never before: until then the production build reads and writes as anon, and
-- these open policies are what let it. Applied as one tracked migration
-- (`apply_migration`, name `release_<x_y_z>_lock_the_database`), its file named
-- after the version Supabase stamps on it, under code repo supabase/README.md.
--
-- Before running: the owner policies of step 1 are live (migration
-- `accounts_owner_policies`), and master's build signs in.

-- ── The open policies ──────────────────────────────────────────────────────
do $$
declare t text;
begin
  foreach t in array array[
    'adaptation_targets', 'blood_donations', 'bodyweight_logs', 'cardio_sessions',
    'cold_sessions', 'exercise_muscle_groups', 'exercises', 'mobility_exercises',
    'mobility_sessions', 'planned_exercises', 'planned_sessions',
    'readiness_inputs', 'sauna_sessions', 'session_exercises', 'session_sets',
    'sleep_logs', 'sport_sessions', 'sport_types', 'sync_runs',
    'training_sessions', 'user_profiles', 'user_section_config'
  ] loop
    execute format('drop policy if exists "MVP open — tighten in v1.1" on public.%I', t);
  end loop;
end $$;

drop policy if exists "MVP open — read only" on public.exercise_aliases;
drop policy if exists "Everyone reads movement_patterns" on public.movement_patterns;
drop policy if exists "Everyone reads muscle_groups" on public.muscle_groups;

-- ── Functions that trusted their caller ────────────────────────────────────
-- request_garmin_sync took any user id; now only the caller's own.
create or replace function public.request_garmin_sync(p_user_id uuid)
returns public.sync_runs
language plpgsql
security definer
set search_path to ''
as $function$
declare
  run public.sync_runs;
  gh_token text;
begin
  if p_user_id is distinct from app.current_user_id() then
    raise exception 'request_garmin_sync: not your account' using errcode = '42501';
  end if;

  select * into run
  from public.sync_runs
  where user_id = p_user_id and provider = 'garmin'
    and status = 'requested' and requested_at > now() - interval '5 minutes'
  order by requested_at desc
  limit 1;
  if found then
    return run;
  end if;

  if (select count(*) from public.sync_runs
      where user_id = p_user_id and trigger = 'app'
        and requested_at > now() - interval '1 day') >= 20 then
    raise exception 'Garmin has been asked 20 times today. The morning sync still runs.'
      using errcode = 'P0001';
  end if;

  select decrypted_secret into gh_token
  from vault.decrypted_secrets
  where name = 'github_actions_dispatch_token';
  if gh_token is null then
    raise exception 'request_garmin_sync: no github_actions_dispatch_token in Vault';
  end if;

  insert into public.sync_runs (user_id, provider, trigger)
  values (p_user_id, 'garmin', 'app')
  returning * into run;

  perform net.http_post(
    url     := 'https://api.github.com/repos/petrovsco/tekio/actions/workflows/garmin-sync-now.yml/dispatches',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || gh_token,
      'Accept', 'application/vnd.github+json',
      'X-GitHub-Api-Version', '2022-11-28',
      'User-Agent', 'tekio-sync-now'
    ),
    body    := jsonb_build_object('ref', 'develop', 'inputs', jsonb_build_object('run_id', run.id::text))
  );

  return run;
end;
$function$;

revoke execute on function public.request_garmin_sync(uuid) from public, anon;
grant execute on function public.request_garmin_sync(uuid) to authenticated;

-- report_error stays callable by anon on purpose (RFC 0103): a crash on the
-- sign-in screen is still reported. The note function is dropped by the next
-- sweep; if it is still here, close it.
do $$
begin
  if to_regprocedure('public.add_error_report_note(text,jsonb,text)') is not null then
    revoke execute on function public.add_error_report_note(text, jsonb, text) from public, anon;
  end if;
end $$;
