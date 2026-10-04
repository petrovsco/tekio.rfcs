# RFC 0074 — audit of the live links against their patterns

Run 2026-10-04 against `exercise_muscle_groups`, after Peter took the ten fork
defaults (inventory D48–D57). Each lift was given a pattern in the committed
catalogue (`src/constants/exerciseCatalogue.ts` in the code repo), and its live
links were diffed against what the catalogue writes. **Nothing below has been
applied to the database yet**; it lands with the catalogue seed, on Peter's
word.

Level 3 counts zero, so a link added at 3 changes no number on screen. Those
are listed apart: they only record that the muscle was considered.

## Links that change a number

| Exercise | Muscle | Live | Catalogue | Why |
|---|---|---|---|---|
| Back Squat, Bulgarian Split Squat, Forward and Backward Dumbbell Lunge | Hamstrings | 2 | 3 | Hamstrings did not grow in squat trials (L) |
| Hip Thrust, Glute Bridge | Hamstrings | 2 | 3 | Hamstrings grew negligibly from hip thrusts (L) |
| Leg Press | Glutes | 2 | 1 | Glute max +15 % in the one leg-press MRI trial (L) |
| Leg Curl | Calves | 2 | 3 | Gastrocnemius growth never measured (L) |
| Deadlift | Erectors | 1 | 2 | D49 |
| Dips | Triceps | 1 | 2 | D51 |
| Bench Dip | Chest | 2 | 3 | Override reason in the catalogue (P) |
| Dumbbell Shoulder Press | Upper Back / Traps | — | 2 | Matches its pattern, as Overhead Press already did (P) |
| Rows, Low Row, Single-Arm DB Row | Rhomboids, Upper Back / Traps | 2 | 1 | D53 |
| Rows, Low Row, Single-Arm DB Row | Posterior Deltoid | — | 2 | Rear delts work as a synergist in rows (U) |
| Face Pulls | Posterior Deltoid | 2 | 1 | D54 |
| Face Pulls | Rotator Cuff | 1 | 2 | D54 |
| Hanging Leg Raises | Obliques | — | 2 | Matches its pattern (T) |
| Decline Sit Ups | Hip Flexors | 2 | 1 | A sit-up is hip flexion; the psoas grows (T) |
| Cable Woodchop, Pallof Press | Rectus Abdominis | 2 | 3 | Bracing rule, D55 |
| Snatch | Anterior Deltoid | 2 | 3 | The overhead receive is a hold (T) |
| Crossbody Pronated Curl | Biceps | — | 1 | It is a curl, filed as wrist work (U) |
| Crossbody Pronated Curl | Forearms | 1 | 2 | Brachioradialis in a pronated grip (U) |

## Links added at level 3 (no number moves)

Lateral Deltoid on Bench Press, Chest Press, Push-ups, Clapping Push-up and
Dips; Rotator Cuff on Reverse Fly and Band Pull-Apart; Forearms on Cable
Shrugs, every curl, every row and the vertical pulls; Posterior Deltoid on
Pull-ups, Chin-up and Lat Pulldown; Hamstrings and Erectors on Goblet Squat and
Leg Press; Calves on Nordic Hamstring Curl.

## Rows the catalogue does not take as they are

| Row | What is wrong | Proposed |
|---|---|---|
| *Lat Raises* | Its sessions are lat pulldowns (loads only a pulldown takes), but its links and the system aliases *Lateral Raises* and *Side Raises* say lateral raise | Move its sessions to *Lat Pulldown*, point the two aliases at *Dumbbell Lateral Raise*, and delete the row. The name reads two ways, so it gets no alias of its own |
| *PJR Pullover / Cable Extension* | Two different lifts on one name. Its one session's load fits the PJR pullover, a lying elbow extension | Rename to *PJR Pullover*, pattern elbow extension (Triceps 1) |

## Out of the catalogue's scope

Mobility drills and stretches keep the `recovery` model and get no pattern.
Power drills keep their hand-written links until a pattern for them is grounded:
Box Jump, Broad Jump, Jump Back Squat, Pogo Hops, Skater Hop, Lateral Bound,
Lateral Shuffle, Sled Push, Sprint, Med Ball Chest Pass, Med Ball Overhead
Throw, Med Ball Slam, Med Ball Throw. Dead Hang and Scap Push-Up are warm-up
drills, not lifts.
