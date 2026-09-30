---
title: Release-blocked schema drops for 2.1.0
authors: [Peter Petrov]
created: 2026-09-30
last_updated: 2026-09-30
status: blocked
status_note: "waits on 2.1.0 reaching `master`. The rule and the reason are [0025](done/0025-release-blocked-schema-drops.md)'s; this is its queue reopened for the next release."
label: infra
---

# RFC 0080: Release-blocked schema drops for 2.1.0

## Why this brief exists

[0025](done/0025-release-blocked-schema-drops.md) closed with the 2.0.0 drops.
Its rule still stands: when `develop` stops reading a column, the code change
ships at once, but the drop waits until `master` runs code that no longer
selects it — staging and production share one database, and a `select` against
a dropped column fails `bootstrap()` in production. This is where the next
release's drops wait, run as step 6 of the release procedure in `CLAUDE.md`,
under the migration policy in [0024](0024-staging-shared-database-safety.md).

## The queue

| Column | Stopped being read | Still read by | Safe to drop once |
|---|---|---|---|
| `user_profiles.tracked_muscle_group_ids` | v2.0.108 ([0046](done/0046-retire-tracked-muscle-groups.md)) — the tracked-groups setting is gone; `loadProfile` no longer selects it and nothing writes it | `master`'s `loadProfile`, which selects it explicitly | `master` runs 2.1.0 or later |

The column is `jsonb NOT NULL DEFAULT '[]'`, and `getOrCreateUser` never sends
it, so it keeps filling itself in while it waits.

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

- [ ] 2.1.0 is on `master`, and production's `loadProfile` no longer selects the column.
- [ ] The drop runs as a tracked migration, and the app's bootstrap is checked against the live schema afterwards.
