# Grounding — 0085 readiness inputs

Reference only: this file states what the evidence *is*. It holds the verbatim
`## Grounding` block the science-scout run for part 1 of
[RFC 0085](../rfcs/done/0085-push-gate-own-baseline.md) returned on 2026-10-04: the
candidate readiness inputs ranked from the most evidence down. The bands' own
block (part 2) stays in the RFC. What the ranking changes, and which inputs
were chosen, is recorded in the RFC and in the
[grounding inventory](../grounding-inventory.md). This file does not move when
the RFC retires. Pending work never lives here; it goes to the RFC.

**Read before quoting a figure.** Only one source was opened in this run
(Dial 2025). The lines marked *not read this run* rest on titles alone: their
findings and n are unverified. The ranking's order rests on the sources that
were read here or in the 0010 and 0085 blocks.

## Grounding

**Claim:** This is a ranking, not one number. It orders the inputs that Tekiō's daily systemic readiness verdict (push / lighter / hold) should rest on, for a trained adult who lifts and does interval plus zone-2 cardio. It drives what `systemicReadiness()` in `src/lib/fusedRead.ts` reads and how it weights them. Today that is mean(device sleep score, HRV score = 50 + 50 × z, 7-day overnight HRV against the person's own 60-day baseline), gated by `PUSH_THRESHOLD = 33`. It also decides which input a user without a wearable can type.
**Searched:** 2026-10-04 · **Verdict:** partially supported. Baseline-relative HRV is the only input that trials have used to prescribe training. The 50/50 sleep-score + HRV blend is **convention only**: no study validates it, or any composite.
**Ranking:**

| Rank | Input | Evidence tier · verdict | What it needs (route reliability) | Typable without a wearable | Baseline needed |
|---|---|---|---|---|---|
| 1 | HRV (LnRMSSD), 7-day rolling vs own baseline. Two routes: overnight, or a 1-min reading on waking | Tiers 1–2: meta-analyses plus RCTs that prescribed training from it. **Partially supported**: performance as good as fixed plans with fewer hard days, not better | A chest strap or a 1-min phone-camera reading on waking (both validated against ECG). Or an overnight wearable: a ring is closest to ECG, a Garmin wrist watch is weaker (CCC 0.87, MAPE ~10.5%) | **Yes**, if measured with a phone-camera app or a strap and the number is typed | **Yes.** 7-day rolling mean vs a ≥14-day baseline (trials used 10 d to 4 wk; Tekiō uses 60 d). No verdict until ~14 days of data. A single day is too noisy to act on |
| 2 | Self-reported wellness: fatigue, soreness, sleep quality, stress, mood (Hooper-style, 1–7 per item) | Tier 1 on the link to training load: tracks load better than objective markers (Saw 2016). Tier 2 only as one marker inside a multi-marker trial rule (Nuuttila 2022). **Partially supported**: no RCT prescribed training from wellness alone | A questionnaire of about 30 s. Nothing to validate against a gold standard; the risk is reporting bias | **Yes**, natively | Preferred: read as deviation from own norm. Nuuttila used a fixed cut (> 5 of 7) |
| 3 | Resting / morning HR (overnight from a device, or counted on waking) | Tier 1 reviews: changes with overreaching are small and inconsistent in direction. **Weak on its own**; a corroborating marker only | A device measures overnight resting HR well (CCC 0.86–0.98, MAPE ≤ 3%). Hand-count reliability: no evidence found | **Yes** (hand count or phone) | **Yes**, own baseline. A few bpm of drift is inside daily noise |
| 4 | Sleep | Tier 1 that acute sleep loss lowers performance (meta-analysis). No trial prescribed training from sleep. **Device sleep score: convention** (unvalidated vendor composite). **Device duration: acceptable.** Self-reported duration: biased | A wrist or ring device detects sleep well, wake poorly, stages moderately at best. The score's algorithm is undisclosed. Typed duration tends to overestimate (direction from general literature, not verified this run) | **Yes** for duration and quality (Tekiō already writes these). **No** for a score | Duration: an absolute deficit (a short night) matters more than a deviation. No trial defines the window |
| 5 | Countermovement jump height (average of several jumps) | Tier 1 meta-analysis: sensitive to neuromuscular fatigue. Not trialled as a daily gate. **Partially supported for the lifting side** | A jump mat or a validated phone app, plus a warm-up and protocol each morning. A high daily burden | Yes, if measured and typed | **Yes** |
| 6 | Orthostatic HR/HRV test (supine → standing) | Tier 6: a methods review only. **Not supported** as a daily gate | A chest strap or phone, ~4–5 min | Yes, if measured | Yes |
| 7 | Vendor composite readiness score (Garmin / WHOOP / Oura) | **Convention only.** 14 scores from 10 makers, none with a disclosed algorithm or validation | The vendor's device | No | Inputs partly baseline-relative; the bands on top are fixed |
| — | Skin temperature, respiratory rate, grip strength | Not searched this run (skin temperature and respiratory rate) or not found (grip strength) as training-readiness evidence. **No usable evidence** | — | — | — |

**Combinations:** no located study compares a combined input against a single one head to head. Not a blend of HRV + wellness, and not today's sleep-score + HRV blend.
- The one indirect hint: Nuuttila 2022's multi-marker rule (HRV + HR–speed index + soreness/fatigue) beat its predefined plan. HRV-only rules pooled in meta-analyses did not significantly beat theirs.
- That is a comparison across trials, not evidence that combining works.
- **Default to use:** HRV (rank 1) as the primary input. When there is no wearable, the default is a typed wellness score (rank 2), marked less certain, and the better input it names is a 1-min HRV reading by phone camera on waking.
- The sleep score should not keep a 50% weight, the strongest evidence-weighted position the app holds today. It is the least-evidenced input currently in the number.

### Evidence
- `[literature]` **Garmin is the weakest HRV route tested.** Nocturnal HRV against ECG:
  - Oura Gen 4 CCC 0.99 (MAPE 6.0%), Oura Gen 3 0.97 (7.2%), WHOOP 4.0 0.94 (8.2%), Garmin Fenix 6 0.87 (10.5%), Polar Grit X Pro 0.82 (16.3%).
  - Nocturnal resting HR CCC 0.86–0.98, MAPE 1.7–3.0%.
  - Design: validation study, 13 healthy adults (6 F), 536 nights, ECG reference. Abstract read via DOAJ — [Dial et al. 2025, Physiol Rep](https://physoc.onlinelibrary.wiley.com/doi/10.14814/phy2.70527) ([abstract](https://doaj.org/article/ea55c9e4369549a0a56e576a581224a4))
- `[literature]` HRV-guided training gives performance equal to fixed plans, and fewer high-intensity days. Meta-analyses (Düking 2021; Manresa-Rocamora 2021; Medellín Ruiz 2020, 8 RCTs, n = 190) and RCTs (Vesterinen 2016; DeBlauw 2021; Kiviniemi 2007). Every decision rule is baseline-relative (Buchheit 2014). Carried from the 0010 and 0085 blocks, not re-fetched — [0085 #grounding](../rfcs/done/0085-push-gate-own-baseline.md#grounding)
- `[literature]` **Both HRV routes have prescribed training in trials.** A 1-min smartphone-camera reading on waking (DeBlauw 2021, RCT, n = 55) and nocturnal HRV from a wearable (Nuuttila 2022, RCT, n = 40/30). No trial compares the two routes. Carried from 0085.
- `[literature]` Morning and nocturnal HR/HRV were compared head to head during intensified training in recreational runners. **Title and abstract not read this run** (fetch refused), so the finding and n are unverified — [Nuuttila et al. 2024, Sports Med Open](https://pubmed.ncbi.nlm.nih.gov/39503915/)
- `[literature]` A smartphone-camera HRV reading was validated against a Polar H7 strap and ECG for LnRMSSD, and agreement is usually reported as near-perfect. Validation study in athletes. **Abstract not read this run**, so n and the agreement statistics are unverified — [Plews et al. 2017, IJSPP](https://journals.humankinetics.com/view/journals/ijspp/12/10/article-p1324.xml)
- `[literature]` **Wellness tracks load better than the objective markers.** Self-reported wellness reflected acute and chronic training load with better sensitivity and consistency than objective measures, HRV and resting HR included. Systematic review, athletes. Carried from 0010 — [Saw et al. 2016, BJSM](https://pubmed.ncbi.nlm.nih.gov/26423706/)
- `[literature]` **Wellness has entered a prescription only alongside HRV.** Soreness/fatigue > 5 of 7 was one of three markers in a decrease / maintain / increase rule that beat predefined training on 10-km time (−6.2% vs −2.9%). Matched-pair RCT, n = 40/30. Carried from 0085 — [Nuuttila 2022](https://pubmed.ncbi.nlm.nih.gov/35975912/)
- `[literature]` **Resting HR is a poor tool for detecting overreaching.** The changes are small and inconsistent in direction. Systematic review. **Abstract not read this run**: the conclusion is what the title asks and is usually cited as a "no", unverified here — [Bosquet et al. 2008, Br J Sports Med](https://pubmed.ncbi.nlm.nih.gov/18308872/)
- `[literature]` HR, HRV and HR-recovery responses to training were meta-analysed against training status, including functional overreaching. The direction of change depends on the training state, which is why resting HR alone is hard to read. Systematic review + meta-analysis. **Not read this run**; findings and n unverified — [Bellenger et al. 2016, Sports Med](https://link.springer.com/article/10.1007/s40279-016-0484-2)
- `[literature]` HRV feeds 86% of 14 vendor composites, resting HR 79%, sleep 71%. None is validated. Carried from 0085 — [Doherty et al. 2025](https://www.degruyterbrill.com/document/doi/10.1515/teb-2025-0001/html?lang=en)
- `[literature]` Acute sleep loss (deprivation, and restriction that cuts the end of the night) lowers physical performance. This is the mechanistic case that a short night matters. Systematic review + meta-analysis. **Not read this run**; effect size and n unverified — [Craven et al. 2022, Sports Med](https://link.springer.com/article/10.1007/s40279-022-01706-y). An endurance-specific meta-analysis also exists — [Lopes et al. 2023, Eur J Sport Sci](https://onlinelibrary.wiley.com/doi/10.1080/17461391.2022.2155583) (not read).
- `[literature]` Six commercial wrist devices and Garmin / WHOOP / Fitbit were each compared with polysomnography. Wrist devices are usually reported as good at detecting sleep, poor at detecting wake, and at most moderate at staging. **Neither read this run**; figures unverified — [Schyvens et al. 2025, Sleep Advances](https://academic.oup.com/sleepadvances/article/6/2/zpaf021/8090472); [JMIR mHealth 2024 systematic review](https://mhealth.jmir.org/2024/1/e52192). No study validates a vendor *sleep score* as a training signal.
- `[literature]` Average CMJ height, rather than the highest jump, is the more sensitive marker of neuromuscular fatigue and supercompensation. Meta-analysis. **Not read this run**; n unverified — [Claudino et al. 2017, J Sci Med Sport](https://www.sciencedirect.com/science/article/abs/pii/S1440244016301542)
- `[literature]` The orthostatic HR/HRV test is reviewed as a monitoring method. Methods review, tier 6-equivalent. Not read — [Eur J Appl Physiol 2024](https://pubmed.ncbi.nlm.nih.gov/39259398/)
- `[literature]` A meta-analysis of readiness markers across physical, physiological and perceptual categories exists. **Not read**; findings unknown, and it may bear directly on this ranking — [SJSP, systematic review + meta-analysis](https://sjsp.aearedo.es/index.php/sjsp/article/view/athlete-readiness-physical-physiological-perceptual-markers)
- `[literature]` A trial prescribed training from HRV + HR + well-being combined, in experienced cyclists. **Unread for the second run running** (429 / CAPTCHA). It is the one located combination trial — [Sci Rep 2025](https://www.nature.com/articles/s41598-025-13540-z)
- `[practitioner consensus]` Read HRV as a multi-day trend against your own norm, and pair it with resting HR and how you feel. Do not let one morning gate the day. Held by Galpin and Huberman (0010), and Attia, who uses HRV for awareness and has never skipped a session on it (0085).
- `[single-practitioner position]` For lifting, readiness is read in the session from the first working sets (reps in reserve, bar speed), not from a morning score. Israetel only, and still unverified on record (carried from 0010/0085). Galpin and Attia use morning trends.

### Conventions (not evidence)
- **The 50/50 sleep-score + HRV weighting** is a convention from RFC 0010. No study weights these two, or any pair.
- **Vendor sleep scores** (Garmin and others) are undisclosed composites. Using one as half of readiness imports another vendor's convention into Tekiō's number.
- **A hand-counted morning pulse** as a readiness input: no reliability or validity study was located. It would be a convention for "resting HR when no device exists".

### Where they split
**Objective HRV vs subjective wellness.** These are two different kinds of evidence. HRV has the trials that prescribed training from it. Wellness has the stronger review showing it tracks load (Saw 2016), but no trial prescribed from it alone. The forced choice for Tekiō:
- **(a) HRV primary, wellness as the no-wearable fallback.** Follows the prescription trials.
- **(b) Wellness as a co-equal input alongside HRV.** Follows Saw, and Nuuttila's rule that combined both.
- Do not invent a 70/30 blend. Nobody tested one.

**Morning gate vs trend (Galpin, Attia vs the daily rule).** The trials acted on a 7-day rolling HRV, but Tekiō's sleep half is a single night. That is the most volatile input carrying half the weight. The trend-first practitioners and the trials agree against it.

**Lifting.** The morning-gate evidence is endurance-heavy, and the resistance trials were null. CMJ (fatigue-sensitive) and Israetel's in-session autoregulation are the alternatives for the Weights side. Whether the systemic verdict should even govern lifting is unresolved.

### Caveats
- **Population mismatch:**
  - The trials used recreational runners and functional-training adults (~24–37 y).
  - The device validation used 13 healthy adults.
  - No study covers a trained adult combining heavy lifting with intervals and zone 2.
  - Sex and age effects on HRV baselines make the own-baseline method more important, not less.
- **Device route:**
  - Garmin is Tekiō's current source and was the weakest HRV route in the one validation located (CCC 0.87). A baseline-relative z-score cancels a constant device bias, but not device noise (reasoning, not tested).
  - A typed 1-min phone-camera reading on waking is a trialled route (DeBlauw) and may be at least as good as Garmin's overnight value.
- **Unread sources:** the fetch budget failed. PubMed's permission prompt timed out, PMC served a CAPTCHA, Europe PMC returned 429 with "do not fetch again", and two URLs were too long for the proxy. These lines therefore rest on titles only and their findings and n are unverified: Bosquet 2008, Bellenger 2016, Nuuttila 2024, Plews 2017, Craven 2022, Schyvens 2025, JMIR 2024, Claudino 2017, the SJSP readiness meta-analysis, and the Sci Rep 2025 cyclist trial. Only Dial 2025 was read this run. Re-verify the unread ones before quoting a figure from them.
- **What would move this ranking:**
  - The SJSP readiness meta-analysis or the Sci Rep 2025 combination trial, once read. Either could lift wellness or a combination above HRV alone.
  - Any head-to-head of morning vs nocturnal HRV for prescription.
  - Any validation of a sleep score against training outcomes.

### Source comment
`// readiness inputs — HRV (7-d rolling vs own baseline) is the only trialled prescription input (Vesterinen 2016, DeBlauw 2021, Nuuttila 2022); typed wellness is the evidenced fallback (Saw 2016); resting HR weak alone (Bosquet 2008); device sleep score + 50/50 blend is convention (Doherty 2025), see tekio.rfcs/grounding/0085-readiness-inputs.md#grounding`
