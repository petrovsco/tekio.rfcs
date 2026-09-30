# Releases

The release registry. This file is furniture — no `NNN-` prefix, so `/roadmap`
never treats it as a task. One `##` section per release; **the heading text is
the release name**, spelled exactly as briefs reference it in their
`**Release:**` header line. `**Target:**` is a free-form date; `**Status:**`
is `planned` (default) or `released <date>`. File order is display order on
the board.

## 2.2.0

**Target:** TBC
**Status:** planned

The open release since 2.1.0 shipped on 2026-09-30: what lands on `develop`
now rides toward it as patches. A column or config row `develop` stops reading
from here on is queued in a new schema-drops brief for 2.2.0, opened with its
first row ([0080](done/0080-release-2-1-0-schema-drops.md) is the pattern).

The product review Peter deferred out of 2.1.0 on 2026-09-05:
[0034](0034-v2-1-candidates-tbc.md)'s five cut candidates (the in-app
assistant, cardio's secondary reads, the Weights chip cloud, the program
template picker, brief 003's name) need a deeper look before anything is
cut. Keepers become briefs; cuts execute from 034.

[0082](done/0082-home-adaptations-line-weight.md) (done, v2.1.2–v2.1.4): the
§6 verdict was recorded **not met** on 2026-09-30 because Home's adaptations line
was correct but hard to spot. It was fixed and re-walked the same day, and
doctrine §6 is now **met**, which ends the austerity.

Tagged by Peter on 2026-09-30, in running order — the unblocked, planned
briefs, done one at a time:

1. [0069](done/0069-sleep-logs-row-origin.md) — `sleep_logs` joins row-origin
   tagging. **Done 2026-09-30** (v2.1.5).
2. [0071](0071-retire-flat-exercises-fallback.md) — retire the flat-`exercises`
   fallback in the program tree.
3. [0072](0072-link-checker-for-this-repo.md) — the link checker follows the
   docs to this repo, so step 1 of a release checks the RFCs again.
4. [0073](0073-garmin-sync-every-activity-type.md) — every Garmin sport mapped
   before it is played.
5. [0077](0077-garmin-sync-on-time.md) — the 08:00 Garmin syncs; live, closes
   after its first scheduled run.

## 3.0.0

**Target:** TBC
**Status:** planned

Named by Peter on 2026-09-05 as the home of adaptation goals
([0040](0040-adaptation-goals.md)). A major bump is his concept-validation
call.

Also tagged: [0065](0065-rescale-exemption-unchecked-base.md) — whether the
grounding gate should fire when never-checked weights are rescaled. Split out of
[0015](done/0015-ground-trigger-spec-fixes.md) on 2026-09-08 and postponed here by
Peter, because no set of weights with that shape survives in the app: it belongs
with however recovery gets measured next, which is when a real case returns to
decide it against.

## 2.1.0

**Target:** TBC
**Status:** released 2026-09-30

Released 2026-09-30 (Peter named it that day): `develop` fast-forwarded onto
`master`, tag `v2.1.0`. **At release:** every item below shipped. The two
briefs still open when it went out, [0049](done/0049-app-version-display.md) and
[0050](done/0050-release-procedure.md), were not carried over — each one's last box
was the release itself, and both closed in the same session. The schema drops
it unblocked are [0080](done/0080-release-2-1-0-schema-drops.md), run after it,
deliberately untagged.

The first release after 2.0.0, scoped by Peter on 2026-09-05, the day 2.0.0
shipped. Theme: **finish the model, clean the house.** Doctrine §6 says no
new sections until the five-second Home read is proven, so this release
closes what 2.0.0 opened rather than adding surface.

**Nothing goes before it any more.**
[0053](done/0053-recover-swept-staging-rows.md) — recovering the rows the
withdrawn release sweep deleted on 2026-09-05 — was **discarded** on
2026-09-07: the sessions are not remembered, so nothing honest can be
re-entered, and the prevention half had already shipped. It was never a 2.1.0
item.

In running order:

1. [0051](done/0051-exit-condition-walk.md) — the exit-condition walk. Walked
   2026-09-07: the muscle read and the push-or-rest call passed, the
   adaptation read did not, so doctrine §6 is **not met** and the austerity
   holds — 2.1.0 adds no sections. Its child runs next:
   [0062](done/0062-home-adaptations-one-screen.md) — whether Home and Adaptations
   should be one screen, now carrying the miss itself (Home names the missing
   muscle-linked quality). That miss was [0061](done/0061-home-names-missing-muscle-quality.md),
   discarded into 062 on 2026-09-07 (Peter's call) so the read ships as part
   of the redesigned shape rather than as a patch in front of it.
2. [0024](done/0024-staging-shared-database-safety.md) — the migration policy
   (Part 2). **Done 2026-09-30** (v2.0.109): the policy is in the code repo's
   `supabase/README.md`. The release sweep is restated, not withdrawn — it
   removes the transitional schema that lets two builds share one database,
   never rows; for 2.1.0 that is [0080](done/0080-release-2-1-0-schema-drops.md).
   [0025](done/0025-release-blocked-schema-drops.md) was the same pattern for
   2.0.0.
3. [0012](done/0012-adaptation-target-shapes.md) — target shapes, carried over
   from 2.0.0 (no code when it shipped). **Done 2026-09-30** (v2.0.110):
   endurance reads minutes (150/week, Galpin's side), power reads sessions per
   muscle. Two legacy target values wait in
   [0080](done/0080-release-2-1-0-schema-drops.md); the anaerobic question went on
   as [0081](0081-anaerobic-standing-target.md), untagged.
4. [0046](done/0046-retire-tracked-muscle-groups.md) — retire the tracked-groups
   setting. **Done 2026-09-30** (v2.0.108). Its column drop waits in
   [0080](done/0080-release-2-1-0-schema-drops.md), which runs *after* 2.1.0
   reaches `master` — step 6 of the release — so, like 025 before it, it is
   deliberately not tagged 2.1.0.
5. [0041](done/0041-garmin-sport-activity-sync.md) — Garmin sync for sport
   activities.
6. [0005](done/0005-hr-zone-intensity-classification.md) — HR-based intensity
   classification, a grounding candidate (inventory rows 6.1–6.5); after 041
   because the sport sync widens the HR supply it needs. Closed 2026-09-07
   (the classifier and the bout length shipped as patches); its two open
   items are [0058](done/0058-garmin-data-on-sport-rows.md) — Garmin data on
   sport rows, done 2026-09-07 — and [0059](done/0059-profile-hrmax-typed-hr-path.md)
   — profile HRmax and the typed-HR path.
7. [0044](done/0044-exercise-name-aliases.md) — exercise aliases, the first step
   toward other users.
8. [0049](done/0049-app-version-display.md), [0050](done/0050-release-procedure.md),
   [0038](done/0038-favicon-and-app-icon.md) — the version on screen, the written
   release ritual, the icon.
9. [0023](done/0023-mechanical-code-quality-tooling.md) — code quality tooling.
   **Done 2026-09-08** (v2.0.58–v2.0.62): ESLint, knip, a conventions file for
   `/code-review`, and a perf budget with its first committed numbers. Its
   chart-bundle item turned out to be already shipped, so it hunted the real
   first-paint weight instead — 552 kB → 324 kB.
10. [0048](done/0048-simplification-candidates.md) and
    [0015](done/0015-ground-trigger-spec-fixes.md) — spare-time units. 015 closed
    2026-09-08: the eight holes in the grounding gate are shut, except the one
    that cannot be judged without a set of weights to judge it against — that
    became [0065](0065-rescale-exemption-unchecked-base.md) in 3.0.0. **048 closed
    2026-09-08** (v2.0.58–v2.0.87): all 30 simplification candidates landed in
    sixteen units, `knip` reports zero, and the three findings it made on the
    way became [0069](done/0069-sleep-logs-row-origin.md),
    [0070](0070-week-start-day-program-week.md) and
    [0071](0071-retire-flat-exercises-fallback.md), none of them tagged to a
    release yet.
11. [0067](done/0067-ground-1rm-estimator.md) — the estimated 1RM Weights prints,
    either grounded or deleted. Added to the release on 2026-09-09 (Peter). It
    is the fourth of 048's found-on-the-way items and the only one that cannot
    start on its own: which of the two readings applies — a claim to ground, or
    decoration to delete — is Peter's call, and the brief waits on it.

Left out on purpose: 003, 020 and 022 (stay in backlog — Peter, 2026-09-05),
013 (cycle grounding — a program property, grounded only if it ships as the
default program), 021 (waits on Peter's inputs, no release), 034 (→ 2.2.0),
040 (→ 3.0.0), 052 (shipped as a patch on 2026-09-05: line anchors are
forbidden in briefs).
Since 2.0.0 the minor digit is
Peter's call: everything lands on `develop` as patches, and 2.1.0 is named
when he releases it.

## 2.0.0

**Target:** TBC
**Status:** released 2026-09-05

Released 2026-09-05: `develop` fast-forwarded onto `master`, tag `v2.0.0`.
Its objective was **one app, one language**: the unified SIGNAL feel
everywhere (defined 2026-09-01). Two halves:

- **The model** — the simplified seven-adaptation model (019), its follow-on
  target shapes (012), and the doctrine-ledger close-out (014).
- **The restyle** — Home already wears the SIGNAL language (018); every other
  surface still wears the v1 slate/indigo look. The restyle train is 037
  (row origin tagging, so restyle testing writes identifiable rows) → 026
  (chrome + shared primitives) → 027–032 (one sweep per page) → 033 (delete
  the old language and prove the walk). 024 carries the rest of the shared-
  database guardrails and rides the same release. **Amended 2026-09-02:** 031
  is no longer a sweep — the Adaptations tab is a read whose composition, not
  its paint, is the problem, so it became a rebuild gated on 039 (grounding
  the numbers that read shows). The tail of the train is now 039 → 031 → 033.

**At release:** the model half and the restyle train shipped in full (014,
019, 026–033, 037, 039, 042, 043). 012 and 024 did not and moved to 2.1.0.

Releasing it unblocked the schema drops queued in
[0025-release-blocked-schema-drops.md](done/0025-release-blocked-schema-drops.md) —
that brief ran *after* this shipped (the same evening), so it was deliberately
not tagged 2.0.0.
