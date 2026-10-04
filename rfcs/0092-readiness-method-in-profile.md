---
title: Readiness method in Profile — choose how readiness is measured, connect its source, and the rungs without a wearable
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: blocked
status_note: "Split out of 0085 on 2026-10-04 at Peter's request. Waits on 0085, which builds the calculator interface and the overnight HRV rung this RFC adds rungs beside."
label: feature
depends: [85]
---

# RFC 0092: Readiness method in Profile — choose how readiness is measured, connect its source, and the rungs without a wearable

## Summary

A user picks in Profile how their readiness is measured: overnight HRV from a
wearable, a 1-minute HRV reading typed each morning, or a how-you-feel
check-in. Picking a method that needs a device asks them to connect it.
Each method has its own calculator, built on the interface
[0085](0085-push-gate-own-baseline.md) lands, and two notes, resting heart rate
and a short night, print beside the verdict without moving it.

## Motivation

- **Without a wearable there is no readiness.** Today readiness reads only
  synced data; a typed night writes duration and quality, never anything the
  verdict reads (0085, Motivation).
- **The ranking says what else works.** `/ground` placed a typed morning HRV
  reading on the same trialled method as overnight HRV, and a how-you-feel
  check-in second, as the evidenced input a person can give with nothing but
  the app ([grounding/0085-readiness-inputs.md](../grounding/0085-readiness-inputs.md)).
- **Peter, 2026-10-04:** each input needs its own calculation, the user should
  select their method in Profile, and a method that needs a device should ask
  them to connect it.

## Goals

- Profile shows the readiness method in use and lets the user change it.
- The default is the highest rung the user can supply (the ladder in 0085,
  Proposal part 1).
- Choosing a method that needs a source the user has not connected says so and
  leads them to connect it.
- The typed morning HRV and the check-in each have their own calculator, their
  own baseline, and their own tests.
- Home names the method a verdict came from, says when a method is less
  certain, and names the rung above.

## Non-Goals

- **Building device integrations.** Garmin sync exists; new sources are their
  own RFCs ([0022](0022-companion-service-live-sync.md) is the live-sync idea).
  This RFC only shows the connection state and where to connect.
- **The overnight HRV rung and the bands.** They are
  [0085](0085-push-gate-own-baseline.md).
- **Mixing methods within a day.** A verdict comes from one method.

## Proposal

1. **Profile: a readiness method.** One choice of three, each saying what it
   needs and how certain it is: *Overnight HRV* (a watch or ring, synced),
   *Morning HRV* (a phone-camera app or chest strap, 1 minute on waking, typed
   in), *Check-in* (four or five taps, less certain). The default follows what
   the user supplies, never taste (P4, below).
2. **Connect when needed.** Choosing overnight HRV without a connected source
   shows that it is not connected and how to connect it. Until it has data,
   the app says so and gives no verdict, rather than falling silently to
   another method.
3. **Morning HRV calculator.** The overnight math (0085) on its own baseline:
   log of HRV, 7-reading mean against the user's own baseline in SD units,
   14 readings before a verdict, the current week kept out of the baseline.
   Morning and overnight readings are never mixed; switching method starts a
   new baseline. A typed field on Home or the readiness card takes the reading.
4. **Check-in calculator.** Four or five items (fatigue, soreness, sleep
   quality, stress, mood), each 1–5, summed, and read against the user's own
   usual total. Its band lines need their own `/ground` run (Nuuttila 2022 used
   a fixed cut, > 5 of 7; Saw 2016 favours the own norm); until then they are
   labelled convention.
5. **Fallback.** When the chosen method has no reading today, a lower method
   gives the verdict only if it has its own baseline; otherwise the day has no
   verdict, as today.
6. **Two notes.** Resting heart rate against its own baseline, and a short
   night under a set number of hours, each with a small calculation of its
   own. They print a line beside the verdict and never change the band. Both
   numbers go through `/ground`.

## Rationale

- **One calculator per method** was Peter's call: the inputs are different
  things, so no shared formula pretends otherwise. They share only what they
  return, a band or nothing.
- **A choice in Profile and P4.** Doctrine P4 says configurability is not a
  decision. This choice is about which device a person has, not taste, and the
  default is the best method they can supply, so it is not a preference
  switch.

## Doctrine checklist (§4)

1. **Read sharpened:** Home's readiness card and its verdict.
2. **Stops:** "no readiness without a wearable".
3. **Input or destination:** input. Profile already exists and is exempt from
   R1; no section is added.
4. **Honest shape:** one systemic number per day, from one method (P5).
5. **Physiological number:** yes. The check-in's band lines and the two notes'
   thresholds need `/ground` before they ship.

## Acceptance

- [ ] Profile shows the readiness method and lets the user change it; the
      default is the highest rung they supply
- [ ] Choosing a method whose source is not connected says so and how to
      connect it
- [ ] The morning HRV calculator has its own baseline and tests
- [ ] The check-in calculator has its own tests, and its band lines have a
      `/ground` block or are labelled convention
- [ ] Resting heart rate and short-night notes have their own calculations and
      tests, are grounded, and never change the band
- [ ] Home names the method behind the verdict, marks a less certain one, and
      names the rung above
- [ ] Seen in the browser on invented data for each method, no console errors
- [ ] It lands on develop and the staging app shows it

## Unresolved questions

1. **How much a typed input is worth.** The ranking puts the check-in second
   on Saw 2016, but no trial prescribed training from it alone. Does Home show
   its verdict with the same weight as an HRV one, or softer?
2. **Where the typed fields live.** On Home beside the readiness card, or a
   morning prompt? Capture is overhead (doctrine §1), so the fewest taps win.
3. **What "connected" means per source.** Garmin is the only sync today;
   which other sources count is the integrations' call.
