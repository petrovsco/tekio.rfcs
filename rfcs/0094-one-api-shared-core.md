---
title: One API and a shared domain core for every client
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-20
status: in progress
status_note: "Step 1, 2a and 2b are on develop (v2.2.43-45). 2c, the API with the three reads, is tekio PR #29 (v2.2.46); 2d, the capture routes, is next."
label: infra
depends: [95, 3]
release: 3.0.0
---

# RFC 0094: One API and a shared domain core for every client

## Progress log

- 2026-10-20: step 1 built, tekio PR #25 (v2.2.43). `packages/core` is an npm
  workspace, `@tekio/core`, holding `adaptations.ts`, `fusedRead.ts`,
  `sets.ts`, `hrMax.ts`, the read constants (`constants/reads.ts`,
  `constants/adaptations.ts`), the calendar helpers and `LEVEL_WEIGHT`
  (`utils.ts`) and the domain types (`types.ts`). Its tsconfig has no DOM lib.
  The four reads moved verbatim, so every line the grounding inventory cites in
  them holds; the inventory rows on the moved constants were repointed. 329
  tests pass with only their import lines changed, and every production chunk
  is the same size as before. The tests still run from the app's `src/test/`:
  some of them exercise app code beside the reads, and splitting them is not
  needed until the API has its own runner.
- 2026-10-20: step 1 merged to develop as v2.2.43 (tekio #25) on Peter's word;
  step 2 planned as 2a–2d below and started at 2a.
- 2026-10-20: 2a merged to develop as v2.2.44 (tekio #27). `packages/db`,
  `@tekio/db`, holds the row loaders the reads stand on, each taking a `Db`
  (a PostgREST client and the caller's user id); the app passes `appDb()`.
- 2026-10-20: 2b built, tekio PR #28 (v2.2.45). `homeRead`, `adaptationsRead`
  and `readinessRead` in core take the rows and the person's own day; Home and
  Adaptations call them. Screens pixel-identical to v2.2.44 against mocked
  rows; first paint re-baselined to 353.78 kB (about 0.6 kB of it this step,
  the rest sign-in).
- 2026-10-20: 2b merged to develop as v2.2.45 (tekio #28).
- 2026-10-20: 2c built, tekio PR #29 (v2.2.46). `packages/api`, Hono with
  `@hono/zod-openapi`, serves `GET /api/read/home`, `/api/read/adaptations`
  and `/api/read/readiness` (each with a required `date`) and
  `/api/openapi.json`. Rows load through `loadReadRows` with the caller's
  token while Supabase Auth checks it. One Vercel function, `api/index.ts`,
  takes every `/api/*` address through a rewrite (a catch-all filename matches
  only one segment outside Next.js), and imports an esbuild bundle that
  `npm run build` writes, because Vercel compiles a function file by file and
  Node cannot follow the packages' extensionless TypeScript imports. Checked on
  the preview: the OpenAPI description is served, routes reach Hono, and the
  app itself stays behind the cookie gate. The response schemas name only
  their top-level fields so far; each field's full shape is still to come
  before a client is generated from the description.

## Summary

Move the reads out of the web client into a TypeScript package, put one HTTP API
in front of the database, and make that API the only door every client uses: the
web app, the Android and iOS apps (0096), and the agent (0099). The API knows
who is asking (0003) and what they may use (0097).

## Motivation

Today the browser talks straight to Postgres and computes the product itself:
the coverage read (`packages/core/src/adaptations.ts`) and the fused readiness read
(`packages/core/src/fusedRead.ts`) run over rows the client fetched. A second client would
need a copy of both, and the agent a third. A paid tier cannot be enforced in a
client at all. And a client that talks to the platform ties the platform to every
client.

## Goals

- The two reads exist once, in a package with its own tests, and every client
  gets the same answer for the same rows.
- No client holds a database key or builds a query.
- The API checks the user on every call and the tier on the calls that need it.
- Moving the database or the API's host changes no client.

## Non-Goals

- Rewriting the reads. They move with their tests and their grounding comments
  unchanged; a number that changes here is a bug.
- GraphQL, real-time sync, offline-first. Each can come later through its own
  RFC if a client needs it.

## Proposal

**Since 2026-10-05 the server side is not optional.** The phone apps are native
(0096), so they cannot import a TypeScript package: every read must be served
by the API, computed by the core package on the server. The web app may still
import the core for speed, but the API's answer is the reference.

1. **`core` package** inside the tekio repo (a workspace, not a new repo):
   `adaptations.ts`, `fusedRead.ts`, `sets.ts`, `hrMax.ts` and the constants they
   read, with no React and no database import. The web app imports it first, with
   no behavior change, which proves the cut before anything else depends on it.
2. **The API**: a small TypeScript HTTP app (Hono is the candidate: it runs on
   Vercel functions, AWS Lambda and Supabase's edge runtime alike, which keeps
   0095's options open). Endpoints follow the product, not the tables:
   - reads: `GET /read/home`, `GET /read/adaptations`, `GET /read/readiness`
   - capture: `POST/PATCH/DELETE` for sessions and sets, cardio, mobility,
     sleep, body weight, donations, and planned items (0098)
   - an OpenAPI description generated from the route definitions, from which the
     clients' typed calls and the agent's tools (0099) are generated.
   Step 2 lands in four patches, each leaving the app working (planned
   2026-10-20, once 0003 was on staging):
   - **2a, a `db` package.** The row loaders and their row ↔ entry mappers move
     out of `src/lib/db/` into `packages/db`, taking the database client and the
     user id as arguments instead of reading the app's. The web app calls them
     with its own client; the API calls them with one carrying the caller's
     token. One mapping, so the two cannot read a row differently.
   - **2b, the reads as whole answers.** What Home, Adaptations and the
     readiness sheet compose from the core calls today (inside `HomeTab.tsx`
     and its siblings) becomes one function per read in core,
     `homeRead(rows, date)` and its two siblings, returning plain data. The
     screens call them, so the API's answer and the screen's are the same call.
   - **2c, the API with the three reads.** `packages/api`: Hono, deployed as a
     Vercel function under `/api` on the same project. Every request carries the
     Supabase access token as a bearer token; the API verifies it, then reads
     with a client that sends that same token, so the policies still decide what
     it may touch. The staging cookie gate in `middleware.ts` lets `/api/` pass,
     because the token is that route's door and a phone app has no cookie.
     Routes are declared with `@hono/zod-openapi`, so the OpenAPI description
     is generated from the same definitions from the first route on.
   - **2d, capture routes**, one domain per patch, in the order the phone app
     will need them: weights first.
3. **Identity** from the auth provider's token (0003), checked on every request;
   the database is reached with the user's identity so RLS stays a second lock.
4. **The web app** moves from `src/lib/db/` to the API one domain at a time,
   each move a patch that leaves the app working.
5. **Integrations** (the Garmin syncs) write through the same API or the same
   core, with per-user credentials; that is 0096's health-data half.

## Rationale

- **Rejected: keep PostgREST and share only the core package.** It shares the
  reads, but every client still holds a database key and builds queries, the
  tier cannot be enforced, and the agent would need its own server anyway.
- **Rejected: compute the reads in the database (SQL views or functions).** The
  reads are ~1,100 lines of tested TypeScript with grounding comments on their
  constants; translating them into SQL risks the numbers for no user benefit.
- **A workspace package, not a new repo**, so one commit can change a read and
  its callers together.

**Brief checklist (doctrine §4).** 1: every read, unchanged. 2: copying the reads
into each client. 3–4: infrastructure. 5: no new number; existing numbers move
untouched.

## Acceptance

- [x] `core` package exists, the web app imports the reads from it, and the test
      suite passes unchanged
- [ ] The API serves the three reads and every capture route, behind a checked
      token
- [ ] The web app no longer imports `@supabase/postgrest-js`
- [ ] The OpenAPI description is generated and a typed client is generated from it
- [ ] The first-paint budget (`npm run perf`) holds or is re-baselined with a reason

## Unresolved questions

1. ~~The API's first host?~~ Vercel functions, next to the web app: 0095
   stayed on Supabase with the API on Vercel (2026-10-05).
2. ~~The API's language: TypeScript or Rust?~~ Answered 2026-10-20 by Peter:
   TypeScript. The reads move as they are and the web app shares the core;
   Rust stays an option for a hot path that is measured slow.
