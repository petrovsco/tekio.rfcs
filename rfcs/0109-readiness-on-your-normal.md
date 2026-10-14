---
title: Readiness as a point on your normal, with its history
authors: [Peter Petrov]
created: 2026-10-14
last_updated: 2026-10-14
status: in progress
status_note: On develop as tekio v2.2.31, the chart showing the 60 nights the normal comes from and a touched day able to be put away; waits on Peter's phone check on staging.
label: feature
---

## Progress log

- 2026-10-14 — Peter saw a good night's HRV printed beside a readiness bar
  about a fifth full. The bar was the 0–100 score of the 7-night mean against
  his own normal; the number beside it was last night alone. tekio v2.2.25
  printed the 7-night mean the bar measures; v2.2.27 printed the normal range
  under the bar and shaded it on the track.
- 2026-10-14 — On his phone the fill and the shaded range read as one bar
  measuring two things, and a week under the normal printed as the normal's
  first value. He asked for the week as a point on the normal, and for the
  readiness sheet to carry more: a larger gauge, last night's reading and a
  longer history. Other readiness methods read the same way against their own
  normal. He chose a one-year Garmin sleep backfill so the history has depth.
  The sleep sync's single bulk write failed on rows of mixed shape (PostgREST
  PGRST102) and wrote nothing; it now writes one shape at a time, and the
  backfill ran. Older nights carry sleep but no HRV, so the history starts
  where HRV does. The backfill also completes the 60-night baseline the
  reading was built for: a band read on fewer nights can change when it fills.
- 2026-10-14 — Built as tekio v2.2.29 and walked at 412 px on invented data:
  overnight HRV inside, under and held, a baseline still building, morning
  HRV and the check-in, each with the chart scrubbed. No console errors.
  Pushed to develop.
- 2026-10-14 — Peter: six months was too much, and what he was looking for
  was the 60 nights the sheet's sentence names. The chart now covers the
  reading's own window, the 60 nights before this week and the week itself
  (for the check-in, the 28 days and today), with today's normal drawn across
  it as one band. Built as tekio v2.2.30, walked the same way, pushed to
  develop.
- 2026-10-14 — Peter: a day read by touch stayed on the readout and nothing
  brought the legend back. A finger lifting kept it on purpose, and only a
  scroll cleared it. A second tap on the day, or a tap anywhere outside the
  chart, now puts it away; the legend keeps its room under the readout, so
  the sheet no longer jumps a line when they swap. Built as tekio v2.2.31,
  walked at 412 px with a simulated finger and a mouse on all three
  methods, pushed to develop.

# RFC 0109: Readiness as a point on your normal, with its history

## Summary

Home's readiness column draws the recent read as a dot placed on the
person's normal, a grey band in the middle of the track, instead of a fill,
and prints numbers that agree with where the dot sits. The readiness sheet one
tap away draws the same gauge larger with its numbers, says what the single
reading behind the week was and where the normal comes from, and charts those
days: for HRV the 60 nights before this week and the week itself, with
today's normal drawn across them. Overnight HRV, morning HRV and the check-in
all read this way, each against its own normal.

## Motivation

- A fill reads as an amount. The bar was the 0–100 score, 50 at the person's
  baseline, so a good week read as a short bar and the bar looked broken.
- With the normal shaded on the same track, one bar measured two things: a
  fill that starts at zero and a range that starts part way along. The eye
  compares where the fill ends with where the range starts, which is not what
  the verdict compares.
- Each number was rounded on its own, so a week under the normal could print
  as the normal's first value. Invented figures: a 61.6 ms week against an
  edge at 62.07 printed "62 ms · your normal 62–71 ms" on a Steady day.
- The sheet gave the band's source in one line. The next questions had no
  answer on screen: was last night good, which nights the normal comes from,
  and whether this week is one bad week or a slide.

## Goals

- The card says where the recent read sits against the person's usual at a
  glance, without reading a number, and the number beside it agrees.
- Under, inside and above the normal are three positions anyone can tell
  apart, and the band's edges are where the verdict's are.
- The sheet answers the next three questions: the single reading behind the
  week, which nights the normal comes from, and where this week sits among
  them.
- Morning HRV and the check-in read the same way on their own normals; a
  person who does not use HRV sees nothing about HRV.
- First paint stays inside the perf budget, and the chart loads with the
  sheet.

## Non-Goals

- The readiness maths. Windows, bands, SD floors and thresholds stay as
  [0085](done/0085-push-gate-own-baseline.md) and
  [0092](done/0092-readiness-method-in-profile.md) set them.
- The sleep score column. It is an amount out of 100 and keeps its fill.
- A z-score or the 0–100 score on screen. The card stays word-only
  (0085: the digits confused).
- A setting, a new section, or a Recharts chart.

## Proposal

**The gauge** (`src/components/tabs/home/ReadinessGauge.tsx`, T1). One track
with the normal fixed at its middle 40 % (`GAUGE_NORMAL` in
`src/lib/fusedRead.ts`) and the reading as a dot. The dot is placed linearly
from the unrounded values, in the unit the method computes in: ln ms for HRV,
points for the check-in. A reading under or over the normal keeps at least
2 % of the track off the band's edge, so a hair under never draws inside, and
anything further out pins to the ends. Card size: a 3 px track and a 9 px dot.
Sheet size: a 6 px track and a 14 px dot, with the value over the dot and the
normal's edges under the band. On a held day the card inverts (design-system
§2) and the dot goes white.

**Numbers that agree** (`wholeNumbers`). The normal prints as the whole values
its own test reads inside it. The recent value rounds to the nearest whole
value on its own side of the edge. A normal narrower than one unit prints its
middle.

**The card** (`HomeTab.tsx`). `HRV · 7 NIGHTS` with the mean in ms, the gauge
and "your normal L–H ms"; `MORNING HRV · 7 DAYS` the same; `CHECK-IN` with
"N of 25", the gauge and "your usual L–H". Before a first verdict the column
prints the single reading over an empty track, with "building your normal ·
have of need".

**The sheet** (`RecoverySheet.tsx`, T2). The band word and the method; the
large gauge; one line placing the read ("7‑night average N ms, under your
normal of L–H ms.", with "well under" on a Low day); the single reading and
why it does not decide ("Last night N ms. One night is too noisy to act on, so
the 7‑night average decides.", or the morning's); where the normal comes from
("Your normal comes from the 60 nights before this week."); then the history.

**The chart** (`readinessTrend` in `fusedRead.ts`; `ReadinessTrend.tsx`).
The reading's own window: for HRV the 60 days its normal comes from and the 7
it reads (67 days), for the check-in the 28 days and today, headed
"HRV · 60 NIGHTS + THIS WEEK" or "CHECK-IN · 28 DAYS + TODAY". A history
shorter than the window starts at its first reading ("SINCE 3 OCT"). Each day
carries its single reading, the read (the 7-day geometric mean for HRV, the
day's total for the check-in) and the read as the screen prints it, on its own
side of today's normal. The window carries today's normal, from the reading's
own baseline, edges and side test, so the last day is today's reading and a
test holds it there. Hand-drawn SVG in the sheet's lazy chunk, per
design-system §9: today's normal as one band across the window, the read as
the ink line, single readings as second-series dots behind it, the check-in
as ink dots, the window's first day and today at the ends of the axis with
the months between, and two to four gridlines. Touching a day prints it
under the chart: "Wed 8 Oct · night N · 7‑night average N ms", with "tap
again to clear". It stays when the finger lifts, so it can be read; a second
tap on it, within 16 px of its day because a day can be narrower than a
fingertip, or a tap anywhere outside the chart puts it away. The readout is
printed over the legend, which keeps its room, so nothing below moves. A
mouse reads the day under it and drops it on leaving.

**The sync** (`scripts/garmin-sync/sync_sleep.py`). Rows go up in groups of
one key shape, so a long backfill writes.

## Rationale

- **A dot, not a fill.** The verdict asks where this week sits against where
  the person usually is. That is a position, not an amount, and a dot on a
  range draws exactly that.
- **The normal at a fixed place.** The band sits in the same place on every
  card, so the read is left of grey, on grey or right of grey, and the same
  picture means the same verdict for everyone. An absolute axis in ms was
  rejected: HRV is individual, so two people on the same verdict would see
  different pictures, and most of the axis would be empty for both.
- **Linear in ln ms.** The reading is computed on ln HRV (0085), so the dot is
  placed in the same space, where equal distances are equal z.
- **The reading's own window, not six months.** Six months shipped first, in
  v2.2.29, and was too much: what Peter looked for was the 60 nights the
  sentence above the chart names. Showing exactly those nights and the week
  read against them makes the chart and the sentence say the same thing.
- **Today's normal as one band.** The v2.2.29 band was the normal as it stood
  each day. Across the window today's normal is built from, that drew a
  normal the sentence does not describe. One band shows the nights scattered
  around the normal they make, and this week against it.
- **The average as the line, single readings as dots.** The line is what
  decides; the dots show why one reading does not. Single readings as the
  main series would be noise.
- **The check-in as dots.** It reads each day on its own against the 28 days
  before it. A line would draw a continuity the read does not use.
- **Hand-drawn SVG over Recharts.** Recharts is its own large chunk, and the
  sheet would wait on it when opened from Home. The chart needs one band, one
  line and dots.
- **`readinessTrend` beside the reading in `fusedRead.ts`.** It shares the
  reading's private normal and band tests, so the two cannot draw different
  normals. That costs about 1.2 kB of first paint, measured from the build;
  moving it into the lazy chunk would export the normal's internals.

## Doctrine checklist (§4)

1. **Read sharpened:** Home's readiness card, the push-or-rest question of
   the exit condition, and the readiness sheet one tap from it.
2. **Stops:** a bar that read as broken on a good week, and a printed number
   that contradicted its band.
3. **Input or destination:** neither is new. The same read is drawn honestly,
   and its history lives in the sheet that already exists.
4. **Honest shape:** a position against a personal range, not an amount (P2).
   One systemic read (P5), never split per adaptation.
5. **Physiological number:** none new. Every window, edge and floor drawn is
   0085's or 0092's. The gauge's geometry and the chart's window are display
   choices, so `/ground` Step 0 does not fire.

## Acceptance

- [x] The card draws the read as a dot on the normal for overnight HRV,
      morning HRV and the check-in, and the printed number and range agree
      with the dot's side (`src/test/fusedRead.test.ts`: `wholeNumbers`, the
      readiness gauge).
- [x] The sheet shows the larger gauge, the single reading behind the week,
      the normal's source and the history; walked at 412 px on invented data
      for every method and state, with no console errors.
- [x] The chart covers the 60 nights before this week and the week (the
      check-in: 28 days and today), with today's normal across it, and its
      last day is today's reading (`readinessTrend` tests).
- [x] A day read by touch can be put away, by a second tap on it or a tap
      outside the chart, and the legend comes back without the sheet
      moving; walked at 412 px with a simulated finger and a mouse for every
      method.
- [x] First paint inside the perf budget: 347.38 kB against 353.21 kB.
- [x] A one-year Garmin sleep backfill writes.
- [ ] Peter checks the card and the sheet on his phone on staging.

## Unresolved questions

None.
