---
title: Free and paid tiers — where the line falls
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-20
status: backlog
status_note: "Launch free, billing later (Peter, 2026-10-05). Principle decided 2026-10-20: what a person types by hand is free; what writes data automatically (AI generation, linked assistants, syncs) carries a small charge. The read-only connector stays free. Open: the history row."
label: backlog
depends: [3, 94]
release: 3.0.0
---

# RFC 0097: Free and paid tiers — where the line falls

## Summary

Tekiō gets a free tier for everyone and a paid tier. This RFC draws the line by
a principle rather than feature by feature, puts an entitlement check in the API
from the first day, and leaves the payment plumbing to the end of the release.

## Motivation

Where the line falls changes what the API checks, what the agent may do, and
what the landing site promises. Deciding it late means retrofitting checks into
routes that were built open.

## Goals

- A principle that sorts any new feature into free or paid without a new
  argument each time.
- Every paid feature checked in one place, the API, never in a client.
- Payment through the stores on mobile and a card provider on web, one
  entitlement record per user.

## Non-Goals

- Prices, trials, discounts.
- Ads. They do not fit a product whose rule is that a number you cannot act on
  is not shown (doctrine §1).

## Proposal

### The principle

> **Decided 2026-10-20 (Peter).** Rows marked **decided** are his.

**Manual is free; automatic is paid.** What a person types by hand cannot grow
fast, so it costs little to keep and helps many people: manual capture and the
reads over it are free for everyone. What writes data on its own (an AI that
generates plans, an assistant linked to the account, in-house or outside, and
syncs from other apps) can produce a lot of data quickly, and that is what costs
money. Those carry a small charge. The product's answer, *what's missing*
(doctrine §1), stays on the free side: hiding it would make the free app a
logging app, which is the part doctrine calls overhead.

| Feature | Tier | Why |
|---|---|---|
| Home, Adaptations, the body map, readiness | free | the product |
| Manual capture on every client | **free, decided 2026-10-20** | typed by hand, so it stays small; the read needs it |
| Planned exercises, entered by the user (0098) | free | capture |
| Agents that plan workouts from the training history, connected or in-app (0099) | **paid, decided 2026-10-11, confirmed 2026-10-20** | AI generation: a model reads the history and writes plans, every use |
| Agent onboarding: a goal walk-through that refines which adaptations the user chases (with 0040) | **paid, decided 2026-10-11** | a model conversation per user; not built yet |
| Read-only agent access from the user's own assistant (MCP, 0099) | **free, decided 2026-10-11, confirmed 2026-10-20** | it writes nothing, so it adds no data; an assistant that writes is on the paid side |
| Automatic syncs: Garmin, Apple Health, Health Connect (0096) | **paid, decided 2026-10-20** | another app writes data on its own, and a lot of it |
| History beyond a window (for example 90 days of reads) | open | a lever if the line above is too thin |

### Mechanics

- An `entitlements` record per user, written by the payment provider's webhook,
  read by the API on paid routes.
- Mobile subscriptions through the stores' in-app purchase, as their rules
  require for digital goods; a single provider in front of both stores and the
  web (RevenueCat is the usual choice; to evaluate) keeps one entitlement.
- Launch order: the check exists from the API's first version with every user
  on free; billing switches on later without a client change.

## Rationale

- **Rejected: a free tier that is capture only.** It shows the free user nothing
  the product is for, and they leave before learning what paid adds.
- **Rejected: deciding feature by feature as each ships.** Each argument is
  won by whoever is building that feature, the way R1's cap exists to prevent for
  sections.
- **Rejected: "the read is free, per-user cost is paid" (2026-10-05 draft).**
  Peter redrew it by data volume instead: manual is free, automatic is paid.
  The two mostly agree; the new line is easier to apply to a feature nobody has
  thought of yet.
- **Syncs on the paid side is the debatable row.** It is the strongest reason to
  pay, and also what makes the free read honest without typing. If free users
  drop off for lack of data, sync of a single source moves to free.

**Brief checklist (doctrine §4).** 1: none; packaging. 2: deciding each
feature's tier in its own RFC. 3–4: not applicable. 5: no number.

## Acceptance

- [ ] Peter's call on each row of the table is recorded
- [x] Peter's call on paid at launch or after is recorded: free first (2026-10-05)
- [ ] The API refuses a paid route for a free user, tested
- [ ] A test purchase on each store and on web sets the entitlement

## Unresolved questions

1. ~~Is the principle right?~~ Answered 2026-10-20: manual free, automatic paid.
2. ~~Paid at launch or free first?~~ Answered 2026-10-05: free first.
3. ~~Read-only connector free? Syncs paid?~~ Answered 2026-10-20: the
   read-only connector stays free; syncs are paid.
4. History beyond a window: a lever, or not used?
