---
title: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence
authors: [Peter Petrov]
created: 2026-10-01
last_updated: 2026-10-02
status: in progress
status_note: "Being built from the approved round-four prototype, now that Peter settled the last open questions on 2026-10-02. Its repository, petrovsco/tekio.site, is created by hand on GitHub, since this integration cannot create repositories in the organization."
label: feature
---

# RFC 0084: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence

## Progress log

- **2026-10-01** — opened at Peter's ask. A `site/` folder in the code repo,
  served as a second Vercel project, accepted.
- **2026-10-01** — the first two mocks rejected as static and bolted on;
  direction A + C chosen, with the science as its own page.
- **2026-10-01** — round two: whole-step scrolling, a seven-day act two, a
  release form. The science page waits until every number has its source.
- **2026-10-01** — round three: the map holds still, the verdict sits beside
  readiness, a larger map on desktop.
- **2026-10-02** — round four: readiness without its number or the line at 33,
  both convention; act two labelled an example week; the floor's pour slowed.
  Whether the app's own line should change went to
  [0085](0085-push-gate-own-baseline.md).
- **2026-10-02** — Peter approved round four as it stands. The app's
  readiness is being reworked in its own task
  ([0085](0085-push-gate-own-baseline.md): inputs ranked by evidence, then
  three bands), so the real site's card takes its inputs and states from the
  app's rules as they stand when it is built.
- **2026-10-02** — Peter moved the site out of the code repo into a
  repository of its own, `petrovsco/tekio.site`, for clearer versioning and
  maintenance, and settled the questions left open: the page speaks to the
  reader as "you", describes the released app, and sends release addresses to
  a Sheet in his Google Workspace rather than the app's database. §1 to §3
  are rewritten for the move, and §5 is new.

## Summary

A small, public, indexable static site on the apex `tekio.fyi` that explains
what Tekiō is for and how its reads are computed: the purpose sentence, the
path from one logged set to a muscle's fill, the rep bands, the two-week floor,
the recovery hatch and the readiness gate, then an invented week read day by
day. It ends on a release-notification form until the app is released. A
science page with every number's evidence state and sources follows once every
number it would show has its source. The site lives in a repository of its
own, `petrovsco/tekio.site`, with its own versions, and deploys as its own
Vercel project with no cookie gate. Its numbers are read from this repo's
grounding inventory at build time, so the page cannot quietly disagree with
what the app ships.

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
- **No change to the app.** Its repository, middleware and Vercel project are
  untouched.
- **Not the domain move.** DNS and the apex redirect belong to the domain move
  thread; this RFC only takes the apex over once the site exists.

## Proposal

### 1. Where it lives: its own repository, `petrovsco/tekio.site`

A public repository that holds the site and nothing else, named like this one.
Peter moved the site there on 2026-10-02, out of the `site/` folder first
accepted, for clearer versioning and maintenance: it keeps its own history,
version and deploys, so a landing edit neither bumps the app's version nor
travels with the app's releases, and the app's `lint`, `knip` and `perf` never
meet it. It is code, so it does not live in this repo either.

Its `CLAUDE.md` carries the code repo's conventions, scaled to one page: work
lands on `develop`, which deploys a preview; `master` is the public page and
moves only when a site version is released; every push bumps the patch digit
of its own `package.json`, and the minor and major digits move only when Peter
names a release. The house rules travel with it as committed copies in
`.claude/rules/modus/`, as in the other two repositories.

The move does not change where the page's claims come from: its numbers, and
the rules its example week runs on, are still read at build time from this
repo and the app's (§3).

### 2. How it is served: a second Vercel project

- New project in `bubolazi-projects`, connected to `petrovsco/tekio.site`,
  framework Astro, static output.
- Production branch `master`; `develop` gets a preview URL, as the app's does.
- The app's `middleware.ts` belongs to another repository and another Vercel
  project, so the gate never applies here. The page is indexable: no
  `noindex`, a `sitemap.xml` and `robots.txt`.
- Each project builds only from its own repository, so neither rebuilds the
  other. The site also redeploys when the app releases (§3), since that is
  when its numbers change.
- Domains: `tekio.fyi` (with `www` redirecting to it) moves from the
  temporary redirect onto this project when the site first ships.

**Astro** because the page is mostly prose and tables: it renders to plain HTML
with no client script by default, reads Markdown and data files natively, and
lets the one interactive figure be a small island. Plain hand-written HTML was
the alternative; it loses the build-time reading of the grounding files that
keeps the page honest.

### 3. Where the content comes from

Four inputs, one of them hand-written:

| Input | Source | How |
|---|---|---|
| Narrative prose | `src/content/*.md` in `tekio.site` | Hand-written for a newcomer. Cites inventory rows by id (`row 2.2`) |
| Numbers and states | `grounding-inventory.md` in this repo | Parsed at build time; the page prints the value and state from the row, never a copy |
| The example week's rules | the app's read functions, `src/lib/fusedRead.ts` and `src/lib/adaptations.ts` in `petrovsco/tekio` | The invented week's logs run through the app's own functions at build time, so the stage cannot show a fill the app would not |
| References | `[literature]` bullets in `grounding/` and in done briefs' `## Grounding` sections | Parsed at build time, de-duplicated by URL, grouped by the read they support |

**The page describes the released app** (Peter, 2026-10-02), so a visitor
reads what the app they would open does. The build shallow-clones both
repositories (both are public) into a temporary folder at the last release:
the app at its newest `vX.Y.Z` tag, and this repo at the tag of the same name.
This repo has no tags yet, so the release procedure gains a step: tag this
repo at the registry commit (step 2) with the release's name. 2.1.0 is tagged
here after the fact, at the commit that marked it released. The site
redeploys when the app's release tag is pushed: a workflow in the app's
repository calls the site project's deploy hook.

A check step fails the build when a cited row does not exist, is struck as
retired, or changed state since the prose was written. The references feed
only the science page, which waits (§4).

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

**Revised after round two, 2026-10-01 (Peter).** The same prototype link now
shows round three.

- **The map holds still.** The stage has fixed rows: a head, a top row, the
  map, a bottom row. Whatever a step shows, the map keeps one size and place
  for the whole act. A control a step needs sits in the copy beside it, so the
  reps slider moved there and the stage only shows what it changes.
- **The top row has two columns, as on Home:** the verdict beside the
  readiness card, which shows sleep and HRV under its number. The line of
  qualities and the whole-body squares sit under the map.
- **The map is larger on desktop.** The page is up to 1400 px wide and the
  stage takes 60 % of it. At 1360 × 900 the map is a third taller than in
  round two.
- **Phones stack the two sides:** the stage is pinned over the top half of the
  screen and the copy sits under it. The top row keeps its two columns; the
  bottom row keeps only the squares, and the map's labels are set larger.

**Revised after round three, 2026-10-02 (Peter).** The same link now shows
round four.

- **Readiness without its number.** The card shows the two inputs, last
  night's sleep score and HRV against the athlete's own baseline, and a state,
  OK or Low. The page prints neither the 0–100 number nor the line at 33 it is
  held against: both are `convention` (inventory rows 4.11 and 4.12), and
  Peter doubted that anyone at 33 is fit to push. HRV's bar runs from a tick at
  the athlete's baseline, the part of the method that is grounded (row 4.17),
  and the copy says what a Low day means: train easy, not stop (D7). Every day
  of the example week gets the same call from the app's rule and from the
  baseline-relative rule the evidence supports (D8), so the page does not lean
  on 33. Whether the app's own gate should change is
  [0085](0085-push-gate-own-baseline.md).
- **Act two is an example week, not a program.** Its title step says so, and
  the stage head reads "Example week" on every day.
- **The floor pours slower:** 650 ms a day instead of 300, so each day's label
  can be read.

**The page speaks to the reader as "you"** (Peter, 2026-10-02): "Tekiō tells
you what's missing." A visitor is reading about their own training, and "you"
puts them in it; the doctrine's first person stays in the doctrine.

Next: the real site is built from round four in `petrovsco/tekio.site`.

### 5. Where the release addresses go: a Sheet in Google Workspace

Peter's call, 2026-10-02, in place of a table in the app's database. The form
posts the address to a short Google Apps Script deployed as a web app under
the owner's Workspace account. The script checks that it looks like an
address and appends it, with the date, to a Google Sheet in that account; it
can also email the owner each sign-up as it arrives. No migration, no outside
form service, and the app's tables never see an address. On release day the
Sheet is read by hand, the email goes out, and the Sheet is deleted.

The script's address is public, as any form's endpoint is, so the form carries
a hidden honeypot field and the script drops a submission that fills it.
Deploying the script needs the owner signed in. If the domain's sharing
settings keep files inside it, the web app cannot be opened to anyone until an
admin allows it in the Workspace Admin console.

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

- *A `site/` folder in the code repo.* The first choice, on 2026-10-01, and
  reversed by Peter on 2026-10-02: one repository would carry two products'
  versions, so every landing edit would bump the app's version and travel
  with its releases, and the app's `lint`, `knip` and `perf` would need
  pointing away from it. The cost of the move is a third set of conventions,
  kept small by copying the code repo's.
- *Inside this repo, beside the content.* Rejected: this repo holds no code
  and has no `package.json`, on purpose.
- *A route inside the app.* Rejected: the gate covers its whole host, the app
  is `noindex`, and the page would join the app's first-paint budget.
- *Copying the numbers or the app's rules into the site.* Rejected: a copied
  spec disagrees with itself within a week, which is the code repo's own rule
  about RFCs. The build reads both where they live.
- *Describing `develop` instead of the released app.* Rejected by Peter on
  2026-10-02: the page would promise numbers the app a visitor opens does not
  have yet.
- *Keeping release addresses in the app's database, or with a hosted form
  service.* Set aside by Peter on 2026-10-02 for his own Google Workspace: no
  migration, and no third party holding the addresses.

**No personal context.** The page is public. The example read is invented and
labelled, and nothing on it says whose app this was built around.

## Acceptance

- [ ] `petrovsco/tekio.site` builds with `npm run build`, carries its own
      version, and its `CLAUDE.md` states its branch and version rules
- [ ] The build reads the inventory and grounding blocks from this repo and
      fails on a cited row that is missing, retired or changed state (shown
      by a deliberately broken citation)
- [ ] The build reads both repositories at the last release's tag; this repo
      carries `v2.1.0`, and the release procedure tags it at every release
- [ ] Pushing the app's release tag redeploys the site, and no other push to
      the app does
- [ ] Every number on the page traces to an inventory row, and the example
      week reads the same as the app's own functions return for the same logs
- [ ] One wheel gesture, key press or swipe moves exactly one step, at desktop
      and phone sizes
- [ ] The map keeps the same size and position on every step of an act, at
      desktop and phone sizes
- [ ] Readiness appears as its inputs and a state, never as a number or a line,
      while inventory rows 4.11 and 4.12 are `convention`
- [ ] Act two says it is an example week, not a program, on its title step and
      on every day's stage
- [ ] The page speaks to the reader as "you" throughout
- [ ] The release form says what the address is used for; a test address
      lands as a row in the Workspace Sheet (and is then deleted), a filled
      honeypot lands nowhere, and the form becomes a link to the app at
      release
- [ ] Deployed as its own Vercel project; `https://tekio.fyi` returns 200 with
      no gate, is indexable, and `www.tekio.fyi` redirects to it
- [ ] Readable at 400 px wide and in both themes; first paint under 50 kB
- [ ] The example read is marked invented and no personal data is on the page

## Unresolved questions

None. The four still open on 2026-10-02 were settled by Peter that day: the
repository and its name (§1), which app the page describes (§3), the voice
(§4), and where release addresses go (§5).
