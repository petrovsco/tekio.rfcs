---
title: Remove Admin, put Mobility in the bottom bar, fix the max heart rate inputs
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: done
status_note: "Peter's call on 2026-10-04; landed on develop as v2.1.19 the same day. No schema follows: every table Admin edited is still read by the app."
label: feature
release: 2.2.0
---

# RFC 0090: Remove Admin, put Mobility in the bottom bar, fix the max heart rate inputs

## Summary

Three small changes from one review of the phone build. The Admin screen
leaves the app, to be rethought from the ground up later. Mobility takes the
bottom-bar slot Program left in v2.1.17. On Profile, the max heart rate field's
label shrinks to one line so its input sits level with the birth date beside it.

## Motivation

- **Admin** was a hardcoded menu entry with no gate: anyone past the cookie
  gate saw it and could edit the shared taxonomy (adaptation targets, muscle
  groups, exercise→muscle links). Its own header said it was meant to sit
  behind an admin role "once permissions land", and none ever did. A real user
  must never see it, and Peter wants admin designed properly rather than
  patched.
- **Mobility** is one of the three capture sections but was the only one not
  one tap away. Program's removal freed the slot.
- **The heart rate inputs**: on a phone-width screen the label "Another device
  or a test (bpm)" wrapped to two lines and pushed its input below the birth
  date input.

## Goals

- No Admin entry in the menu, no Admin tab, no taxonomy editors in the bundle.
- The bottom bar reads Home · Weights · Cardio · Mobility · More.
- Both max heart rate inputs sit on one line at phone width.

## Non-Goals

- Any database change. `adaptation_targets`, `muscle_groups`,
  `exercise_muscle_groups` and `exercises` all stay, and the app still reads
  every one of them, so nothing joins [0088](0088-release-2-2-0-schema-drops.md).
- A replacement admin surface. When it comes back it answers doctrine §4 as a
  new RFC, with a real role gate.

## Proposal

Code (tekio, v2.1.19): delete `AdminTab` and the three editors in
`tabs/admin/`, the Admin drawer item, tab, title and icon, the store's
`exerciseNames`, `reloadMuscleData` and `reloadAdaptationTargets`, and the
write helpers only the editors called (`updateAdaptationTarget`,
`setExerciseAdaptation`, the exercise→muscle row CRUD, `createExercise`, the
muscle-group CRUD). Add Mobility to `BottomNav`. Relabel the max heart rate
input "Measured max (bpm)" and align the pair's grid to the bottom, so a wrap
on a narrower phone still keeps the inputs level.

Plan: doctrine §5 gets an Admin row (deleted), and the Habits-shelf note says
where `ExerciseMuscleEditor.tsx` went.

## Rationale

- **Gate Admin instead of deleting it.** There is no auth and one hardcoded
  user, so any gate would be a client-side flag: hiding, not securing.
  Rebuilding it from the ground up later is cheaper than maintaining a hidden
  door.
- **The cost**: until admin returns, a newly logged exercise cannot be mapped
  to its muscles in the app, so it does not count on the body map until a
  mapping row is written to `exercise_muscle_groups` directly. Adaptation
  targets and muscle groups likewise change only through the database.

## Acceptance

- [x] Drawer shows Home, Adaptations, Weights, Cardio, Mobility and Profile &
  Settings, no Admin; bottom bar shows Mobility and it opens Mobility (browser
  walk, 412 × 915 px, stubbed empty data, 2026-10-04)
- [x] Birth date and "Measured max (bpm)" inputs share one top edge, label on
  one line (same walk)
- [x] `npm run build`, `npm run test` (193 passed), `npm run lint` (no errors),
  `npm run knip` (nothing reported) green on v2.1.19
- [x] Doctrine ledger updated in the same session
- [x] v2.1.19 on `develop`

## Unresolved questions

None.
