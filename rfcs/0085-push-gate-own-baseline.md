---
title: The push gate — a fixed line at 33, or HRV against its own baseline?
authors: [Peter Petrov]
created: 2026-10-02
last_updated: 2026-10-02
status: backlog
status_note: "Opened 2026-10-02 from Peter's review of the landing prototype, where he doubted that anyone at a readiness of 33 is fit to push. Not kickoff-ready: the rule that replaces the line needs a /ground run, and the sleep score's place in it is open."
label: feature
---

# RFC 0085: The push gate — a fixed line at 33, or HRV against its own baseline?

## Summary

Home's push-or-hold call averages last night's sleep score with a
baseline-relative HRV score into one 0–100 readiness number, and holds the day
below 33. Both halves are `convention` in
[the inventory](../grounding-inventory.md): the 50/50 blend (row 4.11) and the
line (row 4.12, a wearable vendor's red-zone edge). The method the evidence
does support is baseline-relative (D8): hold when the 7-day HRV mean falls more
than half a standard deviation below the athlete's own baseline. This RFC
decides whether the gate moves to that rule, which retires `PUSH_THRESHOLD`,
and what the sleep score does once it is no longer half of a number.

## Motivation

- **The line looks too low.** Reviewing the landing prototype
  ([0084](0084-public-landing-site.md)), Peter doubted that anyone at a
  readiness of 33 would feel fit to do anything, and the app tells a 33 to
  push. No study settles a fixed line on this composite either way: 0010's
  grounding found no validation of any composite readiness score as a
  training-decision threshold, and every trial decided against the athlete's
  own baseline ([0010 §Grounding](done/0010-home-fused-reads.md#grounding),
  the push-threshold block).
- **The blend hides which signal moved.** A high sleep score carries an HRV
  trend far below baseline over the line, and a very poor night with HRV at
  baseline clears it too. The line tracks neither signal on its own.
- **The landing cannot explain it.** 0084 took the number and the line off the
  public page in its fourth round and shows the inputs and a state instead.
  Once the gate is grounded the page can say what it is.
- **The app already marks it.** Home's hold banner prints `(PLACEHOLDER)` after
  "the push threshold" (`HomeTab.tsx`).

## Goals

- The hold call rests on a rule with a `## Grounding` block, or the reason it
  stays convention is recorded here.
- Inventory rows 4.11 and 4.12 change state, or retire, in the same edit as the
  code.

## Non-Goals

- The local recovery flag (`RECOVER_DAYS`, row 4.15) and donation suppression
  (row 4.16). Both are grounded.
- What a hold means. It stays advisory and means modify, not rest (D7).
- New readiness inputs. 0010's grounding found self-reported wellness more
  sensitive to training load than HRV (Saw 2016); a morning check-in would be
  a new capture and its own brief.

## Proposal

Not yet written. The starting point is D8: hold when the 7-day rolling HRV mean
is below the 60-day baseline minus 0.5 × SD. `systemicReadiness()` already
computes both sides of that comparison for its HRV score, so the rule change
sits in `fusedVerdict()`, which today compares the blended number with
`PUSH_THRESHOLD`. On the HRV score's current scale (50 + 50 × z) the D8 rule is
a score under 25. What Home's readiness card prints once there is no blended
number is part of the decision.

## Rationale

—

## Doctrine checklist (§4)

1. **Read sharpened:** Home's readiness card and its push-or-hold verdict, the
   third of the exit condition's three questions.
2. **Stops:** a fixed line no study supports, and a blended number that hides
   which signal moved.
3. **Input or destination:** input. The gate changes; no surface is added.
4. **Honest shape:** a trend against the athlete's own baseline, not an
   absolute score (P2).
5. **Physiological number:** yes. A hold claims the body is not ready to push,
   so the rule needs `/ground` before code. 0010's push-threshold block is the
   starting point.

## Acceptance

- [ ] `/ground` has run on the hold rule and its block is linked here
- [ ] `fusedVerdict()` holds on the grounded rule, with tests on both sides of
      the edge
- [ ] The sleep score's place in the call is decided and recorded here, with
      its grounding state
- [ ] Inventory rows 4.11 and 4.12 are updated or retired, and
      `(PLACEHOLDER)` is gone from Home's hold banner

## Unresolved questions

1. **Sleep.** D8's rule reads HRV only. Does a poor sleep score hold the day on
   its own, only when HRV is also down, or never? None of the three is
   grounded yet.
2. **The baseline window.** 60 days is convention; practitioners use 21–30
   (row 4.17).
3. **No HRV baseline.** With fewer than 7 nights of HRV the gate falls back to
   the sleep score alone today. What holds the day then?
4. **Lifting days.** The trials behind D8 are endurance trials; 0010 left open
   whether a hold should change a lifting day at all.
