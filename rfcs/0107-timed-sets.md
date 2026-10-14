---
title: Timed sets for holds
authors: [Peter Petrov]
created: 2026-10-14
last_updated: 2026-10-14
status: backlog
status_note: Drafted with a mockup; waits on Peter's direction and on the grounding of how a hold counts in the reads.
label: backlog
---

# RFC 0107: Timed sets for holds

## Summary

Let a set be measured in seconds instead of reps, for holds such as the plank,
side plank, hollow hold, Copenhagen plank, dead hang, wall sit and L-sit. A
timed set is stored as one rep held for a number of seconds (a new nullable
`session_sets.duration_s`), entered through a **Reps / Time** switch over the
sets grid, planned the same way on the Planned card, shown as seconds wherever
sets are listed, and classified into the muscle-linked qualities by its
duration rather than by its single rep.

## Motivation

The sets grid asks for weight × reps and nothing else. A hold has no reps, so
it is logged as one rep per set, and the read then takes it at its word: a
45-second plank lands in the strength band ([1, 5] reps), on Home's body map
and in Adaptations, as a heavy set. The read is wrong in a way the user cannot
see, and the history loses the only number that mattered, how long the hold
lasted. Agents writing plans have the same gap: a planned dead hang can only
say "3 × 1".

## Goals

- An exercise can be logged in seconds, set by set, with optional added load,
  through the same form, ticks and drafts as any lift (RFC 0106 behaviour kept).
- Catalogue holds open on Time; any other exercise opens the way it was last
  logged, and the switch changes it.
- A plan can carry timed targets (`{"weight": 0, "seconds": 45}` in
  `target_sets`), and Log from a timed plan opens the form on Time. Timed lifts
  work inside supersets and circuits.
- Every place that lists sets (Last, Recent, the Planned card, the muscle
  sheet, the edit form) shows a timed set as seconds: `45 s`, or `10kg · 30 s`
  with added load.
- A timed set never feeds the personal best, the 1RM estimate or volume load;
  the personal-best line shows the longest hold instead.
- The muscle read counts a hold as one set, in the qualities its duration
  earns, per the Grounding below.
- Validation stays strict: seconds are a whole number of at least 1, an invalid
  row blocks the save, and no entry is stored without sets.

## Non-Goals

- A countdown or stopwatch on the form. The log records what happened; timing
  it is the phone's or watch's job. (Possible later RFC.)
- Distance-based sets (carries, sled pushes). Same shape, different unit; not
  asked for yet.
- Rewriting history: sets already logged as "1 rep" holds stay as they are,
  and can be fixed by hand in the edit form.

## Proposal

**Schema (expand only).** `alter table session_sets add column duration_s int
check (duration_s is null or duration_s > 0)`. A timed set writes `reps = 1`
and `duration_s = N`, so the build on `master` still reads a valid one-rep set,
exactly as such holds are logged today. Nothing is dropped or narrowed.
`planned_exercises.target_sets` is jsonb and needs no change.

**Types.** `LiftSet` gains `seconds?: number`. `SetStr` gains the same as a
string. `liftSetProblem` checks seconds instead of reps when present. One
helper `fmtSet(s)` renders a set everywhere (`45 s`, `10kg · 30 s`,
`60kg×8`), replacing the five hand-written `kg×` templates.

**Which exercises are timed.** A `TIMED_EXERCISES` set in the catalogue
(Plank, Side Plank, Hollow Hold, Copenhagen Plank, Dead Hang, Wall Sit, L-sit)
gives the default; the last logged entry of that exercise overrides it; the
switch on the form overrides both for this log. No column on `exercises`.

**Form.** A two-option segmented switch, Reps / Time, above the sets grid. On
Time the columns read *Added kg* and *Seconds*. Switching clears the column
that no longer applies on rows not yet ticked; ticked rows lock the switch.
The plan sheet carries the same switch.

**Reads.** `classifyWeightSet` takes the set, not its reps; a timed set is
classified by `duration_s` against duration bands set by the Grounding below.
`muscleStimulus` counts it as one set, like any set. `estimate1RM`, the PR
check and volume load skip timed sets.

## Grounding

Pending. A hold's seconds-to-quality mapping writes a classification claim,
so `/ground` runs before code. The science-scout is asked: which qualities a
sustained submaximal hold of ~20–90 s trains, whether short maximal holds
belong to strength, and whether a hold is one hard set toward weekly volume.

## Rationale

- **`reps = 1` plus `duration_s`, not nullable reps.** Making `reps` nullable is
  also an expand, but the build on `master` would then read `null` reps. One
  rep held for N seconds is literally what a hold is, and it keeps every old
  read valid.
- **A switch remembered per exercise, not a flag on `exercises`.** A column
  would need a migration, an editor and a backfill, and some lifts go both
  ways (a Copenhagen plank held, or pulsed for reps). The catalogue list plus
  history gets the default right without new machinery.
- **Classify by duration, not count holds as "no quality".** Leaving holds out
  of every quality would hide real work from Adaptations; counting them by
  their one rep is the bug this RFC fixes.

## Acceptance

- [ ] `session_sets.duration_s` exists live (migration applied on Peter's word).
- [ ] A plank logged as 3 × 45 s shows as seconds on Last, Recent, the edit form
      and the muscle sheet, at 412 px.
- [ ] Catalogue holds open on Time; a custom exercise logged on Time reopens on
      Time.
- [ ] A timed plan from an agent (`seconds` in `target_sets`) shows as seconds on
      the Planned card and logs on Time, inside a superset too.
- [ ] A timed set never appears as a personal best, 1RM or volume; the longest
      hold shows instead.
- [ ] A 45 s hold no longer counts as a strength set; its qualities follow the
      grounded duration bands, with tests.
- [ ] Seconds of 0, a fraction or empty block the save with a message.

## Unresolved questions

- The duration bands (Grounding, pending).
- Peter's direction on the switch-and-remember design (mockup:
  [0107/timed-sets-mockup.png](0107/timed-sets-mockup.png)).
