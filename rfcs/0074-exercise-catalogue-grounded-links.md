---
title: A mapped exercise catalogue, grounded by movement pattern
authors: [Peter Petrov]
created: 2026-09-27
last_updated: 2026-10-04
status: in progress
status_note: Grounded (31 patterns, ten forks decided), catalogue written (270 lifts, v2.1.21), audit drafted. Waiting on Peter for where the catalogue lives, the movement question's shape, and a go for the database steps.
label: feature
---

# RFC 0074: A mapped exercise catalogue, grounded by movement pattern

## Progress log

- 2026-10-04: picked as the next task. Admin left the app the same day in
  v2.1.19 ([0090](done/0090-admin-out-mobility-in.md)), so this RFC no longer
  leans on an in-app mapping editor: the catalogue is now the only way a new
  exercise gets links without a hand-written SQL edit. Four `/ground` runs
  (lower body, upper push, upper pull, trunk and carries) landed in
  [grounding/0074-exercise-catalogue.md](../grounding/0074-exercise-catalogue.md):
  31 patterns, ten forks with a default each. Peter took all ten defaults
  the same morning (inventory D46–D55); row 7.6 now reads partially
  supported. The movement patterns and the first 60 catalogue rows (every
  lift already in the database) are committed in the code repo with the
  standing check; the audit diff is in [0074/audit.md](0074/audit.md), not yet
  applied.
- 2026-10-04: Peter settled both open questions on decision cards: the
  catalogue is **about 250** lifts (270 committed, v2.1.21), and a name the
  catalogue does not know gets **one movement question** on Weights, links
  inherited from the answer. Two follow-up calls are with him: whether the
  catalogue is read from the committed file or copied into the database, and
  the shape of the movement question.

## Summary

Seed a catalogue of the common lifting exercises with their muscle links, their
movement pattern and their alias spellings, so an exercise typed for the first
time is usually already mapped. Ground the links **per movement pattern**, not
per row: a curl is elbow flexion, and elbow flexion does not train the lats,
whatever an individual row says. Every link gets provenance (who wrote it,
when, and from which build), and the links already in the database are audited
against their pattern.

## Motivation

The muscle read — the Home body map, the Adaptations maps, the recovering flag
— is only as good as `exercise_muscle_groups`. Two ways that table goes wrong
showed up in a single session on 2026-09-27:

1. **A wrong link, and no way to learn where it came from.** *Machine Curl*
   carried *Lats, level 2*. A curl session therefore marked the lats as
   recovering for 48 h (`RECOVER_DAYS`) and credited them half a set per curl
   set. No migration or script writes that row, and the table has no
   `created_at` or `origin` column, so the source cannot be found — a misclick in
   the Admin mapping editor is the likeliest explanation, but only a guess. The
   link was removed by hand the same day.
2. **Links missing.** A new exercise (*Arm Extension*, now *Machine Arm
   Extension*) was logged with no links, and *Leg Press* had sat unmapped since
   it was first logged nine days earlier. Every set on an unmapped exercise
   counts for nothing on the muscle read, and nothing says so — the map just
   reads as a shortfall. [0043](done/0043-scout-named-exercises-catalogue.md)
   fixed fourteen of these on 2026-09-03; they come back with every new name.

Both scale badly. The catalogue today is 112 exercises, 102 of them mapped with
265 links (2026-09-27); the grounding inventory still lists the table as row 7.6,
"179 rows, **unknown**, no brief". Every link is a claim ("this exercise trains
this muscle at this level"), and none of them has been checked against a source.
The level *weights* are grounded (7.1: level 1 = 1 set, level 2 = 0.5, level 3 =
0, [0042](done/0042-level-3-link-audit.md)); what those weights are applied to is
not. And the product goal in [0044](done/0044-exercise-name-aliases.md) — other
users, typing names the catalogue did not anticipate — multiplies both
problems: a stranger will not open an Admin editor to map their exercises.

**Doctrine checklist (§4).**

1. *Which read does this sharpen?* The muscle read (Home map, Adaptations
   per-muscle maps, the recovering flag). No new surface.
2. *What does it let me stop doing?* Hand-mapping each new exercise in Admin,
   and hand-auditing the table after a surprising read.
3. *Input or destination?* Input — rows under an existing read.
4. *Honest shape of the data?* Spatial and per exercise: a set of (muscle,
   level) pairs, inherited from the exercise's movement pattern.
5. *Does it write a number claiming physiological meaning?* **Yes** — every
   link is a classification claim ("a leg press trains the adductors at level
   2"), gated on the same terms as a coefficient since
   [0066](done/0066-inventory-definitional-rows.md). It needs `/ground` before
   implementation; see Proposal §2.

## Goals

- Typing a common lifting exercise for the first time finds a mapped catalogue
  row (directly or through an alias) instead of creating an unmapped one.
- Every link traces to a grounded pattern, or carries a written reason why it
  departs from its pattern.
- Every link row records where it came from and when, so the next surprising
  link can be traced in one query.
- Inventory row 7.6 moves from `unknown` to `grounded` (or to a stated partial).

## Non-Goals

- Inferring links from a name at runtime (by string match or a model). A
  catalogue is decided by a person and committed, the way
  [0073](done/0073-garmin-sync-every-activity-type.md) commits Garmin's sport list.
- Cardio, sport and mobility movements. This is the weights catalogue;
  mobility links (the `recovery` contribution) keep their own model.
- New weights for the levels. 7.1 is grounded and stays as it is.
- A new surface, setting or admin screen (doctrine R1, R3). Admin left in
  v2.1.19 and comes back only through its own RFC.
- A per-user override layer. With one user, a link is fixed in place.

## Proposal

### 1. Provenance on links (small, first, independent)

Add `origin` (the build tag every other user-written table carries, per
[0037](done/0037-row-origin-tagging.md)), `created_at default now()` and
`source` (`catalogue` | `editor` | `migration`) to `exercise_muscle_groups`.
Admin and its editor left the app in v2.1.19
([0090](done/0090-admin-out-mobility-in.md)); whatever writes a link from the
app later (the create flow, if Unresolved question 2 lands that way) writes
through `withOrigin` with `source = 'editor'`, and a hand-written SQL edit
uses `source = 'migration'`. This is additive and safe under the migration policy
([0024](done/0024-staging-shared-database-safety.md)). Existing rows get
`source = 'migration'` and a null `created_at`: their history is unknown, and
the column says so rather than inventing a date.

### 2. Ground the patterns, not the rows

`movement_patterns` already exists with eleven rows (Squat, Hip Hinge, Lunge,
Horizontal/Vertical Push and Pull, Carry, Rotation, and two Isolation buckets),
and `exercises.movement_pattern_id` exists — but no exercise sets it. Two
changes:

- **Split the Isolation buckets by joint action.** "Isolation — Upper" holds
  curls, extensions and raises; those train different muscles, so one link set
  cannot serve them. Proposed: elbow flexion, elbow extension, shoulder
  abduction (lateral raise), shoulder horizontal abduction (reverse fly, face
  pull), shoulder extension (straight-arm pulldown, pullover), knee flexion,
  knee extension, hip extension/abduction isolation, plantar flexion, trunk
  flexion. The final list is a Grounding output, not a guess here.
- **Each pattern gets one grounded link set**: which muscles at which level,
  with sources in a `## Grounding` block produced by `/ground`
  (`science-scout`), in the same shape as [0042](done/0042-level-3-link-audit.md).
  Roughly twenty patterns to scout instead of several hundred rows.

An exercise inherits its pattern's links. Where a variant really differs (a
close-grip bench shifts load to the triceps, a Bulgarian split squat vs a
lunge), the exercise row carries its own links **and a one-line reason**,
reviewed like any other claim.

### 3. The catalogue

A committed list — the source of truth is a file in the code repo, seeded by a
tracked data migration — of the common barbell, dumbbell, cable, machine and
bodyweight lifts, each with canonical name, pattern, links (inherited or
overridden with a reason) and alias spellings for the
[0044](done/0044-exercise-name-aliases.md) resolver. Rows are `is_system = true`,
`user_id null`, `source = 'catalogue'`. The picker already reads the catalogue
(0043), so nothing new is needed on screen.

The pending *Leg Press* mapping lands here as the first Squat-pattern row,
rather than as an ungrounded hand edit.

### 4. Audit what is already there

Assign every existing exercise a pattern and diff its links against the
pattern's set. Each difference is either a documented override or a fix. A link
the pattern rules out (a Lats link on an elbow-flexion exercise) is the class of
error that started this RFC; the audit is how the ones nobody has noticed yet
are found. Duplicates the aliases expose (*Tricep Extensions*, *Incline
Dumbbell Tricep Extension*, *Machine Arm Extension*) are merged or aliased in
the same pass.

### 5. A standing check

A test in the code repo that reads the committed catalogue file and fails when
an exercise has links that neither match its pattern nor carry a reason. It
protects the file, not the live table; the provenance columns cover edits made
in the app.

## Hand edits before the catalogue (2026-09-29)

Made on the shared database by Peter's call during a review of a day's new
mappings. None of them is grounded by this RFC yet. §4's audit re-checks each
against its pattern, and may reverse it.

| Exercise → muscle | Was | Now | Why |
|---|---|---|---|
| Leg Press → Adductors | 3 | **2** | Same squat pattern as Back Squat, Goblet Squat and Bulgarian Split Squat, which [0042](done/0042-level-3-link-audit.md) rows 10–12 moved to 2. Leg Press was created after that audit. This is the "pending Leg Press mapping" in §3, done by hand rather than from the catalogue. |
| Lateral Lunge → Quadriceps | 2 | **1** | The working knee flexes to about 90° under load, like a single-leg squat. Adductors stay at 1. |
| Back Extension → split in two | Erectors 1, Glutes 2, Hamstrings 2 | two rows | The first variant override §2 anticipates. **Back Extension (flat-back)**: Glutes 1, Hamstrings 1, Erectors 2. The spine is held still and the hip moves. The existing row was renamed, so its sessions moved with it, and its aliases (plus the old name) point to it. **Back Extension (round-back)**: Erectors 1, Glutes 2, Hamstrings 2. The spine moves through its range. |

**Found, not yet fixed:** *Lat Raises* was used for lat pulldowns (40–70 kg,
five sessions 2026-03-11 → 08-11), yet it carries lateral-raise links (Lateral
Deltoid 1, Anterior Deltoid 2), and the system aliases *Lateral Raises* and
*Side Raises* point to it. A correctly mapped *Lat Pulldown* exists with no
sessions, and a *Dumbbell Lateral Raise* was created on 2026-09-29. It is the
same class of error as the curl-with-lats link in §Motivation: a name that reads
two ways.

## Rationale

- **Per-row grounding** (scouting every link) is honest but does not scale to
  a catalogue, and the sources do not speak per exercise anyway: EMG and
  hypertrophy studies speak about movements — "rows and curls train the biceps
  alike" is a claim about patterns. Grounding at the level the evidence
  exists is the more honest choice, not only the cheaper one.
- **Hand-mapping on demand** (today) produced both of this RFC's failures in
  one session, and it cannot work for a second user.
- **An import from a public exercise database** was considered as the seed.
  Their muscle lists are unsourced and their "secondary" tiers do not match
  ours, so they would add hundreds of unknown claims under one import. They are
  still a fine source for names and aliases.
- **Provenance first** because it costs one migration, needs no grounding, and
  would have answered "how did Lats get onto a curl?" on the day it was asked.

## Grounding

Four science-scout runs on 2026-10-04, one decision each: L (lower body), P
(upper push and shoulder isolation), U (upper pull), T (trunk, carries and
Olympic lifts). The verbatim blocks, the consolidated table of 31 pattern link
sets and the ten forks live in
[grounding/0074-exercise-catalogue.md](../grounding/0074-exercise-catalogue.md#grounding);
grounding blocks travel there and are never copied here.

**Verdicts.** Supported: squat, hip thrust, knee extension and flexion, calf
raise, horizontal push, elbow extension and flexion. Partially supported:
hinges, vertical push, raises, fly, both pulls, rear-delt work, straight-arm
pulldown, crunch, leg raise, plank. Convention only: lunge, hip abduction and
adduction, front raise, shrug, dips, rotation, side plank, carries, Olympic
lifts.

**What it changes on live rows** (each lands through §4's audit, not by hand):
Back Squat, lunges and Hip Thrust Hamstrings 2 → 3 (hamstrings did not grow in
squat or hip-thrust trials); Leg Press Glutes 2 → 1 (+15 % glute max in the
one MRI trial); Leg Curl Calves 2 → 3; Deadlift Erectors 1 → 2; Dips Triceps 1
→ 2; Bench Dip Chest 2 → 3; rows' Rhomboids and Upper Back / Traps 2 → 1 and
Posterior Deltoid added at 2; Face Pulls Rotator Cuff 1 → 2 with Posterior
Deltoid 2 → 1; Decline Sit Ups Hip Flexors 2 → 1; Woodchop and Pallof Rectus
Abdominis 2 → 3; Snatch Anterior Deltoid 2 → 3. *Machine Curl* and every other
curl carry no back link: the lats do not cross the elbow.

**Found on the way:** *PJR Pullover / Cable Extension* names two different
lifts (a lying triceps extension and a straight-arm pulldown) on one row, the
same class of error as *Lat Raises*; the audit splits it by its sessions.
*Crossbody Pronated Curl* is an elbow-flexion lift, not wrist work.

## Acceptance

- [ ] `exercise_muscle_groups` has `origin`, `created_at` and `source`; every
      path that writes a link sets all three (verified by reading back a row
      the seed wrote and, if the create flow writes links, one it wrote).
- [x] A `## Grounding` section in this RFC covers every movement pattern's link
      set, produced by `/ground`, and `grounding-inventory.md` row 7.6 is
      updated from it.
- [ ] Every lift in the database has a `movement_pattern_id` (mobility and power drills are out of scope, listed in the audit); every link
      either matches its pattern or carries a written reason. The audit's diff
      is recorded in a sidecar (`0074/audit.md`).
- [ ] The committed catalogue is seeded by a tracked migration; typing a
      catalogue name or one of its aliases in the Weights picker offers the
      mapped row, and logging it moves the Home map (verified in the browser).
- [ ] *Leg Press* is mapped from the Squat pattern.
- [x] The standing check exists and fails on a planted bad link.

## Unresolved questions

- ~~**Catalogue size.**~~ About 250, Peter's call on 2026-10-04.
- ~~**What happens to a name that is still not in the catalogue.**~~ Weights
  asks once which movement it is and the exercise inherits that pattern's
  links, Peter's call on 2026-10-04. Saving without an answer still works and
  leaves the lift unmapped.
- ~~**Pattern granularity.**~~ Settled by the scout runs: 31 patterns, see
  [the grounding file](../grounding/0074-exercise-catalogue.md#pattern-link-sets).
- **Where the catalogue lives.** Copied into the database as rows (this RFC's
  original §3), or read by the app from the committed file, a lift becoming a
  row on first log. With Peter.
- **The movement question's shape.** Two taps through body areas, one long
  list, or "like an exercise". With Peter.
