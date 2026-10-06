---
title: The landing site's example week reads the app's exercise catalogue
authors: [Peter Petrov]
created: 2026-10-06
last_updated: 2026-10-06
status: backlog
status_note: "Found while porting the landing site to 2.2.0 (RFC 0084). Not committed to: it changes which muscles the example names from Thursday on, so lines Peter approved change with it, and that is his call."
label: backlog
---

# RFC 0102: The landing site's example week reads the app's exercise catalogue

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
return for the same logs ([RFC 0084](0084-public-landing-site.md),
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

Not chosen yet. Two shapes:

1. Keep the sixteen lifts, read their links from the catalogue, and rewrite
   the lines whose gaps change: the days from Thursday on, act one's end, the
   closing answer, and the film's last frame with its link preview.
2. Swap a lift or two so the story keeps its shape under the catalogue (for
   instance a grip or carry exercise in Saturday's held session, so the hold
   moves forearm work too), and rewrite fewer lines.

Either way the site's `week.ts` reads `linksFor` for each name, as its
citation of row 7.6 already does for the bench press, and the build fails
when a catalogue change moves an example link.

## Rationale

The alternative is to leave the links invented. The page marks the athlete,
every weight and every night as invented, so its reads are honest about their
inputs. But an exercise's links are no longer an athlete's choice; since 2.2.0
they are the app's rule, and the page says it plays the week through the
app's rules.

## Acceptance

- [ ] Peter decides whether the example reads the catalogue, and in which
      shape
- [ ] If it does: every example link comes from the app (the catalogue or a
      movement pattern), checked at build time and cited to inventory row 7.6
- [ ] The day copy, act one's end, the closing answer and the film's last
      frame name what each read names, in lines Peter approves, and the link
      preview is re-taken
- [ ] Walked at phone and desktop sizes

## Unresolved questions

- Read the catalogue at all, or keep the example's own links?
- If it does, keep the lifts and rewrite the lines, or swap lifts to keep the
  story?
