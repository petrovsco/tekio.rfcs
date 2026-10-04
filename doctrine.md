# Tekiō doctrine

The rules this app is built by. Short on purpose — it is meant to be re-read
every time a feature is proposed, and it is only useful if it can say **no** to
something I want.

Established 2026-08-26. Amend it deliberately; don't drift past it.
Amended 2026-08-29: nine adaptations → seven — Speed and Skill dropped,
Power reclassified as muscle-linked (execution: roadmap 019).
Amended 2026-09-05: Habits deleted a month before its R2 expiry — a deliberate
call, not the calendar's (execution: roadmap 035).
Amended 2026-10-02: Program deleted, to be rebuilt later; the in-app assistant
deleted (execution: RFCs 0087 and 0034).
Amended 2026-10-04: Water deleted (execution: RFC 0089). Admin deleted, to be
rethought later (execution: RFC 0090). Blood donation's ledger row follows its
move to a Home stat tile (RFC 0089).

---

## 1. Purpose

> **Tekiō tells me what's missing.**

Whether my training is balanced across the seven adaptations and the muscles
that serve them, and whether I'm recovered enough to close the gap today.

Everything else is judged against that sentence. Two consequences follow
immediately, and they do most of the work:

- **The read is the product. Capture is overhead.** A logging screen is a cost I
  pay to get an honest answer. Time spent making capture prettier is worth less
  than time spent making the answer clearer or faster to reach.
- **A number I can't act on doesn't get shown.** If seeing it changes nothing
  about what I train or how I recover, it's decoration.

## 2. Principles

**P1 — Just in time, both faces.** The control appears where and when it's
needed (inline on the surface that raised the question), and what isn't needed
now isn't loaded now. The UX face and the performance face are the same rule.

**P2 — Honest reads beat pretty ones.** A visualization must fit the shape of
its data. Muscles are spatial; a body map is honest for them — and the four
muscle-linked qualities (strength, hypertrophy, muscular endurance, power) read
per muscle, because power is the force × velocity a specific muscle group can
produce, not a body-wide trait. VO₂max, anaerobic capacity and cardio-endurance
are whole-body qualities — putting them on a silhouette would be a beautiful
lie. When one picture can't answer two questions, use two reads.

**P3 — Fold before you add.** A new signal is usually an *input to an existing
read*, not a new destination. Blood donation isn't a section; it's a readiness
input. Body weight isn't a section; it's a stat on Home. Ask "which existing
read does this sharpen?" before "where does this live?"

**P4 — Configurability is not a decision.** With one user, "you can hide it" is
not a justification for building something. A feature earns its default-on place
or it doesn't ship.

**P5 — Stimulus and recovery are two dimensions of one read, not two places in
the app.** Sustainable progress needs both sides: stimulus alone injures, recovery
alone adapts nothing. But they are not opposite ends of one axis — more rest is not
less training. Every target has a *state* on two axes. Recovery is therefore never a
destination; it is the second dimension of the muscle and adaptation reads, at two
levels:

- **Systemic** (sleep, sauna, cold, HRV / Garmin readiness, blood
  donation) — one global number. Answers *can I push at all today?*
- **Local** (hours since that muscle was last stimulated, recent volume load) —
  per muscle, computed from logged sets. Answers *what can I train today?*

Never split a systemic number N ways and present it as N per-adaptation facts;
that is one fact wearing a costume (P2).

## 3. Rules with teeth

**R1 — Cap: at most 4 menu sections.**
Currently 3 (Weights, Cardio, Mobility) plus Recovery as a Home-only card. One
slot of headroom. The fifth section does not get added — something trades out
first. The cap is the argument, so individual features don't each get to win
their own.

**R2 — The shelf has an expiry: one cycle (6 weeks), then the code is deleted.**
Shelving = default-off (`show_in_menu` / `show_in_home` false, or dropped from
`DEFAULTS` in `src/lib/db/sectionConfig.ts`). A shelved section carries a
delete-by date in the ledger below. When that date passes and it hasn't been
missed, the component, its tests, and its unused tables go. Git remembers it.
Hidden code still costs bundle weight, test runtime, migrations and reading
load — a shelf without an expiry is just a slower way of keeping everything.

**R3 — Shelving and folding are decisions, not features.** They are executed by
editing this ledger and flipping existing config. Building new machinery to
*manage* the feature set (tier fields, admin panels for section categories) is
forbidden — that is solving feature bloat by adding features.

**R4 — Every roadmap brief answers the checklist in §4** before it becomes code.

## 4. Brief checklist

An RFC in `rfcs/` is not ready until it answers all five:

1. **Which read does this sharpen?** Name the existing surface. If the answer is
   "a new one," justify against R1.
2. **What does it let me stop doing?** Folds, cuts, or replacements it enables.
3. **Is this an input or a destination?** (P3 — default is input.)
4. **What's the honest shape of the data?** (P2 — spatial vs. not, per-session
   vs. rolled-up.)
5. **Does it write a number claiming physiological meaning?** If yes, it needs a
   `## Grounding` section before implementation. Run `/ground`; its Step 0 is
   the canonical trigger spec (including the three exemptions where a number
   moves but no new claim is made) —
   `.claude/skills/ground/SKILL.md`.

## 5. Ledger

Status of every surface, last brought current 2026-10-04. This table is the
shelf; keep it current.

**This ledger records verdicts, not steps.** Three surfaces below are folded
into another read rather than given a menu slot, and still ship there — the work
that carried out the folds is
[rfcs/done/0014-doctrine-ledger-execution.md](rfcs/done/0014-doctrine-ledger-execution.md).
Pending work lives in `rfcs/`, never in this file (house rule
`pending-work-in-roadmap`).

| Surface | Verdict | Note |
|---|---|---|
| Home (Overview) | **Core — read** | The product. Answers "what's missing" without tapping. |
| Adaptations | **Core — read** | The seven qualities (simplified 2026-08-29 — roadmap 019). Its split with Home is deliberate since 2026-09-07 (roadmap 062): Home *answers* what's missing, Adaptations *explains* what to do about it — the per-quality map, the effort spectrum and the rx stay here, and its header sentence is the same line Home prints. |
| Weights | **Core — capture** | Primary stimulus source. |
| Cardio | **Core — capture** | Endurance / VO₂max / anaerobic stimulus. |
| Mobility | **Core — capture** | Recovery-axis input with its own volume model. |
| Program | **Deleted 2026-10-02** | Was Core — plan: the cycle and today's plan. Removed on Peter's call in the 0034 review, to be rebuilt later in a better way ([rfcs/done/0087-remove-program.md](rfcs/done/0087-remove-program.md)). Nothing ran on it, and Home and Adaptations never read it. A rebuilt Program comes back through §4 like any new surface. |
| Recovery | **Core — read, Home-only** | Systemic readiness only (P5). Local recovery fuses into the muscle read rather than living here. Already has no tab — the precedent the folds follow. |
| Sports | **Fold → Cardio** | Already classifies into cardio adaptations; a sport session is a cardio session with a name and a quality rating. UI folds first; the DB merge is its own brief. |
| Water | **Deleted 2026-10-04** | Was Fold → Recovery. Removed on Peter's call ([rfcs/done/0089-remove-water-and-weights-chips.md](rfcs/done/0089-remove-water-and-weights-chips.md)): a capture asked for several times a day that no verdict read. It may return when the app can remind, through §4. |
| Donations | **Fold → Home stat** | Not training, but real: full-blood donation suppresses endurance performance for weeks, and eligibility windows are already tracked. Still a readiness input: inside its acute window it holds the day's verdict. Shown since 2026-10-04 as the BLOOD tile beside Body Weight, no longer on the readiness card ([rfcs/done/0089-remove-water-and-weights-chips.md](rfcs/done/0089-remove-water-and-weights-chips.md)). |
| Body Weight | **Fold → Home stat** | A trend, not a stimulus or readiness signal. Inline logging on Home; FRS needs the number anyway. |
| Habits | **Deleted 2026-09-05** | Shelved 2026-08-26; deleted a month before the R2 date on Peter's call (roadmap 035). A checklist is an adherence tool; the app tells me what's missing, it does not make me do it. Sauna/cold/mobility/sleep are captured directly, so habits was a duplicate capture path. The table drops wait for the release in roadmap 025. |
| Profile | **Exempt** | Infrastructure, not a section. Not counted against R1. |
| Admin | **Deleted 2026-10-04** | Was Exempt, as infrastructure. Removed on Peter's call ([rfcs/done/0090-admin-out-mobility-in.md](rfcs/done/0090-admin-out-mobility-in.md)): an ungated screen any user could reach, which a real user must never see. Admin comes back rebuilt, with a real role gate, through §4. |

**Two conditions attached to the Habits shelf**, and both are met:
`ExerciseMuscleEditor.tsx` moved to Admin rather than being deleted with the
section (roadmap 035; it left with Admin on 2026-10-04, RFC 0090), and
`RECOVERY_WEIGHTS.habits` (0.10) was retired with
the whole constant rather than dropped from it — the readiness number it fed
measured adherence, not recovery. The sequencing and the grounding trap are in
[rfcs/done/0014-doctrine-ledger-execution.md](rfcs/done/0014-doctrine-ledger-execution.md).

Resolved by the same decision: habit-derived *muscle* contributions go too. The
muscle read counts logged sets only, which is the more honest answer anyway.

## 6. Exit condition

The core is **perfected** when:

> I open Home and, without tapping anything, know within five seconds which
> muscles are under-stimulated this cycle, which adaptations are untouched, and
> whether I'm recovered enough to push today.

Until then, new sections don't get built and the shelf doesn't unshelve.
This is the sentence that ends the austerity — replace it if it's wrong, but
don't leave it blank.

**Walked 2026-09-07 — not yet met.** Two of the three questions passed cold, on
a real day, against real data: the under-stimulated muscles and the
push-or-rest call were both on the screen inside five seconds and both correct
at source. The third failed. Home can name at most four of the seven
adaptations — the three whole-body ones, plus power, printed by a line
hardcoded to power alone. Strength, hypertrophy and muscular endurance appear
nowhere, because Home's body map counts every set whatever its rep band. It
read correctly that morning only because power happened to be the one
muscle-linked quality at zero. The austerity therefore holds. Record of the
walk and the fix:
[rfcs/done/0051-exit-condition-walk.md](rfcs/done/0051-exit-condition-walk.md).

**Re-walked 2026-09-07, the same evening — question 2 now passes.** Home
prints the seven by name from the same coverage read as Adaptations — one
helper, one sentence on both screens, the power line gone — and still fits one
900 px screen with nothing to scroll. It read: *Untouched: power, anaerobic,
VO₂max. Short: strength, hypertrophy, muscular endurance, endurance.* All three
questions have now passed at source. The sentence above is a real five-second
read, not a test run's, so the verdict is the reader's to record here;
until that line says **met**, the austerity holds. Record:
[rfcs/done/0062-home-adaptations-one-screen.md](rfcs/done/0062-home-adaptations-one-screen.md).

**Verdict recorded 2026-09-30 — not met.** Peter's call, from a cold read of
the build carrying 0012's targets (sets, sessions, minutes). The muscles and
push-or-rest questions pass, correct at source. The adaptations question passes
on the letter: Home named which qualities were untouched and short, and the
door carried him to Adaptations for the rest. But it read thin, because the line
is hard to spot, the smallest text on the screen. A read the eye does not reach
in five seconds is not yet the five-second read, so the austerity holds. The
fix, and the walk that can turn this line into **met**:
[rfcs/done/0082-home-adaptations-line-weight.md](rfcs/done/0082-home-adaptations-line-weight.md).

**Met — 2026-09-30.** Peter's call, from a cold re-walk of v2.1.4 the same day.
The adaptations line now reads at body size, with the untouched names in the
accent, and Home still fits one 900 px screen. All three questions pass within
five seconds, without a tap, and correct at source. The austerity above ends
here: a new section may be proposed again. It still has to answer the §4
checklist and fit under R1's cap of four menu sections, which leaves one slot
today, and anything shelved still expires under R2. Record:
[rfcs/done/0082-home-adaptations-line-weight.md](rfcs/done/0082-home-adaptations-line-weight.md).

## 7. What this doctrine does not cover

- **Is the claim true?** → `/ground` (`.claude/skills/ground/SKILL.md`) + the
  `science-scout` (`.claude/agents/science-scout.md`) subagent.
- **Is the code clean?** → `/simplify`, `/code-review`.
- **Did smoothness degrade?** → the measured perf budget.

See [rfcs/done/0009-feature-grounding.md](rfcs/done/0009-feature-grounding.md) for how the
three fit together.
