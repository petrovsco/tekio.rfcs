---
title: Reorder sets while logging
authors: [Peter Petrov]
created: 2026-11-03
last_updated: 2026-11-03
status: in progress
status_note: built and checked in a 412 px browser on branch claude/project-thread-5qo7ft (tekio v2.2.76); waits on a check on a real phone and Peter's word to merge.
label: feature
---

# RFC 0112: Reorder sets while logging

## Summary

A set on the Weights log form, and on the plan sheet's targets, can be dragged
to another place by its `#` cell. The main case: a lift filled from a plan gets
a warm-up set added, which lands at the bottom, and it belongs at the top.

## Motivation

"+ Add set" only appends. A lift filled from a plan (RFC 0098) arrives with its
working sets already on the form, so a warm-up added before them sits last,
and the only fix was to retype every row. The log then reads in the wrong
order, and a heavier set appears to come before the lighter one that was
really done first.

## Goals

- One gesture moves a set anywhere among the visible rows, at 412 px.
- A set's tick (RFC 0106) moves with it; moving never writes to the log by
  itself.
- The same grip as Settings' section order, so the app keeps one drag gesture.

## Non-Goals

- Reordering exercises, or the lifts of a superset.
- Moving a ticked set. It is in the log already; the unticked ones move around
  it.
- The edit sheet for a logged entry (`EditModal`). It is a plain form edited
  after the fact; it can take the same `onMove` later if it is missed.
- No schema change: set order is the order the sets are written in.

## Proposal

**Checklist (doctrine §4).** 1: sharpens capture on Weights, no new read.
2: stops retyping a whole lift to put a warm-up first. 3: neither: it is a
control on an existing capture. 4: sets are an ordered list per entry; order
is shown as written. 5: no number with physiological meaning is written.

- `SetsGrid` takes an optional `onMove(from, to)`. With it, and more than one
  row showing, each unticked row's `#` cell shows the two-line grip beside the
  number and is the drag handle: a short press-and-hold on touch (200 ms, as in
  Settings), a small drag with a mouse. A ticked row shows its number only and
  is not picked up, but the others can pass it.
- The log form moves the row together with its tick and with what the
  background write queue holds for that lift, so the queue does not read the
  move as a change. Because only unticked rows move, the ticked rows keep
  their order and the entry needs no write; the next tick writes the sets in
  the order the form shows.
- The plan sheet moves its target rows the same way.

## Rationale

Three directions were put to Peter on 2026-11-03: drag by the set number, up
and down arrows on each row, or a "+ Warm-up set" link that adds a row at the
top. He picked the drag. Arrows crowd a row that already holds two fields, the
tick and the delete at 412 px, and take several taps to reach the top; the
warm-up link covers only one case. The drag reuses `@dnd-kit`, already in the
app, and the Weights tab is a lazy chunk, so the first paint is unchanged.

## Acceptance

- [x] Dragging an unticked set to the top of a plan-filled lift puts it first
      on the form and in the saved draft (Playwright, 412 px, mouse drag).
- [x] With set 1 ticked, a dragged set can go above or below it; no write is
      sent by the move, and the next tick writes the sets in the form's order.
- [x] A ticked set has no grip and cannot be picked up.
- [x] The plan sheet's targets move the same way.
- [x] `npm run build`, `npm run test`, `npm run perf` pass; first paint
      unchanged.
- [ ] Press-and-hold drag works on a real phone (Pixel 10, Chrome and Firefox).
- [ ] Peter checks it on staging.

## Unresolved questions

None.
