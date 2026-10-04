---
title: Remove water logging and the Weights chips
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: done
status_note: "Peter's call on 2026-10-04; landed on develop as v2.1.18 the same day. The water_logs drop waits for the 2.2.0 sweep (0088)."
label: feature
release: 2.2.0
---

# RFC 0089: Remove water logging and the Weights chips

## Summary

A second round of cuts after [0034](0034-v2-1-candidates-tbc.md). Water
logging leaves the app entirely: the readiness card's WATER column, the WATER
tile on Home, the water capture in both sheets, its edit form, the store and
its database file. The Weights chips go too, now that an autocomplete pick
fills an exercise's last sets. Blood donation stays, but moves off the
readiness card: it keeps its tile beside bodyweight at the foot of Home.

## Motivation

- **Water** is a capture that asks for several taps a day, and it fed no
  verdict: `fusedVerdict` never read it, so the column and tile were a number
  nobody acted on (doctrine §1). It may come back once the app can remind,
  through §4 like any new input.
- **The chips** were capped at the 8 most recent in v2.1.17. Training rotates
  across days, so the 8 rarely held the day about to be trained, and the
  autocomplete pick now does the chips' one job (fill the last sets).
- **Blood** is logged a few times a year. Sleep and HRV change every day, so
  the readiness card is their place; a donation reads like bodyweight, a fact
  that changes rarely. The verdict still holds a day inside the acute window
  and says why in its banner, so the gate loses nothing.

## Goals

- Nothing in the app says water or hydration.
- Weights shows no chips; picking an exercise from autocomplete fills its last
  sets, as before.
- The readiness card shows SLEEP and HRV; BLOOD shows once, beside WEIGHT.
- No row is deleted here.

## Non-Goals

- Moving or changing blood donation's capture, its eligibility or its hold.
- Deleting water rows. `water_logs` is queued in
  [0088](../0088-release-2-2-0-schema-drops.md), which needs Peter's word because
  a table drop takes its rows.

## Proposal

Code (tekio, v2.1.18): delete `lib/db/water.ts`, `WaterEntry`, the store's
water list and actions, `WaterCapture`, `WaterForm`, `waterStatus`,
`WATER_GOAL_ML`, the water key in export and import, and the WATER column and
tile on Home. Delete the Weights chip row and `recentExercises`. Drop the BLOOD
column from the readiness card.

Plan: doctrine §5 Water row → deleted; inventory 10.1 and 10.5 retired; 0088
gains `water_logs`.

## Rationale

- **Shelve water instead.** R2 shelving is for a menu section the config can
  hide; water is a capture inside Home, and Peter wants it gone, not hidden.
- **Keep BLOOD in both places.** Two copies of one rare fact on one screen,
  one of them among the daily inputs, is the confusion this removes.

## Acceptance

- [x] No WATER on Home or in the recovery sheet; readiness card reads SLEEP and
  HRV; WEIGHT and BLOOD tiles at the foot (browser walk, 390 px, 2026-10-04)
- [x] No Weights chips; an autocomplete pick of an older lift filled its two
  last sets (same walk, invented data)
- [x] `npm run build`, `npm run test` (193 passed), `npm run lint` (no errors),
  `npm run knip` (nothing reported) green on v2.1.18
- [x] Doctrine ledger, inventory §10 and 0088 updated in the same session
- [x] v2.1.18 on `develop`, with Peter's OK (2026-10-04)

## Unresolved questions

None.
