---
title: Shoulder external rotation in the catalogue
authors: [Peter Petrov]
created: 2026-10-12
last_updated: 2026-10-12
status: in progress
status_note: Pattern, four catalogue lifts and the patterns row shipped in tekio v2.2.17 on develop; waiting on the first logged set to check the Rotator Cuff fills on Home.
label: feature
---

# RFC 0105: Shoulder external rotation in the catalogue

## Summary

Add a 32nd movement pattern, shoulder external rotation, with the Rotator Cuff
as its prime mover, and four catalogue lifts that use it (cable, band,
side-lying dumbbell and machine external rotation). It is also offered in the
movement question under Pull.

## Motivation

The Rotator Cuff is one of the twenty muscles Home's body map reads, and no
lift in the catalogue could fill it. Its only stimulus links were level 3 on
the rear-delt fly pattern and level 2 on the face-pull override, so a user
whose map showed the cuff short had no exercise to log that answered it. The
read named a gap the app could not close, which is a number that cannot be
acted on.

## Goals

- A logged set of any of the four lifts counts one weighted set for the
  Rotator Cuff on Home and Adaptations.
- The pattern's links are grounded and the verdict is recorded.

## Non-Goals

- **Internal rotation.** The scout found it is its own pattern (subscapularis
  prime mover, lats and pec as helpers). Nothing asked for it; it waits for a
  need, through §4.
- **Splitting the Rotator Cuff leaf** into its external rotators and the
  subscapularis (split 4 below).
- **Standing dumbbell external rotation with the elbow at the side.** The load
  pulls straight down and barely loads the rotation, so it is deliberately not
  a member.
- Face pull's override (D54) is unchanged.

## Proposal

- `src/constants/movementPatterns.ts`: `shoulderExternalRotation` with
  Rotator Cuff 1, Posterior Deltoid 3, Upper Back / Traps 3, Rhomboids 3,
  verdict *partially supported*, carrying the source comment below.
- `src/constants/exerciseCatalogue.ts`: Cable External Rotation, Band External
  Rotation, Side-Lying Dumbbell External Rotation, Machine External Rotation.
- `src/constants/movementQuestion.ts`: "External rotation" under Pull.
- Migration `20261012041557_shoulder_external_rotation_pattern.sql`: one
  `movement_patterns` row with the new key, additive only, so a lift is tagged
  with its pattern when first logged.

## Rationale

Rotator Cuff at level 2 (half credit, reading the thin growth data as
activation work) was the alternative. It would leave the cuff permanently
short with no lift able to fill it, so level 1 was taken (D59). Crediting the
posterior deltoid at 2 was rejected: with the elbow at the side it runs at
about half the infraspinatus's activity, a stabiliser's share.

## Grounding

**Claim:** A "shoulder external rotation" pattern (cable, band, side-lying dumbbell or machine ER, with the elbow at the side or at 90° abduction). Its proposed link set is Rotator Cuff 1, Posterior Deltoid 2 or 3, and Rhomboids and Upper Back / Traps 3, so one weighted set counts as 1 set of Rotator Cuff stimulus (`LEVEL_WEIGHT` 1 / 0.5 / 0). These links feed Home's body map, the "what's missing" ranking and the 48 h recovering flag. Today no exercise links the Rotator Cuff above level 3 except the face-pull override at 2.
**Searched:** 2026-10-12 · **Verdict:** partially supported
**Number to use:** Rotator Cuff 1, Posterior Deltoid 3, Upper Back / Traps 3, Rhomboids 3. Default: exactly this set, with internal rotation as its own pattern. The cuff is the only muscle whose main job is external rotation, and EMG ranks infraspinatus and teres minor highest in side-lying ER. Loaded ER has produced measurable cuff growth, but only in two small trials in untrained adults. Nothing measured the posterior deltoid or the mid-back growing from ER, so crediting them would hide a gap.

| Pattern | Typical members | Links | Verdict |
|---|---|---|---|
| Shoulder external rotation | cable ER, band ER, side-lying DB ER, machine ER; elbow at side or at 90° abduction | Rotator Cuff 1, Posterior Deltoid 3, Upper Back / Traps 3, Rhomboids 3 | partially supported |
| Shoulder internal rotation (separate pattern) | cable / band IR, elbow at side or at 90° | Rotator Cuff 1, Chest 3, Lats 3 | convention (EMG only) |

#### Evidence
- `[literature]` Infraspinatus and teres minor peaked in side-lying ER (62 % and 67 % MVIC), the highest of the ER exercises tested. The top posterior-deltoid exercise was a different one: prone horizontal abduction at 100° with full ER (88 % MVIC). This supports the cuff as the prime mover of ER, and the posterior deltoid as prime mover of horizontal abduction rather than of ER. EMG, 10 healthy adults — [Reinold et al. 2004, JOSPT](https://pubmed.ncbi.nlm.nih.gov/15296366/). These figures are carried from the 0074 U run. I could not reopen the abstract this run (PubMed showed a CAPTCHA), so I cite no posterior-deltoid value for the ER exercises themselves.
- `[literature]` In a side-lying "wiper" ER exercise, the infraspinatus ran at about 27 % and the posterior deltoid at about 12 %. Adding a horizontal-adduction force lowered the posterior deltoid to about 7.5 % and left the infraspinatus unchanged. In elbow-at-side ER the posterior deltoid is a minor contributor, which supports level 3. Within-subject surface EMG, 28 healthy adults — [Kim et al. 2017, Physical Therapy Korea](https://www.koreascience.or.kr/article/JAKO201734158607220.page)
- `[literature]` 8 weeks of shoulder ER training, 3×10, 3 times a week. The low-intensity slow-tempo group grew infraspinatus CSA by +7.3 % (significant). **The normal-intensity, normal-speed group did not change significantly.** ER strength did not differ between groups. Randomised two-arm trial, no untrained control, 16 healthy men (8 per arm) — [Matsumura et al. 2023, Physical Therapy Research](https://www.jstage.jst.go.jp/article/ptr/26/2/26_E10227/_article/-char/en)
- `[literature]` Side-lying dumbbell ER plus scaption, 4 sets (30/15/15/15), twice a week for 8 weeks at about 20 % of MVIC. In the arm trained with blood-flow restriction, infraspinatus CSA rose +11.7 % (p = 0.009) and supraspinatus +9.8 % (p = 0.004). In the arm trained without it, infraspinatus rose +3.0 % (p = 0.088) and supraspinatus +6.2 % (p = 0.093). Neither arm's ER strength change was significant (+8.5 % and +10.0 %), and no between-arm difference was significant. Case series (evidence level 4), 14 untrained asymptomatic adults — [Safford et al. 2024, IJSPT](https://ijspt.scholasticahq.com/article/118143-effects-of-low-load-blood-flow-restriction-training-on-rotator-cuff-strength-and-hypertrophy-case-series)
- `[literature]` Isokinetic internal- plus external-rotation training, concentric or eccentric, raised rotator strength about 11 % against a 2 % loss in controls (P < 0.0004). Internal and external rotation were reported together, not separately. Randomised three-arm trial (concentric, eccentric, control), 30 elite tennis players. Am J Sports Med 22(4):513–517, 1994; the record I read gave no authors — [database record](https://lida.sport-iat.de/ta/Record/4062593?lng=en)
- `[literature]` In standing internal rotation at 0°, at 90° abduction and in the zero position, the rotator cuff (subscapularis included) was most active at 90° abduction. The latissimus was markedly more active in the zero position. Internal rotation recruits a different set of helpers (lats, and pec major, which was recorded) from ER. Descriptive EMG study with surface and fine-wire electrodes, 30 healthy adults; abstract only — [Alizadehkhaiyat et al. 2015, IJSPT](https://hira.hope.ac.uk/id/eprint/650/)
- `[literature]` I found no meta-analysis or systematic review of rotator-cuff *hypertrophy* from loaded ER in healthy trained adults. I also found no trial measuring posterior-deltoid, trapezius or rhomboid growth from ER work. A systematic review of the Thrower's Ten programme exists ([PMC12633846](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12633846/)). It was located but not read, so I cite it for nothing.
- `[single-practitioner position]` ER (and the face pull) framed as cuff and shoulder-health work. This is Cavaliere's coaching framing (Athlean-X; see the 0074 U run). He is a coach, so this can inform *whether to include* the exercise, not its level. Israetel, Galpin and the rest of the roster were silent on rotator-cuff growth in what I searched. No roster researcher's position was located.

#### Where they split
1. **Is loaded ER growth stimulus, or just rehab and activation?** The two growth datasets point the same way, but neither is clean. In Matsumura 2023 the cuff grew, but only in the *slow, low-load* arm; the normal-load arm did not. Safford 2024 is a case series in which only the BFR arm crossed significance. Neither found a significant ER strength gain. The 1994 tennis RCT shows strength gains but pools IR with ER and is isokinetic. Honestly read: ER can grow the cuff, and the effect is small and has not been shown in trained lifters. Tekiō has to choose:
   - **Rotator Cuff 1 (default).** ER is the only exercise that loads the cuff as the main force generator, and a weighted set of it is the most direct cuff stimulus that exists. Calling it level 2 would leave the cuff permanently "short" with no exercise able to fill it.
   - **Rotator Cuff 2.** This treats ER as half-credit activation work, given the thin growth data.

   Level 1 keeps the read actionable. Level 2 would be a number that can never be acted on. Do not invent a 0.75.
2. **Posterior Deltoid: 2 or 3.** The posterior deltoid is an anatomical external rotator, and its share rises when the arm is abducted. With the elbow at the side it ran at about 12 % against about 27 % for the infraspinatus (Kim 2017). That is a stabiliser-level share, so **default 3** for the whole pattern. If a "90°-abducted / prone ER" variant is ever logged often, PD 2 would be an override resting on convention: I could not read the EMG values for that position this run. Do not put PD 2 on the pattern.
3. **Rhomboids and Upper Back / Traps.** They hold the scapula against the ER torque, and no study measured them doing more than that. Keep both at **3** to document the claim, or drop the links. Either way they are worth 0. 2 has no support.
4. **Internal rotation is a separate pattern.** The rule in 0074 is to split when the link set differs, and here it does: IR's helpers are lats and pec (Alizadehkhaiyat 2015), not the posterior deltoid. Both patterns land Rotator Cuff 1 on one leaf, which raises a choice for Tekiō. The single Rotator Cuff leaf would read "fed" from IR alone while the infraspinatus and teres minor had no work at all. Pressing and pulling already load the subscapularis as an internal rotator, but no data measure how much, so nothing is credited for it. If that matters, it is an argument for splitting the leaf, not for down-levelling either pattern.

#### Caveats
- Population mismatch: every growth or strength number comes from untrained or rehab-oriented young adults (n = 14–16, 8 weeks) or elite tennis players (n = 30, isokinetic). Trained lifters already load the cuff isometrically in every press and row, so their growth from added ER is probably smaller than these figures. The cuff is a small muscle, and a set of 10–20 reps near failure at light load is the usual dose. The level says *which* muscle the set counts for, not how much it grows.
- Exercise mechanics: **standing dumbbell ER with the elbow at the side** puts the weight's pull straight down, so it creates almost no ER torque, and it does not belong in this pattern. Cable, band and machine ER, and side-lying or prone dumbbell ER, all load the rotation. Name catalogue entries so the standing-dumbbell version cannot inherit Rotator Cuff 1.
- Fetch limits: PubMed and PMC returned CAPTCHAs, and Europe PMC refused one request with HTTP 429. The Reinold 2004 values are carried from 0074. Matsumura 2023 and Alizadehkhaiyat 2015 were read at abstract level only.
- What would move this number:
  - An ER-only training trial in trained adults measuring infraspinatus CSA would settle split 1: it would confirm level 1, or push the cuff to 2.
  - EMG or growth data for the posterior deltoid in 90°-abducted ER would decide whether that variant earns a PD 2 override.
  - Splitting the Rotator Cuff leaf into an external-rotator part and the subscapularis would resolve split 4.

#### Source comment
`// shoulder external rotation: Rotator Cuff 1, Posterior Deltoid 3, Traps 3, Rhomboids 3 — cuff is prime mover by EMG (Reinold 2004, Kim 2017); loaded-ER cuff growth small and untrained-only (Matsumura 2023, Safford 2024); IR is its own pattern, see tekio.rfcs/rfcs/0105-shoulder-external-rotation.md#grounding`

## Acceptance

- [x] The pattern, the four lifts and the movement-question choice ship, with the catalogue tests green (tekio v2.2.17)
- [x] The `movement_patterns` row is live (migration 20261012041557)
- [x] D59 is in the grounding inventory's decisions ledger
- [ ] A first logged set of an external-rotation lift creates its row linked Rotator Cuff 1, and the cuff fills on Home

## Unresolved questions

None.
