---
title: The Garmin syncs start at 08:00, not whenever GitHub gets to them
authors: [Peter Petrov]
created: 2026-09-29
last_updated: 2026-09-29
status: in progress
status_note: "Live since v2.0.104, token in Vault and proven on 2026-09-29: a dispatch from the database got `204` and started a dry run on GitHub at once. Closes after the first 08:00 run on its own."
label: infra
---

# RFC 0077: The Garmin syncs start at 08:00, not whenever GitHub gets to them

## Summary

Start both Garmin syncs from the database with `pg_cron`: a function calls
GitHub's `workflow_dispatch` API at 08:00 Europe/Sofia for the activity sync
and at 08:10 for the sleep sync. The workflows keep their own `schedule:` lines
as a fallback.

## Motivation

GitHub's `schedule:` trigger is best-effort. Between 2026-09-20 and
2026-09-29 the activity sync, set for 02:00 UTC, started between 06:56 and
08:04 UTC, and on 2026-09-29 it had not started by 07:15 UTC. The sleep sync,
set for 09:00 UTC, started between 13:28 and 17:24 UTC. Home is read in the
morning, so on those mornings it read yesterday's picture. A missing session
shows up as a shortfall that isn't real, and a missing night hides the
readiness read.

Checklist (doctrine §4): it sharpens Home's recovery and adaptation reads by
making their inputs arrive before the morning look, and lets me stop starting
the sync by hand. It is an input, it adds no surface, and it writes no number.

## Goals

- Both syncs have run by 08:15 Sofia time every day, summer and winter time
  alike.
- A missed start can be diagnosed from the database without opening GitHub.

## Non-Goals

- Changing what the syncs fetch or write.
- Removing the GitHub cron lines. They stay as the fallback, and the sleep
  sync's 09:00 UTC line also catches a night the watch had not synced by 08:10.

## Proposal

[`supabase/migrations/20260929080000_garmin_sync_dispatch_cron.sql`](https://github.com/petrovsco/tekio/blob/develop/supabase/migrations/20260929080000_garmin_sync_dispatch_cron.sql):

- enables `pg_cron` and `pg_net`;
- `public.dispatch_garmin_sync(workflow)` returns at once unless it is hour 08
  in Europe/Sofia, then reads `github_actions_dispatch_token` from Vault and
  posts `{"ref": "develop"}` to the workflow's `/dispatches` endpoint. Execute
  is revoked from `anon` and `authenticated`, because a function in `public`
  is otherwise an RPC;
- two jobs, `0 5,6 * * *` for activities and `10 5,6 * * *` for sleep. Of the
  two UTC slots, exactly one is 08 in Sofia, whichever the season.

The token is a fine-grained GitHub token on `petrovsco/tekio` with Actions:
read and write, inserted by hand. The steps are in the code repo's
`scripts/garmin-sync/README.md`, step 4.

## Rationale

- **More GitHub cron slots**: no token needed, but it still depends on the
  same best-effort queue that is late by hours. Rejected.
- **An outside scheduler** (cron-job.org, a Vercel cron): works, but adds a
  third service holding the token. Supabase is already in the stack and
  already holds the sync's secrets.
- **Ten minutes apart**: both syncs refresh the same rotating Garmin token in
  `integration_tokens`. Started in the same second, one could spend a refresh
  token the other has just rotated, which is the failure that broke the sync
  for weeks (RFC 0017).
- **Hour check in the function, not the schedule**: pg_cron is UTC-only. Two
  slots plus a Sofia-hour guard make daylight saving need no edit.

## Acceptance

- [x] `cron.job` lists both jobs, active.
- [x] `anon` and `authenticated` cannot execute `dispatch_garmin_sync`.
- [x] `github_actions_dispatch_token` is in Vault, and a dispatch sent with it
      from `net.http_post` got `204` and started a run (2026-09-29, 07:34 UTC,
      `dry_run=true`).
- [ ] On the next morning, `net._http_response` shows two `204`s, and
      `gh run list` shows a `workflow_dispatch` run of each sync started
      between 08:00 and 08:15 Sofia time.

## Unresolved questions

- The token expires. When it does, the dispatch returns `401` and only the
  GitHub fallback runs, with nothing to say so. Note the expiry date when it is
  created.
