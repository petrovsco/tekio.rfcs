---
title: Staging on the production database — guardrails
authors: [Peter Petrov]
created: 2026-08-30
last_updated: 2026-09-30
status: done
status_note: "Done 2026-09-30 (v2.0.109). The policy is written in the code repo's `supabase/README.md` and summarised in its `CLAUDE.md`. Part 3 is restated rather than withdrawn: the release sweep removes the transitional schema that lets two builds share one database — never rows. Its first queue is [0080](../0080-release-2-1-0-schema-drops.md). Part 1 moved to [0037](0037-row-origin-tagging.md)."
label: infra
depends: [37]
release: "2.1.0 — carried over: the policy is what makes a release safe on a shared database."
---

# RFC 0024: Staging on the production database — guardrails

**Origin:** Peter's answer when asked whether staging should get its own Supabase project: *"Same database, but then we need to make sure we don't break the production. Also we want to plan database cleanups on major releases so we don't have polluted database."* The cleanup half was misread as a row delete on 2026-09-05 and withdrawn; on 2026-09-30 Peter restated what it meant (Part 3).

## The decision this brief protects

Staging (`stg-tekio.shamatoff.com`, built from `develop`) talks to **the same
Supabase project as production**. That was a deliberate choice: the app has one
user and one real training log, and the reads only mean anything against real
data. A second Supabase project would mean replaying every migration twice and
keeping two schemas in step, for a database whose value is precisely that it is
the real one.

**Staging is somebody's daily app.** While the product has one user, that user
logs on `develop`'s build to test it in live conditions — 2026-09-05: *"they
were real sessions, that's why we used prod DB in staging — because I wanted to
test the app in live conditions."* So a row tagged `origin = 'staging'` is a
real row that happens
to have been written by the staging build. The tag says which build wrote it,
which is useful when a bug is found, and says nothing about whether the row
may be deleted.

The cost of the shared database is one risk, and this brief is the work that
pays it: **staging can break production.** They are the same rows. A bad
migration, a destructive query, or a half-finished feature that writes garbage
does not stay on staging — there is no staging copy to stay in.

Pollution — a throwaway entry logged to try a feature — is rare, small, and
handled by hand: delete it in the app right after the test. It never justifies
a bulk delete.

## What to build

### Part 1 — Tell staging apart → [0037](0037-row-origin-tagging.md)

Split out on 2026-09-01 and moved in full: the nullable `origin` column, the
write-once trigger, the environment resolver, and the on-screen marker. It left
because it was the only part blocking anything — [0026](0026-signal-chrome-and-primitives.md)
waited on it.

### Part 2 — Stop staging from breaking production

- **Migrations land once, from one path.** DDL is applied deliberately (see
  [0016-supabase-migration-baseline.md](../0016-supabase-migration-baseline.md)),
  never as a side effect of testing a branch. Write down that a migration is a
  production change no matter which branch inspired it.
- **Decide what staging is allowed to do destructively.** Deletes and bulk
  updates from staging hit real rows. Either the app blocks them when
  `VITE_ENV=staging`, or the risk is accepted in writing. Do not leave it
  unexamined.
- **`origin`-tagged rows are real data.** Write down that no query deletes
  rows by their `origin` tag, on any release. Before any bulk delete on this
  database, the rows are listed *with their content* and Peter confirms them
  one by one — a preview of counts and dates is not a preview of what the
  rows are.

### Part 3 — The release sweep: transitional schema, not rows

What the cleanup always meant, restated by Peter on 2026-09-30: *"The release
sweep is not about training data entered in STG. It's about temporary schema
changes that must be live only until we go to PROD."* While `develop` runs
ahead of `master`, the database carries scaffolding so both builds work — a
column the new build stopped reading but production still selects, config that
production still shows and staging has dropped, a constraint widened for the
overlap. Once production runs the new code, that scaffolding is dead weight and
goes. **Data logged from the staging app stays.**

This is the pattern [0025](0025-release-blocked-schema-drops.md) already ran for
2.0.0; it now has a name and a home. Each release gets a schema-drops brief
([0080](../0080-release-2-1-0-schema-drops.md) for 2.1.0), and step 6 of the
release procedure runs it as one tracked migration.

**The misreading, for the record.** The first version of this Part planned a
sweep of `origin`-tagged *rows* at every major release, on the assumption that
a staging row was a test row. It ran once, the evening 2.0.0 shipped, after a
preview that listed seven rows by count and date (2026-09-01 to 09-04). They
were real sessions, logged on staging on purpose, and the run deleted 2
`training_sessions` (with 9 `session_exercises` and 29 `session_sets`), 2
`sport_sessions`, 2 `water_logs` and 1 `bodyweight_logs`.
[0053](0053-recover-swept-staging-rows.md) was discarded — nothing honest
could be re-entered. The rule written below exists so it cannot happen again.

## Decisions (2026-09-30, Peter)

1. **The app's own deletes on staging are accepted in writing, not blocked.**
   Staging is a daily app on real rows; an edit or delete there is the same
   one-row action production makes. What the policy guards is schema changes
   and bulk SQL. Staging keeps exercising the delete paths.
2. **The policy lives in `supabase/README.md`**, with a summary and a link in
   `CLAUDE.md` so every session meets it. It is written about builds and roles
   — production, staging, dev, the owner of the data — never about a person,
   because it has to stay true when the product has more than one user.

## The rule, as written

Six points, in the code repo's `supabase/README.md` under *Two builds, one
schema*: a migration is a production change; expand now, contract after the
release; transitional schema is queued in the release's schema-drops brief;
that queue is the release sweep, run at step 6; the sweep removes schema,
never rows; the app's own deletes on staging are accepted.

## Acceptance

- [x] A written rule says how migrations reach production and what staging may
      not do destructively — `supabase/README.md`, points 1–2 and 6.
- [x] The same rule says that `origin`-tagged rows are real data and are never
      deleted by tag; a test entry is deleted in the app right after the test —
      point 5.
- [x] The versioning rules in `CLAUDE.md` point at the migration policy as part
      of a major release. Ticked 2026-09-07 by
      [0050](../0050-release-procedure.md): step 6 of the release checklist sends the
      reader here and says `origin`-tagged rows are never deleted by tag.
