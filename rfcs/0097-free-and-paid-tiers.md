---
title: Free and paid tiers — where the line falls
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-05
status: backlog
status_note: "Decided 2026-10-05 by Peter: launch free, with the tier check in the API from its first version, and billing in a later release. Which feature sits on which side is still open."
label: backlog
depends: [3, 94]
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

**The read is free; what costs money per user is paid.** The product's answer,
*what's missing* (doctrine §1), is the free tier: hiding it would make the free
app a logging app, which is the part doctrine calls overhead. What the paid tier
sells is what costs Tekiō money for each user, or saves the user the most
capture.

| Feature | Tier | Why |
|---|---|---|
| Home, Adaptations, the body map, readiness | free | the product |
| Manual capture on every client | free | the read needs it |
| Planned exercises, entered by the user (0098) | free | capture |
| AI planning and the in-app agent (0099) | paid | a model call per use costs us |
| Agent access from the user's own assistant (MCP, 0099) | free, rate-limited (proposed) | the user pays for their own model; it brings users in |
| Automatic syncs: Garmin, Apple Health, Health Connect (0096) | paid (proposed) | servers and integrations per user; the biggest saving in capture |
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

1. Is the principle right: the read free, the per-user costs paid?
2. ~~Paid at launch or free first?~~ Answered 2026-10-05: free first.
3. The two proposed rows: MCP access free with a limit, syncs paid.
