---
title: Planned sessions on Cardio and Mobility
authors: [Peter Petrov]
created: 2026-10-11
last_updated: 2026-10-11
status: in progress
status_note: "Code built on branch claude/planned-mobility-cardio-svmg5c; waits on Peter's word to create the planned_sessions table before it can reach develop."
label: feature
---

# RFC 0104: Planned sessions on Cardio and Mobility

## Progress log

- 2026-10-11: Raised by Peter. A day planned ahead by an agent had lifts,
  a mobility block and a sport game in it; only the lifts had somewhere to go,
  because the Planned card ([0098](done/0098-planned-exercises.md)) exists on
  Weights alone and its table holds an exercise name plus kg × reps targets.

## Summary

Give Cardio and Mobility the same yellow Planned card Weights has. A cardio
plan names a type and a target length (optionally distance, format, bout); a
sport plan names a sport and optionally a length; a mobility plan lists
stretches with minutes. "Log" fills that tab's form; saving the form logs the
work and the plan leaves the card. A plan never counts toward any read until it
is logged.

## Motivation

0098 made "work that has not happened yet" a state, but only for lifts. A real
day is rarely only lifts: the planned mobility block and the evening game had
no home, so the plan an agent wrote lived half in the app and half in a chat
message. The doctrine's purpose is the read; a plan only helps it if the whole
day is in one place.

## Goals

- A Planned card on Mobility and on Cardio, looking and folding like the
  Weights one, listing Today, Later and a quiet "Not logged" line.
- Add, edit and remove plans from a sheet on each tab.
- "Log" prefills the tab's form; saving links the plan to the entry it became.
- A Garmin-synced cardio or sport session of the same type or sport on the
  plan's day also takes the plan off the card, since that work did happen.

## Non-Goals

- No change to Weights plans or their table.
- No plan touches Home or any read: no outline on the body map, no count, no
  minutes toward a target (0098's rule, unchanged).
- Programs, generating plans (0099).

## Proposal

1. **Data**: one new table, `planned_sessions`: date, `kind`
   (`cardio` · `sport` · `mobility`), a name (the cardio type, the sport, or
   empty for mobility), a `target` jsonb whose shape follows the kind, notes,
   sort order, who planned it, and one nullable link per kind to the logged row
   (`cardio_session_id`, `sport_session_id`, `mobility_session_id`, each
   `on delete set null`). A new table rather than a `kind` column on
   `planned_exercises`, because the build on `master` lists every row of that
   table on its Weights card. Expand only.
2. **Code**: the Weights card's frame (fold, Today / Later / Not logged, add
   link) becomes one shared shell; Weights, Cardio and Mobility each fill it
   with their own rows. One sheet per kind writes the plans.
3. **Matching**: a plan is off the card when it is linked, or (cardio and
   sport only) when a session of the same type or sport is logged that day.

## Rationale

A `kind` column on `planned_exercises` would put cardio and mobility plans on
production's Weights card until the next release, and would bend a lift shape
(name + kg × reps) around minutes. One table for the three non-lift kinds keeps
production untouched and keeps their shapes honest.

## Acceptance

- [ ] `planned_sessions` exists live, created with Peter's word.
- [ ] Mobility shows a Planned card; a plan logged from it leaves the card and
      the session appears in History.
- [ ] Cardio shows a Planned card with cardio and sport plans; logging one from
      the card leaves it, and a Garmin-synced session of the same type that day
      clears it too.
- [ ] Weights' Planned card behaves exactly as before.
- [ ] Checked on staging on a 412 px phone.

## Unresolved questions

None.
