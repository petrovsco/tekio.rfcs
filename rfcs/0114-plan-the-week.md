---
title: Plan the week ahead
authors: [Peter Petrov]
created: 2026-11-07
last_updated: 2026-11-07
status: backlog
status_note: three directions mocked at 412 px against invented data; waits on Peter's pick before anything is built.
label: backlog
---

# RFC 0114: Plan the week ahead

## Summary

The Planned card plans one day well. Someone who knows their week (lower body
on Monday, a run on Tuesday, tennis on Saturday) needs to see the days ahead
side by side, change them, and have the same week come back without writing
it out again. Their agent needs the same: somewhere to queue workouts on
future days so the week meets its goals. This RFC sets out three directions,
each mocked on the real app, so one can be picked before building.

## Motivation

- Plans for later days already exist (`plan_date` on `planned_exercises` and
  `planned_sessions`), but the card lists them as one flat Later list, one row
  per lift with its date on the right. A week of planned lifts is a long scroll
  in which the days cannot be told apart (mockup `0`).
- Each tab shows only its own kinds. Lifts are on Weights, runs and sports on
  Cardio, stretches on Mobility. Nothing shows a whole week at once.
- A structured week is written out again every week, by hand or by the agent.

## Goals

- See any day's plan, this week or next, in one or two taps.
- See the whole week together, lifts and sessions both, at least in one place.
- Optionally (direction C) keep a standing week that fills itself in ahead.
- The agent's plans stay marked Agent wherever they show.
- Today's plan is still logged as now, from its tab's card.

## Non-Goals

- No new menu section (doctrine R1). Every direction lives inside the Planned
  card or in a sheet opened from it.
- No change to Home's read. A plan stays a prefill: it is never counted as
  work and never fills a muscle (design-system §1).
- No automatic progression of weights from week to week.
- No calendar sync with outside calendars.

## Proposal

**Checklist (doctrine §4).** 1: it sharpens the Planned cards, the input the
day's plan line on Home already reads; direction B also asks the existing
muscle read what the week's plan would leave short. 2: no longer scrolling a
flat Later list, and (C) no longer rewriting a known week each week.
3: input, never a destination. 4: plans are per day and per kind, so the
honest shape is a week of days; a muscle preview stays an outline and a
sentence, never a fill. 5: no new number with physiological meaning. B's line
reuses `planPreview` (RFC 0098) over a week's plans; its gap rule is the
existing one, so no new claim is made.

The mockups are in the project's files under `week-plan/`, rendered on the app
at 412 px from invented data. A structured week is shown: lower, run, upper,
mobility, full body, tennis, volleyball.

### A: a week strip in the Planned card

`A1-strip-today.png`, `A2-strip-monday.png`. The card opens with a row of the
week's seven days, with arrows to the week before and after. Each day carries
a mark: a yellow dot for planned on this tab, a tick for logged, a ring for
missed, and a grey dot for a plan on another tab. Tapping a day lists its
plans under the strip, with "+ Add to Mon 9 Nov". A line names what is planned
on the other tabs that day ("Also that day: Tennis on Cardio"). It replaces
the Later and Missed lists. No schema change.

### B: the week in one sheet, every kind

`B1-week-sheet.png`, `B2-next-week-a-day-open.png`. A Week door on every
Planned card opens a sheet listing the seven days. Each day shows its lifts,
cardio, sport and mobility by name, with logged, missed and Agent marks, and
today is outlined in ink. The pager moves between weeks. Over a week still to
come, one line says what the week's plan would leave short ("If you do the
week's plan: still short on forearms, obliques, posterior deltoid"). Tapping a
day opens it: each plan gets Move, and the day gets "+ Lift / Cardio / Sport /
Mobility". The card stays as it is for today. No schema change.

### C: a repeating week of named workouts

`C1-your-week.png`, `C2-a-workout.png`, `C3-planned-by-workout.png`. A
workout is a named group of plans ("Lower A": squat, RDL, calf raise) set to
repeat on chosen weekdays. "Your week" lists them by weekday. The app writes
each workout's plans two weeks ahead, as ordinary plan rows. A day changed in
the plan stays changed; a change to the workout reaches the weeks ahead. On
the card, later days group under the workout's name and fold open. The agent
can write a workout as well as single plans. This needs new tables (a workout,
its items, its weekdays) and a step that writes the rows ahead, so it is the
largest of the three. It can sit on top of A or B rather than replace them.

## Rationale

- A is the smallest change and keeps each tab to its own kinds. It shows one
  day at a time, so a whole week is never in view.
- B answers "what does my week look like" in one screen. It is the only one
  that shows every kind together, and the only one that asks the read about
  the week, which is the product's question (doctrine §1). It costs one sheet
  and no schema.
- C serves the structured user best over time. It is also new machinery, and
  doctrine P4 asks that it earn its place for every user. A user whose week
  changes, the first user's case, would never set one up.
- Recommended: **B**, with A's strip as a later option for the card itself,
  and C as its own RFC once B is in use.

## Acceptance

- [ ] Peter picks a direction, or a mix of them.
- [ ] This RFC is relabelled `feature` and rewritten to the picked direction,
  with testable boxes.

## Unresolved questions

- Which direction, or which mix.
- B: where else the Week door goes. Home has no room on its one 900 px screen
  (RFC 0082), so the cards and the More drawer are the candidates.
- B and A: is Move a drag between days, or a day picker? The mockup shows a
  button.
- C: does a missed workout move to the next free day, or stay missed? Is
  "two weeks ahead" right?
