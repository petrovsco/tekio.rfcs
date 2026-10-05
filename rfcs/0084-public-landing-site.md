---
title: A public landing site on tekio.fyi that explains how the reads are computed and cites their evidence
authors: [Peter Petrov]
created: 2026-10-01
last_updated: 2026-10-05
status: in progress
status_note: "The site is on petrovsco/tekio.site develop at 0.1.7, served at stg.tekio.fyi behind the app's sign-in: it opens on the Thin air film, which rests on \"Adapt.\" and one line on what Tekiō is for, and its release form writes to a Sheet in the company folder of the owner's Drive. Two things wait on Peter (Unresolved questions): the form's human check, and whether the page's lines join the doctrine's purpose; then the site goes public on tekio.fyi on his word."
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
- **2026-10-04** — before closing, Peter asked for three things. The release
  Sheet moved into the company folder of the owner's Drive, under a Tekiō
  project folder; the script is bound to the Sheet and moved with it, so its
  address did not change. The form now takes a bounded number of addresses
  against floods (§5, `tekio.site` 0.1.5): its tests run the script against
  stand-ins for Google's services, and the deployed script answered the same
  three posts as before, a test address, a filled honeypot and a malformed
  address, with the test row then deleted. Whether Cloudflare's Turnstile
  goes on top is Peter's call. The third ask, that the page say what the app
  believes, is drafted as a new first screen for him to check: a person can
  adapt to almost anything, and what they do is what triggers it; the app is
  for chasing the adaptations they want most, and this first version chases
  all seven, muscle by muscle and for the whole body. Two new boxes: 14 of 18.
- **2026-10-05** — Peter asked for the first screen to open on a short film in
  the style of the Opus-made "Prometheus" film, told in Tekiō's own subject
  and look. Three storylines were drawn as live rough cuts and shown to him:
  Thin air (four places no body was built for, then the read), The plate (one
  set to the read, as an anatomical plate) and A year in ink (an invented year
  chasing strength, then endurance, then all seven). Thin air is
  recommended. The storylines are kept in
  [0084/opening-film.md](0084/opening-film.md); the pick waits on him.
- **2026-10-05** — Peter picked Thin air. Its full cut goes into the site as
  the first screen, on staging only until the site goes public. Before it is
  shown, its four numbers get their sources and its claim, that a body adapts
  to each place, goes through `/ground`. One new box: 14 of 19.
- **2026-10-05** — the full cut of Thin air opens the site on staging
  (`tekio.site` 0.1.6, §4). Its read is act one's, so the film shows nothing
  the app's own functions do not return. Each of its numbers carries its
  source under the film, and its claim went through `/ground`
  ([Grounding](#grounding)): partially supported. Two lines were narrowed:
  "You can adapt to almost anything." became "Your body adapts to what it
  meets.", because the summit is past where anyone lives and orbit adapts a
  body by taking bone and muscle away; and "No gravity." became
  "Weightless.", because gravity at 400 km is about 89 % of the surface's.
  Whether the first narrowing stands is Peter's call (D58). Checked on a
  local build in Chromium at eight sizes from 360 × 740 to 1920 × 1080: no
  overflow and no console errors; it played through at the screen's frame
  rate, and reduced motion showed only the last frame. First paint is 37 kB
  compressed, under the 50 kB box. The film's box is ticked: 15 of 19.
- **2026-10-05** — Peter kept the grounded line (D58): the film goes on
  saying "Your body adapts to what it meets.", so nothing on staging changed.
  The page's philosophy box now asks for that line instead of "a person can
  adapt to almost anything", and the parked philosophy draft opens on it too,
  reading the film's own copy. Its lead lost the sentence that repeated the
  new heading; the words wait on Peter's check. Still 15 of 19.
- **2026-10-05** — Peter asked why the page needs a philosophy screen after
  the film, and it does not: the film says the philosophy's first half and
  comes to rest on "Adapt.", and the next step is act one, as staging already
  has it. The drafted screen is dropped. The one point only it made, that
  Tekiō is for chasing the adaptations you want most and this first version
  chases all seven, is drafted as one line of the page's own text under
  "Adapt.", shown once the film stops (unpushed, checked at six sizes and
  under reduced motion); whether it goes there or is left out is his call.
  Still 15 of 19.
- **2026-10-05** — Peter kept the line under "Adapt." and cut its second
  sentence, "This version chases all seven.": the page says nothing about
  versions. Once the film stops, it says "Tekiō is for chasing the
  adaptations you want most." (`tekio.site` 0.1.7, §4). The same rule takes
  the release number out of the page's foot (Non-Goals). Checked on a local
  build at six sizes from 360 × 740 to 1920 × 1080 and under reduced motion,
  and played through in real time: the line appears only once the film stops,
  and one step down brings act one. The philosophy box narrows to what the
  page says and is ticked: 16 of 19.
- **2026-10-05** — the doctrine question drafted and put to Peter, with
  "premise only" recommended (Unresolved questions). The doctrine changes
  only on his word. Still 16 of 19.

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
- **No versions.** The page names no app version, neither a release number
  nor "this version" (Peter, 2026-10-05); it describes the released app
  without saying which release that is.
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

**The first screen is a film** (Peter, 2026-10-05): Thin air, picked from
three storylines ([0084/opening-film.md](0084/opening-film.md)). It takes its
grammar from the Opus-made "Prometheus" film (Latin chapter marks that pin to
the corner, a ticking timeline, a counter that climbs, line-work that redraws
itself twelve times a second) and wears the page's paper, ink and one accent.
Four places no body was built for, each counted to a sourced number: Everest's
8,849 m, 10 m of seawater at 2 atmospheres, the marathon's 42.195 km and the
station's 400 km. Then the edge of the Earth shrinks into the head of the
app's body map, the invented fortnight lands on it a day at a time, and the
film rests on act one's read and the word "Adapt." Its words are grounded
([Grounding](#grounding)). It is drawn in code from the time alone, so the
page plays it live with nothing to stream: once, muted, only while it is on
screen, then at rest on its last frame, which is all that reduced motion
shows. Phones get an upright cut. Its sources open from a button under it,
and a transcript reads it to a screen reader. The film's words live in
`src/lib/film.ts`, its drawing in `src/scripts/film.js`.

Once the film stops, one line of the page's own text appears under "Adapt.":
"Tekiō is for chasing the adaptations you want most." There is no separate
philosophy screen after the film, and the page says nothing about versions
(Peter, 2026-10-05).

### 5. Where the release addresses go: a Sheet in Google Workspace

Peter's call, 2026-10-02, in place of a table in the app's database. The form
posts the address to a short Google Apps Script deployed as a web app under
the owner's Workspace account. The script checks that it looks like an
address and appends it, with the date, to a Google Sheet in that account; it
can also email the owner each sign-up as it arrives. No migration, no outside
form service, and the app's tables never see an address. On release day the
Sheet is read by hand, the email goes out, and the Sheet is deleted.

The script's address is public, as any form's endpoint is, so the form carries
a hidden honeypot field and the script drops a submission that fills it. It
also takes a bounded number of addresses, so a flood cannot fill the Sheet
(Peter, 2026-10-04): at most 20 new ones a minute and 1,000 a UTC day, and
none past 10,000 rows. An Apps Script web app never learns who is posting, so
the limits count everyone together; past one, the form says to try again in a
moment. Nothing in it sends email.
Deploying the script needs the owner signed in. It is deployed from the
site's repository with clasp, Google's Apps Script CLI (Peter's call,
2026-10-02), so a later change keeps the same address. Its manifest lets it
touch only its own Sheet, which the owner allows once by running its `setup`
in the editor. If the domain's sharing settings keep files inside it, the web
app cannot be opened to anyone until an admin allows it in the Workspace Admin
console.

The Sheet lives in the company folder of the owner's Drive, in a Tekiō project
folder beside the company's other projects (Peter, 2026-10-04). Moving it
there changed nothing for the form, since the script is bound to the Sheet.

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

## Grounding

**Claim:** Prose, no number. The opening film says a body adapts, with exposure, to the air on Everest's summit (8,849 m), 10 m of water (~2 atm), a marathon (42.195 km) and orbit (~400 km): "You can adapt to almost anything." It then says the stimulus decides the adaptation: "What you do is what triggers it." No training or recovery decision depends on it. It is the public page's stated philosophy, held to RFC 0084's "no new claim" rule.
**Searched:** 2026-10-05 (search results only; no abstracts were opened, so no n below was checked) · **Verdict:** partially supported
**Number to use:** no number; wording. Default: keep "What you do is what triggers it.", narrow "You can adapt to almost anything." to "Your body adapts to what it meets.", and change "No gravity." to "Weightless." Each place does change a body, but the first is where adaptation runs out (the highest city is ~3.5 km below the summit), the last is where it runs backwards (bone and muscle are lost), and gravity at 400 km is ~89 % of what it is at the surface.

### Evidence
- `[literature]` **Thin air.** One person really does acclimatize, and it reverses. Haemoglobin mass changes quickly in early acclimatization to 5,260 m and changes again on de-acclimatization. Population: healthy humans; design and n not checked. Source: [AltitudeOmics, PLOS One](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0108788). A meta-analysis of athletes' blood response to altitude also exists: [Am J Hematol](https://onlinelibrary.wiley.com/doi/10.1002/ajh.24941) (pooled estimates not checked).
- `[literature]` **Thin air, the limit.** The highest city, [La Rinconada, is at 5,100–5,300 m](https://www.researchgate.net/figure/Localization-of-the-highest-city-in-the-World-La-Rinconada-Peru-5-100-5-300-m_fig1_342953893). Some of its residents develop [excessive erythrocytosis and chronic mountain sickness](https://www.researchgate.net/publication/342953893_Excessive_Erythrocytosis_and_Chronic_Mountain_Sickness_in_Dwellers_of_the_Highest_City_in_the_World), and a 2024 study there is titled for the [limits of human adaptations](https://physoc.onlinelibrary.wiley.com/doi/full/10.1113/JP284550) (J Physiol). Population: residents; design, n and prevalence not checked. The summit is studied as the edge of [human limits for hypoxia](https://pubmed.ncbi.nlm.nih.gov/10863526/). People cross it; nobody lives there.
- `[literature]` **Deep water.** Humans have a [diving response](https://onlinelibrary.wiley.com/doi/full/10.1111/j.1600-0838.2005.00440.x) (review, Scand J Med Sci Sports 2005). Long-term breath-hold training produces both [adaptations and maladaptations](https://pubmed.ncbi.nlm.nih.gov/33791844/) (state-of-the-art review, 2021). Novices show adaptations after [13 days of apnea training](https://pubmed.ncbi.nlm.nih.gov/40674174/) (training study, n not checked).
- `[literature]` **Not the same thing.** The diving traits of sea nomads ([Cell 2018](https://pubmed.ncbi.nlm.nih.gov/29677510/)) and the altitude traits of highlanders ([review](https://pubmed.ncbi.nlm.nih.gov/11443005/)) include genetic adaptations, selected in whole populations over generations. One person's exposure cannot produce those. Population genetics; n not checked.
- `[literature]` **The long road.** The best supported of the four: training for a first marathon reverses age-related stiffening of the aorta. Population: first-time marathon runners; design and n not checked. Source: [JACC 2020](https://www.jacc.org/doi/10.1016/j.jacc.2019.10.045).
- `[literature]` **No gravity.** The body does adapt to orbit, mostly by shedding what weightlessness no longer asks for: [pathophysiological adaptations to the space environment](https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2017.00547/full) (review, Front Physiol 2017), [muscle and bone atrophy in space](https://www.nature.com/articles/s41526-021-00145-9) (npj Microgravity 2021), and [bone loss from unloading](https://pmc.ncbi.nlm.nih.gov/articles/PMC8862023/). Population: astronauts and ground-based stand-ins; n and sizes not checked.
- `[literature]` **Reference facts, not studies.**
  - Gravity at 400 km is ≈ 89 % of surface gravity (inverse-square law with Earth's 6,371 km radius, worked out here). Astronauts float because they are in free fall ([NASA](https://www.nasa.gov/learning-resources/for-kids-and-students/what-is-microgravity-grades-5-8/), page not opened).
  - 10 m of seawater adds ≈ 1 atm (ρgh ≈ 101 kPa), so the total pressure is ≈ 2 atm ([NOAA](https://oceanservice.noaa.gov/facts/pressure.html), page not opened).
  - Everest is [8,848.86 m](https://kathmandupost.com/national/2020/12/08/it-s-official-mount-everest-is-8-848-86-metres-tall) (2020 China–Nepal survey).
  - The marathon is 42.195 km by definition ([World Athletics](https://worldathletics.org/disciplines/road-running/marathon)). The ISS orbits at roughly 400 km ([NASA](https://www.nasa.gov/reference/international-space-station/)). Neither page was opened.
- `[literature]` **(b) Specific to the stimulus.** Strength gains are specific to [training mode](https://pubmed.ncbi.nlm.nih.gov/7674868/) and [velocity](https://pubmed.ncbi.nlm.nih.gov/8341872/) (reviews). A [2025 systematic review with meta-analysis](https://link.springer.com/article/10.1007/s40279-025-02225-2) (Sports Med) tests how much dynamic training carries over to untrained isometric strength (pooled estimate not checked).
- `[literature]` **(b) Lost when the stimulus stops.** Training adaptations fade when the training stimulus is too small. This is the same rule that costs astronauts bone and muscle. Review: [Mujika & Padilla, Sports Med 2000](https://link.springer.com/article/10.2165/00007256-200030030-00001).
- `[literature]` **(b) A trigger, not a guarantee.** How much VO₂max rises on the same programme runs in families ([HERITAGE, J Appl Physiol 1999](https://journals.physiology.org/doi/full/10.1152/jappl.1999.87.3.1003); family training study, n not checked). People who seemed not to respond did respond to more training ([Montero & Lundby, J Physiol 2017](https://physoc.onlinelibrary.wiley.com/doi/10.1113/JP273480); training study, n not checked).
- `[practitioner consensus]` Adaptation is specific to what is trained. Galpin splits fitness into [nine adaptations](https://ai.hubermanlab.com/s/WwnlbVpN) to train for, and Israetel teaches [specificity](https://www.youtube.com/watch?v=h8oAKnIfOq4) as a named training principle. Held by Galpin and Israetel (only the titles were seen).

### Where they split
No practitioner disagreement was found on (b), and no roster member was found saying "adapt to almost anything" (Huberman, Attia and Patrick were not searched on it). Two splits in the evidence decide the copy:
- **What "adapt" means.** In physiology, "adapt" covers any change that fits the body to what is asked of it, including loss. A reader hears "gets better". In orbit the body adapts by losing bone and muscle. Read as "fitting the demand", the orbit scene supports line (b). Read as "gets better", under "almost anything", it misleads. Tekiō has to choose: a first line that means fitting the demand ("adapts to what it meets"), or drop the orbit scene.
- **Trigger versus size.** HERITAGE finds that part of the response runs in families. Montero & Lundby find that more training brings in the people who seemed not to respond. Both agree that the stimulus triggers adaptation. So the line can claim the trigger and the direction, but never equal results for everyone or a pace.

### Caveats
- Population mismatch: the extreme-place evidence comes from small, selected groups (highland residents, climbers, breath-hold divers, astronauts). The training evidence comes mostly from previously untrained adults. None of it describes one trained adult. That does no harm on a page that prescribes nothing, but no caption should promise how much or how fast a body adapts.
- Storyboard wording: "the water presses twice as hard as the air above it" is wrong if it means the water's own pressure, because 10 m of water adds about one atmosphere, the same as the air. "The pressure is twice that at the surface" is correct.
- If the film ever shows a place with the people native to it (Sherpa, Bajau), it stops being about acclimatization and becomes about evolution, which "you" cannot do.
- What would change this: reading the abstracts would confirm the n and effect sizes but not change the verdict. A caption that states a rate or an amount ("in weeks", "doubles") would need its own grounding.

### Source comment
`// "Your body adapts to what it meets." / "What you do is what triggers it." / "Weightless." — adaptation is real, stimulus-specific and bounded, and in orbit it is loss (~89 % g at 400 km), see tekio.rfcs/rfcs/0084-public-landing-site.md#grounding`

**Taken 2026-10-05, and kept by Peter the same day:** the first side of the
split. The film's turn to the body says "Your body adapts to what it meets.",
which reads as fitting the demand and holds in all four places, so orbit stays
in the film; and orbit's caption is "Weightless." (D58). The run read search
results only, so no study's n was checked; the block says so, and no number on
the page rests on one.

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
- [x] The page says what the app believes: a body adapts to what it meets,
      and what a person does is what triggers it; the app is for chasing the
      adaptations they want most
- [x] The first screen opens on the Thin air film: drawn in code from the
      time alone, it plays once, muted, and comes to rest on its last frame;
      reduced motion shows only that frame; the read it ends on is the app's
      own for the invented athlete; each of its numbers carries its source on
      the page, and its claim is grounded
- [x] The release form says what the address is used for; a test address
      lands as a row in the Workspace Sheet (and is then deleted), and a
      filled honeypot lands nowhere
- [x] The form takes a bounded number of addresses: at most 20 new ones a
      minute and 1,000 a UTC day, and none past 10,000 rows, shown by its
      tests against stand-ins for Google's services
- [ ] When the app opens, the form becomes a link to the app
- [ ] Deployed as its own Vercel project; `https://tekio.fyi` returns 200 with
      no gate, is indexable, and `www.tekio.fyi` redirects to it
- [x] `https://stg.tekio.fyi` serves the `develop` build behind the app's
      sign-in page, which the app's staging login opens
- [x] Readable at 400 px wide, in the app's one light theme; first paint
      under 50 kB compressed
- [x] The example read is marked invented and no personal data is on the page

## Unresolved questions

Two, one asked of Peter on 2026-10-04 and one on 2026-10-05:

- **Does the form add Cloudflare's Turnstile on top of its limits?** A free,
  mostly invisible check that the poster is a person, which the script would
  then verify with Cloudflare on every post. It needs one more permission in
  the script's editor. Offered with **both** recommended; his answer is typed,
  because the set-up runs on his accounts.
- **Do the page's lines join the doctrine's purpose?** The page says what the
  app believes in three lines: "Your body adapts to what it meets.", "What you
  do is what triggers it." and "Tekiō is for chasing the adaptations you want
  most." The first two are the reason behind the purpose, and both rest on
  this RFC's Grounding. The third goes further than the app does today, which
  measures what's missing against all seven adaptations equally. Declaring
  what a user chases is [RFC 0040](0040-adaptation-goals.md) (backlog, 3.0.0),
  which still has to show that a goal is a training input rather than a
  setting (P4). Three options, put to Peter on 2026-10-05:
  - **Premise only** (recommended): §1 gains one paragraph, after the note on
    who *me* is: "My body adapts to what it meets, and what I do is what
    triggers it." The third line stays the page's own, and 0040 keeps the
    question of goals.
  - **All three**: §1 also says Tekiō is for chasing the adaptations I want
    most, which commits the product to 0040's goals before the app has them.
  - **Leave it**: the doctrine stays as it is.

The six questions open on 2026-10-02 were settled by Peter that day: the
repository and its name (§1), which app the page describes (§3), the voice
(§4), where release addresses go (§5), how a release redeploys the site (§3),
and creating `master` ahead of the site's first release (§2). The film asked
for on 2026-10-05 was settled by him the same day: the first screen opens on
Thin air ([0084/opening-film.md](0084/opening-film.md)), and the film keeps
its grounded line, "Your body adapts to what it meets." (D58). The
philosophy's words were settled the same day: no screen after the film, one
line under "Adapt.", and nothing about versions.
