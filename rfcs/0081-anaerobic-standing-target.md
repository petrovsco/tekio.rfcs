---
title: Anaerobic capacity — a standing weekly target, or a block?
authors: [Peter Petrov]
created: 2026-09-30
last_updated: 2026-09-30
status: backlog
status_note: "Split out of [0012](done/0012-adaptation-target-shapes.md) §5 when that brief closed on 2026-09-30. An open product question, not kickoff-ready: it needs somewhere to store which block the user is in."
label: feature
---

# RFC 0081: Anaerobic capacity — a standing weekly target, or a block?

## Summary

Tekiō asks for one anaerobic-capacity session every week, forever (inventory row
1.7, `convention`). The evidence says this quality is trained in blocks and
lost slowly, so a permanent `1` may report a gap that costs nothing. The
alternative is no standing target, and a target only inside a block.

## Motivation

Carried from [0012](done/0012-adaptation-target-shapes.md) §5 and
[0011](done/0011-adaptation-weekly-targets.md) follow-up #3, where it was
recorded as an open question and deliberately left undecided:

- No adequacy-threshold literature exists for anaerobic capacity in a
  non-competitive trained adult. The improvement studies are block-shaped:
  sprint-interval trials run 3×/week for 4–7 weeks, then stop.
- Anaerobic capacity is among the slowest qualities to detrain. A permanent
  weekly `1` shows a gap for an absence that costs nothing measurable for
  several weeks. That is the opposite of "tells me what's missing".
- A standing target raises the cardio count, and interference with power and
  explosive strength scales with endurance frequency (Wilson 2012, PMID
  22002517).

## Goals

- Decide whether anaerobic capacity keeps a standing weekly target.

## Non-Goals

- Periodising any other quality.
- Changing the anaerobic classifier ([0005](done/0005-hr-zone-intensity-classification.md)).

## Proposal

Not yet written. The shape [0012](done/0012-adaptation-target-shapes.md) left
behind already expresses "no standing target": every target field at `0`
(`targetShape` then reads it as untargeted and `met` stays false). What does not
exist is any place to store "in a block, target 2", and that is a new
destination-shaped piece of state. Doctrine R3 forbids building machinery to
manage the feature set, so the proposal has to show the block is a *read input*
and not a planner.

## Rationale

—

## Doctrine checklist (§4)

1. **Read sharpened:** the whole-body strip on Home and the effort spectrum on
   Adaptations.
2. **Stops:** a permanent anaerobic gap that may mean nothing.
3. **Input or destination:** input by intent. The block state is the risk.
4. **Honest shape:** block-periodised, not a weekly rate.
5. **Physiological number:** `0` asserts nothing (inventory row 1.10). A block
   target of 2–3/week is a new claim and needs `/ground`.

## Acceptance

- [ ] Standing target kept or dropped, recorded here with the reason.
- [ ] If a block target ships, `/ground` has run for its value.

## Unresolved questions

1. Where does block state live, and does storing it break R3?
