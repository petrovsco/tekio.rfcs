---
title: Home's adaptations line is right but hard to spot
authors: [Peter Petrov]
created: 2026-09-30
last_updated: 2026-09-30
status: planned
status_note: "Opened 2026-09-30 when Peter recorded the doctrine §6 verdict as not met: all three questions answer correctly at source, but the seven-quality line does not draw the eye inside five seconds. Closing this is what the next walk tests."
label: feature
release: 2.2.0
---

# RFC 0082: Home's adaptations line is right but hard to spot

## Summary

Doctrine §6's second question asks which adaptations are untouched. Home
answers it with the `coverageLine` sentence (*Untouched: power, anaerobic.
Short: strength.*), and the answer is correct. But it is printed at 9 px in
secondary ink under the body map, the smallest text on the screen, so a cold
five-second read does not land on it. This RFC gives that line the visual weight
its job needs, without pushing Home past one 900 px screen.

## Motivation

On 2026-09-30 Peter recorded the §6 verdict after a cold read of the
post-0012 build (targets in sets, sessions and minutes):

- **Q1 — under-stimulated muscles:** pass, correct at source.
- **Q3 — recovered enough to push:** pass, correct at source.
- **Q2 — untouched adaptations:** he knew which ones, and the door to
  Adaptations (0064) carried him to the drill-down as intended by 0062's split.
  But the answer *felt thin*, and asked what "thin" meant, the one reason
  he chose was **hard to spot**. It was not missing magnitude, a missing muscle
  link or a missing action for today.

So the content is right and the weight is wrong. The line is
`text-[9px] text-ink-2` in `src/components/tabs/home/HomeTab.tsx`, sitting
between the body map and the "What to do about it" door. The body map's
numbered callouts and the readiness verdict both outrank it visually, even
though it is the only thing on Home that answers Q2.

## Goals

- In a cold five-second read, the eye reaches the adaptations line together
  with the body map and the readiness verdict.
- Home still fits one 900 px screen with nothing below the fold (the 0062
  constraint).

## Non-Goals

- Changing what the line says. `coverageLine` stays the single helper that both
  Home and the Adaptations header print (0062).
- Adding magnitude, per-muscle breakdowns or a today-action to Home. Peter ruled
  these out as the reason for "thin".
- Merging Home and Adaptations again. 0062 settled that.

## Proposal

Promote the line inside the card it already sits in:

1. Give it a text step that matches the other answers on Home (the readiness
   verdict's size and weight), in primary ink, not `ink-2`.
2. Separate its two halves visually: *Untouched* is the stronger claim and
   leads, and *Short* follows at lower emphasis. The string is unchanged; only
   how it is rendered changes.
3. Win back the height it gains from the whitespace around the body map, not
   by moving anything below the fold.

Tokens and type steps come from `design-system.md`. Don't add a new size.

## Rationale

This is the smallest change that addresses the stated reason. The alternatives
(a chip row, a separate card, repeating the line above the map) each add
a surface. That is what P3 argues against, and each would also compete with the
readiness verdict for the top of the screen.

## Doctrine checklist (§4)

1. **Which read does this sharpen?** Home: the "what is missing" card.
2. **What does it let me stop doing?** Tapping through to Adaptations just to
   confirm which qualities are behind.
3. **Input or destination?** Neither. It changes visual weight on an existing read.
4. **Honest shape of the data?** Unchanged: a sentence of names over whole-body
   and muscle-linked qualities, from one coverage read.
5. **Physiological number?** No. It adds no new claim and moves no number.

## Acceptance

- Peter re-walks §6 cold on the build that ships this, and Q2 passes without
  feeling thin. Only that walk can move §6 to **met**.
- Home measured at 900 px with nothing below the fold.
- Verified in the browser on staging, in both themes.

## Unresolved questions

- If more weight still reads as thin on the next walk, the reason was not only
  visual, and the Non-Goals above get reopened.
