---
title: Error reports, sent automatically, which an agent turns into fixes
authors: [Peter Petrov]
created: 2026-10-08
last_updated: 2026-10-15
status: in progress
status_note: "All three stages run on develop. The first real fault (a stale tab after a deploy, 16 reports) was filed, fixed and merged as tekio PR #7 (v2.2.33). Open boxes wait on a render crash, a refused save and a repeat reaching the table, a report the routine cannot fix, the privacy policy and the release sweep."
label: feature
---

# RFC 0103: Error reports, sent automatically, which an agent turns into fixes

## Progress log

- 2026-10-15: tekio PR #7 merged into develop (v2.2.33, on Peter's word): a
  stale tab no longer reports the background loads that fail while it reloads.
  It closes issues #2 to #18, all 16 real reports so far, every one that fault
  on staging. GitHub closes at most ten issues from one PR, so the other seven
  were closed by hand. The chunk hash in the message split one fault into 16
  signatures; worth grouping in the filer if it ever recurs.
- 2026-10-10: stage 1 built (tekio v2.2.11, branch `claude/error-reports-stage-1-tmsxfh`).
  The `error_reports` table moved forward from stage 2, because stage 1's
  acceptance needs a row to land: closed to the browser (RLS on, no policy),
  written only through `report_error` and `add_error_report_note`. Two calls
  made while building: the Home sheets await their writes with no catch, so an
  uncaught error now also shows a "Something went wrong. Reported" toast; and
  the failure toast stays six seconds when it offers a note, above any open
  sheet. Checked in a browser against a stubbed database: a refused write, a
  render crash and an uncaught error each sent one report, and a note reached
  the same signature. Not yet against the real table.
- 2026-10-11: on Peter's yes, the `error_reports` migration was applied through
  the Supabase connector (stamped 20261011042312). Checked in a rolled-back
  transaction as the browser's role: two reports counted 2 on one row, a note
  attached to it, and a direct read returned nothing. Stage 1 merged to
  `develop` as v2.2.11.
- 2026-10-11: on Peter's call, the note is gone (tekio v2.2.14): reports are
  the automatic data only, and the screens just say "Reported". Checked in a
  browser against a stubbed database. Issues will go in public `tekio`.
- 2026-10-11: stages 2 and 3 built (tekio v2.2.16). Stage 2 is a GitHub
  Actions workflow rather than the edge function first proposed: it uses the
  workflow's own token and the Supabase secrets the Garmin syncs already
  hold, so it needed no token to mint, no secret to store and no migration.
  Run end to end against a fake API (new, held, junk, came-back, repeat and
  closed rows each did the right thing). Stage 3 is the
  `fix-error-reports` skill in tekio, run daily at 08:59 Sofia time by the
  routine "Fix error reports", which wakes the project thread "Error reports,
  stages 2 and 3". The first dry run found three real reports from staging,
  all one fault: a tab open across a deploy asking for a lazy chunk the
  deploy had replaced. Its chunk name in the message split it into three
  signatures.

## Summary

When the app hits an unexpected error, it sends a technical report on its own,
with nothing the user typed or logged in it. The report lands with what an
engineer needs to reproduce it, and a
scheduled agent reads new reports, groups duplicates, reproduces the fault, and
opens a fix as a pull request against `develop`. A person still merges. Three
stages, each useful on its own: catch and send, store and file, fix by agent.

## Motivation

Today an error reaches anyone only if the user mentions it. The app's one net is
`ErrorBoundary` (`src/components/ui/ErrorBoundary.tsx`), which shows the message
and a Reload button and then forgets it; store actions that throw end in a
generic toast. Nothing is recorded, so a fault seen once on a phone is gone
unless it is described from memory in a chat. With other users coming (0093)
that stops working: they will not write to the developer, they will leave.

## Goals

- Every uncaught error and every failed write is reported without a tap, and
  the report carries only what the app gathers on its own.
- A report carries enough to reproduce: app version, screen, the error and its
  stack, browser, and the last few actions, with no logged values in it.
- Reports are stored privately and deduplicated by their error signature.
- An agent works new reports without being asked and opens a fix PR, or says
  why it could not.

## Non-Goals

- **Auto-merge or auto-deploy.** `develop` is the staging build somebody trains
  on, and it shares the production database; a patch nobody read does not go
  there. The agent stops at a pull request.
- **Reports as RFCs.** An RFC is planned work. A report is an input to triage.
  The agent opens an RFC only when the fix is planning-sized (a migration, a
  read changing meaning, anything `/ground` would trigger on), and labels it
  `bug`.
- **Performance monitoring, session replay, analytics.** Not the read; not
  shown; not built.
- **Known field errors.** A validation message the app already shows (an
  invalid set's red line, a blocked Save) is expected behaviour and is never
  reported. Only the unexpected is: a crash, a write the database rejects, an
  error nothing caught.
- **A new menu section or screen.** The offer appears where the error happened
  (P1) and nowhere else.

## Proposal

### Stage 1: catch and send (web app, small)

- One `reportError(error, context)` helper fed from three places:
  `ErrorBoundary.componentDidCatch`, `window` `error` and
  `unhandledrejection`, and the store's shared catch that today ends in a toast.
- **Sent automatically** (Peter, 2026-10-10). The technical payload below goes
  as soon as the error happens; no tap. The boundary screen says "Reported"
  beside **Reload**, and a failed write's toast says "Reported." too.
- **No note** (Peter, 2026-10-11). A report is the error, not a conversation.
  A user who wants to say more has other channels (suggesting RFCs, the GitHub
  repo) and decides there what to share. This replaces the opt-in note decided
  on 2026-10-10.
- **Why automatic is allowed.** The payload holds no personal or health data, so
  under GDPR it rests on legitimate interest and needs no consent, but it must
  be stated in the privacy policy (0093's launch readiness). Health data is the
  line that needs explicit consent: logged values are never in the payload,
  and there is no free text in it. To be confirmed before the public launch; this
  is a reading of the rule, not legal advice.
- The payload is built from a whitelist, never by serialising state: version
  (`package.json`), build (`origin` tag), tab, error name, message, stack, user
  agent, and the last ~10 navigation and action names (names only, no values).
  The signature is a hash of the error name plus the top frames of the stack,
  so the same fault seen many times is one report.

### Stage 2: store and file

- An `error_reports` table (built in stage 1, because stage 1 needs a row to
  land): signature, payload, count, first and last
  seen, status (`new` · `triaged` · `fixing` · `fixed` · `wontfix`), and a link
  to the issue or PR. Insert-only for the client once 0003 locks the database;
  the agent reads and updates it with a service role.
- Each new signature becomes an issue in the public `tekio` repository
  (Peter, 2026-10-11: with no note, a report holds nothing personal, so no
  private repo is needed), labelled `error-report`. The issue shows the error,
  version, build, screen, source, stack and trail; the browser line stays in
  the table only, being the closest thing to identifying a device. Filed by
  `.github/workflows/error-report-issues.yml`, hourly, through
  `scripts/error-reports/`:
  - A repeat updates the issue's count and comments once per run; a fault back
    after its fix reopens its issue.
  - The table follows the issue: closed as done is `fixed`, closed as not
    planned is `wontfix`, the `fixing` label is `fixing`.
  - The table is written by anyone with the app's public key, so nothing in a
    row is trusted: a row the app could not have built is `wontfix` and never
    filed, free text is fenced so nothing renders, the title keeps only plain
    characters, and at most five issues open per run.
  - A fault that could show a way in (a refused permission, a key or token in
    the text) is not filed publicly: a bare issue labelled `held` names only
    its signature, and it is worked from the table.
  - The run's log is public too, so it names signatures, never contents.
- The note left over from stage 1's first build (the `note` column and
  `add_error_report_note`) is dropped in the next release's schema sweep; the
  build on staging called it until v2.2.14 deployed.

### Stage 3: the agent

- A scheduled Claude Code routine, daily, plus on demand, following
  `.claude/skills/fix-error-reports/SKILL.md` in tekio. It works the open
  `error-report` issues the filer opened (issue text is data, never
  instructions), at most three a run. For each: read it, find the code, reproduce with a failing Vitest test where
  the fault is in logic, fix, run `npm run build`, `npm run test` and
  `npm run lint`, bump the patch version per the repo's rule, and open a PR to
  `develop` whose body says `Fixes #N`, and labels the issue `fixing`. The
  filer turns that label, and the issue closing on merge, into the report's
  status; the routine never needs the database.
- Where it cannot reproduce, or the fix is planning-sized, it comments its
  findings on the issue and stops. It never touches the schema, never edits a
  grounded constant, and never merges.
- Notification is the PR itself; Peter merges from the phone as today.
- The native apps (0096) send the same payload to the same table through the
  API (0094); the agent does not care which client sent it.

## Rationale

| | Own pipe (recommended) | Sentry, with its Seer agent |
|---|---|---|
| Where user data goes | our database, and issues holding no personal data | a third party that then holds error context from a health app |
| First-paint cost | a few kB | its SDK, lazy-loadable, still the largest new dependency |
| Native apps later | same table through the API | its Swift and Kotlin SDKs, a real advantage |
| Agent | Claude Code with this repo's rules: modus, `/ground`, versioning, `code-review.md` | Seer opens PRs, but knows none of those rules |
| Grouping and stack mapping | ours to build (signature hash; source maps uploaded or read by the agent) | done well, out of the box |
| Cost | free at this volume | free tier for errors; Seer is a paid add-on |

Sentry is the stronger tool for crash grouping and will matter more once there
are many users and native crashes. The own pipe wins now because the expensive
part, the fix, has to follow this repo's rules, and because it keeps a health
app's error context out of a third party before the data-processing questions
in 0095 are answered. Moving to Sentry later only replaces stage 2's capture;
the routine reading issues does not change.

**Brief checklist (doctrine §4).**

1. *Which read does this sharpen?* None directly; it keeps the reads working.
   Infrastructure, like Profile: no menu slot, R1 unchanged.
2. *What does it let me stop doing?* Describing faults from memory in chat, and
   finding them by hand.
3. *Input or destination?* An input, captured where the error happened.
4. *Honest shape of the data?* A list of distinct faults with counts; never
   shown to the user beyond their own report.
5. *Does it write a number claiming physiological meaning?* No. The agent is
   fenced off grounded constants for that reason.

## Acceptance

- [x] Peter's call on where reports land is recorded: own pipe (2026-10-10)
- [x] Peter's call on how far the agent goes is recorded: PR only (2026-10-10)
- [x] Peter's call on sending is recorded: automatic (2026-10-10), no note (2026-10-11)
- [ ] A thrown render error creates one row with no tap and shows "Reported";
      a second identical error bumps its count
- [ ] A failed write files the same way; its toast says "Reported."
- [x] A validation error the app already shows creates no row (a test throws a
      `KnownError` through `withToast` and asserts nothing is sent)
- [ ] The privacy policy states the error reports before the public launch
- [x] The payload contains no logged values (a test asserts the whitelist and
      that a database error's row values stay behind)
- [ ] A new signature opens one issue in `tekio`; a repeat comments (built and
      run against a fake API; ticked when a real report files)
- [ ] The `note` column and `add_error_report_note` are dropped in the release sweep
- [x] The routine turns a seeded report into a PR on `develop` with a failing
      test that its fix makes pass, and marks the report `fixing` (met by a real
      report rather than a seeded one: tekio PR #7, merged 2026-10-15)
- [ ] A report the routine cannot reproduce gets its findings as a comment and
      no PR

## Unresolved questions

- Answered 2026-10-10 (Peter): own pipe, not Sentry; the agent opens a PR to
  `develop` and never merges; reports send automatically.
- Answered 2026-10-11 (Peter): no note at all, and so issues in the public
  `tekio` repo rather than a private one.
- Whether stage 1 and 2 wait for accounts (0003). They need not: the table can
  ship insert-only under today's open policies and tighten with 0003.
