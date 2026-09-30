---
title: Should Garmin's yoga, pilates and mobility sessions sync into Mobility?
authors: [Peter Petrov]
created: 2026-09-30
last_updated: 2026-09-30
status: backlog
status_note: "Opened by [0073](done/0073-garmin-sync-every-activity-type.md), which skipped `yoga`, `pilates` and `mobility` because the sync writes only cardio and sport rows (Peter, 2026-09-30). Not kickoff-ready: a Garmin session has no exercise list, and the Mobility read is built from one."
label: backlog
---

# RFC 0083: Should Garmin's yoga, pilates and mobility sessions sync into Mobility?

## Summary

Garmin records three activity types that are mobility work: `yoga`, `pilates`
and `mobility`. The activity sync skips all three today. It writes only
`cardio_sessions` and `sport_sessions`, and Mobility has a capture of its own.
This RFC decides whether a watch-recorded session should become a
`mobility_sessions` row, and if so, what the row says when the watch cannot
say which movements were done.

## Motivation

Mobility is a core capture (doctrine §5): it is the recovery-axis input with
its own volume model. A session recorded on the watch and not logged by hand is
missing from that model, just as an unsynced sport was missing from the cardio
read before [0073](done/0073-garmin-sync-every-activity-type.md). The sync
already has the claim rule that would keep a synced row from doubling a
hand-logged one.

## Goals

- A yoga, pilates or mobility session recorded on the watch reaches the
  Mobility read without being typed in again, if an honest row can be made
  from what the watch sends.

## Non-Goals

- `breathwork` and `meditation`. Both stay skipped: they are stillness
  practices, with no training stimulus the app reads.
- Any change to the mobility volume model itself.

## Proposal

To be shaped. The sync's catalogue (`scripts/garmin-sync/activity_types.json`
in the code repo) would give the three types a fourth decision, `mobility`,
and the sync would need a third writer beside `plan_cardio` and `plan_sport`.

## Rationale

To be written with the Proposal.

## Acceptance

- [ ] To be written once the unresolved questions are decided

## Unresolved questions

- **What goes in the row.** A `MobilityEntry` is a date, a duration and a list
  of exercises, and the volume model reads the exercises. Garmin sends a
  duration and heart rate, but no movement list. Would a row with only a
  duration be honest (doctrine P2), or would it credit volume the model cannot
  place?
- **Claim or add.** Should a synced session claim a hand-logged mobility row on
  the same date (the same rule cardio and sport use), with the hand-logged
  exercise list kept?
- **Does this answer §4 question 5?** Crediting a session with volume but no
  movement list would write a number that claims physiological meaning, so it
  may need `/ground`.
