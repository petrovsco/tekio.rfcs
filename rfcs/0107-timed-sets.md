---
title: Timed sets for holds
authors: [Peter Petrov]
created: 2026-10-14
last_updated: 2026-10-14
status: in progress
status_note: Built on branch claude/time-based-sets-fdai3p as tekio v2.2.24 and checked in the browser against fixtures; waits on Peter's word to apply the duration_s column, then the dead hang rewrite and the merge to develop.
label: feature
---

## Progress log

- 2026-10-14: drafted and grounded; Peter chose ask-once over a switch on every log, then said go and asked that existing hold logs be rewritten (the 8 Oct dead hang: 30 s a set). Built as tekio v2.2.24 on the branch; walked at 412 px against fixtures (plan log, tick write with duration_s, new-name question, plan sheet, Recent, Home read).

# RFC 0107: Timed sets for holds

## Summary

Let a set be measured in seconds instead of reps, for holds such as the plank,
side plank, hollow hold, Copenhagen plank, dead hang, wall sit and L-sit. A
timed set is stored as one rep held for a number of seconds (a new nullable
`session_sets.duration_s`). Timed is a property of the exercise: catalogue
holds are timed, and a new name is asked once, beside the movement question;
the sets grid then reads *Added kg* and *Seconds*. Timed sets are planned the same way on the Planned card, shown as seconds wherever
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
- Catalogue holds are timed; a name the app does not know asks "reps or
  time?" once, and the answer sticks to that exercise. No switch on the form.
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
marks the known holds. Any other exercise is timed when its logged sets carry
`duration_s` (or its plan's targets carry `seconds`), so the answer to the
question below sticks from the first logged set with no column on
`exercises`. The few lifts that go both ways (Pallof press and hold, a glute
bridge for reps or held) get two names.

**Form.** The `MovementQuestion` panel for an unknown name gains a second
question, "Is it counted in reps or held for time?", Reps / Time chips,
defaulting to Reps. On Time the grid's columns read *Added kg* and *Seconds*.
The plan sheet asks the same for a new name. A known exercise shows no
question and no switch.

**Reads.** `classifyWeightSet` takes the set, not its reps; a timed set is
classified by `duration_s` against duration bands set by the Grounding below.
`muscleStimulus` counts it as one set, like any set. `estimate1RM`, the PR
check and volume load skip timed sets.

## Grounding

**Claim:** a timed set is classified by the seconds held, in overlapping bands
like `repRange`, and each hold is one set toward the weekly per-muscle targets.
**Searched:** 2026-10-14 (science-scout) · **Verdict:** partially supported;
the cut-points and the one-hold-one-set rule are **convention only**.

**Numbers to use (`HOLD_BANDS_S`):** strength [1, 10] s · hypertrophy
[10, 60] s · muscular endurance [30, ∞) s. A hold counts in full for every band
it falls in, so a 45 s plank is one hypertrophy set and one muscular-endurance
set, never a strength set. The cut-points carry the existing rep bands across
at roughly 2–3 s per rep (5 reps ≈ 10–20 s, 15 reps ≈ 30–45 s, 30 reps ≈
60–90 s); no study measured seconds bands directly. Convention ranges: the
strength edge 5–15 s, the hypertrophy top 60–90 s, the endurance floor 30–45 s.

**Hard-set assumption.** As with the rep bands (039 S3), a hold is assumed to
be taken near failure. The app does not capture effort for any set, so holds
get the same assumption rather than a new field.

### Evidence

- `[literature]` Isometric training grew muscle and raised maximal force at
  every intensity studied; longer muscle lengths grew more. Systematic review,
  23 outputs — [Oranchuk et al. 2019](https://pubmed.ncbi.nlm.nih.gov/30580468/).
- `[literature]` At 70 % MVC, 4 × 30 s holds beat 4 × 10 × 3 s for strength,
  and only the long holds grew cross-sectional area. n = 7, 14 weeks —
  [Schott, McCully & Rutherford 1995](https://link.springer.com/doi/10.1007/bf00240414).
- `[literature]` At 70 % MVC, 4 × 20 s holds and 50 × 1 s contractions gave the
  same strength and volume gains. n = 8, 12 weeks —
  [Kubo, Kanehisa & Fukunaga 2001](https://pmc.ncbi.nlm.nih.gov/articles/PMC2278867/).
- `[literature]` Easy, unloaded 30 s holds between sets added little: holds
  far from failure are not hard sets. RCT, 27 trained men —
  [Schoenfeld et al. 2020](https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2019.01571/pdf).
- `[literature]` Time to failure of a static hold falls as a power function of
  %MVC, so seconds-to-failure proxies intensity the way reps-to-failure do; the
  curve is joint-specific (trunk and grip differ from shoulder) —
  [Frey-Law & Avin 2010](https://iro.uiowa.edu/esploro/outputs/journalArticle/Endurance-time-is-joint-specific-A-modelling/9984046821002771).
- `[literature]` Isometric and dynamic strength gains agree poorly (pooled ES
  0.13), so a hold credited to strength is a looser claim than one credited to
  size — meta-analysis, 11 studies, IJSPP 2024 vol. 19(1).

### Caveats

Every positive trial used high-intensity, dynamometer-measured, single-joint
holds in untrained or recreational young adults; none covers plank, dead hang
or L-sit. What would move the numbers: a trial of near-failure bodyweight holds
of different lengths, a volume model that counts isometric sets, or per-joint
endurance-time coefficients.

### Source comment

`// HOLD_BANDS_S — strength [1,10], hypertrophy [10,60], endurance [30,∞) s, 1 hold = 1 hard set: convention mapping rep bands to time under tension; long holds grow muscle (Schott 1995, Kubo 2001, Oranchuk 2019), time to failure tracks %MVC per joint (Frey-Law 2010), see tekio.rfcs/rfcs/0107-timed-sets.md#grounding`

## Rationale

- **`reps = 1` plus `duration_s`, not nullable reps.** Making `reps` nullable is
  also an expand, but the build on `master` would then read `null` reps. One
  rep held for N seconds is literally what a hold is, and it keeps every old
  read valid.
- **Ask once, not a switch on every log** (Peter, 2026-10-14). Almost no
  exercise is logged both ways: holds have names of their own, and their rep
  versions are other exercises. A switch would be a control on every log for a
  case that barely exists. Deriving "timed" from history rather than a column
  on `exercises` avoids a second migration, an editor and a backfill.
- **Classify by duration, not count holds as "no quality".** Leaving holds out
  of every quality would hide real work from Adaptations; counting them by
  their one rep is the bug this RFC fixes.

## Acceptance

- [ ] `session_sets.duration_s` exists live (migration applied on Peter's word).
- [ ] The 8 Oct dead hang reads 3 × 30 s, and today's open dead hang plan is in
      seconds.
- [ ] A plank logged as 3 × 45 s shows as seconds on Last, Recent, the edit form
      and the muscle sheet, at 412 px.
- [ ] Catalogue holds show Seconds with no question; a new name asks reps or
      time once, and a custom hold logged on Time reopens on Time.
- [ ] A timed plan from an agent (`seconds` in `target_sets`) shows as seconds on
      the Planned card and logs on Time, inside a superset too.
- [x] A timed set never appears as a personal best, 1RM or volume; the longest
      hold shows instead.
- [x] A 45 s hold no longer counts as a strength set; its qualities follow the
      grounded duration bands, with tests.
- [x] Seconds of 0, a fraction or empty block the save with a message.

## Unresolved questions

None. Mockup: [0107/timed-sets-mockup.png](0107/timed-sets-mockup.png).
