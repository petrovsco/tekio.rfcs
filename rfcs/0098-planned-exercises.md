---
title: Planned exercises — a state for work that has not happened yet
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-06
status: in progress
status_note: "Moved to 2.2.0 and started by Peter on 2026-10-05. Built and on staging since 2026-10-06 (tekio v2.1.45), with the plans table live; two boxes wait on Peter logging a plan on his phone."
label: feature
release: 2.2.0
---

# RFC 0098: Planned exercises — a state for work that has not happened yet

## Progress log

- 2026-10-05: tagged 2.3.0, ahead of the rest of the public release plan.
- 2026-10-05: moved to 2.2.0 and started, at Peter's word. Relabelled feature.
- 2026-10-05: plans get their own table rather than a status column, so the
  build on master cannot count them. The table, the Plan card on Weights and
  the never-counted test are on tekio branch `claude/project-thread-p40di1`
  (v2.1.39). The migration waits on Peter's word; the map treatment on his call.
- 2026-10-05: Peter picked the outline layer for the map, and asked for the Plan
  card to read as pending (a contour or yellow); the style is put to him.
- 2026-10-05: the layer is built (tekio v2.1.40, same branch): planned muscles
  get a dashed edge, never a fill, and one line under the map names the gaps
  the plan reaches and what is left after it. The preview takes a never-logged
  catalogue lift's links from the catalogue, the links its first log would
  write, and loads only on a day with an open plan. With a plan, Home runs
  about two lines past one 900 px screen.
- 2026-10-05: Peter's review: the card is renamed Planned (Today, Later) and
  plans are editable (tekio v2.1.41).
- 2026-10-05: Peter picked yellow; design-system §1 gains it as *planned*. A
  plan is added from "+ Add to plan" on the card, which puts the form in plan
  mode; the form's Plan it button is gone (tekio v2.1.42).
- 2026-10-06: at Peter's word, adding and editing a plan open a sheet over
  Weights instead of using the log form (tekio v2.1.43).
- 2026-10-06: the Planned card folds from its header, showing how many plans
  are open today, and remembers the fold on the device (tekio v2.1.44).
- 2026-10-06: at Peter's word, `planned_exercises` applied to the shared
  database (version 20261006041035, expand-only) and the build merged to
  develop for staging (tekio v2.1.45). An agent-written session was planned for
  that day so he could test logging from the plan.

## Summary

Add a `planned` state for exercises and sets: written ahead of time by the user
or by an agent, shown on the day, and turned into logged work by doing it. Planned
work never counts toward the body map or the adaptations read. It can be shown
on Home as its own layer, *what is missing after today's plan*, so the user sees
whether the plan closes the gap before training.

## Motivation

A day's training planned with an agent had nowhere to live in the app: either it
was logged in advance, which made the body map claim work that had not happened,
or it stayed in the chat. The first is a lie on the screen that is the product
(doctrine P2); the second leaves the plan out of the place where the gap is read.

Program, the app's earlier home for plans, was deleted on 2026-10-02 to be
rebuilt ([0087](done/0087-remove-program.md)). A planned set is the smallest
piece any rebuilt Program needs, so it is built once here.

## Goals

- A planned exercise is visible, editable and deletable, and is never counted as
  done.
- Doing it (logging the sets, possibly with different weights or reps) turns it
  into ordinary logged work.
- The agent (0099) and the user write plans through the same API route.
- Home can answer "does today's plan close the gap?" without blurring what has
  happened with what has not.

## Non-Goals

- Programs, cycles, progressions, deloads. A rebuilt Program comes back through
  doctrine §4 as its own RFC and reuses this state.
- Generating plans. That is the agent's job (0099).

## Proposal

1. **Data**: a table of its own, `planned_exercises` (date, exercise name,
   target sets, who planned it, and the logged entry it became), not a status
   column on the session rows. The build on `master` reads every
   `session_exercises` row it finds, so a planned row there would count as done
   on production until the release; a separate table that no read selects from
   cannot leak into a number on either build. Expand only under the two-builds
   migration policy (`supabase/README.md` in the code repo). The exercise is
   kept as a name and resolved only when the plan is logged, so planning a new
   lift writes no exercise row and no muscle links. Built in 2.2.0 on today's
   stack (Peter, 2026-10-05); the agent's `plan_exercises` tool (0099) writes
   the same rows. In the app, a plan's type is not a `WeightEntry` (its sets are
   `targets`), so no read type-checks with one.
2. **Capture**: Weights shows a Planned card above the log form: today's planned
   exercises with their targets drawn dashed, later days under them, and one
   line naming last week's unlogged plans. **Log** fills the form with the
   plan's exercise and targets; saving the form logs the work and ticks the
   plan, whatever numbers were actually done. **+ Add to plan** on the card opens a
   sheet that writes a plan for today or a later day. Each open plan has an edit
   button that opens the same sheet as **Edit plan**; Save plan rewrites the
   plan, its day included, and logs nothing. Unlogged plans from earlier days
   expire to that line, never into the read.
3. **The read**: Peter picked the layer on 2026-10-05. The options were:
   - **A layer (recommended)**: the body map shows logged work as today, and
     planned work as an outline on the muscles it would reach, with Home's line
     saying what would still be missing after the plan.
   - **A switch**: the map shows logged only, or logged plus planned, by a toggle.
     Doctrine P4 counts against it: a setting is not a decision.
   - **Not on the map**: plans live only on Weights.

## Rationale

The layer keeps the honest read (logged only) as the read, and adds the question
a planner actually asks without making the user choose a mode. The switch puts
the same information behind a tap, against doctrine §6's "without tapping".

**Brief checklist (doctrine §4).**

1. *Which read does this sharpen?* The body map and Home's adaptations line.
2. *What does it let me stop doing?* Keeping the day's plan in a chat, or logging
   it early.
3. *Input or destination?* An input to the existing read.
4. *Honest shape of the data?* Spatial, like logged work, and visibly distinct
   from it.
5. *Does it write a number claiming physiological meaning?* The preview restates
   the existing read over planned rows and adds no constant; run `/ground` Step 0
   at kickoff to confirm it is exempt.

## Acceptance

- [x] Peter's call on how the map shows planned work is recorded: the outline
      layer (2026-10-05)
- [x] Planned rows never change Home or Adaptations, tested (tekio
      `src/test/plans.test.ts`: planning leaves both reads equal, and no read
      type-checks with a plan)
- [ ] A plan entered in the app appears on Weights and becomes logged work by
      logging it
- [ ] The chosen map treatment is walked on a phone at 412 px

## Unresolved questions

1. ~~Layer, switch or not on the map?~~ Layer (Peter, 2026-10-05).
2. ~~Dashed ink or yellow for planned work?~~ Yellow (Peter, 2026-10-05);
   design-system §1 amended with it.
