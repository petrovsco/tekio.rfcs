# RFC 0096: the Android app, step by step

The order the Android app is built in, one reviewable step at a time. Each
step ends in a PR to `develop` in tekio; the progress log in the RFC records
what landed.

1. **The API the apps need.** Home's words and the body map in `@tekio/core`,
   served as `GET /api/view/home`; sign-in by email link in the PKCE flow
   through the API; an `operationId` on every route. *(tekio #48)*
2. **The scaffold.** Kotlin and Jetpack Compose in the tekio repo, the client
   generated at build time from `packages/client/openapi.json`, the SIGNAL
   theme (`design-system.md`), and a GitHub Actions build that leaves a test
   APK to sideload. Sign-in, then Home drawn from `GET /api/view/home`.
3. **Home's sheets.** The muscle drill-in, the readiness sheet with sleep,
   sauna and cold capture, the whole-body quality sheet, weight and blood.
4. **Capture.** Weights (sets, plans, supersets), Cardio with sport, Mobility.
5. **The rest of the web's screens.** Adaptations, Profile, Settings,
   sign-out, and account deletion from inside the app (a store requirement).
6. **Health Connect.** HRV and sleep into readiness, with the consent screens.
7. **Release.** Release signing and the Play listing, once the developer
   account exists.

**Open at kickoff, put to Peter on 2026-10-23:** whether the code lives in the
tekio repo or its own, and whether to use Kotlin Multiplatform. Built
meanwhile on the recommended answers: an `android/` folder in tekio, plain
Kotlin with the API layer in a pure-Kotlin module.

**Peter's step before sign-in works:** add `fyi.tekio.app://sign-in` to the
Supabase project's Auth redirect allow list.
