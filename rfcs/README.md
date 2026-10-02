# The RFCs

**The convention is not written here.** It is the modus house rule
`rfc-convention`, committed here as `.claude/rules/modus/rfc-convention.md`:
file naming, the frontmatter fields, the six statuses, the four labels, the eight sections,
releases and assets. A second copy would disagree with the first inside a week.

This file holds only what is specific to tekio.

## Labels, as tekio uses them

The four are the rule's four. Two need a tekio-specific reading:

- **infra** covers the grounding *process* itself — auth, migrations, schema
  baselines — not just tooling.
- **feature** includes a grounding RFC that validates numbers already shipping.
  It changes what the product claims, so it is product work even though no
  screen changes.

## Numbers

tekio's IDs are in commit messages and in the user's head, so they were never
renumbered when the briefs moved out of the code repo on 2026-09-10 — brief 71
is RFC 0071. Only the padding changed. The gaps are real: they are retired
work, and `done/` holds both endings, `done` and `discarded`.

## The link checker

`node scripts/check-links.mjs`, from the repository root, runs three checks in
one pass and exits 1 if any fails:

- every relative link in every `.md` here still lands on a file;
- every line anchor in `grounding-inventory.md` still lands on its row's
  identifier (RFC 0047) — there are none today, because links into the code
  repo became code spans when the docs moved, but the check stands for the
  next one;
- no RFC outside `done/` carries a `#L<n>` line anchor (RFC 0052) — a line
  moves with every edit and no tool notices.

**Run it after retiring an RFC** and before committing anything that moves or
renames a file here; it is also step 1 of a release, beside the code repo's
`npm run check:docs`. There is no `package.json`: the script has no
dependencies, and this repository holds no code. The code repo's
`check:docs` checks only its own four README-shaped files.

## Retiring an RFC

Moving a file into `done/` changes its depth, so fix the relative links inside
it (`../` becomes `../../`, a sibling `NNNN-x.md` becomes `../NNNN-x.md`) and
repoint everything that linked to it — including comments in the code repo:
`grep -rn "<rfc-filename>"` across both checkouts.
