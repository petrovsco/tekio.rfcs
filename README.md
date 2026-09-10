# tekio.rfcs

Specifications and standing reference for **petrovsco/tekio**, a training and
recovery app. The code lives there; what we intend to build, and what the
product already claims, live here.

- `rfcs/` — one numbered RFC per unit of work. `0000-template.md` to start one,
  `done/` for retired ones, `releases.md` for the release registry.
- `doctrine.md` — what the app is for and what may be built. Read it before
  proposing anything.
- `design-system.md` — the visual language.
- `code-review.md` — what a good generic React reviewer gets wrong in this
  codebase.
- `grounding-inventory.md` and `grounding/` — every number the app ships that
  claims a physiological meaning, and the sources behind it.

Everything at the root is standing reference: it states what *is*. The moment
one of those files grows a follow-up or a next step, that item has escaped
tracking and becomes an RFC.

## Where this came from

These files were `docs/` inside the code repo until 2026-09-10 and moved here
with their history, not as a copy — a status line's history is how its story is
read back. The 71 briefs kept their numbers and gained a fourth digit.

Links that used to point into the code (`../../src/...`) are now plain code
spans: the file is in another repository, and a link that cannot resolve is
worse than a name that can be searched.
