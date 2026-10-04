---
title: Readiness method in Profile — choose how readiness is measured, connect its source, and the rungs without a wearable
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: blocked
status_note: "Direction approved by Peter 2026-10-04 and grounded. Waits only on 0085 landing on develop, which brings the calculator interface and the hooks this RFC builds on."
label: feature
depends: [85]
---

# RFC 0092: Readiness method in Profile — choose how readiness is measured, connect its source, and the rungs without a wearable

## Progress log

- **2026-10-04** — Direction drawn for Peter before building, on invented
  data: a Readiness card in Profile above Max heart rate (three rows, best
  first), a not-connected note in place, the typed rungs in the recovery
  sheet opened from the readiness card, and the method named on Home. Picks
  proposed for the open questions: a check-in gives the same three verdicts
  with a "less certain" line; typed fields live in the recovery sheet; a source
  is connected when it delivered a night in the last 3 days; the connect
  button opens a how-to until a connect flow exists. Waiting on his word.
- **2026-10-04** — `/ground` ran on the check-in lines and the two notes
  (search only, no page opened, so every source rests on its title):
  [grounding/0092-readiness-method.md](../grounding/0092-readiness-method.md).
  Check-in: Steady below own mean − 1 SD and 2 points, Hold below − 2 SD and
  4 points, 28-day baseline, 14 entries first, all convention. Resting HR note:
  ≥ own 30-day mean + 1 SD and ≥ 5 bpm, convention. Short night: under 6 h
  device sleep, partially supported.
- **2026-10-04** — Peter, in the 0085 thread: the scores beside the band
  confuse; the words alone are enough, and one tap from the verdict must show
  what it was worked out from and where in Profile to change it, above all on
  a less certain method. Split agreed through the coordinator: 0085 builds the
  word-only verdict and the one-tap explanation on Home; this RFC builds the
  Profile card, which that explanation links to, so the card must open
  directly (Profile scrolled to Readiness). Direction redrawn without scores.
- **2026-10-04** — Hooks 0085 leaves for this RFC (tekio branch
  `claude/readiness-inputs-b9o2ks`, v2.1.23, not on develop yet): Home's
  card shows only the band word and opens `RecoverySheet.tsx`, whose
  ReadinessSource block links "Readiness method · Profile →" through HomeTab's
  `onOpenProfile` prop (opens Profile at the top today; wire it to this card).
  Extend `METHOD_NAME` and `BAND_WORD` there, and `ReadinessMethod` (only
  `overnight_hrv`), `ReadinessReading`, `SystemicReadiness.method` / `.z` in
  `fusedRead.ts`.
- **2026-10-04** — Peter chose "Go" on the direction: the picks below stand.
  Kickoff-ready; the build waits only on 0085 landing on develop.

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
- The readiness card in Profile can be opened directly, so Home's
  explanation (built in 0085) links straight to it.

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

## Grounding

The blocks are in
[grounding/0092-readiness-method.md](../grounding/0092-readiness-method.md)
(2026-10-04). In short: the check-in's form is McLean's 5 × 1–5 and its lines
are **convention** (own mean − 1 SD → Steady, − 2 SD → Hold, with 2- and
4-point floors, 28-day baseline, 14 entries first); the resting HR note is
**convention** (≥ own 30-day mean + 1 SD and ≥ 5 bpm); the short-night note
is **partially supported** at under 6 h of device sleep. Every source rests on
its title this run; re-verify before quoting a figure.

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
- [ ] Profile's readiness card opens directly from Home's explanation link
- [ ] Home names the method behind the verdict, marks a less certain one, and
      names the rung above
- [ ] Seen in the browser on invented data for each method, no console errors
- [ ] It lands on develop and the staging app shows it

## Unresolved questions

None. Settled 2026-10-04 when Peter approved the direction:

1. **A check-in verdict's weight:** the same three words as HRV, with a grey
   "less certain" line that names the rung above. No cap at Steady.
2. **Where the typed fields live:** the recovery sheet, opened from Home's
   readiness card. No separate morning prompt.
3. **"Connected":** a source that delivered a night in the last 3 days.
   Garmin is the only one today; others list as "Not yet".
4. **The connect button:** opens a short how-to; an in-app connect flow
   belongs to the live-sync RFC ([0022](0022-companion-service-live-sync.md)).
