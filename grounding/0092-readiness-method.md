# Grounding — 0092 check-in lines and the two notes

Reference only: this file states what the evidence *is*. It holds the
`## Grounding` blocks the science-scout run for
[RFC 0092](../rfcs/done/0092-readiness-method-in-profile.md) returned on
2026-10-04: the check-in's band lines, the resting heart rate note and the
short-night note. What was chosen from them is recorded in the RFC. Pending
work never lives here; it goes to the RFC.

**Read before quoting a figure.** This run used web search only and opened no
page. Every search returned titles and links, with no snippets. Every
`[literature]` line rests on a title, plus the scout's recall where it says
so. No n or effect size here was checked in this run. The blocks are good
enough for choosing defaults; re-verify before quoting a figure.

## Grounding — check-in calculator

**Claim:** Five items (energy/fatigue, soreness, sleep quality, stress, mood), each 1–5 with 5 the good end, summed to 5–25, read against the person's own rolling baseline, drive Push / Steady / Hold when there is no wearable.
**Searched:** 2026-10-04 · **Verdict:** partially supported. The form is accepted. The decision lines and the window are **convention only**, by analogy to how the HRV trials read their data; no wellness trial validated them.
**Number to use:**
- Steady when today's total is below own mean − 1 SD **and** at least 2 points below the mean.
- Hold when it is below own mean − 2 SD **and** at least 4 points below the mean.
- Baseline: 28-day rolling window (range 14–60); no verdict before 14 entries.
- The point floors stop a very consistent responder (SD near 1) from dropping a band on a one-point dip.

### Evidence
- `[literature]` The 5-item 1–5 form (fatigue, sleep quality, soreness, stress, mood, summed) is McLean's. Observational, professional rugby league. Recalled, not read; n unverified — [McLean et al. 2010, IJSPP](https://www.researchgate.net/publication/46403560_Neuromuscular_Endocrine_and_Perceptual_Fatigue_Responses_During_Different_Length_Between-Match_Microcycles_in_Professional_Rugby_League_Players)
- `[literature]` The Hooper index is the 1–7 original (sleep, stress, fatigue, soreness). Observational, elite swimmers. Title only — [Hooper et al. 1995, MSSE](https://pubmed.ncbi.nlm.nih.gov/7898325/)
- `[literature]` A similar questionnaire tracked the weekly training and match cycle. Observational, elite Australian football. Title only — [Gastin et al. 2013, JSCR](https://www.researchgate.net/publication/233948546_Perceptions_of_Wellness_to_Monitor_Adaptive_Responses_to_Training_and_Competition_in_Elite_Australian_Football)
- `[literature]` A systematic review of single-item wellbeing measures against training load in team sport exists. Title only — [Duignan et al. 2020](https://pmc.ncbi.nlm.nih.gov/articles/PMC7534939/)
- `[literature]` Tier-1 basis carried from 0085: wellness tracks load better than objective markers (Saw 2016); it entered a prescription only alongside HRV, as a fixed cut of soreness/fatigue > 5 of 7 (Nuuttila 2022) — [0085 block](0085-readiness-inputs.md)
- `[literature]` One located trial prescribed training from HRV plus a self-reported stress-tolerance measure, in recreational runners. Title only; rule and lines unverified. **The source most worth opening** — [PubMed 36940300](https://pubmed.ncbi.nlm.nih.gov/36940300/)
- `[literature]` The HRV trials' smallest-worthwhile-change band (mean ± 0.5 SD) applies to a 7-day mean, not one day (carried from 0085). A single daily total is noisier, so its line is wider.
- `[practitioner consensus]` Read how you feel against your own norm, as a trend, alongside HRV. Carried from 0085.

### Conventions (not evidence)
- The −1 / −2 SD lines, the 2- and 4-point floors, the 28-day window and 14 entries before a verdict.
- The 1–5 scale rather than Hooper's 1–7: faster to tap, coarser SD.
- An optional item trigger (soreness or fatigue at 1–2 of 5 → Steady), rescaled from Nuuttila. Never averaged into the total.

### Where they split
Own-baseline z-lines on the total (the HRV method, the doctrine's own-baseline rule) against Nuuttila's fixed item cut (trialled, but on 1–7, only with HRV, only in runners). Proposed: z-lines on the total.

### Caveats
- Team-sport and endurance cohorts in season; none covers an adult who lifts and does intervals. Reporting bias and habitual "3"s compress the SD over months.
- Would move it: reading PubMed 36940300 or the SJSP readiness meta-analysis named in 0085.

### Source comment
`// WELLNESS_STEADY_Z = -1, WELLNESS_HOLD_Z = -2 (floors 2/4 pts), 28-d baseline, ≥14 entries — McLean 2010 5×1–5 form; lines are convention by analogy to the HRV trials' own-baseline reading, see tekio.rfcs/grounding/0092-readiness-method.md`

## Grounding — resting heart rate note

**Claim:** A note beside the verdict, never moving it, when last night's resting HR is above the person's own baseline.
**Searched:** 2026-10-04 · **Verdict:** convention only. Resting HR is weak alone (0085), which is why it is only a note; no located study validates a threshold for "meaningfully up".
**Number to use:** last night ≥ own 30-day mean + 1 SD **and** ≥ 5 bpm above it (range +3 to +7 bpm).

### Evidence
- `[literature]` Resting HR is a poor marker of overreaching alone (Bosquet 2008; Bellenger 2016), carried from 0085, still unread — [0085 block](0085-readiness-inputs.md)
- `[literature]` Resting HR varies widely between people and less within one; it moves with sleep, age, sex, BMI and season. Retrospective cohort, large n per the title; figures unverified — [Quer et al. 2020, PLOS One](https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0227709)
- `[literature]` HR measures are read as individual trends against the person's smallest worthwhile change. Narrative review. Title only — [Buchheit 2014, Front Physiol](https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2014.00073/pdf)
- `[literature]` Device overnight resting HR agrees well with ECG (Dial 2025, read in 0085).
- `[practitioner consensus]` Pair resting HR with HRV and how you feel; never gate on it alone. Carried from 0085.

### Conventions (not evidence)
- +1 SD, the 5 bpm floor, the 30-day window. The common "+5 bpm" heuristic turned up only outside the literature.
- A typed morning resting HR is acceptable as a convention, taken the same way each day (on waking, lying down) and with **its own baseline**: an overnight device minimum runs below a waking count (reasoning, not tested).

### Caveats
- The night after a hard session can raise resting HR meaning "you trained", not "you're unwell": the note reads as information, not alarm.

### Source comment
`// RHR_NOTE: last night ≥ own 30-d mean + 1 SD and ≥ +5 bpm; note only, never moves verdict — RHR weak alone (Bosquet 2008), own-baseline (Quer 2020); threshold is convention, see tekio.rfcs/grounding/0092-readiness-method.md`

## Grounding — short-night note

**Claim:** A note beside the verdict when last night's sleep was shorter than a set number of hours.
**Searched:** 2026-10-04 · **Verdict:** partially supported. Acute sleep loss impairing next-day performance is tier 1; the exact cut-off for physical performance is not pinned.
**Number to use:** under 6 h of device-measured sleep (range 5–7 h).

### Evidence
- `[literature]` Acute sleep loss lowers physical performance; an early wake matters more than a late bedtime (recalled). Systematic review + meta-analysis. Direction carried from 0085; details unverified — [Craven et al. 2022, Sports Med](https://link.springer.com/content/pdf/10.1007/s40279-022-01706-y.pdf)
- `[literature]` 6-h nights for 14 days accumulate cognitive deficits, and subjects underrate them (recalled). Laboratory dose-response trial. Title confirmed, n not — [Van Dongen et al. 2003, Sleep](https://www.semanticscholar.org/paper/The-cumulative-cost-of-additional-wakefulness:-on-Dongen-Maislin/1859697f2f65b93c91e54e985e61f14e8a185c0b)
- `[literature]` Adults should sleep at least 7 h, for health outcomes, not next-day performance. Consensus panel — [Watson et al. 2015, AASM/SRS](https://aasm.org/resources/pdf/pressroom/adult-sleep-duration-consensus.pdf)
- `[literature]` Self-reported duration overestimates measured sleep. Cohort, self-report vs actigraphy. Title only; size of bias unverified — [Lauderdale et al. 2008, Epidemiology](https://www.researchgate.net/publication/23316998_Self-Reported_and_Measured_Sleep_Duration)

### Conventions (not evidence)
- 6 h as the line; an absolute threshold rather than a deficit against own usual (0085 judged the absolute deficit matters more).
- Typed duration, if accepted: mark the note less certain or raise its line; the size is a guess until Lauderdale is read.

### Where they split
Absolute vs relative: 6 h misses a usual 8-h sleeper at 6.5 h, and fires most mornings for a usual 6-h sleeper (a note that always shows is decoration, doctrine §1). The alternative, "under 6 h or ≥ 1.5 h below own 14-day median", is pure convention. Proposed: absolute 6 h; add the relative clause only if the note proves blind in use.

### Caveats
- Restriction studies are mostly young men in labs on short protocols; lifting effects are less consistent than endurance ones (recalled).
- Would move it: Craven 2022's hours slept in the protocols that showed impairment.

### Source comment
`// SHORT_NIGHT_H = 6 — acute sleep loss impairs performance (Craven 2022), 6 h/night accrues deficits (Van Dongen 2003), 7 h health floor (AASM 2015); exact cut is convention, device duration only, see tekio.rfcs/grounding/0092-readiness-method.md`
