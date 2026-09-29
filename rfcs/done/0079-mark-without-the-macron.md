---
title: The mark loses its macron and gains a far arm
authors: [Peter Petrov]
created: 2026-09-29
last_updated: 2026-09-29
status: done
status_note: "shipped in v2.0.106 — favicon, touch icon and splash all carry the two-arm mark."
label: feature
---

# RFC 0079: The mark loses its macron and gains a far arm

## Summary

The mark shipped in [0038](0038-favicon-and-app-icon.md) was a wrapped octopus
arm forming an O, with a macron above it. It now has no macron. The ring is
unchanged apart from moving down to centre, and the thin end of a second arm
slides out from behind it along the inside of the top, the way a far leg shows
past a near one. The favicon, the touch icon and the splash
([0078](0078-splash-while-loading.md)) are all regenerated from one piece of
geometry.

## Why

Ō, a round O under a level bar, is a registered trademark of Oura Health Oy
(ŌURA). Oura is in the same market: a health and recovery read, sold as an app
and a wearable. It lists **Ō** on its own among its marks and enforces its IP.
A plain circle is free for anyone. The risk was the pairing of a closed ring
with a separate bar floating over it. At 16 px, where the suckers stop carrying
the drawing, the old mark reduced to exactly that pairing. The risk only grows
with traction, and a rebrand after launch costs more than one now.

The Ō stays in the wordmark `TEKIŌ`, where a romanised Japanese word calls for
it. The mark is now the creature and no longer tries to spell the letter.

## How it was chosen

Rounds on a review sheet, 2026-09-29:

1. Four ways to break the pairing: open the ring, drop the macron, let the arm
   draw the macron, and a curled arm with no letter. All four were rejected.
   The existing ring was to stay exactly as it was, minus the bar.
2. A second arm, thinnest part only, placed inside, outside lower left and
   outside by the root. The choice was inside, running parallel under the top.
3. The parallel arm angled inward toward its tip, so a triangular gap opens
   between the two. It came in two run lengths × two drops.
4. Starting the far arm from behind the root bulb, the "head", read as two
   arms from one point, but it lost the parallel. Reverted.
5. The far arm's thick end showed in the counter as a rounded end, so it looked
   like it started in empty space. Fixed by starting it hidden inside the
   ring's own width, so it slides out from under the inner edge at a shallow
   angle and has no visible start.
6. The chosen run was **2a**: out near ten o'clock, drifting to 6 units in.
   Rounding its sharp start was tried at radii 0.6, 1.1 and 1.7, and the sharp
   version was kept.

A trap from round 3 is worth recording. The sheet's own outline code drew both
round caps bulging *inward*, which turned the root's bulb into a notch. That
was a bug in the sheet, never in the shipped file. The rule it confirms:
check an end cap's bulge direction against the direction of travel, never
assume it.

## Which read does this sharpen?

None. It is the brand mark, infrastructure like Profile, and it does not count
against R1.

1. **Which read?** None, see above.
2. **What does it let me stop doing?** Carrying a mark that reads as a
   competitor's registered symbol at icon size.
3. **Input or destination?** Neither.
4. **Honest shape of the data?** No data.
5. **Physiological number?** No.

## Change

**The geometry, on the 0–100 grid.**

- **Near arm:** as 0038, recentred on (50, 50). The outer edge is a circle of
  r 39. The centreline is r = 39 − w/2, with w(t) = 5.2 + 9.8·(1−t)^0.85 over
  366° from −45°. The root ends in a semicircle cap, and the eight suckers are
  holes at w/4 radius, spaced (i + 0.6)/8.8. It is written as arcs (the
  splash's compact form from 0078), not 220 samples.
- **Far arm:** width 4.4 tapering to 1.4. It runs from 148° to 278° (clock
  angle, clockwise from three o'clock). For the first 55° it rides the middle
  of the ring band and smoothsteps out to 1.8 units inside the ring's inner
  edge, so it is hidden, then slides out. After that its offset drifts from 1.8
  to 6 units along (progress)^1.3, which opens the wedge. It first shows at
  about 177°.
- **The "behind" cut** is a real boolean: the far arm's outline minus the ring
  outline grown by 1.6 units (Clipper, round joins). The far arm ships as plain
  outline, with no mask. Its start is the sharp point left by the shallow
  crossing, kept on purpose.
- **Measured:** ink reaches x 11–89 and y 11–89, centred both ways. The tip is
  5.99 units from the ring.

**Files.**

- `public/favicon.svg`: two paths, 4.2 kB (was 22.7 kB). It still inverts to
  white under `prefers-color-scheme: dark`, and nonzero is still the fill
  rule, for the reason 0038 gives.
- `public/apple-touch-icon.png`: 180×180, paper `#faf9f7`, the mark inset to
  140 of 180, as before.
- `index.html` splash: the same two paths. The macron's left-to-right wipe is
  replaced by a second brush, a mask stroke along the far arm's own centreline,
  from where it clears the ring to 2 units past its tip, so a butt cap never
  shaves the round tip. It runs 0.38 s from 0.97 s, the macron's old slot, so
  it follows just behind the first brush as that brush passes over it. The
  sucker delays are unchanged, because they depend only on t. `index.html` is
  3.9 kB gzipped (was 3.6 kB).

The generator was a scratch script that ported the review sheet's code, so the
output is what was approved. It is not kept. Every number it used is above and
in the favicon's comment.

## Non-Goals

- A trademark clearance search. Before any filing or public launch, a search in
  the software, wearable and health-service classes is still the step that
  settles this. This RFC removes the known collision; it does not clear the
  mark.
- The wordmark. `TEKIŌ` keeps its macron.

## Acceptance

- [x] `favicon.svg` and `apple-touch-icon.png` are served by the production
      build and match the approved sheet (option 2a, sharp start).
- [x] The splash in `index.html`, from the production build in headless
      Chromium: ring, suckers and far arm fully drawn, `TEKIŌ` below. At ¼
      speed: the ring draws root to tip, the suckers open behind the brush,
      then the far arm draws in from where it clears the ring.
- [x] `npm run build`, `npm run test` (237), `npm run perf` (within budget),
      `npm run check:docs`.
