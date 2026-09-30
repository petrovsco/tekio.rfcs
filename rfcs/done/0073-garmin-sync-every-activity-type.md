---
title: Every Garmin sport is mapped before it is ever played
authors: [Peter Petrov]
created: 2026-09-27
last_updated: 2026-09-30
status: done
status_note: "done 2026-09-30 (v2.1.8–v2.1.9): all 154 Garmin types decided in `activity_types.json`; the full-history backfill synced the one skating session and created `Skating`. Yoga, pilates and mobility went on to [0083](../0083-garmin-yoga-pilates-mobility-sync.md)."
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

- [x] The catalogue is committed, and a test proves every key in it is in
      exactly one of the three maps
- [x] A catalogued sport never played before syncs on first play, creating its
      sport type
- [x] Skating syncs as a `Skating` sport; walking and hiking stay skipped with
      the corrected reason
- [x] A Garmin volleyball activity named with "beach" lands under
      `Beach Volleyball`, any other under `Volleyball`
- [x] A key missing from the catalogue is skipped, the run succeeds, and the
      run shows a warning
- [x] The full-history backfill is run and claims hand-logged rows rather than
      doubling them

## Unresolved questions

None open. The borderline endurance types were decided on 2026-09-30 (see
*Outcome*). Hiking stays skipped and remains the call most likely to be
revisited.

## Outcome — 2026-09-30, v2.1.8–v2.1.9

**The catalogue.** A manual run of the activity workflow gained a `catalogue`
input (v2.1.8) that uploads `get_activity_types()` as an artifact, so the pull
happened in CI, where the token is. Garmin returned **154 types** in 16 parent
categories. They are committed, decided, as
`scripts/garmin-sync/activity_types.json` in the code repo, plus the legacy
`rowing` key Garmin no longer lists, so old activities in a backfill still map.

**One file instead of three hand-kept maps.** Each type carries exactly one of
`cardio`, `sport` or `skip`, and a skip names a written reason. The sync builds
`CARDIO_TYPE_KEYS`, `SPORT_TYPE_KEYS` and `SKIPPED_BY_DECISION` from it, and so
does `analyze_dump.py`, which had its own stale `{"tennis_v2"}`. The check lives
in Vitest (`src/test/garminActivityTypes.test.ts`), so `npm run test`, which is
release step 1, runs it. It checks four things: every type is decided exactly
once; no type is listed twice; cardio lands only on a modality the app has; and
every skip has a reason. A type added without a decision was shown to fail it,
by name.

**Decisions taken 2026-09-30** (Peter), on top of the 2026-09-27 ones:

| Decision | Types |
|---|---|
| Cardio, existing modality | 9 running, 15 cycling, 3 swimming, 3 rowing variants (e.g. ultra run, track and enduro cycling, hand cycling) |
| Cardio, `custom` (none of Running / Cycling / Swimming / Indoor Rowing) | 17: elliptical, stair and floor climbing, indoor, cross-country and skate skiing, backcountry skiing and snowboarding, jump rope, `indoor_cardio`, kayaking, paddling, SUP, wheelchair push-run, and both grinding types |
| Sport | 47: every team and racket sport; board, water and gravity sports; golf, disc golf, archery, resort skiing and snowboarding, BMX and downhill biking, climbing, boxing, MMA, dance, horseback riding, sailing, whitewater; skating and inline skating both as `Skating` |
| Skip | 60, under 8 reasons: walking-type (8 — the corrected reason), strength, mobility (yoga, pilates, mobility — to [0083](../0083-garmin-yoga-pilates-mobility-sync.md)), not training (31), safety alerts, catalogue categories, multisport containers and transitions, and Garmin's generic *Other* |

**Grounding: no new claim.** A synced cardio row and a synced sport row both
go through `classifyGarminIntensity` on their own Training Effect, and neither
path reads the modality or the sport. So mapping a type to `custom` or to a
sport changes where a session shows, not what it credits: `/ground` Step 0's
exemption for a change that makes no new claim.

**Beach volleyball** is decided by the name: `sport_name()` sends a
`volleyball` activity whose name contains "beach" to `Beach Volleyball`. The
catalogue has no separate beach key.

**The warning.** A key in none of the maps is still skipped and listed, and the
run now prints a `::warning::` annotation naming it. The run still succeeds.

**Backfill.** A full-history dry run, then the real run (`days=3650`, 288
activities from 2016-10-03): **one new row**, the skating session of
2025-02-16, which created the `Skating` sport type. Checked in the database:
`source = garmin`, with a Garmin id. Everything else was already synced (226
cardio, 8 sport). There were no hand-logged rows to claim, and no unknown
type came up.

**What the evidence does and does not cover.** The beach rule, the unknown-key
skip and first-play type creation for a *new* key were exercised offline, by
calling the sync's routing on constructed activities; first-play creation was
also seen live, with Skating. Two things were **not seen on a real run**,
because the history holds no case of them: a beach-named volleyball activity,
and an uncatalogued key (so the warning line has not yet appeared on the
Actions page). The claim rule is 0041's, unchanged, and had nothing to claim
here.
