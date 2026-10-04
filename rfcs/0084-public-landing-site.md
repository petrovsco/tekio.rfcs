---
title: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence
authors: [Peter Petrov]
created: 2026-10-01
last_updated: 2026-10-04
status: in progress
status_note: "The site is on petrovsco/tekio.site develop at 0.1.4, served at stg.tekio.fyi behind the app's sign-in, and its release form works: the script runs in the owner's Workspace and its address is set for staging and production. master is the production branch, kept from deploying until the site's first release. Next: the site goes public on tekio.fyi, on Peter's word."
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
  [0085](done/0085-push-gate-own-baseline.md).
- **2026-10-02** — Peter approved round four as it stands. The app's
  readiness is being reworked in its own task
  ([0085](done/0085-push-gate-own-baseline.md): inputs ranked by evidence, then
  three bands), so the real site's card takes its inputs and states from the
  app's rules as they stand when it is built.
- **2026-10-02** — Peter moved the site out of the code repo into a
  repository of its own, `petrovsco/tekio.site`, for clearer versioning and
  maintenance, and settled the questions left open: the page speaks to the
  reader as "you", describes the released app, and sends release addresses to
  a Sheet in his Google Workspace rather than the app's database. §1 to §3
  are rewritten for the move, and §5 is new.
- **2026-10-02** — built in `tekio.site` at 0.1.0; its first push waits for
  the repository. It reads the app at `v2.1.0` and this repo at the commit that
  marked 2.1.0 released, until the tag exists. The build stops when a cited row
  is missing, retired or re-graded, when the app ships a value the copy was not
  written against, when a verdict sentence on Home changes, or when a day's
  copy stops matching what that morning's read names. Walked in Chromium at
  1360 × 900 and 390 × 664: one key press per step, the map in one box for each
  act, no console errors, and the form's success path. First paint is 23 kB
  compressed. Three sentences of the approved copy said more than the app does
  and were narrowed: the hero's muscles "short this week" became muscles that
  "need more work", because the read is a rolling 14 days; the floor is no
  longer "the least weekly work that still produces it", which the three
  convention targets cannot claim; and the hatch marks "a set today or
  yesterday", which is what the app counts (calendar days, any set), rather
  than "a hard set in the last 48 hours". The acceptance now asks for the
  app's one light theme rather than two, and for 50 kB compressed.
- **2026-10-02** — pushed to `develop` in `petrovsco/tekio.site` once Peter
  created the repository. Against the acceptance: a wheel notch or a key press
  moves one step at 1360 × 900, and a swipe moves one step at 390 × 664 (a drag
  shorter than half a screen snaps back, the browser's own snapping, and a hard
  fling still stops at the next step); act two's map keeps one box over all
  seven days at both sizes; the page's data carries no readiness number. The
  second box now asks for the inventory only, since the grounding blocks feed
  the science page, which waits. How a release redeploys the site went back to
  Peter (Unresolved questions): §3's workflow would sit in the app's
  repository, which the Non-Goals keep untouched.
- **2026-10-02** — Peter asked for the site's staging to be protected as the
  app's is. `tekio.site` 0.1.1 carries the app's sign-in gate in its own
  `middleware.ts`, driven by the same three variables, which the site's Vercel
  project sets for Preview only, with the app's staging login (§2). It differs
  from the app's copy twice: the cookie holds a hash of the credentials rather
  than the credentials, and a gate switched on without credentials lets nobody
  in. Walked through a local stand-in for Vercel at both sizes: the sign-in
  page, a wrong password turned away, then the site with its cookie.
- **2026-10-02** — Peter settled how a release redeploys the site: through the
  release procedure, not a workflow and deploy hook in the app's repository.
  The app's `CLAUDE.md` (v2.1.15 on `develop`) now tags this repo at step 2
  and redeploys the site's production at step 4. This repo carries `v2.1.0`
  at the commit that marked 2.1.0 released (pushed from a device session,
  since a cloud session's git proxy refused the tag), and the site builds with
  a plain `npm run build`, reading both repositories at `v2.1.0`.
- **2026-10-02** — the Vercel project `tekio-site` exists in
  `bubolazi-projects`, linked to `petrovsco/tekio.site` as Astro, with nothing
  deployed. Vercel will not name `master` the production branch before the
  branch exists, so the project holds `develop` for now, and every deployment
  sits behind Vercel's own login until that is settled (Unresolved
  questions). `BASIC_AUTH_ENABLED` is set for Preview; the staging user and
  password are entered by hand rather than copied out of the app's project.
- **2026-10-02** — Peter chose to create `master` now, and entered the staging
  login. `master` sits at `develop`'s commit of that morning (`2a93bf9` in
  `tekio.site`) and is the project's production branch, and `tekio.site`
  0.1.2 adds a `vercel.json` that keeps Vercel from deploying `master` until
  the site's first release (§2). No production deployment exists, and
  `tekio-site.vercel.app` answers 404.
- **2026-10-02** — `stg.tekio.fyi` serves `develop`. Its DNS-only CNAME in
  the `tekio.fyi` zone was added with Cloudflare's new `cf` CLI rather than by
  hand, and nothing else in the zone changed. Vercel's own login is off, as on
  the app, so the sign-in page is the only door. The address answers 401 with
  that page and a valid certificate, checked from a device session (a cloud
  session's proxy cannot reach it). `tekio.site` 0.1.3 names the address.
  Peter then signed in there with the app's staging login and the site
  opened. That was the gate's first signed-in run outside the local
  stand-in, so the staging box is ticked: 12 of 15.
- **2026-10-02** — the release form works. Peter chose to deploy the script
  with clasp, Google's Apps Script CLI, from the site's repository (§5), and
  signed it in. `tekio.site` 0.1.4 commits the script's manifest and a
  `setup()` the owner runs once in the editor to allow it. The script lives in
  a new Sheet in the owner's Drive, and its web app address is the site's
  `PUBLIC_SIGNUP_URL` for Preview and Production; staging was rebuilt with it.
  Posted to from a device session: a test address landed as the Sheet's one
  row and was then deleted with the Google Sheets connector; a filled honeypot
  and a malformed address landed nothing; the reply carries
  `access-control-allow-origin: *`. The page's side was checked in a browser
  on a local build pointed at a stand-in: the form says what the address is
  for, posts a plain form-encoded request, and shows its thanks and both error
  lines. The box's last clause, the form becoming a link to the app, can only
  happen when the app opens, so it is now its own box: 13 of 16.

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
- **No change to the app.** Its code, middleware and Vercel project are
  untouched. Its repository gains only what releasing the site needs: two
  lines in its release procedure, one tagging this repo and one redeploying
  the site (§3). No workflow and no secret.
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
- Production branch `master`, created on 2026-10-02 ahead of the site's first
  release because Vercel takes only an existing branch as production (Peter,
  2026-10-02). The site's `vercel.json` keeps Vercel from deploying it
  (`git.deploymentEnabled.master: false`) until that release deletes the
  entry in its own commit, so the release push is what publishes the page.
- `develop` is served at `stg.tekio.fyi` (Peter, 2026-10-02), as the app's is
  at `stg-app.tekio.fyi`: a DNS-only CNAME in the `tekio.fyi` Cloudflare zone,
  attached to the project's `develop` branch.
- `develop`'s preview sits behind the app's staging sign-in gate (Peter,
  2026-10-02): the site carries its own copy of the app's `middleware.ts`,
  switched on by `BASIC_AUTH_ENABLED` with the app's staging login in
  `BASIC_AUTH_USER` and `BASIC_AUTH_PASSWORD`, all three set for Preview only.
  Production never sets them, so the public page has no gate. It is
  indexable: no `noindex`, a `sitemap.xml` and `robots.txt`.
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
| Narrative prose | `src/pages/index.astro` in `tekio.site`, and each example day's copy in `src/lib/story.ts` | Hand-written for a newcomer. A day's copy is checked against what that morning's read names |
| Numbers | the app's constants at the release tag, each cited to its row of `grounding-inventory.md` in this repo (`src/lib/cite.ts` in `tekio.site`) | Read from the app at build time, never typed into the page. The check holds the row's state and its Value cell against what the app ships |
| The example week's rules | the app's read functions, `src/lib/fusedRead.ts` and `src/lib/adaptations.ts` in `petrovsco/tekio` | The invented week's logs run through the app's own functions at build time, so the stage cannot show a fill the app would not |
| References | `[literature]` bullets in `grounding/` and in done briefs' `## Grounding` sections | Parsed at build time, de-duplicated by URL, grouped by the read they support |

**The page describes the released app** (Peter, 2026-10-02), so a visitor
reads what the app they would open does. The build shallow-clones both
repositories (both are public) into a git-ignored `.sources/` folder at the
last release:
the app at its newest `vX.Y.Z` tag, and this repo at the tag of the same name.
So the release procedure tags this repo at the registry commit (step 2) with
the release's name; 2.1.0 was tagged after the fact, at the commit that marked
it released. The site redeploys at each app release through the same
procedure (Peter, 2026-10-02): once both tags exist, step 4 redeploys the
site's production through the Vercel connector's `create_deployment` or
`vercel redeploy`. A workflow in the app's repository calling a deploy hook
was the alternative, and was not taken: it would have put a file and a secret
in a repository the Non-Goals keep untouched.

A check step fails the build when a cited row does not exist, is struck as
retired, or changed state since the prose was written, and when the app ships
a value other than the one the prose was written against. The references feed
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
  [0085](done/0085-push-gate-own-baseline.md).
- **Act two is an example week, not a program.** Its title step says so, and
  the stage head reads "Example week" on every day.
- **The floor pours slower:** 650 ms a day instead of 300, so each day's label
  can be read.

**The page speaks to the reader as "you"** (Peter, 2026-10-02): "Tekiō tells
you what's missing." A visitor is reading about their own training, and "you"
puts them in it; the doctrine's first person stays in the doctrine.

The real site was built from round four in `petrovsco/tekio.site` on
2026-10-02.

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
Deploying the script needs the owner signed in. It is deployed from the
site's repository with clasp, Google's Apps Script CLI (Peter's call,
2026-10-02), so a later change keeps the same address. Its manifest lets it
touch only its own Sheet, which the owner allows once by running its `setup`
in the editor. If the domain's sharing settings keep files inside it, the web
app cannot be opened to anyone until an admin allows it in the Workspace Admin
console.

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

- [x] `petrovsco/tekio.site` builds with `npm run build`, carries its own
      version, and its `CLAUDE.md` states its branch and version rules
- [x] The build reads the inventory from this repo and fails on a cited row
      that is missing, retired or changed state (shown by a deliberately
      broken citation)
- [x] The build reads both repositories at the last release's tag; this repo
      carries `v2.1.0`, and the release procedure tags it at every release
- [ ] Each app release redeploys the site, and no other push to the app does
- [x] Every number on the page traces to an inventory row, and the example
      week reads the same as the app's own functions return for the same logs
- [x] One wheel gesture, key press or swipe moves exactly one step, at desktop
      and phone sizes
- [x] The map keeps the same size and position on every step of an act, at
      desktop and phone sizes
- [x] Readiness appears as its inputs and a state, never as a number or a line,
      while inventory rows 4.11 and 4.12 are `convention`
- [x] Act two says it is an example week, not a program, on its title step and
      on every day's stage
- [x] The page speaks to the reader as "you" throughout
- [x] The release form says what the address is used for; a test address
      lands as a row in the Workspace Sheet (and is then deleted), and a
      filled honeypot lands nowhere
- [ ] When the app opens, the form becomes a link to the app
- [ ] Deployed as its own Vercel project; `https://tekio.fyi` returns 200 with
      no gate, is indexable, and `www.tekio.fyi` redirects to it
- [x] `https://stg.tekio.fyi` serves the `develop` build behind the app's
      sign-in page, which the app's staging login opens
- [x] Readable at 400 px wide, in the app's one light theme; first paint
      under 50 kB compressed
- [x] The example read is marked invented and no personal data is on the page

## Unresolved questions

None. The six questions open on 2026-10-02 were settled by Peter that day:
the repository and its name (§1), which app the page describes (§3), the voice
(§4), where release addresses go (§5), how a release redeploys the site (§3),
and creating `master` ahead of the site's first release (§2).
