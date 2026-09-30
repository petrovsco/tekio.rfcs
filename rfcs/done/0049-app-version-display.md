---
title: Show the app version in the app
authors: [Peter Petrov]
created: 2026-09-05
last_updated: 2026-09-30
status: done
status_note: "done 2026-09-30 with the 2.1.0 release. Production's deployment builds commit 6c7681f, whose package.json is 2.1.0 — the string the Profile line compiles in. Checked through Vercel's deployment record, not by eye: the gate credentials are Vercel Secrets."
label: feature
release: 2.1.0
---

# RFC 0049: Show the app version in the app

**Origin:** the 2.0.0 release (2026-09-05). Production could only be verified through Vercel's deployment metadata — the gate credentials are Vercel Secrets, so an agent cannot log in, and the running app has no way to say which version it is.

## The plain summary

Put the `package.json` version on screen once, where it costs nothing: the
foot of the Profile page, as `v2.1.0`. Then anyone can open
tekio.shamatoff.com and know in ten seconds whether a release landed. Every
push already bumps the version, so the string is always right.

## How

- Vite exposes it at build time: `define: { __APP_VERSION__:
  JSON.stringify(pkg.version) }` in `vite.config.ts`, plus a
  `declare const __APP_VERSION__: string` in a `.d.ts`. No network call.
- Render it in the quiet text style of the SIGNAL language
  ([design-system.md](../../design-system.md)) — no colour, no icon.
- Profile and Admin are exempt infrastructure in the doctrine ledger, so
  the line adds nothing to any read.

## Doctrine §4

1. **Which read?** None — Profile is exempt (ledger). 2. **Stop doing:**
verifying releases through Vercel metadata. 3. **Input or destination?**
Neither. 4. **Shape:** a string. 5. **Physiological number?** No.

## Acceptance

- [x] The version from `package.json` renders on Profile with no network call.
      Vite `define` in both `vite.config.ts` and `vitest.config.ts`;
      `declare const __APP_VERSION__` in `src/vite-env.d.ts`; the line is the
      last element of `ProfileTab`. Verified in the browser 2026-09-07 — the
      foot of Profile read `v2.0.42`, and the string is in the built bundle.
- [x] After the next release, production at tekio.shamatoff.com shows the
      released version. 2.1.0, 2026-09-30: the production deployment is
      READY on commit `6c7681f` (= `master`), aliased `tekio.shamatoff.com`,
      and that commit's `package.json` is `2.1.0`, which `__APP_VERSION__`
      is built from. Confirmed from the deployment record; reading it off the
      Profile page needs the gate credentials.
- [x] The release procedure ([0050](0050-release-procedure.md)) names it as the
      verification step — step 5, "Verify production".
