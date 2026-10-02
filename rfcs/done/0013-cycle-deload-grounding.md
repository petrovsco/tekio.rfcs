---
title: Ground the 6-week cycle and the week-6 deload
authors: [Peter Petrov]
created: 2026-08-26
last_updated: 2026-10-01
status: done
status_note: "shipped 2026-10-01: the 6-week block and the last-week deload are convention, the 0.7 rep factor is partially supported, and no value moved. Decisions D43–D45 in the inventory ledger."
label: feature
release: 2.2.0
---

# RFC 0013: Ground the 6-week cycle and the week-6 deload

## Progress log

- **2026-08-26** — created to carry inventory §5, the last domain with no brief.
- **2026-09-05** — parked by Peter. The cycle and the deload were taken to be
  properties of a program, so they would be grounded only if Tekiō shipped them
  as its default program.
- **2026-10-01** — unparked by Peter. The parking premise did not hold in the
  code: every program, hand-built ones included, gets the app-wide constants,
  and nothing reads the per-program columns, so Tekiō makes the claim itself.
  Three scout runs and the Grounding section below. Done, with no value moved
  and so no migration.

The de-duplication is already done (three bugs fixed 2026-08-26). What is left is
the claim itself, which no one has ever checked: **a training block is 6 weeks,
it deloads in week 6, and a deload is 70% of the previous reps at unchanged load.**

## Why this is its own brief

Inventory §13.9 ranks this third in the back-fill order, and its reasoning holds:
the numbers are load-bearing and completely unexamined. `CYCLE = 6` sets how
often the user deloads for the entire life of a program, and
[doctrine.md](../../doctrine.md) R2 borrows the same 6 weeks as the shelf clock — so
one unchecked number is doing two jobs in two documents.

§13.2 draws the boundary that puts this in scope rather than exempting it:

> `CYCLE = 6` is **not** definitional: "a block is 6 weeks with a deload at week
> 6" is a dose claim about deload frequency, and it is the number in §5 that most
> needs a run. `r05` is definitional: plates come in 2.5 kg pairs.

## The §4 checklist (doctrine R4)

1. **Which read does this sharpen?** Program (cycle + today's plan), and the
   deload banner on Weights. Both already exist — no new surface, so R1 is not
   engaged.
2. **What does it let me stop doing?** Nothing is removed. It converts three
   `unknown` rows into labelled ones and closes the last `(no brief)` domain in
   the inventory.
3. **Input or destination?** Input. No new UI.
4. **Honest shape of the data?** Three scalars plus a placement rule. Not
   spatial, not per-session — a block-level policy.
5. **Writes a number claiming physiological meaning?** **Yes.** This brief needs
   a `## Grounding` section before any value moves. Run `/ground`.

## Scope — the three claims to ground

| Inventory row | Constant | Value | The claim to test |
|---|---|---|---|
| 5.1 | `CYCLE` — `src/constants/app.ts` | `6` | A training block runs 6 weeks before it resets |
| 5.3 | `DELOAD_WEEK` — `src/constants/app.ts` | `= CYCLE` (6) | The deload is the *last* week of the block, not a mid-block week |
| 5.4 | `DELOAD_REP_FACTOR` — `src/constants/app.ts` | `0.7` | A deload cuts reps to 70% and leaves load unchanged |

Three separable questions, and the scout should be allowed to answer them
differently. Deload *frequency* (5.1), deload *placement* (5.3) and deload
*method* (5.4) have distinct literatures — reduced volume at maintained
intensity is the better-supported half, and it is 5.4 that asserts it.

Rows 5.6, 5.7, 5.8 and 5.9 all derive from the three above as of 2026-08-26, so
grounding these three covers them. **5.9 has a DB shadow**: the
`programs.deload_strategy` jsonb column default still carries a literal `0.7`
that nothing reads. Per §13.3, if a value moves, the migration moves with it or
the app keeps the ungrounded number.

## Non-Goals

- **Adaptive / autoregulated deloads** (trigger off readiness or logged fatigue
  instead of a fixed week). That is a feature, and it needs its own brief against
  R1 — this brief only asks whether the *current* fixed numbers are defensible.
- Doctrine R2's 6-week shelf clock. It borrowed `CYCLE`'s number as a convenient
  period, not as a physiological claim; it does not move if `CYCLE` does. Note
  the coincidence in the grounding block so a later reader does not assume one.

## Grounding

Run 2026-10-01, three scouts, one question each, as the Scope section asked:
deload *frequency* (5.1), *placement* (5.3) and *method* (5.4). The blocks are
pasted as returned, with three corrections made on receipt and marked
*(corrected on receipt)*:

- **The survey's frequency.** Run A quoted the preprint's 5.8 ± 3.4 weeks. The
  published paper says 5.6 ± 2.3, so that figure is used here.
- **The Delphi panel.** Run A described it as "coaches and athletes", but the
  panel was coaches.
- **The Sci Rep 2026 trial.** Run A named "Pancar" as first author, and the
  publisher page did not confirm that, so the trial is cited by title.

**How the citations were checked.** NCBI eutils was unreachable from the
session that ran this (the proxy refused the tunnel). Instead, the four
load-bearing papers were each opened on the publisher's own page and checked for
title, journal, year, n and the quoted figure: Bell 2023, Rogerson 2024,
Coleman 2024 and the Sci Rep 2026 trial. The rest were checked only by the
scout that cited them.

| Row | Constant | Verdict | Inventory state | Value |
|---|---|---|---|---|
| 5.1 | `CYCLE = 6` | **convention only** | convention | unchanged |
| 5.3 | `DELOAD_WEEK = CYCLE` | **convention only** | convention | unchanged |
| 5.4 | `DELOAD_REP_FACTOR = 0.7` | **partially supported** | grounded | unchanged |

No value moved, so the `programs` column defaults (`6`, and `0.7` inside
`deload_strategy`) already agree with the constants and no migration was needed.

### Run A — frequency: a block is 6 weeks (row 5.1)

**Claim:** A resistance-training block lasts 6 weeks (5 loading weeks + 1 deload week), so a trained adult deloads about once every 6 weeks. This drives `CYCLE`: when the deload week falls, when the program resets, and the default phase length.
**Searched:** 2026-10-01 · **Verdict:** convention only
**Number to use:** 4–8 weeks per block, default 6. Six sits in the middle of what practitioners report and what the expert consensus describes, but no trial has compared deloading every 4, 6 or 8 weeks. So 6 is the centre of a convention, not a measured optimum.

#### Evidence
- `[literature]` Experts agreed that deloads are "generally undertaken every 4–6 weeks for a period of ~7 days". This describes current practice. It is not an agreed best frequency. The panel also agreed that a deload can be pre-planned or autoregulated. Design: three-round Delphi, consensus at ≥70% agreement, strength and physique coaches, n = 34 → 29 → 21 *(corrected on receipt)*. This is expert opinion with a formal method (tier 6), not outcome data. Bell et al. 2023, *Sports Med Open* 9:87 — [link](https://link.springer.com/article/10.1186/s40798-023-00633-0)
- `[literature]` Self-reported practice: athletes deload every 5.6 ± 2.3 weeks *(corrected on receipt)*, and a deload lasts 6.4 ± 1.7 days. 47.2% plan the deload in advance, 13.4% deload reactively, and 39.4% combine the two. Design: cross-sectional survey of 246 competitive strength and physique athletes (63% powerlifters; training age 8.2 ± 6.2 y). It records what athletes do, not what works. The paper does not say whether the interval counts the deload week itself. Rogerson, Bell et al. 2024, *Sports Med Open* — [full text](https://shura.shu.ac.uk/33446/1/s40798-024-00691-y.pdf)
- `[literature]` Recommends deloading "every 4–8 weeks based on the structure of the training cycle and recovery needs". Design: a narrative practical review that builds on the two papers above, with no new data. Bell et al. 2025, *Strength Cond J* — [PDF](https://doras.dcu.ie/31501/1/a_practical_approach_to_deloading__recommendations.203(2).pdf)
- `[literature]` One week off all resistance training at week 5 of a 9-week program gave similar quadriceps growth to training straight through, but smaller strength gains (squat 1RM +13 vs +16.4 kg). Design: parallel-group RCT, adults aged 18–40 with ≥1 y of training, n = 39 completers (18 deload, 21 continuous). It tests whether to deload, using complete rest. It does not test how often. Coleman et al. 2024, *PeerJ* 12:e16777 — [link](https://peerj.com/articles/16777/)
- `[literature]` Deloads in weeks 4 and 8 of an 8-week program gave similar muscle-thickness and 10RM gains with about 18% fewer total sets. Design: within-subject randomised trial in untrained young men, n = 19. Again it tests whether a deload costs anything, not how often to take one, and the sample is untrained. *Effects of deload periods in resistance training on muscle hypertrophy and strength endurance in untrained young men*, *Sci Rep* 2026 *(corrected on receipt)* — [link](https://www.nature.com/articles/s41598-026-40612-5)
- `[practitioner consensus]` A block should run about 5–7 weeks, including one deload week. Held by Galpin (6 weeks of building, then a deload week, so a 7-week block) and Israetel (4–6 accumulation weeks, then a mandatory deload). Both positions are known only through secondary summaries: [Galpin, podcast notes](https://podcastnotes.org/huberman-lab/guest-series-dr-andy-galpin-optimize-your-training-program-for-fitness-longevity-huberman-lab/), [Israetel/RP, third-party summary](https://arvo.guru/resources/methods/rp-training).

#### Where they split
The real disagreement is over how a deload is *triggered*, not over the number. The Delphi panel and the survey both accept a fixed calendar and a response-triggered deload, and nearly half of the surveyed athletes plan theirs in advance. In Israetel's model the deload comes when volume reaches the maximum the lifter can recover from (MRV), and 4–6 weeks is a typical outcome rather than a rule. Galpin's framing is a fixed calendar. Tekiō is fixed today (`cycleInfo` counts days since `startDate`). That is defensible, because it is the majority practice and the simplest to read. But it means the app will never deload early for a lifter who hits MRV in week 4. If an early deload is ever wanted, it belongs in a readiness input, not in a different `CYCLE`. Galpin's block is 6 + 1 and Tekiō's is 5 + 1. Both sit inside 4–8, so the gap between them is a convention choice and neither one corrects the other.

#### Caveats
- **Population mismatch.** The survey sample is mostly competitive powerlifters with about 8 years of training. The two RCTs used lifters with at least a year of training, or untrained men, in programs of 9 weeks or less. **None varied deload frequency.**
- **What would move this number.** An RCT that compares deload intervals (say every 4 vs every 8 weeks) in trained lifters over 16 weeks or more. Until then, Coleman 2024 (a week off cost strength) is a mild argument against shortening the block below 6. It says nothing about lengthening it.
- **Coincidence, not grounding.** Doctrine R2's 6-week shelf expiry borrowed this number as a convenient period. R2 is a product-governance rule and makes no physiological claim, so `CYCLE = 6` does not justify R2, and R2 does not justify `CYCLE`. Either one can change without the other.

#### Source comment
`6 — 5 loading + 1 deload; convention at the centre of reported practice (survey 5.6 ± 2.3 wk, Delphi 4–6 wk), no trial on frequency`

### Run B — placement: the deload is the last week (row 5.3)

**Claim:** The deload is the last week of the block (week 6 of 6). It is a fixed, scheduled week, not one placed mid-block or triggered by fatigue. This decides which calendar week `cycleInfo` marks `isDeload`, and so when the user is told to pull volume back.
**Searched:** 2026-10-01 · **Verdict:** convention only
**Number to use:** the final week of the block (week 6 of 6). Week 1 of the next block is equally defensible. No trial compares where a deload goes, so this is a convention. The end of the block is the most defensible default for three reasons: it is the placement the expert literature names first, it doubles as the block's review checkpoint, and the one trial in trained lifters that put the deload mid-block found no hypertrophy benefit and a cost to lower-body strength.

#### Evidence
- `[literature]` No study was found that compares where a deload goes (mid-block, end of block or fatigue-triggered). A 2025 practical review recommends a scheduled deload "in the final week of the mesocycle … or the first week of a new mesocycle". It also allows lighter days at any point, guided by performance tests and wellbeing ratings. It cites no trial comparing these options and calls this a research gap. Narrative review, *Strength Cond J* 2025 — [Bell et al., A Practical Approach to Deloading](https://shura.shu.ac.uk/35313/3/Bell-APracticalApproach(AM).pdf)
- `[literature]` Expert consensus is that a deload "could be integrated into the training programme before, during, or at the end of each mesocycle". It can be planned or taken when the athlete is fatigued, every 4–6 weeks, for about 7 days. Three-round Delphi, strength and physique coaches, n = 34 → 29 → 21, ≥70% agreement threshold, *Sports Med Open* 2023 — [Bell et al. 2023](https://link.springer.com/article/10.1186/s40798-023-00633-0)
- `[literature]` In interviews, coaches split three ways. Some pre-schedule the deload ("like the fifth week"), some trigger it from how the athlete responds, and most use a hybrid in which the scheduled deload is a *checkpoint* for deciding whether to deload rather than a mandatory week. Qualitative interviews with national- and international-level powerlifting, bodybuilding and weightlifting coaches, n = 18, *Front Sports Act Living* 2022 — [Bell et al. 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC9811819/)
- `[literature]` A one-week deload in the **middle** of a block (after week 4 of 9) gave the same hypertrophy as continuous training, and continuous training gave larger lower-body strength gains. This deload was a full week off, not a reduced-volume week. RCT, resistance-trained adults aged 18–40, n = 39 completers, 9 weeks, *PeerJ* 2024 — [Coleman et al. 2024](https://peerj.com/articles/16777/)
- `[literature]` Deloads at weeks 4 and 8 of an 8-week program did not reduce muscle-thickness or 10RM gains compared with no deload. Within-subject randomised trial in **untrained** young men, n = 19, *Sci Rep* 2026 — [link](https://www.nature.com/articles/s41598-026-40612-5)
- `[single-practitioner position]` A deload is triggered when performance falls once volume passes the lifter's MRV: "Always deload right after it does". In this model the deload lands at the end of the volume ramp, wherever that falls. Israetel only — [guest post](https://medium.com/@propanefitness/how-to-find-your-maximum-recoverable-volume-mrv-mike-israetel-guest-post-854458b8a2d9)

#### Where they split
Nobody argues for the end of the block against the middle. The real fork is **fixed against triggered**. Israetel's MRV model, and the "reactive" coaches in Bell 2022, end the block when fatigue arrives. The commonest practice is a hybrid: a scheduled end-of-block week used as a checkpoint. No trial shows that either side gives better hypertrophy or strength. The evidence does not say fixed placement is weaker, only that it has not been shown to be better. Tekiō keeps `DELOAD_WEEK = CYCLE` as a hard rule, as this brief's Non-Goals already decided. That is a product choice, not something the evidence dictates. Coleman's mid-block deload cost lower-body strength in trained lifters, which is weak support for *not* moving the deload earlier.

#### Caveats
- **Population mismatch.** The only trial in trained lifters tested complete rest, not a reduced-volume week, and neither trial ran long enough to show fatigue building up across repeated blocks.
- **Repeating cycles.** Back to back, "last week of block N" and "first week of block N+1" produce the same sequence of weeks. The choice only changes the first block. Week 6 is the better of the two because a new program then gets a full block of training before its first deload.
- **What would move this number.** A trial of fixed against readiness-triggered deloads in trained lifters (Bell 2025 lists this as a gap). A change to `CYCLE` moves this value automatically.

#### Source comment
`CYCLE (the last week) — placement is convention: no trial compares deload placement; end-of-block is the default the expert literature names (Bell 2023/2025)`

### Run C — method: 70% of reps, load held (row 5.4)

**Claim:** On a deload week, each set's reps become 0.7 × the last session's reps (rounded, minimum 1), while load and set count stay the same. That is about a 30% cut in rep volume, with external load held. It drives what the Weights screen prescribes in the deload week (the "70% reps" badge and `deloadSets`).
**Searched:** 2026-10-01 · **Verdict:** partially supported
**Number to use:** a rep factor of 0.5–0.75 (a 25–50% volume cut), default 0.7. A planned, routine deload fits the "low recovery need" tier of the only deload-specific guidance, and taper data for maximal strength favour small-to-moderate cuts over large ones. No trial has tested 0.7 against any other dose of an actual deload.

#### Evidence
- `[literature]` Across tapers, cutting volume by 41–60% while keeping intensity and frequency gave the largest performance gains (ES 0.72 for the volume cut). Changing intensity added little. Meta-analysis of 27 studies, mostly endurance athletes, so this is evidence on tapering to peak, not on deloading. [Bosquet et al. 2007, *MSSE*](https://pubmed.ncbi.nlm.nih.gov/17762369/)
- `[literature]` For maximal strength, volume cuts of about 30–50% did better than larger cuts of 50–70%, with intensity held at ≥85% 1RM or raised. Narrative review of powerlifting taper studies in trained lifters, with no pooled n. [Travis et al. 2020, *Sports* 8:125](https://www.mdpi.com/2075-4663/8/9/125)
- `[literature]` "Reductions in training volume, with maintained or small increases in training intensity, seem most effective for improving muscular strength." Narrative review of strength tapers. [Pritchard et al. 2015, *Strength Cond J* 37(2)](https://research.bond.edu.au/en/publications/effects-and-mechanisms-of-tapering-in-maximizing-muscular-strengt/)
- `[literature]` Deload consensus: volume falls, through fewer sets, fewer reps per set or fewer sessions. Intensity can go up, down or stay the same, but stays the same "only when training volume is reduced". No percentage reached consensus. Delphi, strength and physique coaches, n = 34 → 21. [Bell et al. 2023](https://link.springer.com/article/10.1186/s40798-023-00633-0)
- `[literature]` Volume cuts are tiered by recovery need: low ≤25–45%, moderate 40–60%, high 60–90%. Cutting reps per set at the same absolute load is named as a valid lever. The authors say "there is a clear absence of high-quality experimental research" behind these figures. A practical recommendations paper, not a trial. [Bell et al. 2025, *Strength Cond J*](https://doras.dcu.ie/31501/1/a_practical_approach_to_deloading__recommendations.203(2).pdf)
- `[literature]` In practice, 78.9% of athletes cut weekly sets and 52.8% cut reps per set. 83.7% also cut the load on multi-joint lifts. Deloads came every 5.6 ± 2.3 weeks. Cross-sectional survey, n = 246. It describes practice, not efficacy. [Rogerson, Bell et al. 2024, *Sports Med Open*](https://shura.shu.ac.uk/33446/1/s40798-024-00691-y.pdf)
- `[literature]` A week of complete rest gave the same hypertrophy as continuous training but smaller strength gains. It tested stopping entirely rather than a reduced dose, so it argues against too large a cut and says nothing about 0.7 itself. RCT, resistance-trained adults, n = 39. [Coleman et al. 2024, *PeerJ*](https://peerj.com/articles/16777/)
- `[literature]` Deload weeks of one session a week with 2 sets per exercise, against twice a week with 6–8 sets, gave the same muscle-thickness and 10RM gains as continuous training. Randomised within-subject design, untrained young men, n = 19, 8 weeks. [*Sci Rep* 2026](https://www.nature.com/articles/s41598-026-40612-5)
- `[practitioner consensus]` A deload reduces volume. Held by Galpin and Israetel, who differ on how much and on intensity.
- `[single-practitioner position]` Deload at week 6 to "70 percent volume and intensity", cutting both. Galpin only ([podcast clip](https://podclips.com/ct/andy-galpin-recommends-taking-a-week-off-training-at-the-end-of-every-quarter)).
- `[single-practitioner position]` "Cut all of your volume in half", expressed as sets (10 → 5). Israetel only ([secondary report](https://fitnessvolt.com/exercise-scientist-de-load-overtraining/)).

#### Where they split
**(a) Hold the load or drop it.** The taper literature says hold intensity and cut volume, but it comes from peaking for a test, not from recovery deloads. Most athletes drop both (84% lower the load on compound lifts), and so does Galpin. The Delphi allows either, provided volume falls. Holding the load is the better-supported side for keeping strength, but it is not what most athletes do. Tekiō keeps `type: 'reps'`, which holds the load.

**(b) How big a cut.** Galpin's 30% and Israetel's 50% both sit inside the 25–50% band that Travis 2020 and Bell 2025 ("low to moderate recovery need") support. The real choice is between a fixed factor, which fits a planned deload, and one scaled to measured fatigue (Bell's tiers, 0.4–0.75). Only the second needs a readiness input.

**(c) Cut reps per set or cut sets.** Both levers are endorsed. Lifters cut sets more often (79% against 53%). No study compares the two.

#### Caveats
- **Population mismatch.** None of the trials tested a reps-per-set cut at the same load. The evidence supports the direction (cut volume, keep the load) better than it supports the exact factor.
- **Lever artifact 1.** Tekiō's muscle read counts logged *sets*. A reps-only deload leaves the set count unchanged, so the deload week counts as full stimulus in that read. A cut in sets would not have this blind spot.
- **Lever artifact 2.** Rounding means low-rep work barely deloads. 5 reps → 4 is a 20% cut, 2 → 1 is 50%, and 1 → 1 is no cut at all. Heavy strength sets get the smallest reduction.
- **What would move this number.** A controlled trial comparing reduced-volume deload doses or levers in trained lifters, of which none exists. Or a decision to measure deload volume in sets.

#### Source comment
`0.7 — ~30% volume cut, load held: low end of the 25–50% strength-taper/deload range (Travis 2020; Bell 2025); the dose itself is untested by any trial`

## Acceptance

- [x] A `## Grounding` section here carries the scout's verdict and provenance tags
  for all three rows, with citations verified before pasting — against the publisher pages, since NCBI
  eutils was unreachable (see the note at the top of Grounding).
- [x] Source comments on all three constants in
  `src/constants/app.ts` point back here.
- [x] Inventory §5's `(no brief)` column names this file, and the rows carry a real
  state instead of `unknown`.
- [x] If a value changes, the DB defaults change in the same commit and are verified
  by query. *No value changed, so neither did the defaults.*
