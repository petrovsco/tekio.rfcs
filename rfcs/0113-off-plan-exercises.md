---
title: Add exercises outside the plan while logging
authors: [Peter Petrov]
created: 2026-11-06
last_updated: 2026-11-06
status: in progress
status_note: built as tekio v2.2.77 on a pull request to develop; waits on Peter's word to merge, then his phone check on staging.
label: feature
---

# RFC 0113: Add exercises outside the plan while logging

## Summary

The Weights log form's switcher (the chips naming each lift on the form) ends
with a dashed "+ Exercise" chip. It adds an empty lift that belongs to no plan.
You name it in the usual Exercise field, which suggests names and fills in last
time's sets, and it saves beside the planned lifts.

## Motivation

Since the Log switcher (tekio PR #50), a lift joins the form only through Log
on the Planned card. A lift done that day but not planned had no way onto the
form next to the planned ones. The only ways to log it were to finish the
planned lifts first, or to plan it just in order to log it.

## Goals

- From any form that has a lift on it, one tap adds a lift that is not in the
  plan, and the form shows it.
- The new lift is named, filled and saved exactly as any unplanned lift is.
- Nothing new to learn: the same chips, Exercise field and Save buttons.

## Non-Goals

- A picker sheet or a list of recent lifts. Option B of the mockups, not chosen.
- A door on the Planned card. Option C, not chosen.
- Adding the new lift to a superset on the form. It is logged as its own entry.
- No schema or API change.

## Proposal

**Checklist (doctrine §4).** 1: sharpens capture on Weights, no new read.
2: no longer forces you to finish the plan, or to plan a lift, before logging
an unplanned one. 3: neither: it is a control on an existing capture.
4: one entry per lift, as now. 5: no number with physiological meaning is
written.

- The switcher shows as soon as the form holds a lift with anything typed, or
  holds more than one lift. It used to show only for two or more.
- Its last chip, "+ Exercise", has a dashed outline: a slot for a lift, not a
  lift. Tapping it calls `addLift` (`src/lib/logDraft.ts`). That adds an empty
  lift with no plan and shows it. An empty one already waiting is shown instead
  of a second, and untouched lifts are dropped, as Log on a plan drops them.
- "Remove …" under the switcher, for an unplanned lift with nothing logged, now
  needs a second lift on the form, so the only lift cannot remove itself.

Mockups and the built screens are in the project's files under
`plan-card-log/off-plan/`. Peter picked option A on 2026-11-06.

## Rationale

Of the three mockups, A puts the door beside the lifts you switch between, and
it adds no new screen. B's sheet duplicated the Exercise field's own
suggestions. C split one action, adding a lift to the form, between two cards.

## Acceptance

- [x] "+ Exercise" adds an empty unplanned lift and shows it (`logDraft.test.ts`).
- [x] At 412 px, checked against mocked data: planned squat on the form →
  "+ Exercise" → "Lateral Raise" picked, last sets filled → back to the squat.
- [ ] Peter's phone check on staging.

## Unresolved questions

None.
