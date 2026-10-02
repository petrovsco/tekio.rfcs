---
title: Remove Program, to rebuild it later
authors: [Peter Petrov]
created: 2026-10-02
last_updated: 2026-10-02
status: in progress
status_note: "Peter's call on 2026-10-02 in the 0034 review. The code is built and tested as v2.1.17 on the working branch claude/project-thread-85re9p and waits for his OK to land on develop. The table drops wait for the 2.2.0 release sweep (0088)."
label: feature
release: 2.2.0
---

# RFC 0087: Remove Program, to rebuild it later

## Summary

Take the whole program concept out of the app: the Program tab, Today's Plan
and the superset logger on Weights, the 6-week cycle and its week-6 deload
(the header badge, Home's cycle label and deload verdict, the deload set
suggestions, deload-aware baselines and chart dots), program import/export,
and the cycle constants. Program is to be rebuilt later "in a better way"; this
RFC clears the ground and does not design the replacement.

## Motivation

[0034](0034-v2-1-candidates-tbc.md) asked whether the template picker was
worth its screen. The answer went further: on 2026-10-02 Peter chose to delete
the whole program concept for now and rebuild it later. Nothing ran on it at
the time — both stored programs were paused, so Home already printed "No
active program" — and the reads that make the product (Home, Adaptations)
never depended on it: their windows are `MUSCLE_WINDOW_DAYS`, by decision since
[0039 §6.6](done/0039-adaptations-read-grounding.md).

Kept, it costs a tab, a bottom-nav slot, ~5 000 lines with the assistant,
and the reading load of a cycle model that shapes nothing on screen.

## Goals

- Nothing in the app says program, cycle, week N of 6 or deload.
- Weights logs and charts exactly as before, minus the plan above the form.
- The stored programs survive as an export Peter keeps, made before the code
  went: both programs as JSON and as a page, day by day with every block and
  prescription.
- No row is deleted here. The tables stay until `master` no longer reads them,
  and what happens to them then is [0088](0088-release-2-2-0-schema-drops.md)'s question.

## Non-Goals

- Designing the rebuilt Program. That gets its own RFC when Peter asks for it,
  starting from the export and from doctrine §4.
- Deleting rows. Program rows are real data; the release sweep removes schema
  only, and only through [0088](0088-release-2-2-0-schema-drops.md).
- Supersets in history. Logged supersets keep showing and stay editable; only
  the way to *start* one goes, because the program was its only entry point.

## Proposal

Code (tekio, v2.1.17):

- Delete `ProgramTab`, `TodaysPlan`, `ExPlan`, `SupersetLogger`, `VolumeRow`,
  `MiniChart`, `lib/db/program.ts`, `lib/programImport.ts`,
  `constants/program.ts`, the program types, the store's program state and
  actions, `useVariantWeek`, `VariantChips` and `DeloadBadge`.
- Delete the cycle helpers (`cycleInfo`, `isDeloadDate`, `deloadSets`,
  `programMode`, `resolveTodayDay`, `variantGroups`, …) and the constants
  `CYCLE`, `DELOAD_WEEK`, `DELOAD_REP_FACTOR`, `DAYS_OF_WEEK`.
- `lastPerformance` no longer skips deload weeks: with no cycle there is no
  deload week to skip.
- Program leaves the drawer and the bottom nav (Home, Weights, Cardio, More).
- Export and import stop carrying a program.

Plan (tekio.rfcs): doctrine §5 ledger row Program → deleted; inventory §5
rows retired; [0070](done/0070-week-start-day-program-week.md) discarded;
[0086](0086-readiness-brings-deload-forward.md) waits on the rebuild; the
tables queued in [0088](0088-release-2-2-0-schema-drops.md).

The export lives in the project's shared files, never in either repository,
because it is one person's training plan (house rule `no-personal-context`).

## Rationale

- **Shelve under R2 instead.** Default-off and delete in six weeks. Rejected:
  Program is not a menu section the config can hide, it reaches into Weights,
  Home and the header, and Peter wants it gone now, not hidden.
- **Keep the cycle, drop only the editor.** The 6-week cycle and deload are
  meaningful only relative to a program's start date; without one they are a
  calendar fiction. The grounding (0013) stays on record for the rebuild.

## Acceptance

- [x] Both stored programs exported before any code changed, as JSON and as a
  page (2026-10-02)
- [x] No Program tab, nav entry, Today's Plan, cycle label or deload badge:
  browser walk on 2026-10-02 at 390 px (Home, Weights, Cardio, drawer, Profile)
- [x] `npm run build`, `npm run test` (198 passed), `npm run lint` (no errors)
  and `npm run knip` (nothing reported) green on v2.1.17
- [x] Doctrine ledger, inventory §5, 0070 and 0086 updated in the same session
- [ ] v2.1.17 on `develop`, with Peter's OK

## Unresolved questions

None for the removal. What the rebuilt Program should be is the next RFC's
question, not this one's.
