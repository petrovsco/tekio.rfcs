---
title: Every Garmin activity type lands somewhere, by rule
authors: [Peter Petrov]
created: 2026-09-27
last_updated: 2026-09-27
status: planned
status_note: Opened after volleyball sat unmapped for weeks; nothing blocks it.
label: feature
---

# RFC 0073: Every Garmin activity type lands somewhere, by rule

## Summary

The activity sync maps Garmin types to app rows one key at a time
(`CARDIO_TYPE_KEYS`, `SPORT_TYPE_KEYS`) and silently skips everything else.
Turn that around: every activity Garmin records ends up as a cardio row, a
sport row, or an explicit skip, and a type the sync has never seen is handled
by a default rule and reported, not dropped.

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

- An unknown `typeKey` never vanishes. It either lands by a default rule or
  makes the run visibly unhappy, whichever the decision below picks.
- The maps are completed from data: a full-history dry run
  (`days=3650`, `dry_run=true`) inventories every `typeKey` ever recorded, and
  each one is assigned cardio, sport or skip-by-decision.
- `SKIPPED_BY_DECISION` stays the one place a type is left out on purpose.

## Non-Goals

- New destinations. Every activity lands in `cardio_sessions` or
  `sport_sessions`; a new table or section is out (doctrine R1).
- Strength sets from Garmin. `strength_training` has no sets or reps in the
  summary and stays skipped for that reason.
- Overturning the walking / hiking / skating decision of 2026-09-06 by default.
  "All possible sessions" is read as *all training sessions*; whether those
  three count is an unresolved question below, not an assumption.

## Proposal

1. **Inventory.** Run the full-history dry run (two years is already clean — see Motivation) and record the `typeKey` list
   with counts and date ranges (the dump's `analyze_dump.py` already does most of
   this).
2. **Map what the inventory finds.** Endurance modalities go to
   `CARDIO_TYPE_KEYS` under the four existing `activity_type` values or
   `custom`. Ball, racket and team games go to `SPORT_TYPE_KEYS`, creating the
   sport type if needed (`create_sport_type` already does). Everything else
   is added to `SKIPPED_BY_DECISION` with its reason.
3. **Default for the never-seen key.** Candidate: land it as a sport row named
   after Garmin's own `typeKey` (title-cased). The app's sport classification
   reads Garmin's Training Effect, not the sport's name, so an unknown sport is
   still classified honestly. The alternative is to fail the run so the Actions
   email is the notification.
4. **Make skips visible on the daily run.** A non-zero count of unmapped
   activities is a warning annotation (`::warning::`) on the run, so a new type
   shows up on the Actions page without anyone opening a dry-run log.
5. **Backfill** once, with the maps complete, over the full history. Hand-logged
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
which depends on a human reading a log. A default rule plus a visible warning
keeps the "from data" discipline without the silent loss.

## Acceptance

- [ ] A full-history dry run reports zero unmapped types
- [ ] Every entry in `SKIPPED_BY_DECISION` carries its reason
- [ ] A daily run that meets an unmapped type shows a warning on its Actions
      page (or lands it by the default rule, per the decision below)
- [ ] The full-history backfill is run and claims hand-logged rows rather than
      doubling them

## Unresolved questions

- **Walking, hiking, skating.** Excluded on 2026-09-06 as "not a stimulus the
  app counts." Does "all sessions" reopen that, or does it stand?
- **Default for an unknown type:** land it as a sport named after the Garmin
  key, or fail the run?
- **Beach volleyball.** The app keeps `Beach Volleyball` apart from
  `Volleyball`. Whether Garmin has a separate key for it is unknown until the
  inventory runs.
