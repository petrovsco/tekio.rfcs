---
title: Product questions the screen survey raised — decide keep or cut
authors: [Peter Petrov]
created: 2026-09-01
last_updated: 2026-09-08
status: planned
status_note: "committed to 2.2.0 by Peter on 2026-09-05: \"we need to review more deeply before cut\". The work is the review session itself; keepers graduate into their own briefs and cuts execute from this one. Raised by the 2026-09-01 screen survey."
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
5. **Brief 003's stale name.** `003-rls-auth-v1.1.md` predates the 2.0.0
   versioning world — the "v1.1" in the slug and title no longer means
   anything. Rename (ID stays 003) and repoint links, or leave it.

## What does not belong here

Ideas that already have parked briefs stay in them:
[0001](done/0001-cross-adaptation-rep-ranges.md) (fuzzy rep ranges — decided and shipped inside 039),
[0005](done/0005-hr-zone-intensity-classification.md) (HR zones),
[0020](0020-skill-recommendations-per-exercise.md) (skill recommendations),
[0022](0022-companion-service-live-sync.md) (companion service).

Nor do the two dropped on 2026-09-01:
[0007](done/0007-nutrition-food-recovery-score.md) (nutrition FRS) and
[0008](done/0008-garmin-recovery-load-axis.md) (Garmin daily readiness). They are
not parked awaiting a slot — reviving either means a new brief that argues for
its surface first, because the surface both targeted no longer exists.
