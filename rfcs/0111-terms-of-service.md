---
title: Terms of Service
authors: [Peter Petrov]
created: 2026-10-20
last_updated: 2026-10-20
status: in progress
status_note: "A first draft is in the app on staging (Profile → Legal → Terms of Service, v2.2.41), marked as a draft. Waits on Peter's review of the wording, the operator's details and the governing law."
label: infra
release: 3.0.0
---

# RFC 0111: Terms of Service

## Summary

Tekiō gets Terms of Service before it has a second user: one page, in plain
words, readable from Profile on every client, that says who runs the service,
that it is not medical advice, who owns the data, what is free and what may be
paid, and what neither side may do. It is the first piece of workstream 8,
launch readiness, in [0093](0093-first-public-release-plan.md). The privacy
policy, account deletion and store listings are the rest of that workstream and
get their own RFCs.

## Motivation

A product other people install needs terms before they install it: the app
stores require a terms link for any subscription, EU consumer law requires the
withdrawal and renewal rules to be stated before a person pays, and an app that
reads a body's readiness needs to say plainly that it is not a doctor. Today
the app says none of this. Writing it now, while the product has one user, lets
the wording be reviewed without a deadline and moves to the public build
unchanged.

## Goals

- One Terms page, reachable from Profile in one tap, in the app's voice.
- Every rule the plan has already decided is stated, not invented: the free and
  paid line ([0097](0097-free-and-paid-tiers.md)), the code licence (Apache 2.0,
  decided 2026-10-20), error reports that carry no personal data
  ([0103](0103-error-reports-to-agent-fixes.md)), export of the user's data.
- A health disclaimer a person reads before they act on a readiness word.
- Marked as a draft until Peter reviews the wording; the operator, address,
  contact and governing law are visible placeholders until he supplies them.

## Non-Goals

- **The privacy policy.** A separate document with separate legal rules (GDPR);
  its own RFC in workstream 8. The Terms point at it.
- **Recording acceptance.** A "you agreed to version N" row needs an account to
  hang on; it comes with [0003](0003-lock-the-database.md). Until then the
  Terms are shown, not signed.
- **A public web address for the Terms.** The stores and the landing site need
  one; it belongs with the landing site's release form becoming a link to the
  app (0093 workstream 8). The text is kept in one module so it can be served
  from there too.
- **Legal advice.** The draft follows common practice for consumer fitness
  apps; a lawyer's read before 3.0.0 ships is an acceptance box, not something
  this RFC replaces.

## Proposal

### Where it lives

- `src/lib/terms.ts` holds the text as data: a version date and a list of
  sections, each a heading and paragraphs. One source, so a later web page or
  native client renders the same words.
- `src/components/tabs/profile/TermsSheet.tsx` renders it in the shell's
  `Modal`, loaded lazily the first time it is opened (doctrine P1: what is not
  needed now is not loaded now).
- Profile gains a **Legal** group under Data with one row, *Terms of Service*,
  styled like the Data rows. The privacy policy joins it when it exists.

### What the draft says

Thirteen short sections. The decisions they carry:

| Section | Says | From |
|---|---|---|
| Who we are | the service is run by the operator (placeholder); the code is open source under Apache 2.0, which covers the code, not the hosted service or the name | Peter, 2026-10-20 |
| Not medical advice | not a medical device; readiness is an estimate from data that can be wrong; see a doctor before starting or changing training; stop on chest pain, dizziness, or unusual breathlessness | coordinator brief |
| Who can use it | 16 or older, one person per account | the highest digital-consent age in the EU, so one rule fits every member state |
| Your data | you own it; we use it only to run the service for you; never sold; export any time; error reports carry no personal data | 0103 |
| Connected services | a sync or an assistant acts on your instruction; its own terms apply | 0099, 0110 |
| Free and paid | manual capture and the reads free; automatic features may carry a small charge, shown before you pay; free at launch | 0097 |
| Subscriptions | renew until cancelled; cancel takes effect at the period's end; store purchases follow the store's rules; 14-day EU/UK withdrawal; price changes 30 days ahead | EU consumer rights rules |
| Acceptable use | no reaching other people's data, no overloading, no unlawful use; security reports welcome | — |
| Changes and availability | the service may change; at least 30 days to export before a shutdown | — |
| Liability | nothing excludes what law does not let us exclude; otherwise capped at what you paid in 12 months | common practice |
| Ending | you may leave any time; we suspend only for serious breach | — |
| Changes to these terms | 30 days' notice in the app for material changes | — |
| Law and contact | placeholders; consumers keep their home country's mandatory protections | — |

## Rationale

- **In the app, not only on the landing site.** The person who needs the health
  disclaimer is the one reading a readiness word, and the app is where they
  are. A web address comes later from the same text.
- **A sheet from Profile, not a tab.** Terms are infrastructure, like Profile
  itself; doctrine R1's section cap is not touched.
- **Text as data, not JSX.** The same words will be needed by the landing site
  and the native clients; prose embedded in a component would be copied, and a
  copied legal text disagrees with itself within a week.
- **Placeholders shown, not guessed.** Inventing an operator or a jurisdiction
  would read as decided. A visible bracket says what is missing.

**Brief checklist (doctrine §4).** 1: no read; infrastructure, like Profile.
2: nothing. 3: neither; a reference page. 4: not applicable. 5: no number
claiming physiological meaning; the disclaimer prescribes caution and makes no
quantitative claim.

## Acceptance

- [x] A Terms of Service row in Profile opens the Terms in a sheet, checked in a browser at phone width
- [x] The Terms text lives in one module, separate from the component that shows it
- [ ] Peter has reviewed the wording
- [ ] The operator, address, contact and governing law are filled in, and the draft banner is gone
- [ ] A lawyer has read it before 3.0.0 ships
- [ ] The privacy policy exists and the Terms link to it
- [ ] The Terms have a public web address the stores and the landing site can link to

## Unresolved questions

1. Which company operates the service, at which address, with which contact
   address? Peter supplies them.
2. Which country's law governs, and whose courts?
3. Is 16 the right minimum age, or 18 because of the health data?
