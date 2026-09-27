---
title: Every Garmin activity type is decided, and a new one is noticed
authors: [Peter Petrov]
created: 2026-09-27
last_updated: 2026-09-27
status: planned
status_note: Opened after volleyball sat unmapped for weeks. The open questions were decided on 2026-09-27; nothing blocks it.
label: feature
---

# RFC 0073: Every Garmin activity type is decided, and a new one is noticed

## Summary

The activity sync maps Garmin types to app rows one key at a time
(`CARDIO_TYPE_KEYS`, `SPORT_TYPE_KEYS`) and silently skips everything else.
Turn that around: every activity type Garmin records is decided — a cardio
row, a sport row, or a skip with a reason — and a type the sync has never seen
is skipped *out loud*, with a warning on the run, instead of quietly.

## Motivation

`SPORT_TYPE_KEYS` grows only when someone reads a dry-run log and notices a
`Skipped, no mapping` line. Volleyball is the case in point. `volleyball` was
skipped on every daily run until 2026-09-27, when a 30-day backfill printed
`Skipped, no mapping: volleyball ×3`, even though a `Volleyball` sport type
with a dozen hand-logged rows already existed. It was mapped in code v2.0.96.
The daily run never says this out loud, because a skip is a normal outcome.

Once volleyball was mapped, a 730-day dry run (2026-09-27, 143 activities)
found no unmapped type at all. The only skips were by decision:
`strength_training` ×42 and `skating_ws` ×1. So the maps are complete for
two years of history today. What this RFC fixes is that the *next* new type
would go missing just as quietly, plus whatever lies further back than two
years.

Each missed session is a gap in the read the app exists for: the cardio
adaptations and the muscle read are computed from what is logged, so a sport
played but not synced makes Home report a shortfall that isn't real.

## Goals

- An unknown `typeKey` is skipped, never guessed at, but the run says so where
  it will be seen.
- The maps are completed from data: a full-history dry run
  (`days=3650`, `dry_run=true`) inventories every `typeKey` ever recorded, and
  each one is assigned cardio, sport or skip-by-decision.
- `SKIPPED_BY_DECISION` stays the one place a type is left out on purpose.

## Non-Goals

- New destinations. Every activity lands in `cardio_sessions` or
  `sport_sessions`; a new table or section is out (doctrine R1).
- Strength sets from Garmin. `strength_training` has no sets or reps in the
  summary and stays skipped for that reason.
- Walking and hiking. They stay out, and the reason is corrected (see
  Decisions): not that they are no stimulus, but that neither table fits them.

## Decisions

Taken 2026-09-27, answering the questions this RFC opened with.

- **Walking — skip.** The 2026-09-06 exclusion stands, but its recorded reason
  was wrong. Walking was left out because it fits neither table: it is not a
  cardio session in the app's sense (no rowing / running / cycling / swimming
  modality, no intervals) and it is not a sport either.
- **Hiking — skip,** for the same reason as walking. It is the closer call of
  the two; it comes back only with a reason stronger than "it was recorded."
- **Skating — sport.** Garmin's `skating_ws` maps to a `Skating` sport type,
  created by the sync if it does not exist, and is classified like any sport
  from its Training Effect. One activity in the two-year window.
- **Unknown types — skip.** No default rule guesses where a never-seen type
  goes. It is skipped, and step 3 below makes the skip visible.
- **Beach volleyball — a label on Volleyball, or its own sport type.** In two
  years Garmin sent only `volleyball`, so the watch does not tell them apart.
  The app already has a `Beach Volleyball` sport type. A Garmin volleyball
  activity whose name contains "beach" lands under `Beach Volleyball`, the way a
  HIIT activity's name picks its modality (RFC 0054); any other lands under
  `Volleyball`. Either way the Garmin activity name is kept in `notes`, which is
  the label if the name rule ever misfires. If a full-history inventory turns up
  a separate Garmin key, that key maps to `Beach Volleyball` directly.

## Proposal

1. **Inventory.** Run the full-history dry run (two years is already clean — see Motivation) and record the `typeKey` list
   with counts and date ranges (the dump's `analyze_dump.py` already does most of
   this).
2. **Apply the decisions.** `skating_ws` moves from `SKIPPED_BY_DECISION` to
   `SPORT_TYPE_KEYS` as `Skating`. The volleyball name rule for beach is added.
   `walking` and `hiking` keep their place in `SKIPPED_BY_DECISION` with the
   corrected reason. Anything new the inventory finds is decided the same way:
   an endurance modality to `CARDIO_TYPE_KEYS`, a game or sport to
   `SPORT_TYPE_KEYS`, anything else to `SKIPPED_BY_DECISION` with its reason.
3. **Make skips visible on the daily run.** A non-zero count of unmapped
   activities is a warning annotation (`::warning::`) on the run, so a new type
   shows up on the Actions page without anyone opening a dry-run log. The run
   still succeeds; skipping is the decided behaviour, the warning is only the
   notice that there is something new to decide.
4. **Backfill** once, with the maps complete, over the full history. Hand-logged
   rows are claimed, not doubled (RFC 0041's claim rule).

## Doctrine checklist

1. **Which read does this sharpen?** The cardio adaptations on Home and
   Adaptations (anaerobic, VO₂max, endurance), which count sport and cardio
   sessions.
2. **What does it let me stop doing?** Hand-logging sessions the watch already
   recorded, and reading dry-run logs to find out what the sync is dropping.
3. **Input or destination?** Input. No new surface.
4. **Honest shape of the data?** Per-session, whole-body; the same shape the
   existing cardio and sport rows have.
5. **Does it write a number claiming physiological meaning?** No new one. Rows
   are classified by the existing `classifyGarminIntensity` from Garmin's
   Training Effect. Deciding that a type is a cardio modality rather than a
   sport chooses which rules read it, so each cardio mapping beyond the four
   existing modalities is checked against `/ground`'s Step 0 before it lands.

## Rationale

Mapping key by key was right while the sync was new: RFC 0041 mapped only keys
seen on real activities so that the maps grew from data, not guesses. That
still holds for choosing *where* a type goes. What fails is the discovery step,
which depends on a human reading a log. Guessing a home for an unknown type
would trade that silence for rows in the wrong place; a skip plus a visible
warning keeps the "from data" discipline without the silent loss.

## Acceptance

- [ ] A full-history dry run reports zero unmapped types
- [ ] Every entry in `SKIPPED_BY_DECISION` carries its reason
- [ ] Skating syncs as a `Skating` sport; walking and hiking stay skipped with
      the corrected reason
- [ ] A Garmin volleyball activity named with "beach" lands under
      `Beach Volleyball`, any other under `Volleyball`
- [ ] A daily run that meets an unmapped type succeeds, skips it, and shows a
      warning on its Actions page
- [ ] The full-history backfill is run and claims hand-logged rows rather than
      doubling them

## Unresolved questions

None open. Hiking is the decision most likely to be revisited.
