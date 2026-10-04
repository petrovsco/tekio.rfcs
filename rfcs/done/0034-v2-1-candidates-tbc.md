---
title: Product questions the screen survey raised — decide keep or cut
authors: [Peter Petrov]
created: 2026-09-01
last_updated: 2026-10-02
status: done
status_note: "Reviewed with Peter on 2026-10-02: all five decided (see Verdicts). The cuts landed on develop as v2.1.17 the same day, on his OK."
label: feature
release: 2.2.0
---

# RFC 0034: Product questions the screen survey raised — decide keep or cut

The 2.0.0 restyle briefs (026–033) deliberately re-skin what exists and
change no product decisions. These are the product questions the survey
raised along the way. None is committed; each needs the doctrine §4
checklist before it becomes work. Removing things is also on the table —
several of these are cut candidates, which is the doctrine working, not
scope creep.

## The list

1. **The in-app assistant.** A floating FAB overlaps content on every tab
   (it sits over the Cardio sessions list and the Admin editors). 026
   restyles it, but the product question is open: does an in-app chat
   assistant serve "tells me what's missing" (§1), or is it a shelf
   candidate under R2? Options when discussed: keep as-is, move behind
   More, or shelve with an expiry.
2. **Cardio secondary reads.** The per-type Progress filter chips and the
   per-sport "Sessions per week" bar chart — do they pass the act-on-it
   test (§1)? Candidates to fold into one Sessions read or cut.
3. **Weights exercise chip cloud.** 30+ chips render on every visit. The
   read is the product, capture is overhead — a recent-N + search shape
   would cost less screen. Re-skin happens in 027 regardless.
4. **Program template picker.** A single enrolled user sees "Start a
   program" templates on every Program visit. Worth its screen, or does it
   collapse behind an action?
5. **Brief 003's stale name.** `003-rls-auth-v1.1.md` (now `0003-lock-the-database.md`) predates the 2.0.0
   versioning world — the "v1.1" in the slug and title no longer means
   anything. Rename (ID stays 003) and repoint links, or leave it.

## Verdicts (2026-10-02)

Decided by Peter, one at a time, in the review session.

1. **The in-app assistant — deleted.** It read none of the training; it only
   edited setup (exercises, muscle links, program days). The button, panel,
   settings card and both edge functions' source go in v2.1.17. Its table and
   the two deployed functions wait for the release sweep
   ([0088](../0088-release-2-2-0-schema-drops.md)).
2. **Cardio secondary reads — the frequency chart is cut, the chips stay.**
   The type chips keep Progress on one pace scale, so they are load-bearing.
   The Sessions per week bars go: Home already reads sessions against their
   targets. The win/loss record, the one thing that card held that nothing
   else shows, moves into Progress and appears once a sport with a competitor
   is picked.
3. **Weights chip cloud — kept, capped to the 8 most recent.** The chips are
   the one-tap start when no program runs; the concern was the count growing
   without bound. Picking a name from the autocomplete now fills its last sets
   the way a chip does (the history is already in memory, so no loader).
   Reopened once on Peter's word after a first "cut it".
4. **Program template picker — Program removed entirely**, to be rebuilt later
   in a better way. Bigger than the question asked, so it has its own RFC:
   [0087](0087-remove-program.md). Both stored programs were exported first.
5. **0003's stale name — renamed** to
   [0003-lock-the-database.md](../0003-lock-the-database.md), links repointed.

## Acceptance

- [x] Each of the five has a verdict (above)
- [x] The cuts are built, tested and walked in a browser (v2.1.17)
- [x] v2.1.17 is on `develop` (2026-10-02)

## What does not belong here

Ideas that already have parked briefs stay in them:
[0001](0001-cross-adaptation-rep-ranges.md) (fuzzy rep ranges — decided and shipped inside 039),
[0005](0005-hr-zone-intensity-classification.md) (HR zones),
[0020](../0020-skill-recommendations-per-exercise.md) (skill recommendations),
[0022](../0022-companion-service-live-sync.md) (companion service).

Nor do the two dropped on 2026-09-01:
[0007](0007-nutrition-food-recovery-score.md) (nutrition FRS) and
[0008](0008-garmin-recovery-load-axis.md) (Garmin daily readiness). They are
not parked awaiting a slot — reviving either means a new brief that argues for
its surface first, because the surface both targeted no longer exists.
