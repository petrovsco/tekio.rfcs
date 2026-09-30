---
title: Home's adaptations line is right but hard to spot
authors: [Peter Petrov]
created: 2026-09-30
last_updated: 2026-09-30
status: in progress
status_note: "Opened 2026-09-30 when Peter recorded the doctrine §6 verdict as not met: all three questions answer correctly at source, but the seven-quality line does not draw the eye inside five seconds. The change shipped the same day (v2.1.2): 12 px body text, untouched half semibold in ink, short half in ink-2, Home still one 900 px screen. What remains is Peter's cold re-walk of §6. That walk closes this RFC, and only it can record **met**."
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

1. Move it from 9 px `ink-2` to the 12 px body step (design-system §5, the
   verdict's own sub-line size), in primary ink. It does not take the verdict's
   size: 28 px serif is reserved for the verdict alone.
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

- [ ] Peter re-walks §6 cold on the build that ships this, and Q2 passes without
      feeling thin. Only that walk can move §6 to **met**.
- [x] Home fits one 900 px screen: local dev build, live database, 390 px
      wide, 2026-09-30. The line went from 21 px to 34 px tall (two lines). The
      card's top gap went from 12 px to 8 px, matching the cards below it, so the
      page height is 899 px (890 before). The last card ends at 803 px, and the
      nav starts at 848 px. With all seven qualities named, the line still
      takes two lines.
- [x] Verified in the browser. The app has one theme, so there is no second
      theme to check. The untouched half renders at 600 in ink `#1a1a1a`, and
      the short half at 400 in ink-2 `#6b6b6b`.
- [x] `coverageParts` joins back to `coverageLine` exactly (tested), so Home
      and the Adaptations header still print one sentence.

## Unresolved questions

- If more weight still reads as thin on the next walk, the reason was not only
  visual, and the Non-Goals above get reopened.
