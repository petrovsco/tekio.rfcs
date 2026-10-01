---
title: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence
authors: [Peter Petrov]
created: 2026-10-01
last_updated: 2026-10-01
status: backlog
status_note: "Opened 2026-10-01 at Peter's ask. Where it lives, how it is served and the design direction are proposed below and wait on his call; the design mock is linked in Proposal. Depends on the apex tekio.fyi being free once the domain move lands."
label: feature
---

# RFC 0084: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence

## Summary

A small, public, indexable static site on the apex `tekio.fyi` that explains
what Tekiō is for and how its numbers are computed: the purpose sentence, the
two-dimensions principle, the path from one logged set to a muscle's fill,
every weekly target with its evidence state (grounded, convention,
definitional), the readiness gate, and the full reference list. It lives in a
`site/` folder of the code repo and deploys as a second Vercel project with no
cookie gate. Its numbers and references are read from this repo's grounding
inventory and grounding blocks at build time, so the page cannot quietly
disagree with what the app ships.

## Motivation

Everything the app claims about a body is already researched and written down,
in `grounding-inventory.md`, `grounding/` and the `## Grounding` sections of
done briefs. None of it is readable by anyone who is not reading RFCs: the app
is behind a gate and shows numbers without their reasons. The apex `tekio.fyi`
is reserved for this page (the domain decision of 2026-10-01) and redirects to
the app until it exists.

## Goals

- One public page a newcomer can read in a few minutes and come away knowing
  what Tekiō answers, how each answer is computed, and how sure each number is.
- Every number on the page is a number the app ships, with its inventory
  state. Every source is one a grounding block cites.
- The build fails when the page cites an inventory row that was retired or
  whose state changed.
- First paint stays small: static HTML and CSS, with script only for the one
  interactive figure.

## Non-Goals

- **Not a sign-up or marketing funnel.** No pricing, no accounts, no waitlist,
  no analytics beyond Vercel's own.
- **No new claim.** The page restates grounded rows. Any sentence that would
  prescribe or classify beyond what a grounding block says goes through
  `/ground` first, like any other claim.
- **No developer doctrine.** R1's section cap, R2's shelf expiry and other
  rules about how the app is built stay in this repo; the page states only
  what a user can feel.
- **No live data.** The example read is invented and marked invented; the site
  never talks to Supabase.
- **No change to the app**, its middleware, or its Vercel project, beyond
  excluding `site/` from the app's build trigger.
- **Not the domain move.** DNS and the apex redirect belong to the domain move
  thread; this RFC only takes the apex over once the site exists.

## Proposal

### 1. Where it lives: `site/` in the code repo

A `site/` folder in `petrovsco/tekio` with its own `package.json`, not a new
repository. It is code, so it does not belong here (this repo holds none). A
third repository would split the release and versioning rules across three
places for one page. The app's root `package.json` is untouched; `knip`,
`lint` and `perf` are pointed away from `site/`.

Edits to `site/` follow the code repo's rules: they land on `develop` and bump
the patch version like every other push.

### 2. How it is served: a second Vercel project

- New project in `bubolazi-projects`, root directory `site/`, framework Astro,
  static output.
- Production branch `master`, so the public page describes the numbers the
  production app uses; `develop` gets a preview URL.
- The app's `middleware.ts` sits at the repo root, outside the project root, so
  the gate never applies. The page is indexable: no `noindex`, a `sitemap.xml`
  and `robots.txt`.
- Ignored Build Step on both projects so each rebuilds only when its own files
  change (`site/` for the landing, everything else for the app).
- Domains: `tekio.fyi` (with `www` redirecting to it) moves from the
  temporary redirect onto this project when the site first ships.

**Astro** because the page is mostly prose and tables: it renders to plain HTML
with no client script by default, reads Markdown and data files natively, and
lets the one interactive figure be a small island. Plain hand-written HTML was
the alternative; it loses the build-time reading of the grounding files that
keeps the page honest.

### 3. Where the content comes from

Three inputs, one of them hand-written:

| Input | Source | How |
|---|---|---|
| Narrative prose | `site/src/content/*.md` | Hand-written for a newcomer. Cites inventory rows by id (`row 2.2`) |
| Numbers and states | `grounding-inventory.md` in this repo | Parsed at build time; the page prints the value and state from the row, never a copy |
| References | `[literature]` bullets in `grounding/` and in done briefs' `## Grounding` sections | Parsed at build time, de-duplicated by URL, grouped by the read they support |

The build clones this repository's `develop` (it is public) into a temporary
folder. A check step fails the build when a cited row does not exist, is
struck as retired, or changed state since the prose was written.

### 4. The design

Mock: <https://claude.ai/artifact/9qCs6ppbGNwUjjNgfu1fHo>. Its example read
is invented; every number and source in it is a real one from the inventory.

It wears the app's SIGNAL language (`design-system.md`) so the site and the
app read as one product: paper ground, ink, one accent meaning *what's
missing*, the serif only for the thesis line. One deliberate extension: the
type scale goes up (17 px body instead of 12 px) because this is a page that
is read, not a screen that is glanced at. Light and dark both.

**Revised 2026-10-01 after Peter's review of the first mock:**

- **An octopus in the side rail** adapts as the reader scrolls. Its eight arms
  start pale with an accent edge (the gaps), fill with the same four-step ink
  ramp the body map uses as each section passes, and two of them carry the
  recovery hatch in the push-or-hold section. A line under it names its state.
  On a phone it shrinks to a corner badge. The ink is the metaphor: in the app
  ink accumulates like work.
- **The scroll is alive:** sections settle in as they enter, from a visible
  resting state, and nothing moves under `prefers-reduced-motion`.
- **The fill step has a working example:** a slider of credited sets against
  hypertrophy's floor of 10 fills a muscle shape and names its ramp band.
- **Power and anaerobic capacity are split** into what counts (grounded: the
  load, effort and length of a session) and how often (convention), with why
  power counts sessions rather than sets.
- **The HRV score is explained in words and on a scale** (50 at your usual
  level, 50 points per standard deviation, held between 0 and 100) instead of
  as a formula.
- **No developer doctrine on the page.** The section cap and the shelf expiry
  are rules for building the app, not promises to the reader, so the
  principles section keeps only what a user can feel.

One page, in this order:

1. **Thesis.** "Tekiō tells you what's missing," the three questions Home
   answers in five seconds, and an invented Home read beside it.
2. **Two reads.** Stimulus and recovery as two axes (P5); local versus
   systemic; why the whole-body qualities do not go on the body map (P2).
3. **How one set becomes a read.** Four numbered steps: the overlapping rep
   bands (with a rep slider, the one interactive figure), the 1 / 0.5 / 0
   credit by muscle role, the seven-day sum against a floor, and the ink ramp.
   Each step carries its state badge and its sources.
4. **The seven adaptations.** One table: weekly target, unit, state, key
   source.
5. **Push or hold.** The readiness formula, the threshold of 33, the 48-hour
   local recovery window, blood donation as a readiness input.
6. **The evidence.** How grounding works, counts, and the full reference
   list.
7. **The principles.** Four user-facing promises in one line each: the read
   is the product, fold before you add, a number you can't act on isn't
   shown, honest beats pretty.

## Rationale

**Brief checklist (doctrine §4).**

1. *Which read does this sharpen?* None inside the app. It is outside the app
   and outside R1's count: it adds no menu section, the way Profile and Admin
   do not.
2. *What does it let me stop doing?* Explaining the model from RFCs. It also
   turns the grounding work into something a reader outside this repo can
   check.
3. *Input or destination?* A destination, but outside the product, which is the
   one case where that is the honest answer.
4. *Honest shape of the data?* Muscle-linked qualities on a body figure,
   whole-body qualities in their own table, as in the app (P2). Every number
   with its evidence state, never stripped of it.
5. *Does it write a number claiming physiological meaning?* It restates rows
   that are already indexed, with their states, and adds none; that is why it
   reads them from the inventory instead of copying them. New prose that
   prescribes or classifies goes through `/ground`.

**Alternatives considered.**

- *A new repository.* Rejected: a third place for release and version rules,
  for one page.
- *Inside this repo, beside the content.* Rejected: this repo holds no code
  and has no `package.json`, on purpose.
- *A route inside the app.* Rejected: the gate covers its whole host, the app
  is `noindex`, and the page would join the app's first-paint budget.
- *Copying the numbers into the page.* Rejected: a copied spec disagrees with
  itself within a week, which is the code repo's own rule about RFCs.

**No personal context.** The page is public. The example read is invented and
labelled, and nothing on it says whose app this was built around.

## Acceptance

- [ ] `site/` builds with `npm run build` inside it, and the app's `npm run
      build`, `lint`, `knip` and `perf` are unchanged by its presence
- [ ] The build reads the inventory and grounding blocks from this repo and
      fails on a cited row that is missing, retired or changed state (shown
      by a deliberately broken citation)
- [ ] Every number on the page traces to an inventory row and every reference
      to a grounding block
- [ ] Deployed as its own Vercel project; `https://tekio.fyi` returns 200 with
      no gate, is indexable, and `www.tekio.fyi` redirects to it
- [ ] Pushing a change outside `site/` does not rebuild the landing, and a
      change inside it does not rebuild the app
- [ ] Readable at 400 px wide and in both themes; first paint under 50 kB
- [ ] The example read is marked invented and no personal data is on the page

## Unresolved questions

- **Peter's call on the three decisions:** `site/` in the code repo, a second
  Vercel project with Astro, and the mock's direction.
- **The voice.** The doctrine speaks in the first person ("tells me"); the mock
  uses "you". The public page probably wants "you".
- **Production branch.** `master` keeps the page matched to the released app
  but means landing edits wait for a release. `develop` would ship them at
  once, at the cost of describing unreleased numbers.
