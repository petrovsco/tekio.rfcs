---
title: The Cardio screen reads through one lens — Cardio, Sport or All
authors: [Peter Petrov]
created: 2026-09-28
last_updated: 2026-09-28
status: done
status_note: "shipped in v2.0.98 — the log mode became a screen-level lens that the progress chart, sessions per week and the history all follow."
label: feature
---

# RFC 0076: The Cardio screen reads through one lens

## Summary

The Cardio/Sport toggle used to switch the log form and nothing else, so a
sport form sat above a running chart, a sport-only frequency card and a merged
history. It is now a lens over the whole screen: **Cardio** (the default),
**Sport**, **All**. Every card below the lens follows it.

## Goals

- **Progress.** Under Cardio it stays as it was: duration, plus pace per
  cardio type. Under Sport it charts duration and **average heart rate**, with
  chips for each sport. Under All it charts duration and average heart rate,
  with chips for Cardio and Sport.
- **Sessions per week** replaces the sport-only card. Its drill-down lists only
  what the lens admits: every cardio type, or every sport, or under All just
  Cardio and Sport. The win/loss record appears once a single sport with a
  competitor is picked, as before.
- **Session history** lists only the lens's rows, and its type filter lists
  only the lens's names.
- **Logging under All** gets its own Cardio/Sport switch, because under All the
  lens can't say which form to show.

## Which read does this sharpen?

The Cardio screen's own history reads: Progress, the session count and the
list. Home is untouched. Doctrine ranks capture below the read, so this is
worth doing only because it makes those reads **honest**. Before, a heart-rate
question about a sport had no chart at all, and the frequency card could not
show cardio.

- **What it lets us stop doing:** keeping a sport-only card beside a
  cardio-only chart. The two are now one card each, driven by the lens.
- **Input or destination:** neither. It adds no section, so R1 is unaffected.
- **Honest shape:**
  - Per session, every session is a point. A missing heart rate is bridged,
    because it means "not recorded", not "no training".
  - Rolled up by week or month, an empty bucket stays a gap. Average heart rate
    is weighted by duration, the same way pace is weighted by distance.
  - Sessions per week gets a time frame and fills empty weeks. The Garmin
    backfill put three years of runs under it, and without a frame that is a
    comb of bars. All time counts by month.
- **Grounding:** exempt. Average heart rate is the recorded value, and the
  rollup is arithmetic. No threshold, zone or classification is introduced. A
  match's average is an intermittent one, and the chart claims no more than
  that.

## Change

- `CardioTab.tsx` holds the lens.
- `cardio/lens.ts` holds the lens type and the merged, newest-first session
  list.
- `cardio/Progress.tsx` is the chart, moved out of the tab.
- `cardio/SessionsPerWeek.tsx` replaces `SportProgress.tsx`.
- `SessionList` takes the lens.
- `rollupCardio` in `src/lib/utils.ts` now also returns a duration-weighted
  `avgHr`, and accepts a session with no duration (it counts the session and
  adds no minutes).
- `hasLonePace` became `hasLonePoint`, which takes the field it checks.

## Non-Goals

- The database merge of cardio and sport rows. It remains its own brief.
- Remembering the lens between visits. Cardio is the default every time.
- Heart rate on the Cardio lens. There, pace stays the second series.

## Acceptance

Checked in a headless Chromium at 390 px, against invented data mounted into
the real components (no local database credentials):

- All three lenses render.
- The Sport lens drills to one sport, and the record shows for a sport that
  tracks a competitor.
- The history and its filter follow the lens.
- Typecheck, 233 tests, lint (0 errors), knip, perf budget and build are all
  green.
