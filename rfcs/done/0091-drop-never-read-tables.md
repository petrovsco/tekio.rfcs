---
title: Drop the tables no build reads
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: done
status_note: "Applied 2026-10-04 through the Supabase connector as 20261004092442 drop_never_read_tables (tekio e854272, v2.1.21). All fourteen tables were empty and are gone. All 20 tables develop's bootstrap queries still exist; checked at the schema, not in a browser."
label: infra
---

# RFC 0091: Drop the tables no build reads

## Summary

Fourteen tables in the shared Supabase project are read by neither build, the
one on `master` (2.1.0) or the one on `develop`, and every one of them is
empty. They are scaffolding from the early schema that no feature ever used:
health metrics, blood work, nutrition logs, supplements, goals, body
composition, and the sport drill tree. This RFC drops them in one tracked
migration, now rather than at the 2.2.0 sweep.

## Motivation

A table nobody reads still costs something. The schema baseline
([0016](0016-supabase-migration-baseline.md)) would pull it into the repo, the
advisors report on it, and a reader of the table list takes it for a feature.
`nutrition_logs` and `blood_work_*` suggest surfaces the doctrine never ruled on,
and `goals` reads like [0040](../0040-adaptation-goals.md) already exists.

## Goals

- The fourteen tables below are gone from `public`, with no build broken.
- The repo carries the migration under the version Supabase stamps on it.

## Non-Goals

- Anything a build still reads, including the program tables and `water_logs`
  that [0088](../0088-release-2-2-0-schema-drops.md) queues for the 2.2.0 sweep.
- `movement_patterns`. It is out of this RFC for good: the exercise catalogue
  ([0074](0074-exercise-catalogue-grounded-links.md)) makes it live, with the
  grounded patterns every lift will point at.
- `sport_types` and `sport_sessions`, which the sport sync and Cardio read.
- `user_profiles`, which `develop` reads.

## Proposal

Checked on 2026-10-04:

- **No build reads them.** None of the fourteen names appears in `src/`,
  `scripts/` or `supabase/functions/` on `origin/master` or `origin/develop`.
- **Every table is empty.** `count(*)` returned 0 for each one.
- **Nothing else hangs on them.** No view or `public` function names them. The
  only foreign keys that point *into* the set come from tables inside it, plus
  `program_goal_links → goals`. `program_goal_links` is empty and unread too
  (`master`'s `loadProgramData` never selects it), so it is dropped here and
  leaves 0088's queue.

| Group | Tables |
|---|---|
| Health | `health_metrics`, `blood_work_markers`, `blood_work_panels`, `body_composition_logs` |
| Food | `nutrition_logs`, `supplement_logs`, `supplements` |
| Goals | `program_goal_links`, `goal_milestones`, `goals` |
| Sport drills | `sport_session_drills`, `sport_progressions`, `sport_drills`, `sport_areas` |

The migration drops them children first, with no `CASCADE`. If something was
missed, the drop fails instead of quietly taking a constraint with it:

```sql
-- RFC 0091: tables no build reads, every one empty (checked 2026-10-04).
DROP TABLE IF EXISTS public.blood_work_markers;
DROP TABLE IF EXISTS public.blood_work_panels;
DROP TABLE IF EXISTS public.health_metrics;
DROP TABLE IF EXISTS public.body_composition_logs;
DROP TABLE IF EXISTS public.nutrition_logs;
DROP TABLE IF EXISTS public.supplement_logs;
DROP TABLE IF EXISTS public.supplements;
DROP TABLE IF EXISTS public.program_goal_links;
DROP TABLE IF EXISTS public.goal_milestones;
DROP TABLE IF EXISTS public.goals;
DROP TABLE IF EXISTS public.sport_session_drills;
DROP TABLE IF EXISTS public.sport_progressions;
DROP TABLE IF EXISTS public.sport_drills;
DROP TABLE IF EXISTS public.sport_areas;
```

Right before applying it, the row counts run again. A table that has gained a
row is taken out of the migration and reported, never dropped.

## Rationale

The migration policy in the code repo's `supabase/README.md` makes a drop wait
for the release only when the build on `master` still reads the table, and that
is not true of any of these. Waiting for the 2.2.0 sweep would buy nothing. It
would only make that sweep larger, and the 0016 baseline would pull dead tables
into the repo in the meantime.

The alternative was to keep the sport drill tree for
[0020](../0020-skill-recommendations-per-exercise.md)'s technique tips. That RFC
names these tables as something it "could reuse — or delete". They are four
empty tables shaped for logged drills, and 0020 explicitly writes no number, so
a tips feature that comes back through §4 would design its own shape.

## Acceptance

- [x] Row counts re-checked at zero right before the migration
- [x] Migration applied with `apply_migration`, and the file committed to the code repo under the version `list_migrations` reports
- [x] The fourteen tables are absent from `public` afterwards
- [x] The staging app's bootstrap still loads against the live schema — checked at the schema, not in a browser (the cloud proxy cannot reach Supabase or staging): every one of the 20 tables `src` on develop queries exists after the drop (`to_regclass`, 2026-10-04), and none of the fourteen is named in `src`, `supabase/functions` or `scripts`
- [x] `program_goal_links` is removed from 0088's queue, and 0020 notes that the drill tables are gone

## Unresolved questions

None. Peter gave the word on 2026-10-04 and the drop ran the same day.
