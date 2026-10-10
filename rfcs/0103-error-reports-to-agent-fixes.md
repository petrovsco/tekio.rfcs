---
title: Error reports, sent automatically, which an agent turns into fixes
authors: [Peter Petrov]
created: 2026-10-08
last_updated: 2026-10-10
status: in progress
status_note: "Stage 1 built on tekio branch claude/error-reports-stage-1-tmsxfh (v2.2.11), waiting on Peter's word to apply the error_reports migration before it merges to develop. Stages 2 and 3 not started."
label: feature
---

# RFC 0103: Error reports, sent automatically, which an agent turns into fixes

## Progress log

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

## Summary

When the app hits an unexpected error, it sends a technical report on its own
and lets the user add a note if they want. The report lands in a private inbox with what an engineer needs to reproduce it, and a
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

- Every uncaught error and every failed write is reported without a tap; a
  free-text note is optional and only ever sent by the user.
- A report carries enough to reproduce: app version, screen, the error and its
  stack, browser, and the last few actions, with no logged values in it.
- Reports land somewhere private and are deduplicated by their error signature.
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
  beside **Reload**, with an **Add a note** link; a failed write's toast carries
  the same link for its few seconds. The link opens a small sheet showing what
  was sent, in full, and a line of text; the note is attached to the same row
  only when the user taps Send.
- **Why automatic is allowed.** The payload holds no personal or health data, so
  under GDPR it rests on legitimate interest and needs no consent, but it must
  be stated in the privacy policy (0093's launch readiness). Health data is the
  line that needs explicit consent: logged values are never in the payload, and
  the free-text note, which a user might fill with something about their body,
  stays opt-in for that reason. To be confirmed before the public launch; this
  is a reading of the rule, not legal advice.
- The payload is built from a whitelist, never by serialising state: version
  (`package.json`), build (`origin` tag), tab, error name, message, stack, user
  agent, and the last ~10 navigation and action names (names only, no values).
  The signature is a hash of the error name plus the top frames of the stack,
  so the same fault seen many times is one report.

### Stage 2: store and file

- An `error_reports` table: signature, payload, note, count, first and last
  seen, status (`new` · `triaged` · `fixing` · `fixed` · `wontfix`), and a link
  to the issue or PR. Insert-only for the client once 0003 locks the database;
  the agent reads and updates it with a service role.
- Each new signature becomes an issue in a **private** repository (proposed
  `petrovsco/tekio.reports`, created by hand: the GitHub integration cannot
  create repos in the org). Not in `tekio` or `tekio.rfcs`: both face the
  world, and a user's note about an error in a health app may carry health
  data. A Supabase edge function on insert files it; a repeat signature only
  bumps `count` and comments.

### Stage 3: the agent

- A scheduled Claude Code routine, daily, plus on demand. For each `new`
  report: read it, find the code, reproduce with a failing Vitest test where
  the fault is in logic, fix, run `npm run build`, `npm run test` and
  `npm run lint`, bump the patch version per the repo's rule, and open a PR to
  `develop` that links the issue. It updates the report's status and posts the
  PR link on the issue.
- Where it cannot reproduce, or the fix is planning-sized, it comments its
  findings on the issue and stops. It never touches the schema, never edits a
  grounded constant, and never merges.
- Notification is the PR itself; Peter merges from the phone as today.
- The native apps (0096) send the same payload to the same table through the
  API (0094); the agent does not care which client sent it.

## Rationale

| | Own pipe (recommended) | Sentry, with its Seer agent |
|---|---|---|
| Where user data goes | our database and a private repo | a third party that then holds error context from a health app |
| First-paint cost | a few kB, the note sheet lazy-loaded | its SDK, lazy-loadable, still the largest new dependency |
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
- [x] Peter's call on sending is recorded: automatic, note opt-in (2026-10-10)
- [ ] A thrown render error creates one row with no tap and shows "Reported";
      a second identical error bumps its count
- [ ] A failed write files the same way; its toast offers Add a note
- [ ] Add a note shows the full payload and attaches the note to the same row
- [ ] A validation error the app already shows creates no row
- [ ] The privacy policy states the error reports before the public launch
- [ ] The payload contains no logged values (a test asserts the whitelist)
- [ ] A new signature opens one issue in the private repo; a repeat comments
- [ ] The routine turns a seeded report into a PR on `develop` with a failing
      test that its fix makes pass, and marks the report `fixing`
- [ ] A report the routine cannot reproduce gets its findings as a comment and
      no PR

## Unresolved questions

- Answered 2026-10-10 (Peter): own pipe, not Sentry; the agent opens a PR to
  `develop` and never merges; reports send automatically, the note is opt-in.
- Whether stage 1 and 2 wait for accounts (0003). They need not: the table can
  ship insert-only under today's open policies and tighten with 0003.
