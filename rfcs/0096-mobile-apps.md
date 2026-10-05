---
title: Android and iOS apps beside the web app
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-05
status: backlog
status_note: "Approach decided 2026-10-05 by Peter: native apps, Swift for iOS and Kotlin for Android, beside the web app. Waits on the API (0094), which now must serve the reads computed on the server."
label: backlog
depends: [94]
---

# RFC 0096: Android and iOS apps beside the web app

## Summary

Ship Tekiō in the Play Store and the App Store while the web app stays.
**Decided 2026-10-05 (Peter): native apps**, Swift for iOS and Kotlin for
Android, each calling the API (0094) for the reads and for capture. The
recommendation had been a Capacitor wrap of the React app; the comparison is
kept under Rationale. The native apps add the native pieces that make a store app
worth installing: reading health data (Apple Health, Android Health Connect),
notifications, and a home-screen widget later.

## Motivation

Capture happens at the gym, on a phone, and the readiness inputs (HRV, sleep,
resting heart rate) live in the phone's health store. A web app cannot read
either health store and cannot send a reliable reminder; water logging was cut
on 2026-10-04 partly because the app could not remind
([0089](done/0089-remove-water-and-weights-chips.md)).

## Goals

- Installable apps on both stores, with the same screens and the same reads as
  the web.
- Readiness inputs arrive from the phone's health store for users without a
  Garmin, per user, with their consent.
- One source of truth for the product: the reads are computed once, by the API,
  and every client only draws them. Three UIs, one product.

## Non-Goals

- A native redesign. The SIGNAL language (`design-system.md`) is the design on
  every client.
- Offline-first sync. The apps need the network as the web app does; a capture
  queue for a bad gym signal can come later.
- Watch apps.

## Proposal

1. **Two native apps**: iOS in Swift (SwiftUI), Android in Kotlin (Jetpack
   Compose), with typed API clients generated from the API's OpenAPI description
   (0094). No read is computed on the phone: the apps draw what the API returns,
   so a grounded number cannot drift between clients. Where the two apps share
   logic beyond the API calls (validation, a capture queue), Kotlin Multiplatform
   is the candidate to keep it in one place; decided at kickoff.
2. **Native features**: HealthKit and Health Connect (HRV, resting HR, sleep,
   workouts) feeding readiness through the API; push notifications (the companion
   idea in [0022](0022-companion-service-live-sync.md) moves here); sign in with
   Apple and Google (0003).
3. **Store requirements**, checked at kickoff: in-app account deletion (App Store
   guideline 5.1.1(v)), a privacy policy and the health-data declarations on both
   stores, and in-app purchase for digital subscriptions (0097).
4. **Garmin** for other users needs Garmin's own developer programme rather than
   the owner's login that the syncs use today; until then Garmin users reach
   readiness through the phone's health store, where Garmin Connect can write.
   (Inferred; to confirm at kickoff.)

## Rationale

| | Capacitor (recommended) | React Native / Expo | Native (Swift, Kotlin) |
|---|---|---|---|
| UI code reused | all of it | the core package only; every screen rebuilt | none |
| Health stores, push | plugins | libraries | first-class |
| Feel | web view; the app is a read plus short forms, which a web view carries well | native | native |
| Team of one | one codebase | two (web stays React DOM) | three |

The product is a read and short capture forms, not gesture-heavy UI, so the
native feel buys little and costs a second UI. Apple's guideline 4.2 rejects
apps that are only a website in a frame; the health-store reading and
notifications are the native functionality that answers it. If the web view
shows its limits on a real phone (charts, drag-and-drop), React Native is the
fallback, and the core package (0094) is what it would reuse.

**Brief checklist (doctrine §4).** 1: every read, on a phone. 2: typing
readiness inputs that the phone already measured. 3: the health-store reads are
inputs to readiness (P3). 4: unchanged. 5: no new number; a new *source* for an
existing input goes through 0085's calculator, which says how it is weighed.

## Acceptance

- [x] Peter's call on the approach is recorded: native apps (2026-10-05)
- [ ] Both apps build in CI and run the same screens as the web
- [ ] HRV and sleep arrive from each health store into readiness for a test
      account, with the consent screens shown
- [ ] Account deletion works from inside the app
- [ ] Both apps pass store review

## Unresolved questions

1. ~~Capacitor or React Native?~~ Answered 2026-10-05: native apps.
2. Where the apps' code lives: in the tekio repo, or one repo per app. To
   decide at kickoff.
3. Kotlin Multiplatform for shared app logic, or two independent apps.
