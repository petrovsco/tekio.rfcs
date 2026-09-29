---
title: A splash that draws the Ō while the app loads, and never holds it up
authors: [Peter Petrov]
created: 2026-09-29
last_updated: 2026-09-29
status: done
status_note: "shipped in v2.0.105 — the arm curls in from index.html before the bundle arrives, and leaves the moment bootstrap() settles."
label: feature
---

# RFC 0078: A splash that draws the Ō while the app loads, and never holds it up

## Summary

Opening the app showed a blank page until the entry chunk had downloaded and
run, then `HomeSkeleton` until `bootstrap()` returned. Now the first paint is
the logo drawing itself: the arm curls from root to tip, each sucker opens just
behind the brush, the macron is drawn left to right and `TEKIŌ` settles under
it. It leaves as soon as the data is in.

## Goals

- Something on screen from the first paint, including the stretch before any
  JavaScript has run. That rules out a React component; the splash is plain
  SVG and CSS in `index.html`.
- **No minimum time on screen.** The splash exists to cover a wait, never to
  make one. Nothing appears for the first 250 ms, so a fast load never sees it.
- The mark is the real logo, drawn the way its construction describes it.

Three directions were prototyped side by side before building: **A**, the arm
curling in; **B**, the suckers filling as a live count of the 18 bootstrap
requests; **C**, both. A was chosen on 2026-09-29. C's count only showed on
slow loads, and on a normal 1.5 s load it held the splash about 0.3 s past the
data while the last suckers finished opening.

## Which read does this sharpen?

None directly. It is the face of doctrine P1 that deals with speed: it fills
the blank screen before the first paint, adds no time to the Home read, and
leaves nothing on the page once the app is up.

1. **Which read?** Home, by covering the wait before it without lengthening it.
2. **What does it let me stop doing?** Staring at a blank page.
   `HomeSkeleton` stays, for the lazy tab chunks.
3. **Input or destination?** Neither. It is chrome, not a section, and does not
   count against R1.
4. **Honest shape of the data?** It shows no data, so it claims no progress it
   cannot measure. That is why the counting variant was not taken.
5. **Physiological number?** No.

## Change

- `index.html` holds the splash (inline CSS and SVG) and a one-line guard that
  removes it on any uncaught error, so a bundle that throws before React mounts
  leaves the old blank page rather than a logo that waits forever.
- The logo geometry is **rebuilt from the construction stated in
  `public/favicon.svg`'s own comment**: the outer edge is a circle of r 39, the
  inner edge is 39 − w(t), the root has a semicircle cap and the suckers are
  circles, all drawn with arc commands instead of dense Béziers. That is 1.8 kB
  against 21 kB. A pixel diff at 400 px found 115 of 33,333 arm pixels and 8 of
  2,351 macron pixels differing by more than 25 % coverage, none by more than
  80 %. Those are anti-aliased edges only. The splash adds **3.0 kB gzipped**
  to `index.html`. The entry chunk is unchanged, and `npm run perf` stays
  within budget.
- The reveal is a mask stroke along the arm's centreline (r = 39 − w/2), over
  1.1 s. A sucker is an ink disc over its real hole, scaled away 0.1 s after
  the brush passes it. Those delays come from inverting the curl's easing at
  the suckers' positions along the sweep, t = (i + 0.6)/8.8.
- `src/lib/splash.ts` — `dismissSplash()` fades the splash in 0.2 s and removes
  it. If the mark has not appeared yet, it removes it at once so nothing flashes
  mid-fade. It is called by `App` when `loading` goes false, and by
  `ErrorBoundary.componentDidCatch`, so the splash never covers the Reload
  button.
- The splash sits at z-index 1000, above the app's highest layer (`z-[201]`).
- `prefers-reduced-motion: reduce` shows the finished mark with no motion.

## Non-Goals

- Real progress (variants B and C). See Goals.
- A dark splash. The app has no dark theme; the favicon's dark-mode ink is for
  the browser tab, not the page.
- A native PWA launch screen (`manifest.json` splash, iOS startup images). The
  app has no manifest; that is a separate decision.

## Acceptance

Verified against the production build in headless Chromium with the database
stubbed:

- [x] Fast load, data in at about 130 ms: splash removed, the mark never shown.
- [x] Typical load: the curl, the suckers opening in order, the macron and the
      wordmark all draw, nothing overlaps them, and the splash leaves when the
      data lands.
- [x] Reduced motion: the finished mark, still.
- [x] A bundle that throws at module level: the splash is removed at about 30 ms.
- [x] `npm run build`, `npm run test` (237), `npm run perf`, `npm run knip`.
