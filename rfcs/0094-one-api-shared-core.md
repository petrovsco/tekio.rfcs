---
title: One API and a shared domain core for every client
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: backlog
status_note: "Scoped 2026-10-04 in the 0093 plan. Waits on the platform choice (0095) and on accounts (0003)."
label: infra
depends: [95, 3]
---

# RFC 0094: One API and a shared domain core for every client

## Summary

Move the reads out of the web client into a TypeScript package, put one HTTP API
in front of the database, and make that API the only door every client uses: the
web app, the Android and iOS apps (0096), and the agent (0099). The API knows
who is asking (0003) and what they may use (0097).

## Motivation

Today the browser talks straight to Postgres and computes the product itself:
the coverage read (`src/lib/adaptations.ts`) and the fused readiness read
(`src/lib/fusedRead.ts`) run over rows the client fetched. A second client would
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

- [ ] `core` package exists, the web app imports the reads from it, and the test
      suite passes unchanged
- [ ] The API serves the three reads and every capture route, behind a checked
      token
- [ ] The web app no longer imports `@supabase/postgrest-js`
- [ ] The OpenAPI description is generated and a typed client is generated from it
- [ ] The first-paint budget (`npm run perf`) holds or is re-baselined with a reason

## Unresolved questions

1. The API's first host: Vercel functions (recommended, next to the web app) or
   wherever 0095 lands. Decided by 0095.
