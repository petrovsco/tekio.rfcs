---
title: Plan the week ahead
authors: [Peter Petrov]
created: 2026-11-07
last_updated: 2026-11-12
status: in progress
status_note: the week sheet is on develop as tekio v2.2.83 (PR #65); the strip on the card, which Peter asked for on 2026-11-12, is in a PR as v2.2.85. Both wait on his phone check on staging.
label: feature
---

# RFC 0114: Plan the week ahead

## Progress log

- 2026-11-07: three directions mocked at 412 px against invented data
  (project files `week-plan/`): A, a week strip in the Planned card; B, the
  week in one sheet with every kind; C, a repeating week of named workouts.
- 2026-11-10: Peter picked **B**. A and C are not built. C can come back as its
  own RFC on top of B. Built as tekio v2.2.83, with screens in `week-plan/built/`.
- 2026-11-12: Peter asked for A's strip on the yellow card as well, beside the
  sheet. It was built as tekio v2.2.85, with screens in `week-plan/strip/`.
- 2026-11-12: Peter found the Missed list crowding the card. In the same PR it
  became one line of missed days as chips, each opening its day on the strip
  (screens `week-plan/strip/7-` and `8-`). How long a missed plan is kept is
  RFC 0104's constant, set in its own PR.

## Summary

Every Planned card (Weights, Cardio, Mobility) gets a **Week** door. It opens
a sheet with seven days of plans of every kind: lifts, cardio, sport and
mobility, whichever tab plans them. Arrows move between weeks. Tapping a day
opens it, so each plan can be moved to another day and the tab's own kinds
can be added to it. Over the days still to come, one line says what the
week's plan would leave short.

## Motivation

- Plans for later days already exist (`plan_date` on `planned_exercises` and
  `planned_sessions`), but the card lists them as one flat Later list, one row
  per lift. A week of planned lifts is a long scroll in which the days cannot
  be told apart (mockup `week-plan/0-today-the-later-list.png`).
- Each tab shows only its own kinds, so nothing shows a whole week at once.
- Someone with a structured week, and the agent that plans for them, needs to
  see the days side by side and move work between them.

## Goals

- From any Planned card, one tap shows this week's plans, every kind together.
- Next week and later weeks are one arrow away.
- A plan moves to another day of the week in two taps.
- A day can be given a new plan of the tab's kinds, with the plan sheet
  opening on that day.
- The agent's plans stay marked Agent. A logged day reads as logged, and a
  past day with open plans reads as missed.
- One line says what the week's open lifts would leave short.

## Non-Goals

- No new menu section, and no door on Home, which has no room on its one
  900 px screen (RFC 0082). The cards are the doors.
- No repeating week or named workouts (direction C). That would be a later RFC.
- The strip does not list a whole week's plans at once: that is the sheet's
  job.
- No logging from the sheet. Today's plans are logged from their card, as now.
- Adding a plan of another tab's kind from the sheet. Each tab adds its own
  kinds, in the sheet it already has.
- No schema or API change.

## Proposal

**Checklist (doctrine §4).** 1: it sharpens the Planned cards, and through its
line, the muscle read the day's plan line on Home already previews.
2: no more scrolling a flat Later list, or opening three tabs to see one week.
3: input: it moves and adds plans and logs nothing. 4: plans are per day and
per kind, so the honest shape is a list of seven days with each day's kinds
apart. The muscle preview stays a sentence and never a fill
(design-system §1). 5: no new number. The line runs `planPreview`
(RFC 0098) over the week's open lifts, with the existing gap rule, so
`/ground` Step 0 makes no new claim.

- `src/lib/week.ts` lists every plan of the week as one item, with kind,
  name, targets, Agent and logged. A session counts as logged by the cards'
  own rule, `sessionPlanLogged`, now shared with `SessionPlanCard`.
- `src/components/ui/WeekSheet.tsx` is the sheet. It is a lazy chunk opened
  from `PlannedCard`'s header, so neither it nor the preview loads before the
  door is tapped (P1). Its weeks start on the profile's week start.
- **Move** shows the shown week's days from today on. A tap writes the new day
  through the existing plan routes. Moving a lift of a superset takes its
  group along, as the plan sheet already does.
- **Add** closes the sheet and opens the tab's plan sheet on that day. The
  sheets take an `initialDate`.
- **The strip (A), from 2026-11-12.** The card opens with the week's seven
  days (`WeekStrip.tsx`) and arrows. Each day is marked planned (yellow dot),
  logged (tick), missed (ring) or planned on another tab only (grey dot), by
  `dayMark`. The card lists the picked day, which is today until another is
  tapped. Today keeps Log. Another day lists its plans to edit or remove, and a
  past one offers Reschedule. A line names what the other tabs plan that day,
  and "+ Add to Fri 13 Nov" plans on the picked day. The Later list is gone,
  because the strip and the sheet show later days. Missed plans are not
  listed either: one line, "Missed: Mon 9 Nov · Wed 11 Nov", names each missed
  day still kept as a chip that picks it, paging the strip to its week, and
  that day's rows offer Reschedule and Remove.
- The line: "If you do the week's plan: still short on forearms, obliques and
  posterior deltoid." It reads the open lifts from today to the week's end, as
  though done together.

## Rationale

Of the three mockups, B is the only one that shows the whole week together
and asks the read about it, which is the product's question (doctrine §1). It
needs no schema. A showed one day and one tab at a time. C would be new
machinery that a user whose week changes would never set up (P4). Peter's pick,
2026-11-10.

## Acceptance

- [x] The Week door on all three Planned cards opens the sheet. The sheet shows
  seven days of every kind, with logged, missed and Agent marks, and today
  outlined. Checked at 412 px against mocked data (`week-plan/built/`).
- [x] Arrows move between weeks, labelled This week and Next week.
- [x] Move puts a plan on another day from today on, through the plan's own
  route (`PUT /api/plans/lifts/{id}` was seen with the new date).
- [x] Add opens the tab's plan sheet on that day: Lift on Weights, Cardio and
  Sport on Cardio, Mobility on Mobility.
- [x] The preview line names what the week's open lifts leave short
  (`week.test.ts`, and on screen).
- [x] Peter's review of the PR (merged 2026-11-10).
- [x] The strip on all three cards marks each day and lists the picked one,
  with Log only on today and Add on today or later. Checked at 412 px
  against mocked data (`week-plan/strip/`, `week.test.ts` for the marks).
- [ ] Peter's review of the strip's PR.
- [ ] Peter's phone check on staging.

## Unresolved questions

None blocking. Whether a later RFC adds C's repeating week is Peter's call.
