---
title: The link checker follows the docs it checked
authors: [Peter Petrov]
created: 2026-09-10
last_updated: 2026-09-10
status: planned
status_note: Opened by the migration that created this repo; nothing blocks it.
label: infra
---

# RFC 0072: The link checker follows the docs it checked

## Summary

`scripts/check-docs-links.mjs` stayed in the code repo when the docs it existed
to check moved here. Bring the equivalent check to this repository so the links
between RFCs, and from an RFC into the reference documents, are verified again.

## Motivation

The checker did three jobs, and two of them now have no target in the code repo:

1. every relative link under `docs/` still lands on a file,
2. every line anchor in `grounding-inventory.md` still lands on its row's
   identifier (RFC 0047),
3. no active brief carries a `#L<n>` line anchor (RFC 0052) — a line moves with
   every edit and nothing re-checks it.

Jobs 1 and 2 now belong here. Job 3 belongs here too, since briefs are here.
The code repo's `check:docs` was narrowed to the four README-shaped files it
still owns.

The migration itself is the argument. Moving the tree broke **264** relative
links in one commit — 151 needed repointing and 113 pointed into the code repo
and had to become plain code spans. They were repaired by a one-off script and
verified once, at 522 links and 0 broken. Nothing re-verifies them, so the next
retirement into `done/` can break a link silently, which is exactly the failure
RFC 0047 was written about.

## Goals

A single command in this repo that reports every dead relative link, every stale
inventory anchor, and every `#L<n>` line anchor in an RFC that is not in `done/`.

## Non-Goals

- Checking links **into** the code repo. Those are deliberately code spans now,
  not links, precisely because they cannot be resolved from here.
- A CI job. Nothing in this repository builds; the check is run by whoever edits.
- Rewriting the checker. Copying it and narrowing its arguments is enough.

## Proposal

Copy `scripts/check-docs-links.mjs` from the code repo, drop what it does not
need, and add an `npm` script — or a plain `node scripts/check-links.mjs` with
no package.json at all, which suits a repository holding no code.

Point it at the repository root so it walks `rfcs/`, `rfcs/done/`, `grounding/`
and the four reference documents in one pass.

## Rationale

The alternative is to leave the checker in the code repo and give it a path into
this one. That fails the first time someone has only one of the two checkouts,
and it makes a code-repo test depend on a sibling directory that may not exist.

## Acceptance

- [ ] The check runs in this repo and reports 0 dead links on the current tree
- [ ] It flags a `#L<n>` anchor in an RFC outside `done/`
- [ ] It flags an inventory anchor that no longer lands on its row identifier
- [ ] The code repo's `check:docs` is unchanged by this work

## Unresolved questions

Whether this repo should carry a `package.json` at all. A single `node` script
with no dependencies argues against it; consistency with every other repo argues
for it.
