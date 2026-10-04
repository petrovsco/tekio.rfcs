---
title: Sheets in steps, sized for a thumb
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-04
status: in progress
status_note: Everything but the owner's phone check is on develop as tekio v2.1.36, including in-sheet catalogue search with 0074's movement question.
label: feature
depends: [74]
release: 2.2.0
---

# RFC 0100: Sheets in steps, sized for a thumb

## Summary

The Home sheets put the read and the capture into one long scrolling panel,
and their controls are too small for a fingertip. This RFC splits each sheet
into steps: the read comes first with a single action, and the capture is its
own step. Every save ends with an undo, the map picks the muscle nearest to a
tap, and the sheet's grab handle can be dragged.

## Motivation

The owner reported that the sheets ask for too much thinking at once and that
taps misfire on a phone, especially when tapping a muscle and then logging more
records from its sheet. A touch-emulated pass at 412 px wide, on invented data,
measured the following
([review](https://claude.ai/artifact/CK4c7twYGqK8npQzk1xk9u)):

- **Map:** 79 of 152 taps placed 6–8 px off a muscle's centre (52 %) opened that
  muscle. 38 opened a different muscle and 35 opened nothing. The anterior
  deltoid went 0 of 8. Most zones are 3–16 px wide on screen.
- **Muscle sheet:** Save stays live after saving, so a second tap writes the
  same sets again. Once an exercise is picked, Save sits below the screen edge.
  The rep and kg boxes are 26 px tall. Only the three exercises that already
  fed the muscle are offered. "Something else" closes the sheet and opens an
  empty Weights form that has forgotten the muscle.
- **Copy:** the developer mark "PLACEHOLDER" is printed on screen, twice in
  the muscle sheet and more on Home.
- **Recovery sheet:** 19 of 20 controls are under 44 px. One tap logs a session
  with no confirmation and no undo, and a double tap logs twice. Nothing on
  screen confirms that a log worked.
- **Handle:** the grab handle looks draggable but does nothing.

## Goals

- Tapping a muscle opens the muscle the finger was aimed at.
- Logging more sets for a muscle is: pick an exercise, step the numbers, Save,
  then land back on the exercise list ready for the next one.
- Every capture control is at least 44 px tall, and Save is always on screen.
- No save can be repeated by a second tap, and each save offers Undo.
- The handle moves the sheet with the finger. Dragging down closes the sheet
  and dragging up opens it full screen when its content needs the room.

## Non-Goals

- No change to what any read computes, and no new number on screen.
- Weights tab (owned by 0074 while it is in flight). Searching the full
  exercise catalogue inside the sheet waits for 0074 to land (Proposal 6).
- RecoverySheet.tsx until 0085 and then 0092 have landed on `develop`, because
  both change that file.
- The desktop centred-card layout keeps no handle and no drag.

## Proposal

1. **Map tap** (`GapMap.tsx`): one tap handler on the map's SVG. A tap that
   lands on a muscle opens it, as before. A tap that lands on nothing samples
   rings of points out to 14 px and opens the muscle that most of the nearest
   ring hits. Callout labels take part in the same handler.
2. **Muscle sheet** (`MuscleSheet.tsx`) gets three views inside one sheet:
   - *Read*: the existing read, then a footer button "Log sets for X".
   - *Pick*: a search box and every exercise that has fed or can feed the
     muscle, the most recent first. Exercises already logged today show as
     TODAY ✓. "Done" returns to the read.
   - *Sets*: rows of reps and kg, each with − and + buttons around a 44 px
     number field, "Same again", and a pinned "Save N sets".
   Save is disabled while it writes. After the write the sheet returns to
   *Pick* and shows "Bench Press: 3 sets saved · Undo" above the footer.
3. **BottomSheet** (`BottomSheet.tsx`) gets an optional `footer` that stays
   pinned at the bottom of the scroll area, and a draggable handle on phones.
   The panel follows the finger. Releasing more than a quarter of the panel's
   height down, or flicking down, closes the sheet. Dragging up opens the
   sheet full screen when its content is taller than the panel. When the
   content already fits, the panel springs back, because full screen would
   only add empty space. Existing callers are unchanged.
4. **Copy**: the PLACEHOLDER mark leaves every screen (Home, the muscle sheet
   and the blood sheet), on the owner's call on 2026-10-04. Design-system §11
   now says the mark lives in code comments and RFCs, never in the UI. The
   numbers it sat beside on screen (the 48 h recovery window and the blood
   windows) already carry their grounding in 0010.
5. **Owner's review, 2026-10-04**: the sheet's top edge on a phone is 1px
   rather than 2px, because the dimmed page above already says it is a
   sheet. The verdict's plus glyph becomes a ring, so the footer button is
   the only thing that looks like an action. "Same again" becomes "Add a
   set", because the copy is only a starting point. The door to Adaptations
   is removed: it reopened the same sheet over Adaptations, and the sheet
   already shows the four qualities. Home keeps its own link to Adaptations.
   His second pass, the same day: the close glyph on the menu, sheets and
   modals moves in to the 16px gutter, and an emptied kg or reps field stays
   empty instead of becoming 0 and putting a 0 in front of the next digit.
6. **Search inside the sheet**, after 0074 landed: the pick list offers the
   catalogue's lifts for the muscle after the ones logged and linked. Search
   covers every catalogue lift and everything on file, by any spelling, and a
   match that does not train the muscle says so. A name nothing knows is logged
   as a new exercise in the sheet, with 0074's movement question at thumb
   size, so logging never leaves for Weights; the "open Weights" escape is gone.
7. **Recovery sheet**, after 0085 and 0092 landed: the read, then a LOG list
   (morning HRV or check-in when that is the chosen method, then Sauna, Cold
   and Sleep), then one capture per step ending in "… saved · Undo". Sauna
   and cold preselect the last bout's length. Undo on sleep is offered only
   for a night that did not exist before, because a typed night replaces the
   watch's. When today's reading is what is missing, the sheet opens on that
   capture.

## Rationale

The review weighed three directions: *Tidy*, which keeps one sheet with bigger
controls; *Steps*; and *Hand-off*, where logging moves to Weights. The owner
chose Steps on 2026-10-04. Tidy fixes the misfires but leaves six jobs on one
scrolling screen. Hand-off leaves Home, so the map's answer is lost while
logging, and it collides with 0074. Snapping to the nearest muscle was chosen
over enlarging the drawn zones, because the figure's proportions are part of
the read and should not change.

## Brief checklist (doctrine §4)

1. *Which read does this sharpen?* Home's muscle read and its readiness card,
   by making the path from the read to the capture shorter.
2. *What does it let me stop doing?* Scrolling inside a sheet to reach Save,
   deleting duplicates, and leaving Home to log a new exercise for a muscle.
3. *Input or destination?* Input: no new surface.
4. *Honest shape?* Unchanged; no read is redrawn.
5. *Physiological number?* None written or moved. The stepper increments
   (1 rep, 2.5 kg) are input conveniences, not claims.

## Acceptance

- [x] Off-centre taps (6–8 px) on the map open the aimed muscle or its
      neighbour, never nothing, in the same 412 px emulated test (2026-10-04:
      100 right, 52 neighbour, 0 nothing of 152; it was 79 / 38 / 35)
- [x] Muscle sheet: read, then pick, then sets, then back to pick after Save, with Undo
- [x] A second tap on Save cannot write a second copy
- [x] Save is on screen without scrolling once an exercise is picked
- [x] Every control in the muscle sheet's log steps is at least 44 px tall
- [x] PLACEHOLDER is not visible on any screen
- [x] The handle drags the sheet: down past a quarter closes, up opens full screen when the content needs it and springs back when it does not
- [x] Search inside the sheet covers the full catalogue, with the movement question for a new name (after 0074)
- [x] Recovery sheet in the same steps, after 0085 and 0092 land
- [ ] Verified on the owner's phone

## Unresolved questions

None.
