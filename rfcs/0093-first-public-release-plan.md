---
title: The first public release — the map of the work
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-06
status: in progress
status_note: "Mapped 2026-10-04; nothing is built. Decided 2026-10-05: stay on Supabase, native apps, agent help outside the app first, launch free, the plan tagged 3.0.0, and the doctrine rewritten for every user. Planned exercises (0098) left the plan for 2.2.0 and its own thread. Open: the free/paid line, refined while 3.0.0 is built."
label: infra
release: 3.0.0
---

# RFC 0093: The first public release — the map of the work

## Summary

Tekiō has one user, one web client and one hardcoded `USER_ID`. The first public
release makes it a product other people install: web kept, plus Android and iOS
apps, all talking to one API; accounts with rows only their owner reads; a free
and a paid tier; a *planned* state for exercises that have not happened yet; and
an agent that can plan and log on the user's behalf, inside the app, outside it,
or both. A move from Supabase to AWS was raised in the same breath and is
evaluated here before anything is built on top of either.

This RFC is the map. It names each workstream, orders them by what blocks what,
gives a recommendation for each, and points at the one RFC per workstream that
carries the detail. It builds nothing itself; it is done when every workstream
has its RFC decided and the release is named in `releases.md`.

## Motivation

Six asks arrived at once, and every one of them changes how the others are
built. Mobile apps need an API; an agent needs the same API; a paid tier needs
the API to know who is asking and what they paid for; a move to AWS changes
where that API runs. Taking them one at a time, in the order they were said,
builds the web client's data layer a second time inside each new client and then
again when the backend moves. Ordering them first is cheaper than any one of
them.

There is also no user yet other than the one the product was built on, so this
is the cheapest moment the platform will ever have to change: no other user's
data has to move with it.

## Goals

- Every workstream has an owner RFC with a recommendation, its dependencies and
  its open forks.
- The order below is the order work starts in, and nothing starts before what it
  depends on.
- Each fork that is Peter's call is put to him once, with a pick, and its answer
  is written into the RFC it belongs to.

## Non-Goals

- Building any of it. Each workstream's RFC is kicked off on its own.
- Naming the release or its version. The minor and major digits are Peter's call
  (code repo `CLAUDE.md`, *Branching and versioning*).
- Pricing. 0097 decides which features sit behind the paid tier, not what it
  costs.
- The readiness work already in flight (0085, 0092) and the exercise catalogue
  (0074). They ride along as they are and are listed only where they touch this
  plan.

## Proposal

### The current shape, measured on 2026-10-04 (tekio v2.1.21)

- **One client, talking straight to the database.** The web app reads and writes
  Postgres through `@supabase/postgrest-js` from the browser; there is no server
  of ours in between. Supabase Auth, Storage and Realtime are not used.
- **The reads live in the client.** What the product *is* — the coverage read in
  `src/lib/adaptations.ts` and the fused readiness read in `src/lib/fusedRead.ts`,
  about 1,100 lines — runs in the browser over rows it fetched itself. A second
  client would have to carry a copy of both.
- **One user, by constant.** `USER_ID` in `src/constants/app.ts` filters every
  query; RLS is wide open on purpose (`code-review.md`). Accounts are RFC
  [0003](0003-lock-the-database.md), in backlog as "post-MVP".
- **Integrations run on the owner's credentials.** The Garmin activity and sleep
  syncs are Python scripts in GitHub Actions, dispatched by `pg_cron`, logged in
  as one Garmin account.
- **Supabase-specific surface is small**: PostgREST, `pg_cron` + `pg_net` for the
  dispatch, the project's migrations. The schema is plain Postgres.

That last point decides more than any other: the platform is not yet load-bearing
anywhere but the database, and Postgres moves.

### The workstreams, in order

| # | Workstream | RFC | Depends on | Recommendation |
|---|---|---|---|---|
| 0 | Doctrine for more than one user | — (an amendment) | — | **Done 2026-10-05**: the first person is the user's voice, P4 no longer leans on one user, R3 places a paid tier |
| 1 | Backend platform: Supabase or AWS | [0095](0095-backend-platform-decision.md) | — | Stay on Supabase's Postgres for the first release; put our own API in front so the move stays cheap later |
| 2 | Accounts and data isolation | [0003](0003-lock-the-database.md) | 1 | Real logins, RLS on every table, `USER_ID` gone, the existing rows adopted by the first account |
| 3 | One API and a shared domain core | [0094](0094-one-api-shared-core.md) | 1, 2 | The reads move into a TypeScript package; one HTTP API is the only door to the database for every client |
| 4 | Android and iOS apps | [0096](0096-mobile-apps.md) | 3 | **Decided 2026-10-05: native apps** (Swift, Kotlin) beside the web, drawing reads the API computes; health data and notifications |
| 5 | Agent access | [0099](0099-agent-access.md) | 3 | Outside the app first, as an MCP server on the same API; the in-app agent later, on the same tools |
| 6 | Planned exercises (**2.2.0**, ahead of the rest) | [0098](0098-planned-exercises.md) | — | A `planned` state that never counts toward the body map, shown as its own layer rather than a switch |
| 7 | Free and paid tiers | [0097](0097-free-and-paid-tiers.md) | 2, 3 | The read stays free; what costs us money per user (AI planning, automatic syncs) is paid. Entitlements in the API from day one, billing later |
| 8 | Launch readiness | — (opened when 2–4 land) | 2, 4 | Privacy policy, account deletion and export in the app, store listings, and the landing site's release form turning into a link to the app (the site itself goes public with 2.2.0, [0084](done/0084-public-landing-site.md)) |

Workstreams 4, 5 and 6 can run side by side once 3 lands. 7's principle (which
feature goes where) can be decided at any time; only its billing waits.

### Why this order

1. **The platform first, because it is the only decision that gets more expensive
   every week.** Auth, the API's runtime and the integrations all land somewhere;
   choosing where after building them means building them twice. 0095 is an
   evaluation, short on purpose.
2. **Accounts before the API**, because the API's first job is to know who is
   asking. An API built for one user and then retrofitted with identity is the
   rewrite this plan exists to avoid.
3. **The API before any new client.** Mobile, the agent and the paid tier all
   read the same reads. With the reads in a shared core behind one API, each
   new client is a client; without it, each new client is a second copy of the
   product.
4. **The mobile apps, the agent and planned exercises after that, in parallel.**
   None blocks another. Planned exercises is the one most likely to be wanted by
   the agent (an AI plan is a list of planned sets), so it should land no later
   than the agent's write tools.
5. **Tiers last to build, first to decide.** Where the free/paid line falls
   changes what the API must check, so the line is drawn early; the payment
   plumbing is the last thing before launch.

### What this plan does not change

- The doctrine's purpose and the R1 cap of four menu sections. Every workstream
  above is either infrastructure (no section), a client (no section), or an input
  to an existing read (planned exercises sharpen the body map; the agent is a way
  to reach the reads, not a destination). None adds a fifth section.
- The grounding gate. Nothing here writes a new physiological number. 0098 is the
  one to watch: a "what if I train today's plan" preview restates the existing
  read over rows that do not exist yet, which `/ground`'s Step 0 should confirm is
  exempt before 0098 becomes code.

### Earlier decisions this plan meets

- **The in-app assistant was deleted on 2026-10-02** ([0087](done/0087-remove-program.md),
  from the 0034 review). 0099 is the place it may come back, and it has to say
  what is different this time.
- **Program was deleted on the same day, to be rebuilt.** A plan for today is the
  smallest piece of a program; 0098 is written so that a rebuilt Program reuses
  its `planned` state rather than inventing another.
- **Admin was deleted on 2026-10-04, to come back with a real role gate**
  ([0090](done/0090-admin-out-mobility-in.md)). The role gate needs accounts, so
  it follows 0003; it is not a workstream of its own here.
- **The companion service ([0022](0022-companion-service-live-sync.md))** was an
  earlier idea for a service of ours in front of the data. 0094 supersedes its
  sync half; its notifications half moves into 0096.

## Rationale

**One umbrella and six RFCs, rather than one large RFC.** Each workstream will
be kicked off, argued and closed on its own, by a different session, months
apart. A single file would carry six status lines in one `status` field.

**Rejected: start with the mobile apps, because they are the visible part.**
Without the API they re-implement the data layer and the two reads in a second
codebase, and the paid tier and the agent then need a third.

**Rejected: move to AWS first, while it is cheap.** It is cheap now, but the
move itself buys nothing a user sees, and its cost later is mostly in whatever
gets built on Supabase-only features in the meantime. Putting our API in front
of the database (workstream 3) keeps that cost low whichever way 0095 goes. 0095
carries the comparison.

**Brief checklist (doctrine §4)** for the plan as a whole; each workstream RFC
answers it for itself.

1. *Which read does this sharpen?* None directly. It lets the existing reads
   reach more people and more devices.
2. *What does it let me stop doing?* Building each new client's data layer by
   hand, and treating one person's data as the product's.
3. *Input or destination?* Neither: platform and clients.
4. *Honest shape of the data?* Unchanged.
5. *Does it write a number claiming physiological meaning?* No.

## Acceptance

- [x] Every workstream named in the ask has an owner RFC or an owner amendment
- [x] The doctrine amendment for more than one user is written (2026-10-05, on
      Peter's "fix the doctrine")
- [x] 0095's platform decision is recorded (stay on Supabase, 2026-10-05)
- [x] 0096's mobile approach is recorded (native apps, 2026-10-05)
- [x] 0099's agent order is recorded (outside first, 2026-10-05)
- [ ] 0097's free/paid principle is recorded
- [x] 0098's body-map treatment is recorded: the outline layer (Peter, 2026-10-05)
- [x] The release is named in `releases.md` and every workstream RFC carries its
      `release:` field: 3.0.0, with 0098 in 2.2.0 (Peter, 2026-10-05)

## Unresolved questions

Each is put to Peter on its own, in this order, and its answer moves into the
RFC named.

1. ~~Backend: stay on Supabase or move to AWS?~~ Answered 2026-10-05: stay on
   Supabase, with our own API in front ([0095](0095-backend-platform-decision.md)).
2. ~~Mobile: Capacitor or React Native?~~ Answered 2026-10-05: native apps
   ([0096](0096-mobile-apps.md)).
3. ~~Agent order?~~ Answered 2026-10-05: outside first, as a remote MCP
   connector ([0099](0099-agent-access.md)).
4. Paid tier: ~~at launch or after?~~ Answered 2026-10-05: free first, billing
   later. Still open: which side of the line each feature sits on
   ([0097](0097-free-and-paid-tiers.md)).
5. Planned exercises on the body map: a separate layer, a switch, or not shown?
   ([0098](0098-planned-exercises.md))
6. ~~The release name~~ 3.0.0, with 0098 in 2.2.0 (2026-10-05). Still open:
   ~~the doctrine amendment's wording~~, written 2026-10-05.
