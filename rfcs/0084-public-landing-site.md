---
title: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence
authors: [Peter Petrov]
created: 2026-10-01
last_updated: 2026-10-01
status: backlog
status_note: "Opened 2026-10-01 at Peter's ask. Where it lives and how it is served are accepted. The design is in its second round (whole-step scrolling, a seven-day act two, a release form) and its prototype is linked in Proposal; the science page waits until every number has its source. Depends on the apex tekio.fyi being free once the domain move lands."
label: feature
---

# RFC 0084: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence

## Summary

A small, public, indexable static site on the apex `tekio.fyi` that explains
what Tekiō is for and how its reads are computed: the purpose sentence, the
path from one logged set to a muscle's fill, the rep bands, the two-week floor,
the recovery hatch and the readiness gate, then an invented week read day by
day. It ends on a release-notification form until the app is released. A
science page with every number's evidence state and sources follows once every
number it would show has its source. The site lives in a `site/` folder of the
code repo and deploys as a second Vercel project with no cookie gate. Its
numbers are read from this repo's grounding inventory at build time, so the
page cannot quietly disagree with what the app ships.

## Motivation

Everything the app claims about a body is already researched and written down,
in `grounding-inventory.md`, `grounding/` and the `## Grounding` sections of
done briefs. None of it is readable by anyone who is not reading RFCs: the app
is behind a gate and shows numbers without their reasons. The apex `tekio.fyi`
is reserved for this page (the domain decision of 2026-10-01) and redirects to
the app until it exists.

## Goals

- One public page a newcomer can read in a few minutes and come away knowing
  what Tekiō answers and how each answer is computed.
- Every number on the page is a number the app ships, and the example week is
  run through the app's own rules.
- Later, on the science page: how sure each number is, and the sources behind
  it.
- The build fails when the page cites an inventory row that was retired or
  whose state changed.
- First paint stays small: static HTML and CSS, with script only for the one
  interactive figure.

## Non-Goals

- **Not a marketing funnel.** No pricing, no accounts, no analytics beyond
  Vercel's own. The one exception is a release-notification form (Peter,
  2026-10-01): it asks for an email and nothing else, and gives way to a link
  to the app once the app is released.
- **No new claim.** The page restates grounded rows. Any sentence that would
  prescribe or classify beyond what a grounding block says goes through
  `/ground` first, like any other claim.
- **No developer doctrine.** R1's section cap, R2's shelf expiry and other
  rules about how the app is built stay in this repo; the page states only
  what a user can feel.
- **No live data.** The example athlete is invented and marked invented; the
  site never reads the app's data.
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
struck as retired, or changed state since the prose was written. The
references feed only the science page, which waits (§4).

### 4. The design

First mock (superseded): <https://claude.ai/artifact/9qCs6ppbGNwUjjNgfu1fHo>.
Every example athlete is invented; every number and source is a real one from
the inventory.

It wears the app's SIGNAL language (`design-system.md`) so the site and the
app read as one product: paper ground, ink, one accent meaning *what's
missing*, the serif only for the thesis line. One deliberate extension: the
type scale goes up (17 px body instead of 12 px) because this is a page that
is read, not a screen that is glanced at. Light first, as the app is.

**Direction chosen 2026-10-01 (Peter): A + C, with B as its own page.** The
first two mocks were rejected as static and, in the second, bolted on. The page
keeps the app's SIGNAL language but gets its motion from the read itself.
Storyboard: <https://claude.ai/artifact/SE4nkfDVnN3ZwGJkRoyN3z>.

- **Act one, the read builds itself (A).** One stage stays fixed beside the
  scrolling copy and shows the app's own body map (its real geometry from
  `BodyMap.tsx`). Each scroll stop changes one thing on the stage, the step
  the copy explains: an empty figure; one set credited 1 / 0.5 / 0; the rep
  bands; a week of sets filling the ink ramp with numbered gap callouts; the
  recovery hatch and the readiness number; and the verdict landing in serif.
  At the end the stage is the Home screen.
- **Act two, a week in ink (C).** The stage becomes scrubbable through an
  invented seven days, so the reader watches gaps open and close and sees a
  Hold day where the map stays the same and only the instruction changes.
- **The science (B)** is a separate page at its own address: every inventory
  number as a card, filterable by quality and by evidence state, opening into
  claim, sources, where the evidence splits, and verdict.
- **Verdict strings are the app's own** (`HomeTab.tsx`), and the week is run
  through the app's fill rules at build time, so the stage cannot show a fill
  the app would not.
- **No developer doctrine on the page.** The section cap and the shelf expiry
  are rules for building the app, so the page leaves them out.
- **No mascot.** The octopus from the second mock was dropped.

**Revised after the first prototype, 2026-10-01 (Peter).** This replaces the
act two and science bullets above. Prototype, round two:
<https://claude.ai/artifact/LKj9caKgU6FqD6EndqxQ3a>.

- **The page moves in whole steps.** Every step is one screen tall and snaps
  into place. One wheel gesture or key press moves exactly one step, and touch
  uses the browser's own snapping. The stage animates inside a step; the page
  never comes to rest between two steps.
- **Act one** keeps its steps: credit, the rep bands, the two-week floor,
  recovery and readiness, the answer. Its evidence labels and citations go
  with the science page.
- **Act two** opens with a full-screen title step, then gives each day of the
  first week its own step: the session on the left, each exercise with its
  sets, reps and weight; the read on the right. Each exercise is marked in
  turn on both sides: its tile fills set by set, the muscles it credited are
  outlined on the map with their share, and their fill and hatch change. After
  the last exercise the read updates, as Home does when a session is logged.
  Thursday's intervals fill a whole-body square and leave the map alone.
  Saturday's planned session is held after a bad night, and the gap it was
  meant to close is still named on Sunday.
- **The last step** is a release-notification form while the app is not
  released, and a link to the app once it is.
- **The science page (B) is dropped for now,** until every number it would show
  has its source. In round one it counted 64 live numbers: 32 grounded, 14
  convention, 4 definitional and 14 not yet checked.
- **The example week runs on the app's own rules,** transcribed from
  `fusedRead.ts`, `adaptations.ts` and `HomeTab.tsx`: credit 1 / 0.5 by role;
  the 14-day window against 20 sets; gaps ranked never trained first, then
  fewest sets, then longest since, then name; a muscle recovering for two
  calendar days; readiness as the mean of the sleep score and the
  baseline-relative HRV score, against 33; the seven qualities and the
  whole-body squares over the same 14 days. The athlete, the weights and the
  nights are invented and labelled so. The verdict lines leave out the app's
  `PLACEHOLDER` markers.

Next: Peter reviews round two; then the real `site/` is built from it.

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
- [ ] Every number on the page traces to an inventory row, and the example
      week reads the same as the app's own functions return for the same logs
- [ ] One wheel gesture, key press or swipe moves exactly one step, at desktop
      and phone sizes
- [ ] The release form says what the address is used for, stores it where the
      question below decides, and becomes a link to the app at release
- [ ] Deployed as its own Vercel project; `https://tekio.fyi` returns 200 with
      no gate, is indexable, and `www.tekio.fyi` redirects to it
- [ ] Pushing a change outside `site/` does not rebuild the landing, and a
      change inside it does not rebuild the app
- [ ] Readable at 400 px wide and in both themes; first paint under 50 kB
- [ ] The example read is marked invented and no personal data is on the page

## Unresolved questions

- **Where the release-notification addresses are kept.** The site is static
  and has nowhere to send them yet. Proposed default: one insert-only table in
  the existing Supabase project, where the public key may insert and nothing
  else, unlike the app's open tables. It is read by hand on release day and
  dropped once the email has gone out. Adding it is a migration, so it is a
  production change and waits for Peter's go. A hosted form service is the
  alternative.
- **The voice.** The doctrine speaks in the first person ("tells me"); the mock
  uses "you". The public page probably wants "you".
- **Production branch.** `master` keeps the page matched to the released app
  but means landing edits wait for a release. `develop` would ship them at
  once, at the cost of describing unreleased numbers.
