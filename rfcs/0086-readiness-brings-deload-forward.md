---
title: Let readiness bring the deload forward
authors: [Peter Petrov]
created: 2026-10-02
last_updated: 2026-10-02
status: backlog
status_note: "Recorded on Peter's call, 2026-10-02, from 0013's grounding. The same day Program and its cycle were removed ([0087](0087-remove-program.md)), so there is no deload to bring forward until a rebuilt Program brings one back. The Unresolved questions below stand."
label: backlog
---

# RFC 0086: Let readiness bring the deload forward

## Summary

Today the deload falls in week 6 of every cycle, fixed by the calendar
(`cycleInfo`, `DELOAD_WEEK = CYCLE`). This RFC would let the systemic readiness
read *bring the deload forward* when the lifter is clearly fatigued before week
6. Week 6 would become a checkpoint, not the only possible week.

## Motivation

[0013](done/0013-cycle-deload-grounding.md#grounding) found that the
literature's real disagreement is not 6 weeks against some other number. It is
a **fixed** schedule against a **fatigue-triggered** one. No trial favours
either. The commonest coaching practice is a hybrid, where the scheduled deload
is a checkpoint and an early deload is taken when needed (Bell 2022, Bell 2023).
Tekiō kept the fixed calendar on purpose (decision D43 in the inventory) and
named this as the way to add flexibility: a readiness *input*, never a
different `CYCLE`.

The cost of doing nothing: a lifter who is clearly run down in week 4 is still
told to push until week 6.

## Goals

- When the readiness read says "rest" for long enough before week 6, Tekiō
  offers the deload early, on the surfaces that already show it (the Weights
  banner and Home's cycle line).
- With no fatigue signal, behaviour is exactly as today.

## Non-Goals

- No change to `CYCLE`, `DELOAD_WEEK` or `DELOAD_REP_FACTOR` (0013).
- No *postponed* deload. Readiness can only bring it forward.
- No new surface or menu section (R1). This is an input to an existing read (P3).

## Proposal

To be written once the Unresolved questions are answered. Its likely shape is a
pure helper beside `cycleInfo` that takes the readiness history, plus a
`deload_committed_date` (the `user_programs` column already exists, and it
needs checking whether anything reads it).

## Rationale

The alternative is the status quo: a fixed calendar only. It is simpler and
defensible (D43). This RFC exists because Peter wanted the idea recorded rather
than lost, not because the fixed calendar was found wrong.

## Acceptance

- [ ] The trigger is grounded with `/ground`, because it writes a number with
  physiological meaning (how much fatigue, for how long).
- [ ] An early deload shows on the Weights banner and Home, with no difference
      between the two.
- [ ] With no fatigue signal, `cycleInfo` and `isDeloadDate` give the same
      answers as today, covered by tests.

## Unresolved questions

- **What is the trigger?** Options include N consecutive "rest" days from the
  push-or-rest read, or a stalled load trend on a muscle, and §4.5 says it needs
  grounding.
- **Is it automatic or offered?** Does Tekiō switch to the deload, or ask once
  and let the user accept it?
- **What happens to the rest of the cycle?** After an early deload, does the
  cycle restart, or does week 6 become a normal week?
