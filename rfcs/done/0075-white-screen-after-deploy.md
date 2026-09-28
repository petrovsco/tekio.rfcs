---
title: A tab left open across a deploy goes white on the next screen change
authors: [Peter Petrov]
created: 2026-09-28
last_updated: 2026-09-28
status: done
status_note: "fixed in v2.0.97 — reload once on a failed lazy chunk, and an error boundary at the root so no render error can leave a blank page."
label: bug
---

# RFC 0075: A tab left open across a deploy goes white on the next screen change

## Goals

Opening the app after a while and changing screen gave a white page; a refresh
fixed it. Reported on staging, and production has the same code path.

**Cause.** Every destination except Home is a lazy chunk with a content hash in
its filename (design-system tier T3). A tab loaded before a deploy still holds
the old `index`, so its next destination change asks for a chunk the new deploy
no longer serves. `vercel.json` rewrites every unmatched path to `index.html`,
so the browser gets HTML where it expected a module, the dynamic import rejects,
and `React.lazy` throws. With no error boundary anywhere, React unmounts the
whole tree. Staging deploys on every push to `develop`, which is why it showed
there first.

The gate in `middleware.ts` fails the same way from the other side: its cookie
lives 24 h, after which the chunk request is answered with the 401 login page.

Reproduced against the production build by removing one chunk after load and
changing screen: before the fix `#root` was empty; after it the page reloads
itself and the screen opens.

## Which read does this sharpen?

All of them, indirectly — every read past Home is behind a lazy chunk.
Doctrine P1's performance face (load only what is needed now) is what creates
the chunks, so this is the cost of that rule being paid properly, not a reason
to retreat from it.

## Change

- `src/lib/staleChunk.ts` — on Vite's `vite:preloadError`, reload the page.
  Once: a second failure within 10 s is let through rather than looping.
- `src/components/ui/ErrorBoundary.tsx` around `<App />` — a render error shows
  one line, the message, and a Reload button instead of a blank page.

A reload is the right answer to both causes: after a deploy it fetches the new
index; after the cookie expires it shows the gate's sign-in form.

## Non-Goals

- Keeping old chunks alive across deploys (Vercel skew protection). It would
  let an old tab keep running old code against a database whose shape may have
  moved; a reload is more honest.
- Lengthening the gate cookie. That is a door policy, not this bug.

## Acceptance

- [x] Removing a chunk after load and changing screen reloads the page and the
      screen opens — verified headless against `vite preview`
- [x] A second failure inside the guard window shows the boundary, not a white
      page and not a reload loop
- [x] The same scenario on the previous build leaves `#root` empty — the bug as
      reported
