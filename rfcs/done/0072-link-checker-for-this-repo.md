---
title: The link checker follows the docs it checked
authors: [Peter Petrov]
created: 2026-09-10
last_updated: 2026-09-30
status: done
status_note: "done 2026-09-30 (v2.1.7): `node scripts/check-links.mjs` runs all three checks here, 0 dead on 93 files. Also carries the code repo's `typecheck` fix, folded in by Peter the same day."
label: infra
release: 2.2.0
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

- [x] The check runs in this repo and reports 0 dead links on the current tree
- [x] It flags a `#L<n>` anchor in an RFC outside `done/`
- [x] It flags an inventory anchor that no longer lands on its row identifier
- [x] The code repo's `check:docs` is unchanged by this work
- [x] *(folded in 2026-09-30)* The code repo's `npm run typecheck` fails on a
      type error

## Unresolved questions

~~Whether this repo should carry a `package.json` at all.~~ Resolved at
implementation: **no**. The script has no dependencies and the repository holds
no code; a `package.json` would exist only to spell `node scripts/check-links.mjs`
as `npm run …`. Reopen it if a second script arrives.

## Outcome — 2026-09-30, v2.1.7

**`scripts/check-links.mjs`**, copied from the code repo's checker with its three
functions unchanged. Run with no arguments it does all three in one pass —
dead links from the repository root, anchors in `grounding-inventory.md`,
line anchors in `rfcs/` — and runs every check even after one fails, so one
pass reports everything. Each mode still runs alone (`--dead`, `--anchors`,
`--no-line-anchors`).

- **On the current tree:** 93 files, 0 dead; 0 inventory anchors; 18 active
  RFCs, 0 line anchors. The first run found 2 dead links, both in
  `0000-template.md` — example link syntax quoted in prose. The checker's
  regex is deliberately strict (RFC 0047: reword the prose, do not loosen
  the match), so the template now names the example paths as code spans.
- **The inventory holds no line anchors at all today.** Every link into the
  code repo became a code span in the move, so the anchor check has nothing to
  check yet. It stays for the next anchor within this repo.
- **Proven to fail**, on a scratch copy of the repo with faults injected: a
  dead link in `design-system.md` was flagged; an inventory row anchored to a
  line without its `R1` failed while a row anchored to the right line passed;
  a `#L12` anchor in active RFC 0073 was flagged while one under `done/` was
  not.
- **Where it is written down:** `rfcs/README.md` (*The link checker* — what it
  checks and when to run it), `code-review.md` §4, and release step 1 in the
  code repo's `CLAUDE.md`, which now runs it beside `npm run check:docs`.

**Folded in: `npm run typecheck` checked nothing** (found during
[0071](0071-retire-flat-exercises-fallback.md)). It ran `tsc --noEmit` against
the root `tsconfig.json`, which is `"files": []` plus two project references, so
it compiled an empty program and exited 0 whatever the code said. It is now
`tsc -b` — both referenced configs already set `noEmit`, so this is exactly the
check `npm run build` starts with, minus the bundle. Proven with a throwaway
file holding a type error: exit 2, and exit 0 on the clean tree.
