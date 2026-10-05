---
title: Agent access — the user's own assistant first, an in-app agent on the same tools
authors: [Peter Petrov]
created: 2026-10-04
last_updated: 2026-10-05
status: backlog
status_note: "Scoped 2026-10-04 in the 0093 plan; the recommendation is an MCP server first, an in-app agent later on the same tools. Waits on the API (0094) and on Peter's call on the order."
label: backlog
depends: [94]
---

# RFC 0099: Agent access — the user's own assistant first, an in-app agent on the same tools

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

1. **Tools, generated from the API's description (0094)**: `get_whats_missing`,
   `get_readiness`, `get_recent_training`, `plan_exercises` (writes planned rows,
   0098), `log_session`, `undo_last_agent_change`. The reads return the app's
   wording, so the agent repeats the product's answer.
2. **MCP server** hosted with the API, signed in through OAuth with the user's
   account (0003), so a user adds Tekiō to their assistant like any other
   connector. Rate-limited on the free tier (0097).
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

- [ ] Peter's call on the order is recorded
- [ ] An MCP client connects with a test account and gets the same "what's
      missing" as Home shows for it
- [ ] An agent-written plan appears as planned on Weights and can be undone
- [ ] The in-app agent, when built, calls only the shared tools

## Unresolved questions

1. External first (recommended), in-app first, or both at once?
