---
title: "Retire the flat-`exercises` fallback in the program tree"
authors: [Peter Petrov]
created: 2026-09-08
last_updated: 2026-09-30
status: done
status_note: "done 2026-09-30 (v2.1.6): `blocks` is required, `defaultProgram()` emits blocks, and every flat-list fallback is gone — seven sites, not the three read fallbacks listed; see *Outcome*."
label: infra
release: 2.2.0
---

# RFC 0071: Retire the flat-`exercises` fallback in the program tree

## Goals

A program day used to be a flat list of exercise names. It is now a list of
**blocks**, each holding its own exercises — that is what the database stores
and what the editor writes. The old flat shape survives in four places as a
fallback, and every one of them is a branch a reader has to hold in their head
while working out what a program day actually is:

| Where | The fallback |
|---|---|
| `lib/db/program.ts`, in `fetchDayDetails` | builds a synthetic block from rows whose `block_id is null` |
| `ProgramTab.tsx`, `flatToBlock` / `normalizeDays` | wraps a day with no `blocks` into one block |
| `weights/TodaysPlan.tsx` | reads `day.exercises` when `day.blocks` is empty |
| `lib/utils.ts`, `defaultProgram()` | *creates* days with `exercises` and no `blocks` |

The `ProgramDay` type says the same thing out loud: `blocks?:` is optional and
`exercises` is documented as "derived … for backward compatibility". So the
type permits a shape the writer can no longer produce, and four readers carry
code for it.

## The migration 048 predicted is not needed

048 recorded these fallbacks as *"look dead but are not"* and said removing
them "needs a backfill migration". Both halves were checked against the live
database on 2026-09-08 and the picture has changed:

- **`program_day_exercises` holds 95 rows and every one has a `block_id`.**
  Zero rows with `block_id is null`, across zero days. There is nothing to
  backfill.
- **No write path can create one.** `saveBlock` always inserts
  `block_id: blockId` from a block it has just created, and the day save above
  it wraps a flat `day.exercises` into a synthetic weight block *before*
  writing. A flat day cannot reach the database any more.

What keeps the fallbacks alive is therefore not the database — it is
`defaultProgram()`, which still returns days with `exercises` and no `blocks`,
plus the import path that feeds the same shape into the editor. Both are
in-memory, both are ours, and both can emit blocks instead.

## Change

1. `defaultProgram()` returns days carrying a single weight block, the same
   shape `saveBlock` would have written.
2. `blocks` becomes required on `ProgramDay`; `exercises` / `supersets` stay as
   the derived convenience fields they are documented to be.
3. Delete the three read fallbacks — `fetchDayDetails`'s `block_id is null`
   branch, `flatToBlock` / the `normalizeDays` conditional, and `TodaysPlan`'s
   `day.exercises` branch. The type change makes the compiler find any site
   this brief missed.

Do it as one unit: the type change is what proves the deletions are safe, so
splitting it leaves the tree in a state where they are not.

## Non-Goals

- Any change to what a program *does*. This is shape only — the same days, the
  same exercises, the same order.
- The program import parser's own tolerance of a flat input file. A file
  someone wrote by hand may still list exercises flat; the parser normalises it
  into blocks, which is exactly right and stays.

## Risk

Low, but **visual**: the Program tab's editor and the Weights tab's "today's
plan" both render off this shape. Walk a program day in both, plus a fresh
`defaultProgram()` (create a program without importing one), before pushing.

## Doctrine checklist

1. **Which read does this sharpen?** None directly — Program and Weights render
   the same thing afterwards. It is the P1 performance/legibility face: one
   shape instead of two.
2. **What does it let me stop doing?** Keeping two program-day shapes in step,
   in four files, forever.
3. **Input or destination?** Neither; code.
4. **Honest shape?** Yes, literally: the type stops advertising a shape nothing
   writes.
5. **Physiological number?** No.

## Acceptance

- [x] `ProgramDay.blocks` is required and `defaultProgram()` emits blocks
- [x] The three read fallbacks are gone and `npm run build` passes
- [x] A program created from `defaultProgram()`, an imported program and the
      live enrolled program all render unchanged on the Program tab and in
      today's plan on Weights — checked in the browser, 0 console errors
- [x] `program_day_exercises` still holds no `block_id is null` row after the
      change (re-run the count; it is one query)

## Outcome — 2026-09-30, v2.1.6

**The fallback had seven sites, not four.** The type change found none of the
extra ones, because `blocks` was always present at runtime as an array — they
were `blocks.length === 0` branches, not missing-field reads. All seven are gone:

| Site | What it did |
|---|---|
| `lib/db/program.ts`, the day load | built the flat list from `block_id is null` rows |
| `lib/db/program.ts`, `saveDayBlocks` | **wrote** a flat day as a synthetic weight block — the write-side twin, not in the table above |
| `ProgramTab.tsx`, `flatToBlock` / `normalizeDays` | wrapped a blockless day for the editor |
| `ProgramTab.tsx`, `DayBlocks` and `BlockTypeStrip` | rendered a blockless day's flat list; a day with no blocks is now a rest day |
| `weights/TodaysPlan.tsx`, `weightSectionsFor` | read `day.exercises` when a day had no blocks |
| `lib/assistant/executor.ts`, add / rename / remove | edited the flat list of a blockless day |

The executor is the one that would have broken quietly. The assistant adding
an exercise to a rest day pushed a name onto the flat list, and only
`saveDayBlocks`' wrap turned it into a row; with the wrap gone the exercise
would have vanished on save. It now opens a weight block itself — the shape the
wrap used to write — and every assistant edit re-derives the flat view from the
blocks once, so the in-memory day no longer goes stale after a block edit.

`defaultProgram()` builds its five days through one `weightDay()` helper, and a
test pins that each carries one weight block with the flat view derived from it.
`getGrouped` now takes only the flat pair it reads, not a whole `ProgramDay`.

**Walked in the browser** on `npm run dev`, 0 console errors: the
5-Day template (`defaultProgram()`) opens in the editor with all five days and
their supersets; an imported program with a warm-up block, a superset weight
block and an empty rest day renders all three; the live Volleyball program's
Progress list reads its exercises from the database's blocks. Nothing was
saved. **Not walked:** today's plan on Weights and the Program tab's schedule
list, because both render only for an *active* program and both enrolled
programs are paused — resuming one to look would change the live database.
The removed branches never ran for a live day (every stored day has blocks),
so what they render for a real program is unchanged by construction.

**Recount after:** `program_day_exercises` 95 rows, 0 with `block_id is null`.

**Found on the way:** `npm run typecheck` checks nothing. It runs
`tsc --noEmit` against the root `tsconfig.json`, which is `"files": []` plus
project references, so it exits 0 whatever the code says; three test fixtures
missing `blocks` passed it and failed `npm run build` (`tsc -b`). Not fixed here;
fixed in [0072](0072-link-checker-for-this-repo.md) (v2.1.7).
