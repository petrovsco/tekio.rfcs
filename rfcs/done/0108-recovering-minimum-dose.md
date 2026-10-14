---
title: A minimum dose before a muscle reads as recovering
authors: [Peter Petrov]
created: 2026-10-14
last_updated: 2026-10-14
status: done
status_note: Shipped in tekio v2.2.26; Peter checked it on staging on 2026-10-14.
label: bug
---

## Progress log

- 2026-10-14 — Peter saw a muscle marked "still recovering" after a single
  set and asked whether a minimum should apply first. Scouted; Peter took
  2 weighted sets a day on the decision card (D60). Shipped to develop.
- 2026-10-14 — Peter checked it on staging: working. Done.

# RFC 0108: A minimum dose before a muscle reads as recovering

## Summary

A muscle reads "still recovering" on Home, in the muscle sheet and on the
Adaptations list only once a single day gave it at least
`RECOVER_MIN_SETS = 2` level-weighted sets: a prime mover's set counts 1, a
synergist's 0.5, a stabiliser's 0. The 48 h window (`RECOVER_DAYS`) then runs
from that day. One set on its own no longer flags anything.

## Motivation

`RECOVER_DAYS` was grounded in [0010](0010-home-fused-reads.md#grounding)
as dose-blind by design, with dose modulation named as the upgrade path (D6).
In practice that meant any linked set started the 48 h flag, including one set
where the muscle was only a synergist. The map then greyed out a muscle the
evidence says is not meaningfully fatigued, which is the over-blocking 0010
warned was worse than under-blocking.

## Goals

- One weighted set in a day never flags a muscle.
- Two prime-mover sets, or four synergist sets, in a day do.
- The fill, `daysSince` and the gap ranking do not change.

## Non-Goals

- Scaling the window itself by dose (24 h light, 72 h+ after high-volume
  failure work). That is a separate constant needing its own grounding.
- An effort-weighted dose (RIR / RPE). Capture records no effort today.

## Proposal

`lastDosedDates` in `src/lib/fusedRead.ts` sums each muscle's level-weighted
sets per day over the last `RECOVER_DAYS` days, across every entry that day,
and keeps the latest day at or above `RECOVER_MIN_SETS`. `recovering` reads
from that date instead of the last date any set touched the muscle. Every set
counts whatever its quality, as before: a muscle recovers from the work, not
from a rep band. Days are not summed together: one set yesterday and one today
is not a dose.

## Rationale

- **3 sets** is the smallest dose shown to delay recovery, so it is the upper
  edge. Taking it would clear muscles that one study already shows tired.
- **Keep it as is** leaves the over-blocking Peter reported.
- **2** sits under the measured edge and still catches a real session. It is a
  convention, and the grounding says so.
- Synergists keep their 0.5: after heavy compound work a synergist tires about
  as much as the prime mover, so counting it at 0 would under-block.

## Grounding

**Claim:** Below a per-muscle daily dose of N weighted sets (prime mover 1,
synergist 0.5), a muscle is not meaningfully fatigued 24–48 h later and should
not read "still recovering".
**Searched:** 2026-10-14 · **Verdict:** partially supported. The direction is
supported; the number is a convention.
**Number to use:** 2–3 weighted sets per muscle per day, default **2**. In
trained lifters 3 sets to failure measurably delays recovery for 24–48 h, so
the cutoff sits at or below 3. No study found tests 1–2 sets at 24–48 h, so
any value below 3 is a choice, not a measurement.

### Evidence

- `[literature]` Effort matters more than set count. 6×5 with a 10RM load (far
  from failure) had jump height and bar speed back to baseline by 6 h; 3×10 to
  failure kept jump height down at 6, 24 and 48 h, recovered by 72 h, with CK
  raised to 48 h. Crossover, highly trained men, n = 10, bench then squat at
  75% 1RM — [Morán-Navarro et al. 2017, Eur J Appl Physiol](https://pubmed.ncbi.nlm.nih.gov/28965198/)
- `[literature]` 6 sets of bench at 75% 1RM: at 24 h, failure and 1 RIR still
  showed a small bar-speed drop against 3 RIR; most participants were
  recovered by 24 h and no protocol differed at 48 h. Randomised crossover,
  trained men and women, n = 24 — [Refalo et al. 2023, Sports Med Open](https://link.springer.com/article/10.1186/s40798-023-00554-y)
- `[literature]` Synergists: 8 sets of bench to failure left pectoralis peak
  torque down to 72 h and triceps total work still down at 48 h; the authors
  read bench as stressing both about equally. Repeated measures, trained men,
  n = 18, isokinetic testing. Abstract read only; authors and journal not
  confirmed from the source reached.
- `[literature]` Volume, not load, drove the longer windows. Trained men —
  [Bartolomei et al. 2017, Eur J Appl Physiol](https://pubmed.ncbi.nlm.nih.gov/28447186/)
  (carried from 0010).
- `[literature]` Damage scales with dose: 30 maximal eccentric actions cost
  less strength than 50 or 70. Randomised groups, male athletes, n = 70 —
  Chen & Nosaka 2006, J Sci Med Sport. Eccentric-only, so direction only.
- `[literature]` No study isolates 1–2 sets, to failure or not, and measures
  recovery at 24–48 h in trained people.
- `[single-practitioner position]` Israetel / RP: per-session volume decides
  how long recovery takes, so recovery is dose-dependent, not a fixed 48 h
  after any set. No citable page with a minimum dose found. Galpin silent on a
  set-count threshold in what was found.

### Where they split

No disagreement on the direction. The fork is what the dose is measured in:
closeness to failure decides more than set count does (6 easy sets recover in
6 h, 3 sets to failure take up to 72 h). A set count is a stand-in for an
effort-weighted dose and is named that way, not presented as the measured
cutoff.

### Caveats

- Population: young, trained, mostly male lifters, mostly bench and squat.
  Older users likely recover more slowly; small single-joint muscles and sets
  far from failure probably recover faster.
- Synergist weighting: 0.5 is not generous, given synergists tire about as
  much after heavy compound work. Do not drop it to 0.
- Stabilisers (weight 0) have no recovery data either way; a convention.
- What would move this number: logged effort (switch to sets at about ≤3 RIR
  and keep 2–3); a study of 1–2 sets to failure at 24/48 h; evidence that one
  set to failure delays recovery past 24 h would put it back to 1.

### Source comment

`// 2 — level-weighted sets one muscle must get in a day before RECOVER_DAYS starts … Convention inside a 1–3 bracket … See tekio.rfcs/rfcs/0108-recovering-minimum-dose.md#grounding`

## Acceptance

- [x] One weighted set in a day leaves a muscle unflagged; two prime-mover
      sets or four synergist sets flag it (`src/test/fusedRead.test.ts`).
- [x] Sets from two entries on one day add up; sets on two different days do
      not.
- [x] `RECOVER_MIN_SETS` carries its source comment; D60 and inventory row
      4.22 record it.
- [x] Peter checks on staging that a one-set muscle no longer reads as
      recovering.

## Unresolved questions

None.
