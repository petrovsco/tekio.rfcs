---
title: Lock the database — real logins, and rows only their owner can read
authors: [Peter Petrov]
created: 2026-07-08
last_updated: 2026-10-20
status: in progress
status_note: "Started 2026-10-20 as the first build step of 3.0.0. Step 1 is live, step 2 is tekio PR #26, the first login is adopted, the Auth URL settings are saved and the gate's blank page after a link is fixed; a real sign-in on the preview comes next. The lock, step 4, waits until the build with sign-in runs on master."
label: infra
release: 3.0.0
---

# RFC 0003: Lock the database — real logins, and rows only their owner can read

## Progress log

- 2026-07-08 — Supabase security alert (`rls_disabled_in_public`). RLS enabled
  on `adaptation_targets` with a matching open policy; `search_path` pinned on
  four functions. The open posture below remained.
- 2026-10-20 — kicked off from the first public release plan
  ([0093](0093-first-public-release-plan.md), workstream 2) once
  [0095](0095-backend-platform-decision.md) settled on Supabase. Audit of the
  live schema written into *Proposal*; the plan rewritten around the shared
  database (expand now, lock after the release). It waited on 0095 only for
  the platform, decided 2026-10-05; 0095's two open boxes (region,
  data-processing agreement) do not touch this work, so `depends` is dropped.
- 2026-10-20 — step 2 built: tekio PR #26 (draft, v2.2.42), checked in a
  browser against a mocked Supabase only. Step 1's migration waits on Peter's
  word; the Auth URL settings and the adoption come before the PR merges.
- 2026-10-20 — step 1 applied as migration 20261020141914 on Peter's word
  (purely additive; the drops of the old `auth.uid()` policies moved to the
  lock). Step 3's adoption done: the first login, made 14:15 UTC, carries
  `app_metadata.user_id` for the existing rows, set on Peter's word in the
  thread. Auth URL settings saved the same afternoon: Site URL
  `https://app.tekio.fyi`; redirects for staging, production, the Vercel
  previews (`tekio-*-petrovsco-projects.vercel.app`) and local dev.
- 2026-10-20 — the first real link ended on a blank page behind the staging
  gate. Its cookie was `SameSite=Strict`, so a link from a mail app arrived
  without it and the gate showed; the gate's form then posted *with* it, the
  gate passed the POST to the static files, and Vercel answered with an empty
  405. Fixed on the PR: the cookie is `Lax`, so the link skips the gate, and a
  POST from a known visitor is redirected back as a GET.

## Summary

Give Tekiō real accounts — Supabase Auth, signing in with a link sent by email —
and bind every row to its owner, so that the anon key shipped in the web bundle
grants nothing on its own. Every policy asks one function,
`app.current_user_id()`, who is asking; the existing rows stay where they are and
are adopted by the first account.

## Motivation

The database is effectively public. The anon key ships in the client bundle
(`VITE_SUPABASE_ANON_KEY`), and every user table carries a policy named
`MVP open — tighten in v1.1` that is `USING (true)` for every role. RLS is
switched on but unlatched: anyone holding the project URL and the anon key can
read, edit and delete every row. Supabase reports these as
`rls_policy_always_true`.

That was tolerable while the app had one user, a hardcoded `USER_ID` and a cookie
gate in front of it. It is not tolerable for a public release, and every other
workstream of 3.0.0 — the API ([0094](0094-one-api-shared-core.md)), the mobile
apps, the agent connector, the paid tier — needs to know who is asking.

## Goals

- A person signs in with their email address and stays signed in on that device.
- Every user-owned row is readable and writable only by its owner; catalogue
  tables are readable by any signed-in user and writable by none.
- The anon key alone reads and writes nothing but the error-report function.
- `USER_ID` is gone from the app.
- The existing rows belong to the first account without a single row being
  rewritten.
- The database stays movable: a move to another Postgres host rewrites one
  function, not every policy.

## Non-Goals

- Sign-in with Google or Apple. Email first; a provider is a later addition to
  the same screen, likely with the mobile apps
  ([0096](0096-mobile-apps.md)). Confirmed at kickoff, as 0095 asked: with
  email only, App Store guideline 4.8 does not apply; adding Google later
  brings Sign in with Apple with it.
- Account deletion and data export. Launch readiness (0093 workstream 8) owns
  them.
- A Garmin connection per user. The sync still runs as one account's scripts;
  connecting your own tracker is paid-tier work
  ([0097](0097-free-and-paid-tiers.md)).
- The Admin role gate ([0090](done/0090-admin-out-mobility-in.md)). It needs
  accounts but is its own brief.
- The API in front of the database ([0094](0094-one-api-shared-core.md)). It
  will run under the same policies, with the caller's token.

## Proposal

### The live schema, audited 2026-10-20 (v2.2.41)

- **One profile, no logins.** `user_profiles` has one row,
  `a0000000-0000-0000-0000-000000000001`, which is the app's `USER_ID`.
  `auth.users` is empty. No table references `auth.users`.
- **Every user table already has its owner.** 18 tables carry `user_id` (or, for
  `user_profiles`, `id`), all holding that one id. Nothing needs a backfill.
- **Three child tables own nothing themselves**: `session_exercises` and
  `session_sets` belong to a `training_sessions` row, `mobility_exercises` to a
  `mobility_sessions` row. Their policies reach the owner through the parent.
- **Catalogue tables**: `muscle_groups`, `movement_patterns`,
  `adaptation_targets`, `exercise_muscle_groups`, `exercise_aliases`, and the
  system rows of `exercises` and `sport_types` (`user_id IS NULL`). The app
  writes `exercise_muscle_groups` only for an exercise the user created.
- **Already closed**: `integration_tokens` (RLS on, no policy) and
  `error_reports` (written only through `report_error`, a definer function).
- **Older owner policies** on nine tables compare with `auth.uid()` directly.
  They are dead today — no request carries a user — and are replaced, not kept.
- **Functions callable by anon**: `report_error` (stays open, by design of
  [0103](0103-error-reports-to-agent-fixes.md)), `add_error_report_note`
  (dropped at the next sweep anyway), `request_garmin_sync(p_user_id)` (a
  definer function that trusts the id it is given — tightened in step 4).
- **No edge functions.** The two the old step 4 named were deleted with the
  assistant ([0034](done/0034-v2-1-candidates-tbc.md)).

### Who is asking: `app.current_user_id()`

```sql
select coalesce(nullif(auth.jwt() -> 'app_metadata' ->> 'user_id', '')::uuid,
                auth.uid())
```

The user id the data is filed under, read from the caller's token. For a new
account it is the login's own id. For an account that adopted existing rows it
is the `user_id` written into the login's `app_metadata` — a field only the
server can set, which the token carries. Every policy calls this function and
nothing else, so the login provider can change by rewriting it. The app reads
the same two fields from its session, so it needs no round trip to learn its id.

### Adoption: the first account takes the existing rows

The rows already belong to `a0000000-…-0001`, and the build on `master` keeps
reading them by that constant until the release. So the rows never move: the
first account is pointed at them instead.

1. The owner of the data asks for a sign-in link on the new build, which creates
   their login.
2. Before they open the link, one statement, run on their word, sets
   `app_metadata.user_id = 'a0000000-0000-0000-0000-000000000001'` on that
   login — the only login it is set on.
3. They open the link. Their token now names the existing id, and the app shows
   their history.

Nobody else can adopt it: `app_metadata` is not writable by the user, and a new
sign-up gets its own id and an empty app.

### Steps, in the order the shared database allows

Staging and production share one database (code repo `supabase/README.md`), and
the build on `master` has no sign-in. So the lock cannot land with the code:
it is the *contract* half of the change, and waits for `master` to run the
build that signs in.

1. **Expand — owner policies beside the open ones** (migration
   `accounts_owner_policies`). Creates schema `app` and `app.current_user_id()`,
   and adds an owner policy to every
   user table, a parent-reaching policy to the three child tables and a
   signed-in read policy to the catalogue — all `TO authenticated`. Postgres
   ORs permissive policies, so with the open ones still in place nothing changes
   for either build. Applied on Peter's word. It only adds: the nine old
   `auth.uid()` policies are dropped by the lock, because the connector holds
   any `DROP` for a confirmation it never surfaced.
2. **Sign-in in the app.** `@supabase/auth-js` joins the PostgREST client; every
   request carries the session's token instead of the anon key. With no session
   the app shows one screen: an email field and *Send sign-in link*. Profile
   gains *Sign out*. `USER_ID` is replaced by the session's user id in every
   file of `src/lib/db/`.
3. **Adopt.** The first account takes the existing rows, as above. Needs the
   Auth URL settings first (Site URL and redirect URLs for staging, production,
   the Vercel previews and local dev), which are set in the Supabase dashboard.
4. **Contract — the lock** ([0003/lock.sql](0003/lock.sql)). Drops every
   `MVP open` policy, the two public `Everyone reads` policies and the old
   `auth.uid()` ones, makes
   `request_garmin_sync` refuse any id but the caller's, and revokes it and the
   note function from anon. Runs as the release sweep of the release that puts
   step 2 on `master`, never before: the open policies are what keep the
   production build working until then.
5. **Verify.** `get_advisors(security)` shows no `rls_policy_always_true`; a
   smoke test with the anon key alone reads zero rows from a user table; a
   second test account sees none of the first account's rows.

## Rationale

- **A claim in the token, not a mapping table.** A table mapping logins to user
  ids works too, but every policy would join it, and the app would need a call
  at start-up to learn its own id before it could load anything. The
  `app_metadata` claim costs neither, and only one login ever needs it.
- **Not a login created with the old id.** Inserting a row into `auth.users`
  with a chosen id would avoid the claim, but it writes Supabase's own tables by
  hand, which their docs warn against and which breaks quietly when Auth
  changes its schema.
- **Not rewriting `user_id` to the new login's id.** The build on `master`
  filters by the constant, so production would go empty the moment the rows
  moved.
- **Email link first.** No password to store, reset or leak, and the same flow
  works on a phone and a desktop. A six-digit code in the same email is a small
  later addition for installed apps, where a link opens in the browser.
- **Parent-reaching policies, not new `user_id` columns** on the three child
  tables. A new column would need a default, a trigger and a backfill so the
  production build's inserts kept working; the `EXISTS` through the parent
  needs none, and the parent is always indexed by its key.

## Acceptance

- [x] `app.current_user_id()` exists, and every user, child and catalogue table
      has its `TO authenticated` policy (step 1)
- [ ] With no session the app shows the sign-in screen and loads no data
- [ ] A sign-in link signs the person in, and they stay signed in across reloads
- [ ] *Sign out* in Profile returns to the sign-in screen
- [ ] `USER_ID` no longer appears in `src/`
- [ ] The first account sees the full existing history after adoption (step 3)
- [ ] A second account signs in to an empty app and can log a set of its own
- [ ] The lock runs at the release sweep, after `master` signs in (step 4)
- [ ] `get_advisors(security)` lists no `rls_policy_always_true`
- [ ] The anon key alone reads zero rows from `cardio_sessions`, and the second
      account reads none of the first account's rows

## Unresolved questions

None blocking the build. When the lock runs is tied to the release that ships
sign-in to `master`; that is 3.0.0 unless Peter names an earlier one.

## Related code

- `src/constants/app.ts` — `USER_ID`, the thing the session replaces
- `src/lib/db/*` — every query filters by it
- `src/lib/supabase.ts` — the PostgREST client; the token goes in here
- `src/store/app.ts` — `bootstrap()`, which now starts from a session
