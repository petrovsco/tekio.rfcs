---
title: Readiness — inputs ranked by evidence, then three bands on top
authors: [Peter Petrov]
created: 2026-10-02
last_updated: 2026-10-04
status: done
status_note: "Landed on develop 2026-10-04 as tekio v2.1.26 (e92cbb6): readiness is overnight HRV alone, in three bands on the distance from the own baseline. The method choice and the rungs without a wearable continue in 0092."
label: feature
---

# RFC 0085: Readiness — inputs ranked by evidence, then three bands on top

## Progress log

- **2026-10-02** — opened from Peter's review of the landing prototype
  ([0084](../0084-public-landing-site.md)), where he doubted that anyone at a
  readiness of 33 is fit to push. First proposal: replace the line with the
  baseline-relative HRV rule (D8).
- **2026-10-02** — Peter decided instead: keep the readiness number and read it
  in three bands, 33 / 66, Low / Moderate / OK, Hold / a middle verdict / Push.
  Steady is the working name for the middle verdict until he picks Steady, Go
  or Train.
- **2026-10-02** — `/ground` ran on the bands: **convention only** for both
  lines, and the middle band's instruction is the trials' middle tier. The
  block is below; the inventory and ledger rows it produced were rewritten for
  the chosen tiers and landed with the code on 2026-10-04. It
  found the lines sit high on this blend: a night at baseline HRV needs a sleep
  score of 83 to push. The app change is built with 33 / 66 and tested;
  whether the lines stay is Peter's call (Unresolved question 3).
- **2026-10-02** — Peter widened it. Readiness should rest on the
  best-evidenced inputs, not on a blend nobody validated: if HRV is the most
  proven, use it. Research the candidate metrics (HRV, morning or resting heart
  rate, and any others), rank them from the most evidence down, and choose a
  few. One is the default and the user can change it. A person without a
  wearable gets an input they can type, marked as less certain and pointing to
  better ones. Garmin is one source among several, and integrations are
  separate work.
- **2026-10-02** — Parked for its own task, so the landing thread can return to
  the site. The bands stay on the working branch (Proposal, part 2) until the
  inputs are chosen, and the two choices put to Peter that day (the lines, and
  Steady, Go or Train) wait with them.
- **2026-10-04** — Part 1 started. `/ground` ranked the candidate inputs
  ([grounding/0085-readiness-inputs.md](../../grounding/0085-readiness-inputs.md)):
  baseline-relative HRV first, the only input trials prescribed training from;
  typed wellness second, the evidenced input without a wearable; resting heart
  rate weak alone; the device sleep score and the 50/50 blend convention only.
  Only one source was opened this run, so the lines marked unread are titles,
  not findings. Put to Peter: which inputs, and the default.
- **2026-10-04** — Peter asked for a chain: use the most efficient input a
  person has, and offer the easiest one when they have nothing. Proposed as a
  three-rung ladder (Proposal, part 1), waiting on his word.
- **2026-10-04** — Peter chose "HRV first": the ladder stands, HRV is the
  default, the device sleep score leaves the number, and the typed
  how-you-feel check-in is the rung for people without a wearable. Next: the
  band lines on the HRV score (Unresolved question 3).
- **2026-10-04** — Peter asked for a separate calculation for each input.
  Added to Proposal part 1, with an acceptance box per calculator.
- **2026-10-04** — Peter split the work: the method choice in Profile,
  connecting a source, and the other rungs go to
  [0092](0092-readiness-method-in-profile.md). This RFC finishes the overnight
  HRV rung and the bands.
- **2026-10-04** — Peter chose the trial tiers. Built: the calculator
  interface, the overnight HRV calculator with the three fixes, HRV alone,
  the three bands; tests green, seen in the browser on invented data. The
  inventory rows landed with it. Waits on landing on develop.
- **2026-10-04** — Peter: the numbers confuse, the words are enough, and one
  tap should show where the state came from and where to change it. The card
  shows the band word only; the readiness sheet explains it and links to
  Profile (v2.1.23), cut to two lines and the link (v2.1.24): the band and method, then HRV this week against the normal in ms (v2.1.25).
- **2026-10-04** — Peter: the normal should be a range, not one value. The
  sheet shows it as the baseline ± the moderate line (0.5 SD), in ms: below
  the range reads Steady or Hold, inside or above it Push (v2.1.26).
- **2026-10-04** — Peter: "go with it." Landed on develop as v2.1.26
  (tekio e92cbb6); staging deployed that commit. 0092 unblocked.

## Summary

Two decisions, in order. First, what readiness rests on: the candidate inputs
ranked by evidence (HRV against the person's own baseline came first), as a
ladder of methods with one calculator each. This RFC builds the first rung,
overnight HRV, and the rest is [0092](0092-readiness-method-in-profile.md).
Second, three bands read on that HRV distance, the tiers the trials used:

| HRV week vs own baseline | Band | Verdict |
|---|---|---|
| more than 1 SD under | Low | **Hold** — walk or mobility only |
| 0.5 to 1 SD under | Moderate | **Steady** — the plan, lighter: no intervals or max efforts |
| within 0.5 SD under, or above | OK | **Push** — close the gaps |

Before this RFC, readiness was the mean of last night's sleep score and a
baseline-relative HRV score, and one line at 33 held the day. The card prints
the band beside its 0–100 number (50 = the person's own normal).

## Motivation

- **The blend is unexamined.** Readiness averages last night's device sleep
  score with a baseline-relative HRV score, 50/50 (row 4.11). 0010 chose that
  as a convention, and no study validates a composite readiness score
  (Doherty 2025, in the block below). Peter's rule is to prefer the most
  evidenced method.
- **Without a wearable there is no readiness.** It reads only synced data: a
  typed night writes duration and quality, never the sleep score, HRV or
  resting heart rate (`src/lib/db/recovery.ts`). Resting heart rate is already
  synced and read nowhere.
- **One line is too blunt.** A 34 and a 95 get the same instruction, and a 33
  is told to push. Peter doubted anyone at 33 would feel fit to do anything.
- **Under the bands, Push needs both inputs.** The number is the mean of the
  two, so 67 needs a sum of 133: an HRV score of 0 caps even a perfect night at
  50, which is Steady, and a sleep score of 0 does the same to the best HRV.
  With one line at 33, either input can carry the other over it.
- **The app marks the line as unfinished.** Home's hold banner prints
  `(PLACEHOLDER)` after "the push threshold" (`HomeTab.tsx`). The mark goes
  once the number has passed `/ground` (`design-system.md` §11).

## Goals

- Readiness rests on the best-evidenced inputs a person can supply, ranked by
  `/ground`, with one default and a choice the user can change.
- A person without a wearable can type an input, and the app says it is less
  certain and which better input they could add.
- Home's verdict has three instructions, set by the band, and the readiness
  card names the band.
- The bands carry a `## Grounding` block, and inventory row 4.12 says so once
  the code lands.

## Non-Goals

- **Device integrations.** Which devices feed an input (Garmin sync today) is
  separate work. This RFC decides which metrics count, not how they arrive.
- **The local recovery flag** (row 4.15) and **donation suppression** (row
  4.16). An acute donation still holds the day, whatever the band.
- **The landing page.** It already shows readiness as a state, not a number
  ([0084](../0084-public-landing-site.md), round four), and takes these three
  bands when its real site is built.

## Proposal

### 1. Readiness inputs (ranked and chosen; this RFC builds the first rung)

- A `/ground` run ranks the candidate inputs from the most evidence down: HRV
  against the person's own baseline (the method every trial used, D8), morning
  or resting heart rate, sleep, self-reported wellness, and any others the
  search turns up. For each it says what the input needs (a wearable, a phone
  camera, a hand count, a questionnaire) and how reliable that route is.
- **Ranked 2026-10-04**, the block is in
  [grounding/0085-readiness-inputs.md](../../grounding/0085-readiness-inputs.md):
  1 HRV against own baseline (overnight, or a 1-min phone-camera reading on
  waking) · 2 self-reported wellness · 3 resting heart rate · 4 sleep (device
  duration acceptable, device score convention) · 5 jump height · 6 orthostatic
  test · 7 vendor readiness scores (convention). No study shows a combination
  beats one input.
- **Proposed 2026-10-04, from Peter's question:** the inputs form a ladder,
  and each person reads from the highest rung they can supply.
  1. Overnight HRV synced from a wearable: no daily effort, the most evidence.
  2. A 1-min HRV reading on waking (phone camera or chest strap), typed: the
     same trialled method, one minute a day.
  3. A how-you-feel check-in (fatigue, soreness, stress, mood; four or five
     taps): anyone can give it, marked less certain.

  Each rung reads against the person's own baseline and needs about 14 days
  of its own data before it gives a verdict. So the rung is chosen per person,
  by what they supply, never mixed day to day. A missed night falls back to a
  lower rung only when that rung has its own baseline, otherwise the day has
  no verdict, as today. The app always names the rung above. Resting heart
  rate and a short night are not rungs: they can show as notes beside the
  verdict and never move it. This answers Unresolved question 4: the default
  follows what a person can measure, which is not a matter of taste (P4).
- **The HRV rung's calculation, proposed with three fixes** (explained to Peter
  2026-10-04): distance = (7-night mean − own baseline mean) / own baseline SD,
  as `systemicReadiness()` does today, plus: read the log of HRV (LnRMSSD, as
  every trial did); no verdict before 14 nights (today 7); and keep the current
  week out of the baseline, so a bad week does not lower its own bar.
- **One calculation per input** (Peter, 2026-10-04: "every other is a
  different thing"). Each rung has its own calculator, and every calculator
  returns the same thing, a band (Push, Steady or Hold) or nothing, so the
  verdict never knows which input made it and a new input is a new calculator.
  1. *Overnight HRV:* the calculation above.
  2. *Morning HRV, typed:* the same math on its own baseline. Morning and
     overnight readings are different numbers and are never mixed; changing
     route starts a new 14-night baseline.
  3. *How-you-feel check-in:* four or five items (fatigue, soreness, sleep
     quality, stress, mood), each 1–5, summed, and read against the person's
     own usual total. Its band lines need their own `/ground` run (Nuuttila
     used a fixed cut, > 5 of 7; Saw 2016 favours the own norm) and are labelled
     convention until then.
  4. *Notes, not inputs:* resting heart rate against its own baseline, and a
     short night under a set number of hours, each with a small calculation of
     its own. They print a line beside the verdict and never move the band.
- **Split 2026-10-04 (Peter):** this RFC builds the calculator interface and
  the first rung, overnight HRV, which the app already syncs, with the three
  fixes, and drops the sleep score from the number. The typed morning HRV, the
  check-in, the two notes, the method choice in Profile and connecting a
  source move to [0092](0092-readiness-method-in-profile.md).
- The bands in part 2 are then checked against the HRV score (Unresolved
  question 3).

### 2. Three bands, on the HRV distance (built 2026-10-04)

The first build (2026-10-02, tekio branch `claude/project-thread-g3kirn`,
0556b9b) drew 33 / 66 on the sleep + HRV blend and is superseded. Peter chose
the trial tiers on 2026-10-04 (the grounding's option (b)). Built on tekio
branch `claude/readiness-inputs-b9o2ks`, v2.1.22 to v2.1.26:

- `HRV_BAND_Z = { moderate: -0.5, low: -1 }` in `src/constants/app.ts`
  replaces `PUSH_THRESHOLD = 33`: z ≥ −0.5 ok (Push), −1 ≤ z < −0.5 moderate
  (Steady), z < −1 low (Hold). One-sided: HRV above baseline never lowers the
  band, the recorded departure below.
- `src/lib/fusedRead.ts`: `ReadinessReading` is what every calculator returns
  (method, band, 0–100 score, z, the recent value and the normal range in ms); `overnightHrvReading()` is the first
  calculator (ln HRV, 7-night mean against the 60 nights before that week,
  14 baseline nights before a reading); `systemicReadiness()` reads it and
  no longer blends the sleep score; `fusedVerdict()` takes the band.
- Home (`HomeTab.tsx`): the card prints LOW, MODERATE or OK and no number
  (Peter, 2026-10-04: the digits confused; the 0–100 score is convention).
  Tapping the card opens the readiness sheet (`RecoverySheet.tsx`), which leads
  with where the band came from: the method, how far this week sits from the
  person's own normal, the band rule, and a link to Profile, where
  [0092](0092-readiness-method-in-profile.md) adds the method choice.
  A Steady day leads with "Steady." and its first fact is `STEADY_NOTE`:
  *Lighter today: no intervals or max efforts.* Only a Low day inverts the card
  and shows the banner, which lost `(PLACEHOLDER)`. Sleep still shows on the
  card as a fact and no longer moves the number.
- Tests: the band edges, log space, the one-sided top, the current week kept
  out of the baseline, a single bad night, 14 nights, no fresh HRV.
- The `/ground` skill's gated table names `HRV_BAND_Z`, the calculator's
  constants and `STEADY_NOTE`.
- Same change, in this repo: inventory rows 4.11 (retired), 4.12, 4.17 and
  4.18, decisions D46 and D47, D8 marked done, design-system §11's
  PLACEHOLDER list.

Seen on invented data at 412 × 900, all three bands, no console errors:
[Push](/mnt/project-files/readiness/0085-home-push.png),
[Steady](/mnt/project-files/readiness/0085-home-steady.png),
[Hold](/mnt/project-files/readiness/0085-home-hold.png) (project files, not
in this repo).

## Rationale

- **The baseline-relative rule (D8)** was this RFC's first proposal: hold when
  the 7-day HRV mean falls more than 0.5 SD under the athlete's own baseline.
  It is the rule the trials used, but it has two levels and leaves the sleep
  score out. Peter chose to keep the number the app already shows and give it
  a middle. Its three-tier form is the grounding's option (b): tiers on the HRV
  score (25 and up as planned, 1–24 lighter, 0 easy), which retires both
  constants and needs a rule of its own for sleep.
- **Fixed bands on a composite are a vendor convention,** the same side of the
  split the line at 33 was on. 33 / 66 are one vendor's thirds taken
  whole; a spliced pair such as 40 / 60 or 33 / 50 is a position nobody holds.
  The bands at least make Push need both inputs, which one line did not
  (Motivation).
- **On this blend the lines are mostly sleep-score lines.** The HRV half sits
  at 50 on a baseline night, so a night at baseline HRV needs a sleep score of
  83 to push and 16 or less to hold. With HRV a full SD down, any sleep score
  of 67 or more reads Moderate, where DeBlauw's trial prescribed active
  recovery. Garmin's lines taken whole (Hold at 24 and under, Push from 50) are
  the alternative that lets a baseline-HRV night push, as the HRV-only trials
  did.
- **The middle band borrows the trials' middle tier**: the planned
  session, lighter, never rest and never a different session. Home shows no
  percentage, because each trial's 25% was its chosen step, not a tested dose.
- **One-sided, a recorded departure.** Both three-tier trials read HRV above
  the normal range as a reason to reduce; Tekiō's score rewards it, so a high
  HRV moves the day toward Push. It stays, because the lines rest on the vendor
  convention and only the middle tier's instruction is borrowed from the
  trials.
- **The middle verdict's name.** Steady, Go and Train were offered; Steady is
  the recommendation because effort is the only thing that changes from Push.

## Doctrine checklist (§4)

1. **Read sharpened:** Home's readiness card and its verdict, the third of the
   exit condition's three questions.
2. **Stops:** one instruction for every readiness from 33 to 100.
3. **Input or destination:** input. The gate changes; no surface is added.
4. **Honest shape:** one systemic number, read in bands (P5). It never splits
   per adaptation.
5. **Physiological number:** yes. The bands claim when a body is ready to push,
   and the middle band prescribes an effort, so `/ground` ran before anything
   was committed.

## Grounding

Part 1, the inputs ranked: [grounding/0085-readiness-inputs.md](../../grounding/0085-readiness-inputs.md#grounding)
(2026-10-04). Part 2, the bands, follows.

**Claim:** Two cut points on Tekiō's 0–100 systemic readiness composite. The composite is the mean of last night's device sleep score and an HRV score of 50 + 50 × z, where z is the 7-day rolling overnight HRV against the person's own 60-day baseline in SD units, clamped to 0–100. The bands:
- **≤ 33 Hold:** walk or mobility only.
- **34–66 Moderate:** train the plan at moderate effort, no maximal or high-intensity work.
- **≥ 67 Push:** train hard as planned.

This drives `PUSH_THRESHOLD` in `src/constants/app.ts` (one line at 33 becomes two band boundaries, 33 and 66), applied in `fusedVerdict()` in `src/lib/fusedRead.ts`. It sets the day's instruction on Home. The Moderate band takes high-intensity work off the day, so it changes what gets trained.

**Searched:** 2026-10-02 · **Verdict:** convention only, for 33 and 66 as lines on a 0–100 composite. The three-tier structure and a "planned session, lighter" middle step are partially supported, but only as tiers on an HRV deviation from the person's own baseline (two RCTs), never on a composite.

**Number to use:**
- **Hold line:** 25–40, default 33 (carried from the 0010 block).
- **Push line:** 50–70, default 66.

Both defaults are one vendor's scheme (WHOOP's thirds) taken whole, rather than spliced from vendors that disagree. 66 is also the highest vendor "go" line that a baseline-HRV day can still reach on this composite: it needs a sleep score ≥ 83, while Oura's 70 needs ≥ 89 and Garmin's 75 needs ≥ 99. The low end, 50, is where Garmin's "good to go" band starts. It is the line that lets a baseline-HRV day train as planned, which is what the HRV-only trials did.

### Evidence
- `[literature]` **A three-tier rule has been trialled, on the person's own baseline.**
  - 7-day rolling LnRMSSD within ±0.5 SD of a 14-day baseline: the session ran as planned.
  - 0.5–1 SD away, in either direction: the scheduled workout ran with reps and load each cut by 25%.
  - Beyond 1 SD: 20 min of low-intensity active recovery (walking, light stretching).
  - Results: strength (CrossFit total +11.6% vs +12.2%), VO₂max and body composition improved alike, on 12.9 vs 26.5 high-intensity days.
  - Design: RCT, recreationally active adults (mixed sex, ~24 y), high-intensity functional training, 6 wk, 1-min smartphone-camera morning HRV, n = 55 (26 vs 29) — [DeBlauw et al. 2021, J Funct Morphol Kinesiol](https://pmc.ncbi.nlm.nih.gov/articles/PMC8705715/)
- `[literature]` **A second three-tier rule: decrease, maintain or increase, decided twice a week.**
  - Markers: nocturnal HRV against a 4-week rolling mean ± 0.5 SD (values above *or* below counted as negative), the HR–running-speed index, and perceived soreness/fatigue (> 5 of 7).
  - Decrease: −25% volume and, in the interval block, no HIT sessions.
  - Maintain: no change.
  - Increase: +5% volume or more HIT.
  - Result: 10-km time −6.2 ± 2.8% vs −2.9 ± 2.4% for predefined training (P = 0.002).
  - Design: matched-pair RCT, recreational runners (20 M / 20 F, 37 ± 7 y), 15 wk, n = 40 randomised / 30 analysed — [Nuuttila et al. 2022, Med Sci Sports Exerc](https://pubmed.ncbi.nlm.nih.gov/35975912/)
- `[literature]` **The trials that founded the method are two-tier, and some are one-sided.**
  - Kiviniemi 2007: if HRV rose or held, the day was a high-intensity run. If it fell below the 10-day mean − 1 SD, or fell 2 days running, the day was a low-intensity run or rest. RCT, 26 moderately fit men, 4 wk — [Kiviniemi et al. 2007, Eur J Appl Physiol](https://link.springer.com/article/10.1007/s00421-007-0552-2)
  - Vesterinen 2016 likewise trained easy outside the normal range (verified in the 0010 block) — [PubMed](https://pubmed.ncbi.nlm.nih.gov/26909534/)
  - A 2025 trial kept two tiers: HIT at or above the smallest worthwhile change (SWC), low intensity below it. Two randomised HRV-guided arms plus a convenience control, 70 sedentary adults — [Casanova-Lizón et al. 2025, Front Sports Act Living](https://www.frontiersin.org/journals/sports-and-active-living/articles/10.3389/fspor.2025.1578478/full)
  - No located trial compares three tiers against two.
- `[literature]` HRV-guided endurance training improves performance and aerobic markers, but not significantly more than predefined training. Systematic review + meta-analysis, 8 RCTs, n = 190 — [Medellín Ruiz et al. 2020, Appl Sci](https://www.mdpi.com/2076-3417/10/23/8532). This agrees with Düking 2021 and Manresa-Rocamora 2021 in the 0010 block.
- `[literature]` **Lifting: HRV-guided resistance training has used a two-level timing rule, not intensity tiers.**
  - A session ran only when RMSSD was at least the baseline mean − 1 SD; otherwise it waited.
  - Against fixed 48-h spacing there was no group difference in muscle cross-sectional area, 1RM, torque or function. RCT, 21 untrained older women, 7 wk — [Bittencourt et al. 2024, Front Physiol](https://www.frontiersin.org/journals/physiology/articles/10.3389/fphys.2024.1472702/full)
  - It reports the same null for the trial it extends, in young untrained men — [de Oliveira et al. 2019, Eur J Sport Sci](https://pubmed.ncbi.nlm.nih.gov/30702985/) (abstract not read, n not verified).
  - A 2024 narrative review says HRV's associations with strength adaptations "have not been studied extensively" — [Addleman et al. 2024, J Funct Morphol Kinesiol](https://www.mdpi.com/2411-5142/9/2/93)
- `[literature]` **No vendor composite score is shown to be valid.**
  - The evaluation covered 14 composite scores from 10 manufacturers, including WHOOP, Oura and Garmin.
  - Inputs: HRV feeds 86% of them, resting HR 79%, activity 71%, sleep 71%.
  - None disclosed its algorithm, few offered empirical validation, and time windows and weightings differ.
  - Design: systematic evaluation of manufacturer documentation — [Doherty et al. 2025, Transl Exerc Biomed](https://www.degruyterbrill.com/document/doi/10.1515/teb-2025-0001/html?lang=en)
- `[practitioner consensus]` A low morning reading does not by itself cancel training; HRV is read as a trend against the person's own norm. Neither practitioner uses fixed colour bands in anything located. Held by Galpin and Attia.
  - Galpin: "go based on what is normal for you". Watch deviations that last 3+ days, and consider backing off only after about 7 consecutive days ([Huberman Lab guest-series notes](https://podcastnotes.org/huberman-lab/guest-series-dr-andy-galpin-maximize-recovery-to-achieve-fitness-performance-goals-huberman-lab/)).
  - Attia: "I have never once not exercised as a result of what that said" ([Drive #305 transcript](https://podscripts.co/podcasts/the-peter-attia-drive/305-heart-rate-variability-how-to-measure-interpret-and-utilize-hrv-for-training-and-health-optimization-joel-jamieson)).
- `[single-practitioner position]` For lifting, readiness is read in the session from the first working sets (reps in reserve, bar performance), not from a morning score. Israetel only. This is carried from the 0010 run; no on-record source was found this run, so treat it as unverified. Galpin tracks HRV trends; Attia uses HRV for awareness, not as a gate.

### Conventions (not evidence)
- **WHOOP:** red 1–33 ("Rest is likely what your body needs"), yellow 34–66 ("ready to take on moderate amounts of strain"), green 67–99 ("primed to perform") — [WHOOP](https://www.whoop.com/us/en/thelocker/how-does-whoop-recovery-work-101/). No study is cited for the edges.
  - WHOOP's own outcome report: runners who adjusted workouts to their recovery were 32.4% less likely to be injured, with similar 5-km gains (2,772 completers, 8 wk) — [Project PR](https://www.whoop.com/us/en/thelocker/project-pr-runner-study/).
  - It is vendor-run, not peer-reviewed and not described as randomised, and it does not say what yellow prescribed.
- **Garmin Training Readiness:** poor 1–24 ("Let your body recover"), low 25–49 ("Time to slow down"), moderate 50–74 ("Good to go"), high 75–94, prime 95–100 — [owner's manual](https://www8.garmin.com/manuals/webhelp/GUID-0221611A-992D-495E-8DED-1DD448F7A066/EN-US/GUID-C21BE0C8-A08E-4DA1-B6C6-2E0E2DDDB372.html). No validation is cited.
- **Oura Readiness:** pay attention 0–59, fair 60–69, good 70–84, optimal 85–100 — [Oura](https://support.ouraring.com/hc/en-us/articles/360025589793-Readiness-Score).
  - Its low-score advice is "limit intense physical activity, but don't stay completely inactive either".
  - Its "balance" inputs compare a 14-day weighted average with the person's ~2-month average. So Oura's inputs are baseline-relative and the bands on top are fixed.

### Where they split
**Fixed bands on a composite vs tiers on the person's own deviation.** Every located trial, two-tier or three, cut on an SD-scaled deviation from the person's own baseline. The vendors cut a 0–100 composite at fixed points, and they disagree with each other:
- **Where the middle sits:** WHOOP's yellow is 34–66, Garmin's moderate is 50–74, Oura's fair is 60–69.
- **What the middle means:** Garmin's says "good to go", where WHOOP's means moderate strain.

Even Oura's inputs are baseline-relative, so the fork is where the cut is drawn, not whether the baseline matters. The 2026-10-02 decision (fixed 33/66 on the composite) is the vendor-convention side of this split, specifically WHOOP's thirds. It forces a choice between two options. Do not split the difference into something like 40/60, which nobody holds.
- **(a) Keep 33/66 as a labelled convention.** On this composite both lines are then mostly sleep-score lines.
  - At baseline HRV, Push needs sleep ≥ 83.
  - Below about z = −0.35, which is still inside every trial's normal band, Push cannot be reached at all.
  - So on days every trial would have trained hard, Tekiō says Moderate.
- **(b) Draw the tiers on the HRV score itself, as DeBlauw did.** Score ≥ 25 trains as planned, 1–24 reduces, and 0 (HRV ≥ 1 SD down) is an easy day. Sleep then gets its own rule (0085 unresolved question 1).

**The middle band's instruction.** In the trials, the middle step was always "the planned session, lighter". It was never rest and never a different session:
- **Lifting:** reps and load each cut by 25% (DeBlauw).
- **Endurance:** volume cut by 25% and the intervals dropped (Nuuttila's decrease tier).

"No maximal or high-intensity work" agrees with both trials on intensity. But neither trial kept full volume in that tier. The 25% was each trial's chosen step, not the result of testing different doses.

Hold's walk-or-mobility matches DeBlauw's bottom tier. Easy aerobic work is also within what the two-tier trials prescribed for their low tier.

For lifting, the direct evidence for any morning gate is thin: one mixed-modality trial with three tiers, and two resistance trials with a train-or-wait rule and null results. That gap is where Israetel's in-session autoregulation stands as the alternative.

**Two-sided vs one-sided.** Both three-tier trials counted HRV above the normal range as a reason to reduce. Kiviniemi 2007 and Casanova-Lizón 2025 did not. Tekiō's score rewards high HRV: z from +0.5 to +1 lifts the composite toward Push. Borrowing the three-tier evidence means borrowing a two-sided rule, or saying in the brief that Tekiō departs from it.

**Daily gate vs multi-day trend (Galpin, Attia).** Tekiō's HRV half is already a 7-day mean, but its sleep half is a single night. So the band can flip on one bad night. Galpin's position argues against acting on that, and no trial tested it.

### Caveats
- **Population mismatch:**
  - DeBlauw: recreationally active ~24-year-olds in functional-training classes, measuring 1-min morning HRV against a 14-day baseline.
  - Nuuttila: recreational runners, 37 ± 7 y.
  - The resistance trials: untrained young men and untrained older women.
  - None studied a trained adult combining heavy lifting with interval and zone-2 work. None used a device sleep score as an input, and none used a 60-day baseline.
- **Score mismatch:** 33/66 are WHOOP's thirds of WHOOP's own score. Tekiō's composite is built differently, and its HRV half is centred on 50 by design, so the thirds do not carry WHOOP's meaning across. Worked from the formula:
  - At baseline HRV, Hold needs a sleep score ≤ 16.
  - With HRV ≥ 1 SD down (HRV score 0), Hold needs sleep ≤ 66. Any sleep score of 67 or more turns DeBlauw's active-recovery day into Moderate.
  - WHOOP's red band includes 33, but today's code holds only below 33. The value 33 itself therefore moves from push to hold, and the edge tests should pin that.
- **What would move this number:**
  - A trial testing three tiers against two, or a composite against HRV alone.
  - Any published validation of a composite's bands against training outcomes (Doherty 2025 found none).
  - The share of days in each band over the user's own last 60 days. If Moderate is the most common day, Push becomes rare, and Push is the only band that allows the weekly VO₂max session (inventory row 1.8). The line should then move toward 50, or onto the HRV score.
  - Choosing option (b), which retires both constants.
- **Not read this run:**
  - The 2025 cyclist trial that prescribed training from HRV, HR and well-being: [Nature](https://www.nature.com/articles/s41598-025-13540-z) returned HTTP 429 and its PMC copy served a CAPTCHA, so its tier structure is unknown.
  - de Oliveira 2019's abstract (403 and 429 errors). It is known only through Bittencourt 2024 and Addleman 2024.
  - Vesterinen 2016 and Javaloyes 2019/2020 were not re-read. Their two-tier rules are carried from 0010 and match [Altini's 2025 summary](https://hrv4training.substack.com/p/week-29-a-brief-history-of-heart).
  - Hickmott 2022, a meta-analysis on autoregulating lifting: the fetch permission timed out, so it is not cited.

### Source comment
`// 33 / 66 — convention only: WHOOP's red/yellow/green edges, unvalidated vendor bands (Doherty 2025); the trialled three-tier rule cuts HRV deviation from own baseline (±0.5 / ±1 SD, DeBlauw 2021), not a composite, see tekio.rfcs/rfcs/0085-push-gate-own-baseline.md#grounding`

## Acceptance

- [x] `/ground` has ranked the candidate readiness inputs, and its block is
      linked here
- [x] Peter has chosen the inputs and the default, recorded here (2026-10-04:
      the three-rung ladder, HRV first)
- [x] A calculator interface returns a band or nothing, and the overnight HRV
      calculator implements it with its own tests: log of HRV, 14 nights
      before a verdict, the current week kept out of the baseline
- [x] The device sleep score no longer moves readiness
- [x] The band lines and the middle verdict's name are confirmed on the chosen
      inputs: the trial tiers on the HRV distance (Peter, 2026-10-04), Steady
- [x] `/ground` ran on the bands, and its block is above
- [x] Its inventory and ledger rows land with the code (rows 4.11, 4.12, 4.17,
      4.18; D46, D47)
- [x] `fusedVerdict()` holds, steadies or pushes by band, tested at the
      edges −0.5 and −1
- [x] Home's card names the band without a number, one tap shows where it
      came from and links to Profile, a Steady day has its own verdict, and the
      hold banner has no `(PLACEHOLDER)`: seen in the browser on invented data,
      all three bands, no console errors
- [x] It lands on develop and the staging app shows it

## Unresolved questions

1. **Sleep's place.** *Answered 2026-10-04:* the device sleep score leaves
   the number. A short night returns only as a note beside the verdict, in
   [0092](0092-readiness-method-in-profile.md).
2. **An HRV override.** Should a 7-day HRV mean more than 0.5 SD under
   baseline hold the day whatever the band (D8 as an override)? Under the bands
   alone it can read Steady, while the trials prescribed easy training there.
   Moot if the trial tiers are chosen in question 3, since they hold beyond
   1 SD down.
3. **Where the lines sit.** *Answered 2026-10-04:* the trial tiers on the HRV
   distance, and the middle verdict stays Steady. The question as it stood: 33 / 66 is Peter's decision, made before the
   grounding showed that a night at baseline HRV needs a sleep score of 83 to
   push. Put to him on 2026-10-02: keep them, take Garmin's lines whole (Hold
   at 24 and under, Push from 50), or move the tiers onto HRV (option (b)). A
   count of how often each band would have come up over the last 60 nights
   would inform it; it needs the live data and has not run. Postponed with
   this RFC: the lines sit on whatever number the inputs make, so they are
   decided after part 1, together with the middle verdict's name (Steady, Go
   or Train).
4. *Moved to [0092](0092-readiness-method-in-profile.md):* the choice in
   Profile and P4, and how much a typed input is worth.
