---
title: Every Garmin sport is mapped before it is ever played
authors: [Peter Petrov]
created: 2026-09-27
last_updated: 2026-09-30
status: planned
status_note: Opened after volleyball sat unmapped for weeks. Scope set on 2026-09-27 to Garmin's whole catalogue, not the types seen so far; nothing blocks it.
label: feature
release: 2.2.0
---

# RFC 0073: Every Garmin sport is mapped before it is ever played

## Summary

The activity sync maps Garmin types to app rows one key at a time
(`CARDIO_TYPE_KEYS`, `SPORT_TYPE_KEYS`), and only after a key has shown up on
a real activity. Replace that with the whole list: Garmin publishes its catalogue
of activity types, so decide every entry in it once, and commit the result.
The first time a sport from that catalogue is played, it syncs with no change
to the sync.

## Motivation

`SPORT_TYPE_KEYS` grows only when someone reads a dry-run log and notices a
`Skipped, no mapping` line. Volleyball is the case in point. `volleyball` was
skipped on every daily run until 2026-09-27, when a 30-day backfill printed
`Skipped, no mapping: volleyball ×3`, even though a `Volleyball` sport type
with a dozen hand-logged rows already existed. It was mapped in code v2.0.96.
The daily run never says this out loud, because a skip is a normal outcome.

Once volleyball was mapped, a 730-day dry run (2026-09-27, 143 activities)
found no unmapped type at all. The only skips were by decision:
`strength_training` ×42 and `skating_ws` ×1. That is exactly the problem: the
maps are complete for what has already been played. The first padel, basketball
or ski-touring session will be skipped as quietly as volleyball was, and
someone will have to notice and add it.

Each missed session is a gap in the read the app exists for: the cardio
adaptations are computed from what is logged, so a sport played but not synced
makes Home report a shortfall that isn't real.

## Goals

- Every entry in Garmin's activity-type catalogue is decided up front: cardio,
  sport, or skip with a reason.
- Playing a catalogued sport for the first time needs no code change. The sync
  lands it, and creates its sport type if the app does not have one yet.
- A type Garmin adds *after* the catalogue was pulled is the only thing that
  can still be unknown. It is skipped, and the run warns about it.

## Non-Goals

- New destinations. Every activity lands in `cardio_sessions` or
  `sport_sessions`; a new table or section is out (doctrine R1).
- Strength sets from Garmin. `strength_training` has no sets or reps in the
  summary and stays skipped for that reason.
- Pulling the catalogue at runtime. It is pulled once, decided by a person and
  committed. A daily run that fetched it live could only guess about a new
  entry, which is what the Decisions below rule out.

## Decisions

Taken 2026-09-27.

- **Scope — the whole catalogue.** Every sport Garmin knows is mapped, not only
  the ones played so far. This overturns RFC 0041's rule of mapping only keys
  seen on a real activity. That rule kept the maps from growing on guesses; here
  the guess is only the sport's *name*, because a sport row is classified from its
  own Training Effect, never from which sport it is.
- **Walking — skip.** The 2026-09-06 exclusion stands, but its recorded reason
  was wrong. Walking was left out because it fits neither table: it is not a
  cardio session in the app's sense (no rowing / running / cycling / swimming
  modality, no intervals) and it is not a sport either.
- **Hiking — skip,** for the same reason as walking. It is the closer call of
  the two; it comes back only with a reason stronger than "it was recorded."
- **Skating — sport.** Garmin's `skating_ws` maps to a `Skating` sport type.
- **Unknown types — skip, with a warning.** No rule guesses where a type
  missing from the committed catalogue goes.
- **Beach volleyball — a label on Volleyball, or its own sport type.** In two
  years Garmin sent only `volleyball` for both. The app already has a
  `Beach Volleyball` sport type. A Garmin volleyball activity whose name contains
  "beach" lands under `Beach Volleyball`, the way a HIIT activity's name picks
  its modality (RFC 0054); any other lands under `Volleyball`. Either way the
  Garmin activity name is kept in `notes`, which is the label if the name rule
  ever misfires. If the catalogue has a separate beach key, that key maps to
  `Beach Volleyball` directly.

## Proposal

1. **Pull the catalogue.** `garminconnect`'s `get_activity_types()` (present in
   the pinned 0.3.x) returns every `typeKey` Garmin knows, each with its parent
   category. Save the list with a one-off script next to `analyze_dump.py`. The
   list is Garmin's product data, not personal data, so it can be committed.
2. **Decide every entry.** Sports go to `SPORT_TYPE_KEYS`, each with the app
   sport name it lands under. Existing app names win: `tennis_v2` stays
   `Tennis`, `volleyball` stays `Volleyball`. A new name reads the way Garmin
   shows it in its app, not the raw key. Endurance modalities go to
   `CARDIO_TYPE_KEYS`; one that fits none of the four existing modalities is
   checked against `/ground`'s Step 0 before it goes in as `custom`.
   Everything else goes to `SKIPPED_BY_DECISION` with its reason; a parent
   category can carry one reason for all its children. Garmin's parent
   categories do most of the sorting, and a person reads the result before it
   is committed.
3. **A check that the maps cover the catalogue.** A test asserts that every
   committed catalogue key is in exactly one of the three maps. Adding a key to
   the catalogue without deciding it fails the test.
4. **Apply the other decisions:** the beach-volleyball name rule, and the
   corrected walking and hiking reasons in `SKIPPED_BY_DECISION`.
5. **Warn on the truly unknown.** A daily run that meets a key in none of the
   maps skips it and writes a `::warning::` annotation, so it shows on the
   Actions page. The run still succeeds. A warning means Garmin has added a
   type: re-pull the catalogue and decide the new entries.
6. **Backfill** once over the full history (`days=3650`). Hand-logged rows are
   claimed, not doubled (RFC 0041's claim rule).

## Doctrine checklist

1. **Which read does this sharpen?** The cardio adaptations on Home and
   Adaptations (anaerobic, VO₂max, endurance), which count sport and cardio
   sessions.
2. **What does it let me stop doing?** Hand-logging sessions the watch already
   recorded, and editing the sync each time a new sport is played.
3. **Input or destination?** Input. No new surface.
4. **Honest shape of the data?** Per-session, whole-body; the same shape the
   existing cardio and sport rows have.
5. **Does it write a number claiming physiological meaning?** Not for sports.
   A sport row is classified by the existing `classifyGarminIntensity` from its
   own Training Effect, so mapping a new sport claims nothing new. A new *cardio*
   mapping chooses which rules read it, which is why step 2 sends each one
   through `/ground`'s Step 0.

## Rationale

Mapping key by key was right while the sync was new. It fails because each new
key waits for someone to read a log. Garmin's catalogue is finite and
published, so it can be decided up front. The risk of mapping sports never
played is small, because the app classifies a sport row from its intensity data
and not from its name. A wrong name is a cosmetic fix, not a wrong read. Keys
Garmin adds later are the only gap, and the warning closes it.

## Acceptance

- [ ] The catalogue is committed, and a test proves every key in it is in
      exactly one of the three maps
- [ ] A catalogued sport never played before syncs on first play, creating its
      sport type
- [ ] Skating syncs as a `Skating` sport; walking and hiking stay skipped with
      the corrected reason
- [ ] A Garmin volleyball activity named with "beach" lands under
      `Beach Volleyball`, any other under `Volleyball`
- [ ] A key missing from the catalogue is skipped, the run succeeds, and the
      run shows a warning
- [ ] The full-history backfill is run and claims hand-logged rows rather than
      doubling them

## Unresolved questions

- **Borderline endurance types.** Elliptical, stair stepper, ski erg,
  cross-country skiing and similar fit none of the four cardio modalities. For
  each: `custom` cardio, a sport, or skip? Decide during step 2, once the
  catalogue shows which of them Garmin has.
- **Hiking** is the decision most likely to be revisited.
