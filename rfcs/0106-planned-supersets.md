---
title: Supersets and circuits on the Planned card
authors: [Peter Petrov]
created: 2026-10-12
last_updated: 2026-10-12
status: in progress
status_note: Peter chose "Group + log as one" on 2026-10-12; built on the branch at tekio v2.2.18. The new column waits on his go before anything reaches develop.
label: feature
---

# RFC 0106: Supersets and circuits on the Planned card

## Summary

Let planned lifts be grouped: two lifts done back to back are a **superset**,
three or more are a **circuit**. The group is one optional column on
`planned_exercises`. The Weights Planned card draws a group as one block, the
plan sheet can put a lift into a group or take it out, and logging from a group
fills its lifts one after another and saves them under one superset, so Recent
shows the session the way it was planned.

## Motivation

A plan is one lift per row ([0098](done/0098-planned-exercises.md)). Workout
plans written by agents keep pairing lifts (a hinge with a hamstring curl, a
press with a raise) and running three-way circuits, and the card had no way to
say so: the rows sat apart and the pairing lived only in the chat that wrote
them. At the gym the card is what is open, so the grouping was lost exactly
where it was needed.

Logged supersets already exist underneath: `session_exercises.superset_group_id`
has been in the schema since the start, and Recent draws a pair with the SS
badge. Nothing in the app has created one since Program left
([0087](done/0087-remove-program.md)), and Recent pairs only two entries, so a
circuit would fall apart there too.

## Goals

- A planned lift can join another planned lift of the same day as a group, and
  leave it.
- The Planned card draws a group as one block, labelled Superset for two lifts
  and Circuit for three or more.
- Log on a grouped lift fills the form with it; saving fills the next open lift
  of the group, and every lift saved from the group carries the same
  `superset_group_id`.
- Recent shows a logged group of any size as one block, and its edit form edits
  every lift in it.
- Rescheduling a grouped lift moves its whole open group, so a group never
  splits across days.

## Non-Goals

- Cardio, sport and mobility plans ([0104](done/0104-planned-cardio-and-mobility.md)).
  A circuit there is one session, already described by its own fields.
- Rest timers, rounds counters or any in-workout mode. The log form stays the
  log form.
- Building a superset from the log form without a plan.
- Any read. Grouping changes no count: every set is still one set to the muscle
  and adaptation reads, so no number moves and no `## Grounding` is needed
  (doctrine §4 question 5).

## Proposal

**Schema** — one expand-only migration:
`alter table planned_exercises add column superset_group_id uuid` (nullable,
no default). Lifts sharing a value are one group; the order inside it is
`sort_order`. A group left with one member reads as a plain lift. The build on
`master` never selects the column, so it is safe to add before the release.

**Logging** — the plan's group id is reused as the logged entry's
`superset_group_id`, so plan and log agree with no mapping table.

**Agents** — a workout thread writes a superset by giving its rows one fresh
uuid in `superset_group_id`.

**Card** — inside Today, Later and Missed, a group renders as a bordered block
with the SS badge and the word Superset or Circuit, its lifts as rows inside it
with their own Log, edit and remove. Colours stay those of the Planned card
(design-system §1); nothing new is introduced.

**Sheet** — a "Superset with" choice lists the other open lifts planned for the
same day, plus None. Picking one joins its group, or starts a new group of the
two.

## Rationale

- *One sheet that logs the whole group at once* — closer to how a superset is
  done, but a second log form to build and keep in step with the first one. The
  form already logs one lift at a time; chaining it keeps one way to log.
- *Grouping on the card only* — cheaper, but the logged session forgets the
  grouping the plan had, and Recent already knows how to show a superset.
- *A separate groups table* — names a group and orders groups, which nothing
  needs yet. One uuid column is what `session_exercises` already uses.

## Acceptance

- [ ] Migration adding `planned_exercises.superset_group_id` applied on Peter's word, file named after its stamped version.
- [ ] The plan sheet joins a lift to another lift of the same day and takes it out again.
- [ ] The Planned card draws a group of two as Superset and of three as Circuit, at 412 px.
- [ ] Logging a group fills its lifts one after another, and Recent shows them as one block with every lift.
- [ ] Rescheduling a missed grouped lift moves the whole open group to the new day.
- [ ] Tests cover grouping on the card, the logged group id, and Recent's groups of three.
- [ ] Peter has checked it on staging.

## Unresolved questions

None open: Peter chose this direction ("Group + log as one") on a decision card
on 2026-10-12.
