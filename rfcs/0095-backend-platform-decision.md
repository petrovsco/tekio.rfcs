---
title: Backend platform for the public release — stay on Supabase or move to AWS
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: backlog
status_note: "Evaluated on paper 2026-10-04 in the 0093 plan; the recommendation is to stay on Supabase's Postgres with our own API in front. Waiting on Peter's call."
label: infra
---

# RFC 0095: Backend platform for the public release — stay on Supabase or move to AWS

## Summary

Decide where Tekiō's database, auth and API run for the first public release:
on Supabase, as today, or on AWS. The recommendation is to stay on Supabase for
the database and auth, and to run our own API (0094) in a form that would move to
AWS without a client noticing. The move is cheapest before there are other
users, but what makes it cheap is the API in front of the data, not the move
itself.

## Motivation

The move was raised for scale and for the long term, with the argument that it
costs least before the release. That is true of the data: today there is one
user's rows and no auth to migrate. It is less true of the work: every month of
building on Supabase-only features makes a later move bigger. So the decision
belongs at the head of [0093](0093-first-public-release-plan.md)'s order.

## Goals

- One recorded choice, with what would make us revisit it.
- Whatever is chosen, the clients never talk to the platform directly, so a
  later move is a server change.

## Non-Goals

- Migrating anything. If AWS wins, the migration is its own RFC.
- Choosing the mobile stack (0096) or the API's shape (0094).

## Proposal

### What Tekiō uses from Supabase today

| Piece | Supabase-specific? | Moving it |
|---|---|---|
| Postgres schema and rows | No, plain Postgres | `pg_dump` / restore; any managed Postgres |
| PostgREST, from the browser | Yes, but the client only uses a thin query layer in `src/lib/db/` | Replaced by our API in 0094 either way |
| `pg_cron` + `pg_net` dispatching the Garmin syncs | Postgres extensions; also on RDS (`pg_cron`) | A scheduler (EventBridge) on AWS |
| Migrations in `supabase/migrations` | Folder convention | Plain SQL; any runner |
| Auth, Storage, Realtime, Edge Functions | Not used | — |

So the platform is load-bearing only as a managed Postgres. That is why staying
costs little, and also why moving costs little *today*.

### The two options for the release

**A. Stay on Supabase (recommended).** Postgres as now; Supabase Auth for
accounts (0003), which gives email, Apple and Google sign-in (the App Store
asks for a privacy-focused option such as Apple's once any third-party sign-in
is offered, guideline 4.8; to confirm at 0003's kickoff); RLS as the second
lock behind the API. The API from 0094 runs on Vercel functions next to the web
app, written so it can also run on AWS Lambda.

**B. Move to AWS now.** RDS or Aurora Postgres, Cognito for accounts, the API on
Lambda behind API Gateway, EventBridge for the syncs, infrastructure as code
(CDK). The same API code as A.

| | A. Supabase | B. AWS |
|---|---|---|
| Work before the first new feature | none | the database move, auth, infrastructure as code, CI for it |
| Running cost at tens of users | one paid project (inferred from current plans; to confirm) | RDS's smallest instance plus API Gateway, Lambda and Cognito: more line items, similar order of size |
| Scale ceiling | managed Postgres on larger compute, read replicas | the same Postgres, plus every other AWS service |
| Lock-in after 0094 | auth users (exportable, with password hashes) | auth users (Cognito does not export password hashes; users reset) |
| Ops load on a team of one | low | higher: networking, IAM, backups, upgrades are ours |
| EU hosting for health data | region chosen per project | region chosen per resource |

Health data is a special category under the GDPR, so wherever it lands, the
region is in the EU and the processor signs a data-processing agreement. Both
platforms offer both; the project's current region is to be confirmed before
launch.

### What would make us revisit

Any one of: a need that only AWS meets (a service the product depends on), a
measured cost or limit on Supabase that the paid tier cannot carry, or a
compliance requirement Supabase's agreement does not cover. With the API in
front, revisiting means moving the database and swapping the auth provider, not
touching a client.

## Rationale

- **The move buys nothing a user sees**, and the release already carries
  accounts, an API, two apps and an agent. Adding a platform migration to that
  list delays all of them for a benefit that does not arrive until scale this
  product does not yet have.
- **Scale is not the difference.** Both options run the same Postgres; Supabase
  itself runs on AWS. The ceiling that matters for years is the database, and it
  is the same database.
- **The real lock-in risk is the client talking to the platform**, which 0094
  removes either way. After that, the remaining coupling is auth, and that is the
  one item to keep portable: standard OIDC tokens checked by our API, not
  platform calls spread through the code.
- **Rejected: Supabase for data, Cognito for auth.** Two vendors for the price of
  neither's convenience, and RLS can no longer read the user from the token.

**Brief checklist (doctrine §4).** 1–4: not a read; infrastructure. 5: no number.

## Acceptance

- [ ] Peter's choice is recorded here, with the date
- [ ] The Supabase project's region is confirmed (EU) and its data-processing
      agreement is in place, or the AWS equivalent if B wins
- [ ] If B wins: a migration RFC is opened and 0003 and 0094 name AWS's auth and
      runtime

## Unresolved questions

1. Stay (A) or move (B)? Recommendation: A, with the revisit triggers above.
