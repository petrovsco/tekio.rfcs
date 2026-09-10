# The RFCs

**The convention is not written here.** It is the modus house rule
`rfc-convention`, imported by this repo's `CLAUDE.md`: file naming, the
frontmatter fields, the six statuses, the four labels, the eight sections,
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

`npm run check:docs` lives in the **code repo** and checked links under its
`docs/` tree. Now that the RFCs and the reference docs are here, that check has
to run here — see the open RFC on it. Until it does, nothing re-checks that a
relative link still lands, and nothing catches a `#L<n>` line anchor, which
RFC 0052 banned precisely because a line moves with every edit and no tool
notices.

## Retiring an RFC

Moving a file into `done/` changes its depth, so fix the relative links inside
it (`../` becomes `../../`, a sibling `NNNN-x.md` becomes `../NNNN-x.md`) and
repoint everything that linked to it — including comments in the code repo:
`grep -rn "<rfc-filename>"` across both checkouts.
