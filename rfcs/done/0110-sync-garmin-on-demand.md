---
title: Sync Garmin on demand from Home
authors: [Peter Petrov]
created: 2026-10-15
last_updated: 2026-10-16
status: done
status_note: Shipped on develop as tekio v2.2.34; taps from the app and the 08:00 runs all record their rows. Rides into the next release.
label: feature
---

# RFC 0110: Sync Garmin on demand from Home

## Progress log

- 2026-10-15 — Peter asked for a way to sync Garmin, or any connected
  service, when he wants to. Four placements were mocked at 412 px: a line by
  the wordmark on Home, a Sync now on the readiness sheet and Cardio, a
  Connected services card in Profile, and syncing on open with pull-down. He
  chose the Home line. The mockups are in the project files under
  `sync-on-demand/`.
- 2026-10-15 — Built: the line, the `sync_runs` table, the
  `request_garmin_sync` function, the combined `garmin-sync-now.yml` workflow,
  and a closing step on all three Garmin workflows. Checked at 412 px against
  stubbed data, with no live database reachable from the build session.
- 2026-10-15 — Migration applied on Peter's word through the Supabase
  connector, stamped 20261015061111.
- 2026-10-15 — Merged as tekio v2.2.34. The first run (started by hand) and
  Peter's tap from his phone on staging both closed their rows `ok`; the tap
  took 15 s from request to finish.
- 2026-10-16 — The 08:00 activity and 08:10 sleep runs each closed a
  `schedule` row `ok`. An early tap had synced before the watch had uploaded
  the night, so Home showed the night before's sleep score as if it were last
  night's; tekio v2.2.35–36 labels it "last night not in yet", with "last
  night" turning over at 04:00. Done.

## Summary

Home's header row prints when Garmin last reached Tekiō — "Garmin · 08:02" —
to the right of the wordmark. A tap asks Garmin again: the line turns into a
spinner and "Syncing Garmin…", and when the run finishes the nights and
sessions it brought are re-read and the line says "Garmin · just now". When no
sync has finished for a day, the line is printed in the accent.

## Motivation

Garmin reaches Tekiō once a day, at 08:00. A night slept late, a watch that
synced to the phone after eight, or a ride finished at noon is missing until
the next morning, and the verdict on Home reads without it. The only way to
pull it sooner was to run a GitHub workflow by hand, which no user can do.
Nothing on screen said how old the synced data was, either.

## Doctrine checklist (§4)

1. **Which read does this sharpen?** Home. The verdict and the readiness card
   read synced nights; the line says whether those nights are in.
2. **What does it let me stop doing?** Starting the sync workflows by hand on
   GitHub, and asking a thread to do it.
3. **Input or destination?** Neither a new read nor a section: a control and a
   freshness fact on the read that depends on it (P1). No menu slot (R1).
4. **Honest shape of the data?** A time, on the phone's clock. No count of what
   came in: a sync re-upserts the last three nights whether or not they are new,
   so a count of nights would be a count of writes.
5. **A number with physiological meaning?** No. The 24-hour stale threshold is
   the schedule's period (one sync a day), not a claim about the body.

## Goals

- One tap from Home starts a Garmin sync, with a spinner while it runs.
- The line always says when the last sync finished, whichever run it was.
- The read below updates when the sync finishes, with no reload.
- A failed or silent run says so and can be retried.
- Nobody can start syncs in a loop: the limits live in the database.

## Non-Goals

- Other providers. The line names Garmin because Garmin is the only one; a
  second provider decides then whether the line lists both or says "Synced".
- Connecting Garmin from the app. Connecting stays outside the app until the
  public release (RFC 0093 family), where Profile's Connected services card
  (mockup C) carries the same Sync now.
- Multi-user syncing. One GitHub secret and one workflow serve one user; see
  Rationale.

## Proposal

**Database** (`supabase/migrations/*_sync_runs.sql`, expand only):

- `sync_runs` (id, user_id, provider, trigger `app|schedule`, status
  `requested|ok|failed`, requested_at, finished_at), open RLS like every user
  table.
- `request_garmin_sync(p_user_id)`, security definer: returns the open run if
  one was asked for in the last 5 minutes; refuses past 20 app requests a day;
  else inserts a `requested` row and dispatches `garmin-sync-now.yml` with its
  id through `pg_net`, using the Vault token RFC 0077 already holds.

**Workflows:**

- `garmin-sync-now.yml`: activities (3 days), then sleep (3 nights), in one job;
  then `record_run.py` closes the row `ok` or `failed`.
- The two daily workflows end with `record_run.py` too, writing a `schedule`
  row, so the line reflects the 08:00 run.
- All three share the `garmin-token` concurrency group: two runs at once could
  spend a refresh token the other has just rotated.

**App:**

- `SyncLine` in Home's header row. Hidden until Garmin has synced once (and
  while the table does not exist yet). Polls the run every 4 s and gives up
  after 3 minutes with "Garmin didn't answer · tap to retry". On `ok` it
  re-reads sleep, cardio and sport through `refreshSynced`.
- The time: "just now" within a minute, the clock today, "yesterday 08:01",
  else the day ("12 Oct"). Accent after 24 hours.

## Rationale

- **Home over the readiness sheet (B), Profile (C) or syncing on open (D).**
  Peter's choice. A shows freshness before the verdict is trusted and takes one
  tap; B needs two and two places; C is where nobody looks to sync; D takes
  over the phone's pull-to-reload, and starts a run on most opens.
- **GitHub Actions behind a database function**, not a new server. The scripts,
  secrets and Vault token exist; runs take 15–50 s. A function keeps the limit
  where the browser's anon key cannot skip it.
- **Multi-user later.** `integration_tokens` is already keyed per user and
  provider. When RFC 0095 picks the backend the worker moves server-side with
  per-user tokens; Garmin's official Health API pushes data on its own, which
  makes the line mostly a freshness fact with a "check now". Only what sits
  behind `request_garmin_sync` changes.

## Acceptance

- [x] Home shows "Garmin · <time>" beside the wordmark once Garmin has synced.
- [x] A tap shows the spinner and "Syncing Garmin…", and the line reads
      "Garmin · just now" when the run closes `ok` (stubbed data, 412 px).
- [x] A day without a sync prints the line in the accent (stubbed data).
- [x] `syncWhen` and `syncStale` are unit-tested.
- [x] The `sync_runs` migration is applied to the live database
      (stamped 20261015061111, 2026-10-15).
- [x] A tap on staging starts `garmin-sync-now.yml` and closes its row
      (run 2, 2026-10-15: requested to `ok` in 15 s).
- [x] The 08:00 runs write `schedule` rows (16 Oct: activity 08:00, sleep
      08:10 Sofia time, both `ok`).
- [x] Peter checks the line on his phone on staging.

## Unresolved questions

None.
