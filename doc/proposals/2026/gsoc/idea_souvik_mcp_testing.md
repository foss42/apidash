### Initial Idea Submission

**Full Name:** Souvik Ghosh  
**University name:** Indian Institute of Engineering Science and Technology, Shibpur  
**Program you are enrolled in (Degree & Major/Minor):** B.Tech in Computer Science and Engineering  
**Year:** 3rd Year  
**Expected graduation date:** 2027  

**Project Title:** MCP Testing  
**Relevant issues:** #1225  

**Idea description:**  
# GSoC 2026: Initial Idea Submission for MCP Testing

## Summary

I want to approach **MCP Testing** as a reliable testing workflow for MCP developers, instead of treating it only as a live debugging tool.

My current direction is to build the project in layers:

- a **Node/TypeScript execution core** for running MCP test sessions,
- a **transport abstraction layer** so different MCP transports can be tested through one common interface,
- a **validation layer** for malformed calls, schema mismatches, timeout handling, and protocol-level failures,
- a **reproducible artifact model** so test runs can be saved, replayed, and compared,
- and then a **minimal React interface** to define, run, and inspect MCP test scenarios.

The main goal is to make MCP testing practical for developers through rerunnable scenarios, clear validation, and reusable test artifacts.

---

## Problem Statement

As MCP usage grows, developers need better tools not just to inspect interactions, but to **test them repeatedly and systematically**.

Some pain points that stand out to me are:

1. **Transport-dependent testing becomes fragmented**  
   Different MCP transports can lead to duplicated logic and inconsistent testing workflows.

2. **Failure visibility is often weak**  
   When a request fails, developers need better insight into malformed requests, invalid responses, schema mismatches, timeout cases, and protocol violations.

3. **Debugging is too one-off**  
   Live debugging is useful, but it does not automatically create reusable tests that can be rerun later.

4. **Regression testing is missing**  
   Once a developer changes a server or client, it should be easy to rerun saved scenarios and compare new behavior against earlier results.

For this reason, I think MCP Testing should focus on **repeatable test workflows**, not just protocol inspection.

---

## Proposed Direction

### 1. Execution Core

The first foundation should be a **Node/TypeScript execution engine** that can:

- connect to or launch an MCP target,
- execute a test session in a structured way,
- normalize request/response/error handling,
- capture the complete session as test output.

This becomes the base layer for everything else.

### 2. Transport Abstraction

Instead of tightly coupling testing logic to one transport, I want to introduce a clean transport interface.

A common abstraction would allow the execution engine to work with different transports through the same contract, for example:

- `connect()`
- `send()`
- `receive()`
- `close()`

This keeps the system extendable without making the first version too broad.

### 3. Validation Layer

The next layer should classify and report failures clearly, instead of only exposing raw output.

Validation should cover things like:

- malformed protocol messages,
- missing required fields,
- schema mismatches,
- invalid method or tool invocation shapes,
- timeout and error propagation.

The goal is to make failures understandable and actionable.

### 4. Reproducible Test Artifacts

Every run should produce structured artifacts that capture:

- the scenario definition,
- transport metadata,
- exchanged messages,
- validation outcomes,
- final result summary.

This would allow replay, comparison, debugging, and future regression support.

### 5. Minimal React Interface

Once the execution and validation layers are stable, a focused React UI can be added for:

- defining test scenarios,
- running tests,
- inspecting responses and failures,
- replaying saved runs,
- comparing expected and actual outcomes.

I want this first UI to stay intentionally small and practical.

---

## Why This Direction

It is tempting to design MCP Testing as a very large DevTools platform from the start, with dashboards, advanced analytics, lifecycle management, CI integrations, and a large UI surface.

That direction is exciting, but I do not think it is the best first step.

For a GSoC project, I think the stronger starting point is a **narrow but reliable first slice**:

- execution core,
- transport abstraction,
- validation,
- reproducible artifacts,
- minimal UI later.

If that foundation is solid, the project can naturally grow after that.

---

## What Makes This Useful

### Not just live inspection

A live inspector is useful, but developers also need:

- repeatable tests,
- saved runs,
- structured validation,
- comparison between iterations.

So the project should focus on **testing workflow**, not only visibility.

### Not overly broad from the start

I do not want the proposal to become too wide in the first phase.

A smaller, stronger first milestone is easier to implement, easier to review, and much more likely to become a useful foundation for future work.

---

## Architecture Sketch

I currently imagine the project in the following modules.

### `mcp-exec`

Responsible for:

- running MCP sessions,
- coordinating transports,
- normalizing events and results.

### `mcp-transport-*`

Responsible for:

- connecting through supported transports,
- exposing a shared contract to the execution engine.

The first version should support one transport properly, with room to extend later.

### `mcp-validate`

Responsible for:

- protocol checks,
- message validation,
- error classification,
- timeout and malformed-message reporting.

### `mcp-artifacts`

Responsible for:

- storing session output,
- serializing runs,
- replay and comparison support.

### `mcp-ui`

Responsible for:

- creating test scenarios,
- running tests,
- viewing failures,
- replaying and comparing results.

---

## Milestones

### Milestone 1 — Execution and Validation Foundation

The first milestone should focus on the smallest complete slice that proves the project direction.

Deliverables:

- a basic Node/TypeScript execution engine,
- one transport supported end-to-end,
- normalized session event flow,
- protocol validation for malformed payloads and timeout/error cases,
- structured output artifacts for a run.

This is the most important milestone because it creates the technical foundation for the rest of the project.

### Milestone 2 — Reusable Test Scenarios

Once the execution core works, the next step is to make tests reusable.

Deliverables:

- a scenario definition format,
- rerunnable saved tests,
- expected vs actual comparison,
- regression-oriented artifact handling.

At this stage, testing becomes repeatable rather than ad hoc.

### Milestone 3 — Minimal React UI

After the core testing flow is stable, add a focused interface.

Deliverables:

- create or load a test scenario,
- run tests,
- inspect responses, traces, and failures,
- replay saved runs,
- compare outcomes.

The UI should stay intentionally lightweight and centered on execution and inspection.

### Milestone 4 — Expansion and Polish

Depending on mentor feedback and timeline, the final phase can include:

- adding one more transport if the first adapter is stable,
- improving scenario authoring and saved-run replay,
- refining failure visualization in the UI,
- integrating artifact export/import more cleanly with the surrounding API Dash workflow.

---

## Final Deliverables

By the end of the project, I would like to have:

- a working MCP execution and validation core,
- transport abstraction with at least one complete adapter,
- a structured artifact format for MCP test runs,
- reusable test scenario support,
- a minimal React UI for running and inspecting tests,
- documentation and examples.

---

## Non-Goals for the Initial Version

To keep the project realistic and deliverable, I would not treat the following as mandatory goals for the first version:

- a full dashboard-heavy DevTools surface,
- a broad CI/CD plugin ecosystem,
- deep analytics/reporting from day one,
- solving every MCP workflow at maximum depth immediately,
- building a large visual platform before the execution core is stable.

These are all interesting future directions, but they should not weaken the first implementation.

---

## Risks and Mitigation

### Risk 1: Transport support becomes too wide too early

**Mitigation:** start with one transport done properly and keep transport support behind a stable adapter interface.

### Risk 2: UI work grows too early

**Mitigation:** build the execution core and artifact model first, then keep the first UI intentionally minimal.

### Risk 3: Validation becomes too tied to one flow

**Mitigation:** keep validation as a separate module so it can be reused cleanly across execution and UI layers.

### Risk 4: Artifact format becomes hard to evolve

**Mitigation:** keep the format small and versioned from the start.

---

## Why I Think This Fits Well

What I find most promising about this idea is that it can become more than a debugging utility.

If done properly, it can give MCP developers a workflow where they can:

- define a scenario,
- execute it,
- inspect failures,
- save the run,
- rerun it after changes,
- and compare behavior over time.

That makes the project useful not only for debugging, but also for development and regression testing.

---

## Questions / Points for Mentor Feedback

I would especially appreciate mentor feedback on the following:

1. Should the first implementation prioritize:
   - one transport done well end-to-end, or
   - a thinner abstraction across multiple transports from the beginning?

2. For the initial vertical slice, should the focus be on:
   - MCP server testing,
   - MCP client testing, or
   - a minimal flow that supports both?

3. Should the artifact format be designed mainly for:
   - local replay and debugging first, or
   - with early CI-style usage also in mind?

---

## Closing Note

My main goal with this proposal is to keep the project grounded in something that can be built and reviewed incrementally.

Instead of starting with a very broad tool vision, I want to begin with the part that makes the whole project believable:

- a reliable execution core,
- repeatable tests,
- clear validation,
- and a minimal interface around that workflow.
