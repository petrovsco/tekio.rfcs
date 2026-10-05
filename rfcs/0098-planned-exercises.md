---
title: Planned exercises — a state for work that has not happened yet
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-05
status: in progress
status_note: "Moved to 2.2.0 and started by Peter on 2026-10-05, built on today's stack without waiting for the API (0094). The data and the reads' filter go first; the map treatment waits on Peter's call."
label: feature
release: 2.2.0
---

# RFC 0098: Planned exercises — a state for work that has not happened yet

## Progress log

- 2026-10-05: tagged 2.3.0, ahead of the rest of the public release plan.
- 2026-10-05: moved to 2.2.0 and started, at Peter's word. Relabelled feature.

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

1. **Data**: a status on the session-exercise and set rows (`planned` /
   `logged`), plus who planned it (`user` / `agent`), additive and nullable under
   the two-builds migration policy (`supabase/README.md` in the code repo). Every
   read (`src/lib/adaptations.ts`, `src/lib/fusedRead.ts`) filters to `logged`,
   so the change cannot leak into a number. Built in 2.2.0 on today's stack
   (Peter, 2026-10-05), before the API exists; when 0094 moves the reads into the
   core package, the filter moves with them, and the agent's `plan_exercises`
   tool (0099) writes the same rows.
2. **Capture**: Weights shows today's planned exercises at the top, with their
   sets as targets; logging a set fills it in. Unlogged plans from earlier days
   expire to a history line, not into the read.
3. **The read**, three options for Peter's call:
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

- [ ] Peter's call on how the map shows planned work is recorded
- [ ] Planned rows never change Home or Adaptations, tested in the reads' own tests
- [ ] A plan entered in the app appears on Weights and becomes logged work by
      logging it
- [ ] The chosen map treatment is walked on a phone at 412 px

## Unresolved questions

1. Layer, switch or not on the map? Recommendation: layer. Peter called it a
   decision for later.
