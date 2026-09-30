---
title: Release-blocked schema drops for 2.1.0
authors: [Peter Petrov]
created: 2026-09-30
last_updated: 2026-09-30
status: done
status_note: "done 2026-09-30: the 2.1.0 release sweep ran as migration `20260930114231_release_2_1_0_schema_drops`, after 2.1.0 reached `master`. Schema only; no rows deleted."
label: infra
---

# RFC 0080: Release-blocked schema drops for 2.1.0

## Why this brief exists

[0025](0025-release-blocked-schema-drops.md) closed with the 2.0.0 drops.
Its rule still stands: when `develop` stops reading a column, the code change
ships at once, but the drop waits until `master` runs code that no longer
selects it — staging and production share one database, and a `select` against
a dropped column fails `bootstrap()` in production. This is where the next
release's drops wait. Running them is **the release sweep** — step 6 of the
release procedure in `CLAUDE.md`, under the migration policy in the code repo's
`supabase/README.md` ([0024](0024-staging-shared-database-safety.md) says
why). It removes schema, never rows.

## The queue

| Column | Stopped being read | Still read by | Safe to drop once |
|---|---|---|---|
| `user_profiles.tracked_muscle_group_ids` | v2.0.108 ([0046](0046-retire-tracked-muscle-groups.md)) — the tracked-groups setting is gone; `loadProfile` no longer selects it and nothing writes it | `master`'s `loadProfile`, which selects it explicitly | `master` runs 2.1.0 or later |

The column is `jsonb NOT NULL DEFAULT '[]'`, and `getOrCreateUser` never sends
it, so it keeps filling itself in while it waits.

### Legacy values in `adaptation_targets`

Not a drop. These are two values that exist only so `master` keeps reading the
old shapes ([0012](0012-adaptation-target-shapes.md)). `develop` reads a
row by the first non-zero of minutes → sessions → sets, so it never consults
them. `master` reads nothing else.

| Row | Legacy value | What `develop` reads instead |
|---|---|---|
| `power` | `weekly_muscle_target = 6` | `weekly_session_target = 2` (per muscle) |
| `endurance` | `weekly_session_target = 2` | `weekly_minutes_target = 150` |

```sql
update adaptation_targets set weekly_muscle_target = 0, updated_at = now() where adaptation = 'power';
update adaptation_targets set weekly_session_target = 0, updated_at = now() where adaptation = 'endurance';
```

The migration, when it runs:

```sql
alter table user_profiles drop column tracked_muscle_group_ids;
```

## Doctrine check (§4)

1. **Read sharpened:** none — schema housekeeping behind 046.
2. **Stops:** a dead column.
3. **Input, not destination.** Neither; nothing is shown.
4. **Shape:** unchanged.
5. **Number claiming physiological meaning?** No.

## Acceptance

- [x] 2.1.0 is on `master`, and production's `loadProfile` no longer selects the column.
      `master` at `6c7681f`; `git grep tracked_muscle_group_ids origin/master` finds nothing.
- [x] The drop runs as a tracked migration, and the app's bootstrap is checked against the live schema afterwards.
      `20260930114231_release_2_1_0_schema_drops`, in the code repo and in
      `list_migrations`. A local build then booted against the live database:
      Home read in full, no console errors.
- [x] The two legacy `adaptation_targets` values are zeroed in the same migration, and the Adaptations read still shows power in sessions and endurance in minutes.
      Live after the run: power 0 / 2 sessions / 0 min, endurance 0 / 0 / 150 min.
      Home's line read *Short: power, …* with endurance covered.
