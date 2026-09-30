---
title: The release procedure, written down
authors: [Peter Petrov]
created: 2026-09-05
last_updated: 2026-09-30
status: done
status_note: "done 2026-09-30: 2.1.0 was released from the checklist in one session, and the two things it missed are now in it."
label: infra
release: 2.1.0
---

# RFC 0050: The release procedure, written down

**Origin:** 2.0.0 was released by hand on 2026-09-05 from three files (`CLAUDE.md`, [0024](0024-staging-shared-database-safety.md), [0025](0025-release-blocked-schema-drops.md)) and memory. Every step turned out right, but nothing said the order, and two of them — the queued schema drops and the staging sweep (misread as a row delete, and its one run deleted real data, [0053](0053-recover-swept-staging-rows.md); restated on 2026-09-30 as a sweep of transitional schema, [0024](0024-staging-shared-database-safety.md) Part 3) — were found only because those briefs happened to be open.

## The plain summary

One checklist, in one place, that a fresh session can run top to bottom
without rediscovering anything.

## The steps, as run for 2.0.0

1. **Pre-flight on `develop`:** `npm run build`, `npm run test`,
   `npm run check:docs` — all green.
2. **Registry:** in [releases.md](../releases.md) set the release's
   `**Status:**` to `released <date>`. Every brief still tagged
   `**Release:** <it>` but not in `done/` is retagged to the next release
   (carry-over) or untagged, and its status line says so.
3. **Version:** bump `package.json` to the release version; commit as
   `release: X.Y.Z — <theme> (vX.Y.Z)`.
4. **Ship:** push `develop`; `git push origin develop:master`
   (fast-forward — `master` has never had a merge commit); annotated tag
   `vX.Y.Z`; push the tag.
5. **Verify production:** `vercel inspect tekio.shamatoff.com` gives the
   deployment id; `vercel api "/v13/deployments/<id>?teamId=<team>"` must
   show `meta.githubCommitSha` equal to `master` and the alias
   `tekio.shamatoff.com`. The gate must answer 401 from that deployment.
   Then open the site and read the version printed at the foot of Profile
   ([0049](0049-app-version-display.md), shipped) — the only check a person can
   do without Vercel.
6. **Post-release:** unblock what depended on the release (025's pattern:
   `blocked` → `planned`, first acceptance box ticked); run the release
   sweep — the release's schema-drops queue ([0080](0080-release-2-1-0-schema-drops.md)
   for 2.1.0) as one tracked migration, under the migration policy in the code
   repo's `supabase/README.md` — and never a sweep of `origin`-tagged rows,
   which are real data (024, Part 3); move finished briefs to `done/` and
   repoint their links.
7. **Open the next release** section in `releases.md`.

## Where it lives

`CLAUDE.md`'s "Branching and versioning" is the file every session reads,
so the short checklist goes there, linking 024 and 025 for the two database
steps. That also ticks 024's third acceptance box ("the versioning rules in
`CLAUDE.md` point at the migration policy as part of a major release"). A separate
`docs/release.md` would be one more reference doc nobody opens.

## Acceptance

- [x] The checklist is in `CLAUDE.md`, seven steps or fewer, each one line.
- [x] 024's third acceptance box is ticked by the same edit.
- [x] 2.1.0 is released from the checklist, and whatever it missed is added
      in that session. Released 2026-09-30. Two misses, both now in step 5
      and step 6 of `CLAUDE.md`:
      - **No Vercel CLI on the machine.** The Vercel connector's
        `get_deployment` on `tekio.shamatoff.com` (team
        `bubolazi-projects`) returns the same id, `meta.githubCommitSha`,
        alias list and `readyState` in one call, and it is what 2.1.0 was
        verified with.
      - **`apply_migration` stamps its own version.** The file in
        `supabase/migrations/` is named after the version Supabase recorded
        (read back with `list_migrations`), not a timestamp chosen
        beforehand, or `supabase migration list` and the folder disagree.
