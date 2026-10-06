---
title: Text greys that pass contrast
authors: [Peter Petrov]
created: 2026-10-06
last_updated: 2026-10-06
status: backlog
status_note: "Found by the landing site's Lighthouse pass for 2.2.0 (RFC 0084). Not committed to: darker greys are a visual call that changes the app and the site together, and it is Peter's."
label: backlog
---

# RFC 0101: Text greys that pass contrast

## Summary

Two of the design system's four text greys fall short of the contrast WCAG asks
of small text: labels `#8a8a8a` measure 3.3:1 on the page background and 3.5:1
on a card, asides `#a8a8a8` 2.3:1 and 2.4:1, against 4.5:1. This RFC decides
whether they change, in the app and on the landing site at once.

## Motivation

The landing site's Lighthouse pass for 2.2.0 scored accessibility 96, and every
finding was one of these two greys: section labels, the muted verdict, the act
labels, the week's ledger, the tiles' credits, the note that the athlete is
invented. The app draws its labels in the same greys
([design-system.md](../design-system.md) §3), so it fails the same check. The
text that goes is the text that names what a reader is looking at, and it goes
first for a reader with low vision or a phone in sunlight.

## Goals

- Every text grey the app and the site draw passes WCAG AA: 4.5:1 for small
  text, 3:1 for large.
- The hierarchy the greys carry still reads at a glance.

## Non-Goals

- The accent, the stimulus ramp and the inverted gated card: this is the text
  greys only.
- Disabled controls, which WCAG exempts.

## Proposal

Not chosen yet. What shapes it: the lightest grey that passes on the page
background is `#737373`, one step from the secondary `#6b6b6b`, so a label or
aside that passes can no longer be told from secondary text by colour alone.
The likely answer is one passing grey for labels and asides, told apart by what
already marks them (labels by size, weight, capitals and tracking; asides by
size), changed in `design-system.md`, the app's tokens and the site's
`site.css` in one go.

## Rationale

The alternative is to keep the four greys and accept the finding: they are a
deliberate quiet layer, and the app has one light theme. Enlarging the smallest
text instead does not reach 4.5:1 either, since 3:1 is allowed only from 18.66 px
bold or 24 px regular, larger than any label.

## Acceptance

- [ ] Peter decides whether the greys change
- [ ] If they do: `design-system.md` §3 states the new set, the app and the site
      draw it, and Lighthouse finds no contrast failure on the site or on the
      app's Home
- [ ] The app's Home and the site walked on a phone after the change

## Unresolved questions

- Change the greys at all, and if so, one passing grey for labels and asides,
  or two?
