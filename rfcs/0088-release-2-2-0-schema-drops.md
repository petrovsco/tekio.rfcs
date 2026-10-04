---
title: Release-blocked schema drops for 2.2.0
authors: [Peter Petrov]
created: 2026-10-02
last_updated: 2026-10-04
status: blocked
status_note: "Waits for 2.2.0 to reach master: the build there still reads every table queued below. Dropping the program tables also deletes the two stored programs (exported 2026-10-02), and dropping water_logs deletes the logged water, so the sweep needs Peter's word on both first."
label: infra
depends: [87, 89]
release: 2.2.0
---

# RFC 0088: Release-blocked schema drops for 2.2.0

## Summary

The queue of schema that `develop` stopped reading during 2.2.0 and `master`
still reads. Running it is the release sweep, step 6 of the release procedure
in the code repo's `CLAUDE.md`, under the migration policy in its
`supabase/README.md` ([0024](done/0024-staging-shared-database-safety.md) says
why; [0080](done/0080-release-2-1-0-schema-drops.md) is the previous queue).

## Motivation

Staging and production share one database. A table `develop` no longer reads
can still be selected by `master`'s `bootstrap()`, and dropping it early breaks
production. So the code change ships at once and the drop waits here.

## Goals

- Every table and column below is gone after 2.2.0 reaches `master`.
- Nothing that 2.2.0 reads is touched.

## Non-Goals

- Deleting rows by their `origin` tag, or any other row cleanup. That never
  happens in a sweep.

## Proposal

### The queue

| Schema | Stopped being read | Still read by | Safe to drop once |
|---|---|---|---|
| `programs`, `program_phases`, `program_days`, `program_day_blocks`, `program_day_exercises`, `program_day_sets`, `program_supersets`, `program_goal_links`, `program_cycles`, `program_week_overrides`, `user_programs`, `progression_adjustments` | v2.1.17 ([0087](done/0087-remove-program.md)): Program removed | `master`'s `loadProgramData` at bootstrap | `master` runs 2.2.0 or later, and Peter has said the stored programs may go |
| `training_sessions.user_program_id`, `training_sessions.program_day_id` | v2.1.17 (0087); both columns are null on every row (checked 2026-10-02) | nothing reads them; their foreign keys point at the program tables | together with the program tables |
| `assistant_settings` | v2.1.17: the in-app assistant was deleted ([0034](done/0034-v2-1-candidates-tbc.md)) | `master`'s two deployed edge functions `assistant-chat` and `assistant-settings` | `master` runs 2.2.0, and the two functions are deleted from the Supabase project first |
| `water_logs` | v2.1.18: water logging removed ([0089](done/0089-remove-water-and-weights-chips.md)) | `master`'s `loadWater` at bootstrap | `master` runs 2.2.0, and Peter has said the logged water may go (an export first if he wants one) |

**Rows go with the program tables.** Unlike a column drop, dropping these
tables deletes what they hold: two paused programs, exported on 2026-10-02 to
the project's shared files (`exports/tekio-programs-2026-10-02.*`) before the
code went. The rebuilt Program (0087's successor) may want a different schema
anyway, but the call is Peter's.

### The migration, when it runs

```sql
alter table training_sessions drop column user_program_id, drop column program_day_id;
drop table if exists
  program_week_overrides, program_cycles, progression_adjustments, program_goal_links,
  program_supersets, program_day_sets, program_day_exercises, program_day_blocks,
  program_days, program_phases, user_programs, programs
  cascade;
drop table if exists assistant_settings;
drop table if exists water_logs;
```

Applied with `apply_migration`; the file is named after the version Supabase
stamps on it (`list_migrations`).

## Rationale

Same as 0080: one queue per release keeps the sweep a single tracked
migration.

## Acceptance

- [ ] 2.2.0 is on `master` and verified (release step 5)
- [ ] Peter has said the stored programs may be dropped with their tables
- [ ] Peter has said the logged water may be dropped with `water_logs`
- [ ] The two assistant edge functions are deleted from the Supabase project
- [ ] The migration above ran as one tracked migration, and `develop` and
  `master` both still boot

## Unresolved questions

- Drop the program tables at 2.2.0, or keep them (unread) until the rebuilt
  Program decides its schema? Default: drop, since the export keeps the
  content.
