---
title: The landing site's example week reads the app's exercise catalogue
authors: [Peter Petrov]
created: 2026-10-06
last_updated: 2026-10-06
status: in progress
status_note: "Peter chose to switch on 2026-10-06. The example reads the catalogue on the site's develop branch (tekio.site 0.1.15, on staging); its four rewritten day lines wait for his OK before the site's next release."
label: feature
---

# RFC 0102: The landing site's example week reads the app's exercise catalogue

## Progress log

- 2026-10-06: put to Peter on a decision card; he chose to switch the example
  to the app's links.
- 2026-10-06: built in shape 2 below as tekio.site 0.1.15, on `develop`
  (staging). Every lift is a name the catalogue knows; wrist curls replace
  shrugs in the held pull session; Wednesday's, Thursday's, Friday's and
  Sunday's lines are rewritten and wait for Peter's OK. Act one, the closing
  answer and the film still end on rotator and erectors; only the fourth
  numbered gap changes, traps to adductors.

## Summary

The landing site plays an invented athlete's two weeks through the app's own
functions, but which muscles each of its sixteen lifts trains comes from the
site's own invented links. Since 2.2.0 the app links an exercise by its name,
from its catalogue of grounded movement patterns
([RFC 0074](done/0074-exercise-catalogue-grounded-links.md)). This RFC decides whether the
example reads the catalogue's links too, and rewrites the lines that change
if it does.

## Motivation

The site says its example week reads the same as the app's own functions
return for the same logs ([RFC 0084](done/0084-public-landing-site.md),
Acceptance). That held while an exercise's links were rows in the app's
database, written by an editor: any set of links was somebody's, and the
site's were marked invented. In 2.2.0 a name the catalogue knows gets the
catalogue's links, so someone who logged the example's fortnight in the app
would be shown other reads. Only act one's bench press is held against the
catalogue today (inventory row 7.6).

Run through the catalogue's links instead (a probe against the 2.2.0 release
commit; "Lateral raise" and "Dumbbell curl" are not in the catalogue, so they
take the shoulder-abduction and elbow-flexion patterns the app's two-tap
question offers for them):

- Readiness, each day's push, steady or hold, and Saturday's hold do not
  change.
- From Thursday on, the gap Home names is forearms and rotator, not rotator
  and traps. The overhead press, pull-ups and rows credit traps; nothing in
  the example credits forearms, because every pull and curl links them at
  level 3, which counts for nothing.
- Sunday's line, "Rotator and traps are still the gap, because the hold moved
  the work", stops being true: the held pull session would have filled the
  rotator, never the forearms.
- Act one ends on forearms and rotator, not rotator and erectors, and so do
  the page's closing answer, the film's numbered gaps on its last frame and
  the link preview taken from that frame.

## Goals

- Every link the example credits is the app's: the catalogue's for a name it
  knows, the movement question's pattern for one it does not, and the page
  says which.
- The story still reads: Saturday's hold still moves the work, and each day's
  copy names what that morning's read names.

## Non-Goals

- The catalogue itself. If the example shows a link the app gets wrong, that
  is an app RFC.
- Readiness, the invented nights and the cardio sessions.

## Proposal

Two shapes were open:

1. Keep the sixteen lifts, read their links from the catalogue, and rewrite
   the lines whose gaps change: the days from Thursday on, act one's end, the
   closing answer, and the film's last frame with its link preview.
2. Swap a lift or two so the story keeps its shape under the catalogue (for
   instance a grip or carry exercise in Saturday's held session, so the hold
   moves forearm work too), and rewrite fewer lines.

Either way the site's `week.ts` reads `linksFor` for each name, as its
citation of row 7.6 already does for the bench press, and the build fails
when a catalogue change moves an example link.

**Built: shape 2** (2026-10-06, tekio.site 0.1.15). It keeps the story with
one swap, where shape 1 would have changed the page's ending as well:

- Every lift is logged under a name the catalogue knows; "Lateral raise" and
  "Dumbbell curl" take the catalogue's spelling (Dumbbell lateral raise,
  Standing dumbbell curl). A name the catalogue does not know stops the build.
- Wrist curls replace shrugs in Saturday's pull session. Under the catalogue
  no pull or curl credits the forearms (level 3), so from Thursday the gap is
  forearms and rotator, and the held session is the one that reaches both.
- The four lines that change:

| Day | Live line | New line |
|---|---|---|
| Wednesday | Biceps and forearms are the gap now. Pull-ups, rows and curls reach both. | Biceps and forearms are the gap now. Pull-ups, rows and curls all reach the biceps. The forearms only grip, so they get nothing. |
| Thursday | … The core work answers this morning's gap. | … The core work answers half of this morning's gap. |
| Friday | Rotator and traps are the gap now. … | Forearms and rotator are the gap now. … |
| Sunday | … Rotator and traps are still the gap, because the hold moved the work. … | … Forearms and rotator are still the gap, because the hold moved the work. … |

- Act one, the page's closing answer and the film still end on "Rotator and
  erectors"; the fourth numbered gap is adductors where it was traps, and act
  one counts 7 muscles still recovering, not 6. The link preview shows only
  the film's last words, so it does not change.
- The site's story check now holds what the lines claim a session reaches,
  and its row 7.6 citation pins every lift's catalogue links.

## Rationale

The alternative is to leave the links invented. The page marks the athlete,
every weight and every night as invented, so its reads are honest about their
inputs. But an exercise's links are no longer an athlete's choice; since 2.2.0
they are the app's rule, and the page says it plays the week through the
app's rules.

## Acceptance

- [ ] Peter decides whether the example reads the catalogue, and in which
      shape
- [x] If it does: every example link comes from the app (the catalogue or a
      movement pattern), checked at build time and cited to inventory row 7.6
- [ ] The day copy, act one's end, the closing answer and the film's last
      frame name what each read names, in lines Peter approves, and the link
      preview is re-taken
- [x] Walked at phone and desktop sizes

## Unresolved questions

- None open. Whether to read the catalogue was Peter's call (yes,
  2026-10-06); the shape rides on his OK of the four lines above.
