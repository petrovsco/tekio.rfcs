---
title: Baseline the Supabase schema into the repo
authors: [Peter Petrov]
created: 2026-08-26
last_updated: 2026-10-04
status: blocked
status_note: "Waits on Peter's yes to push one no-op migration (20261004151807_record_hand_made_open_policies, written in tekio, not committed). Everything else landed 2026-10-04: full history mirrored (tekio f9e0934, bb65559, 0a48c15; v2.1.29-2.1.32), and db diff is clean with that file included."
label: infra
---

# RFC 0016: Baseline the Supabase schema into the repo

`supabase/README.md` documents a one-time "adopt the
existing schema as a baseline" step. It has never been run: there is no
`*_remote_schema.sql` in `supabase/migrations/`, only
eight hand-written files. Until it runs, the repo and the live database are not
in sync, and the README's own "going forward" workflow rests on a baseline that
does not exist.

## The gap

Schema changes **are** tracked server-side — `supabase migration list` shows the
full history — but were historically applied straight through the dashboard or
MCP `apply_migration` and never mirrored here. The eight files in
`supabase/migrations/` are the ones written after the scaffold landed; everything
before them exists only on the server.

## The step

```bash
supabase login                                   # or export SUPABASE_ACCESS_TOKEN
supabase link --project-ref snpjfzfqjwkdwzzqfhsz
supabase db pull                                 # → supabase/migrations/<ts>_remote_schema.sql
git add supabase/migrations && git commit -m "Baseline DB schema"
```

## What `db pull` will not capture

Three changes were applied out of band and are **data**, not schema, so the
baseline will silently skip them. They are recorded in prose in
`supabase/README.md` — which is the wrong place for
something still outstanding, and the reason this brief exists.

| Applied | Kind | Captured by `db pull`? |
|---|---|---|
| `program_phases_stage1` | schema — `program_days.queue_order / is_variant / variant_group_key`, `program_week_overrides`, `mobility_exercises.exercise_id`, `user_programs.deload_committed_date` | **Yes** — folds into the baseline |
| `migrate_5day_split_to_blocks` | **data** backfill — wraps the 5-Day Split's flat days into one `weight` block each, tagging exercises `STRENGTH` | **No** — SQL preserved in the README; idempotent, already applied |
| `seed_volleyball_program_v1` | **data** seed — the active Volleyball program (9 day rows, 32 blocks, 78 tagged exercises, 2 supersets) | **No** — not reproducible from the baseline |

After the pull, decide for each data migration whether to keep it as a numbered
file in `supabase/migrations/` (idempotent, so re-running is safe) or to accept
that it lives only in the live database. Either is defensible; leaving it
undecided in a README is not.

## Risk to check first

The live database is **single-user production data with no sandbox**. `db pull`
is read-only — it generates a file, it does not write to the server — so the step
itself is safe. The thing to watch is the commit afterwards: the generated
baseline may include RLS policies that are deliberately wide open
(`USING(true)`), which is the current intentional MVP posture and must not be
"tidied up" on sight. That posture changes in
[0003-lock-the-database.md](0003-lock-the-database.md), not here.

## Acceptance

- [x] `supabase/migrations/` holds the baseline, committed. Done as the full history instead of one `_remote_schema.sql`: the 28 server-only migrations were fetched with `supabase migration fetch` (the SQL the server stored), and 13 hand-written files were renamed to the versions the server stamped. Repo and server agree on all 54.
- [ ] A fresh `supabase db diff` against the linked project reports no drift. Clean on 2026-10-04 once 20261004151807_record_hand_made_open_policies is included; that file records ten hand-made "MVP open" policies and must be pushed (a no-op on live) before this box can be ticked.
- [x] The two data migrations are committed as files (`20260621185630_migrate_5day_split_to_blocks`, `20260621191314_seed_volleyball_program_v1`), and the README's out-of-band section is reduced to the one change no migration holds (the 2026-09-09 rowing distance backfill).

## Found 2026-10-04: two files out of step with the server

Two migration files carry a different version from the one the server recorded,
so `migration list` and `db pull` will report them out of sync until the files
are renamed to the server's versions (or `supabase migration repair` is run):

| File | Server version |
|---|---|
| `20260909121125_cardio_work_distance_km.sql` | `20260909121142` |
| `20260929080000_garmin_sync_dispatch_cron.sql` | `20260929071908` |


Renamed to the server's versions on 2026-10-04 (tekio f9e0934), together with
eleven more files in the same state.

## Done 2026-10-04: replaying the history

`supabase db diff` replays every file into an empty Postgres. That first
failed: three seed migrations insert rows for the owner's profile, which an
empty database lacks. They now skip when the profile is missing (tekio
0a48c15); the live database already ran them, so nothing changed there. Two
column comments used an en dash where the live text has a hyphen; fixed in the
files. The remaining drift was ten "MVP open" policies added by hand, which
the pending no-op migration records.
