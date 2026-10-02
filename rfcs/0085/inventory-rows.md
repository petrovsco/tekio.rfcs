# RFC 0085 — reference edits that land with the code

The inventory and the design system state what the app on develop does. These
edits describe the three bands as built on the working branch (Proposal,
part 2), so they go into those two files in the same change that brings the
code onto develop, never before. If part 1 changes the inputs or the lines
first, rewrite them to match.

Prepared 2026-10-02. Line numbers in the *Where* column are the branch's;
re-check them when the code lands. *n* is the next free decisions-ledger number
at that time (it was 46 when these were written). Links below resolve from
this file; in the inventory, `../0085-push-gate-own-baseline.md` reads
`rfcs/0085-push-gate-own-baseline.md`.

## grounding-inventory.md

**Row 4.12** replaces the `PUSH_THRESHOLD = 33` row:

| 4.12 | `READINESS_BANDS = { low: 33, moderate: 66 }` | app.ts:108 (`src/constants/app.ts`), applied at fusedRead.ts:488-491 (`src/lib/fusedRead.ts`) | Readiness reads in three bands since (the landing date): 0–33 holds, 34–66 steadies (row 4.18), 67–100 pushes. Until then one line at 33 held everything below it and pushed everything from 33 up, and that line had replaced the old card's 80 / 50 green–amber–red bands. **This is the app's answer to "am I recovered enough to push today?"** — and Hold means modify, not rest (D7). On this blend a night at baseline HRV needs a sleep score of 83 to push (D*n*) | named | **convention** | [0085 §Grounding](../0085-push-gate-own-baseline.md#grounding) — WHOOP's thirds, unvalidated; every trial cut its tiers on HRV against the person's own baseline (D8), never on a composite |

**Row 4.18**, new, after row 4.17:

| 4.18 | *(none)* | HomeTab.tsx:46 (`src/components/tabs/home/HomeTab.tsx`) | `STEADY_NOTE`, the instruction a moderate band gives the day: "Lighter today: no intervals or max efforts." The plan, lighter, never rest and never a different session, as in the middle tier of both three-tier trials. No percentage, because each trial's 25% was its chosen step, not a tested dose (D*n+1*) | named | instruction **grounded**, trigger **convention** (row 4.12) | [0085 §Grounding](../0085-push-gate-own-baseline.md#grounding) |

**Decisions ledger**, two new rows after the last one:

| D*n* | **The push gate reads readiness in three fixed bands, 33 / 66** — Low holds, Moderate steadies, OK pushes. WHOOP's thirds taken whole: a convention, on the vendor side of the split, where every trial cut its tiers on HRV against the person's own baseline; a spliced pair (40 / 60, 33 / 50) is a position nobody holds. On Tekiō's blend the lines are mostly sleep-score lines: a night at baseline HRV needs a sleep score of 83 to push, and with HRV a full SD down a sleep score of 67 still reads Moderate. Peter's decision; whether the lines stay after the grounding is open in 0085 (2026-10-02) | [WHOOP recovery](https://www.whoop.com/us/en/thelocker/how-does-whoop-recovery-work-101/) (convention); [Doherty 2025](https://www.degruyterbrill.com/document/doi/10.1515/teb-2025-0001/html?lang=en); [DeBlauw 2021](https://pmc.ncbi.nlm.nih.gov/articles/PMC8705715/); [Nuuttila 2022](https://pubmed.ncbi.nlm.nih.gov/35975912/) | [0085 §Grounding](../0085-push-gate-own-baseline.md#grounding) |
| D*n+1* | **A Steady day is the plan, lighter: no intervals or max efforts.** It borrows the middle tier of both three-tier trials (the planned session with reps and load cut, or with volume cut and the intervals dropped), never rest and never a different session, and shows no percentage because each trial's 25% was its chosen step. One recorded departure: Tekiō's score is one-sided, so HRV above the normal range moves the day toward Push, where both trials reduced it (2026-10-02) | [DeBlauw 2021](https://pmc.ncbi.nlm.nih.gov/articles/PMC8705715/); [Nuuttila 2022](https://pubmed.ncbi.nlm.nih.gov/35975912/) | [0085 §Grounding](../0085-push-gate-own-baseline.md#grounding) |

**Row D8** ends, before its closing pipe, with: *The one line at 33 became two
bands, 33 / 66, on (the landing date) — D*n*.*

**A dated note** after the latest one at the top:

**Updated 2026-10-02 by [0085](../0085-push-gate-own-baseline.md#grounding)**:
row 4.12 is now `READINESS_BANDS = { low: 33, moderate: 66 }`, still
`convention` (WHOOP's thirds, unvalidated — D*n*), and the value 33 moved from
push to hold. Row 4.18 is new: the instruction a moderate band gives the day,
`grounded` as the trials' middle tier and triggered by row 4.12's convention
(D*n+1*).

## design-system.md §11

The PLACEHOLDER list drops the push threshold:

Every number that claims physiological meaning and has not passed
`/ground` is marked PLACEHOLDER on the boards and in code comments —
currently the cycle target (60 sets), the recovery window (2 days), the
per-quality staleness windows, and the blood-donation windows. The rule is:
the mark stays visible until the number is grounded. The grounding work
itself is tracked in the roadmap (018), not here.
