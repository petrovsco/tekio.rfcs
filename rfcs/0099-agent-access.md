---
title: Agent access — the user's own assistant first, an in-app agent on the same tools
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-23
status: in progress
status_note: "The connector is built on a branch (MCP server at /api/mcp, consent page, undo); it waits on the Supabase OAuth server being switched on and on the agent-writes migration, then a first real connect from Claude."
label: feature
depends: [94]
release: 3.0.0
---

# RFC 0099: Agent access — the user's own assistant first, an in-app agent on the same tools

## Progress log

- 2026-10-23: started on Peter's word in the release plan. Built on branch
  `claude/project-thread-jd80ft` of the code repo: Home's words moved into the
  core read so the API sends them (`HomeRead.words`); `GET /api/history`; the
  MCP server at `/api/mcp` with eleven tools generated from the API's own
  routes; the OAuth protected-resource metadata at
  `/.well-known/oauth-protected-resource`; the consent page at
  `/oauth/consent`; writes marked from the token's `client_id`; the
  `agent_changes` record and undo; the entitlement check, free for every account
  at launch, and a cap of 60 assistant changes an hour. Waiting on Peter: the
  Supabase OAuth 2.1 server switched on with dynamic client registration and
  the authorization path `/oauth/consent`, and the additive migration
  (`written_by` on the four logs an assistant may write, the `agent_changes`
  table).

## Summary

Let an AI agent read a user's Tekiō reads and write plans and logs for them.
Two ways in were raised: an agent inside the app, or the user's own assistant
connecting from outside. The recommendation is both, in that order, on one set
of tools: first an MCP server on the API, which any assistant that speaks MCP
can use; later an in-app agent, a paid feature (0097), that calls the very same
tools.

## Motivation

Planning a day's training with an agent worked: it read what was missing and
wrote a plan. It also showed what was missing in the app: a place for the plan
(0098) and a way for the agent to reach the data without being handed it by
hand.

The in-app assistant was deleted on 2026-10-02 in the 0034 review
([0087](done/0087-remove-program.md)). Bringing an agent back has to say what is
different: this time it acts on the reads through a defined set of tools, rather
than being a chat box beside them.

## Goals

- A user can connect their own assistant and ask "what's missing", "plan today",
  "log what I did", and the answers are the app's reads, not the model's guesses.
- One tool definition serves the external and the in-app agent.
- Every write by an agent is marked as an agent's and is undoable.

## Non-Goals

- A Tekiō model or fine-tune.
- Autonomous scheduling (the agent acting without being asked).
- A CLI as its own product. Generated from the same API it is cheap and can
  follow, but MCP reaches more users with less code.

## Proposal

1. **Tools, generated from the API's description (0094)**: each tool is one
   route, its input read off the route's OpenAPI description and its call made
   through the route itself with the assistant's token. Reads:
   `get_whats_missing` (Home), `get_readiness`, `get_adaptation`,
   `get_recent_training` (`GET /api/history`). Writes: `plan_lifts` (several in
   one call, 0098), `plan_session` (0104), `log_lift`, `log_cardio`,
   `log_sport`, `log_mobility`. And `undo_last_agent_change`. The reads return
   the app's wording: the Home read carries the sentences Home prints
   (`words`), made by one helper in the core, so the agent repeats the
   product's answer.
2. **MCP server** hosted with the API, signed in through OAuth with the user's
   account (0003), so a user adds Tekiō to their assistant like any other
   connector. Rate-limited on the free tier (0097).
   The OAuth server is Supabase Auth's own (OAuth 2.1, with dynamic client
   registration, so an assistant registers itself); the app supplies only the
   consent page. The token an assistant gets is the person's, carrying the
   assistant's `client_id`, so the database policies apply unchanged and the API
   knows a write is an agent's without being told.
   That means a *remote* MCP server: a URL over HTTPS with OAuth sign-in, which
   is what assistants list as connectors. A user adds it by picking it from the
   assistant's connector directory or pasting its URL, then signs in to Tekiō;
   no config file. The JSON-configured, locally run kind of MCP server is for
   developers and is not what ships. Getting listed in each assistant's
   directory is its own submission, done once the server works.
3. **In-app agent, later**: a chat surface reached from Home (not a menu section;
   R1 unchanged) that calls the same tools through the API, with the model call
   paid for by the paid tier.
4. **Guardrails**: agents write `planned` rows and logs marked as written by an agent (a `written_by` field, separate from the existing `origin` build tag);
   nothing an agent writes deletes logged work; every write has an undo.
   Built as: `planned_by = 'agent'` on plans (already there, 0098) and
   `written_by = 'agent'` on the logs, both set by the API from the token; the
   assistant has no edit or delete tool; each call that writes leaves one
   `agent_changes` row listing what it wrote, and undo takes those entries out
   through the API's own delete routes, newest call first. Writing is gated by
   one entitlement check (paid side of 0097, open to every account at launch).

## Rationale

| | External first (recommended) | In-app first | Both at once |
|---|---|---|---|
| Model cost to Tekiō | none: the user's assistant | every call | every in-app call |
| Code | an MCP server over the API | a chat UI, a model integration, prompt and safety work | both |
| Who it suits | users who already live in an assistant | users who do not | everyone, later |
| Doctrine fit | the read reaches the user where they already ask | a new surface to justify | — |

The external agent is cheaper to build, costs nothing to run, and proves the
tools. The in-app agent then reuses those tools and only adds a chat surface and
a model bill, which is why it belongs on the paid side.

**Brief checklist (doctrine §4).**

1. *Which read does this sharpen?* Home's "what's missing", reached from another
   place.
2. *What does it let me stop doing?* Copying data into an assistant by hand, and
   typing a plan the assistant already wrote.
3. *Input or destination?* An input path (plans and logs) and a way to reach the
   existing reads; the in-app agent is the one part that is a surface.
4. *Honest shape of the data?* The tools return the reads as the app states them.
5. *Does it write a number claiming physiological meaning?* The tools do not. A
   model's own advice is not the app's claim, and the in-app agent must say so.

## Acceptance

- [x] Peter's call on the order is recorded: outside first (2026-10-05)
- [ ] An MCP client connects with a test account and gets the same "what's
      missing" as Home shows for it
- [ ] An agent-written plan appears as planned on Weights and can be undone
- [ ] The in-app agent, when built, calls only the shared tools

## Unresolved questions

None. Answered 2026-10-05: external first, then in-app on the same tools.
