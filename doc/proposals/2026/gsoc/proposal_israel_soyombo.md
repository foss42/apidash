# GSoC 2026 Proposal: Agentic API Testing
**Organisation:** API Dash
**Applicant:** Israel Soyombo

---

## About
- **Full Name:** Israel Soyombo
- **Email:** israelsoyombo@gmail.com
- **Discord:** kiing.xo
- **GitHub:** github.com/kiingxo
- **LinkedIn:** linkedin.com/in/israel-soyombo-423041177
- **Time Zone:** GMT+0
- **Resume:** https://drive.google.com/file/d/1w_7ZxNU5AMRxuZhfvTBvzIhF5STHDyGR/view?usp=drive_link

---

## University Info
- **University:** University of Salford
- **Programme:** MSc Artificial Intelligence
- **Year:** 1
- **Expected Graduation:** 2027

---

## Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**
I built and maintain Slash, an open source mobile-first GitHub AI agent built in Flutter — github.com/kiingxo/slash-ai. It uses Gemini and OpenAI APIs to review code diffs, suggest edits, and push changes directly from a phone with no backend required.

**2. What is your one project/achievement you are most proud of?**
Slash. It started as a personal frustration — I wanted to review and merge PRs from my phone without opening a laptop. I ended up building a full agentic system that orchestrates LLM calls, maintains context across multi-step API interactions, and handles secure credential storage on device. The fact that it solves a real problem I had and that other developers relate to makes it the one I'm most proud of.

**3. What kind of problems or challenges motivate you the most?**
Problems where AI can remove genuine friction from a developer's workflow. Not AI for its own sake, but AI that makes something previously annoying or error-prone just work. Agentic API testing is a perfect example — maintaining brittle test suites as APIs evolve is a real widespread problem, and an intelligent agent can solve it in a way that no amount of better tooling alone can.

**4. Will you be working on GSoC full-time?**
Yes, full time. My MSc schedule during summer is light and I have arranged flexibility in my professional commitments to dedicate full GSoC hours to this project across all three months.

**5. Do you mind regularly syncing up with the project mentors?**
Absolutely. I am already active in the Discord and posted in the Idea 4 discussion thread. Weekly syncs and async GitHub communication work well for me.

**6. What interests you the most about API Dash?**
It is the only open source API client treating AI as a first-class architectural concern rather than a feature bolt-on. The decision to build agentic capabilities into the core of the tool rather than as a plugin is the right long-term call, and I want to be part of building that foundation.

**7. Can you mention some areas where the project can be improved?**
The agentic layer is the obvious one — right now API Dash is excellent for manual testing and exploration but has no autonomous quality layer. Beyond Idea 4, deeper MCP support could position API Dash as the go-to tool for testing the AI agent ecosystem itself, not just traditional REST APIs.

---

## Project Proposal

### Proposal Title
Agentic API Testing for API Dash

### Abstract
API testing today is script-driven and brittle. Developers write assertions upfront, maintain them manually, and miss entire classes of edge cases when APIs evolve. This proposal builds a production-quality agentic testing library inside API Dash — an AI agent that parses API specs, autonomously generates comprehensive test strategies, executes them against live endpoints, and self-heals when APIs change. No manual intervention required.

### Detailed Description

The system has four components:

**Spec Parser** — ingests OpenAPI and GraphQL specs and builds a structured internal model of endpoints, parameters, schemas, and contracts. MCP endpoint discovery is included so the agent can also test MCP servers.

**Test Generation Agent** — a ReAct-style agent that reasons over the spec model to produce a prioritised test strategy covering happy paths, edge cases, error states, auth flows, and chained multi-step workflows. Outputs structured JSON test cases that are human-readable and editable before execution.

**Test Execution Engine** — a Dart service that runs generated tests against live or mocked endpoints, captures full request and response context, and validates against expected contracts with clear failure reporting.

**Self-Healing Module** — detects when API changes cause test failures, diffs the old and new spec, and proposes updated assertions automatically.

### Weekly Timeline

| Week | Focus |
|------|-------|
| 1 | Codebase deep dive, module structure setup, contribution to existing issues |
| 2 | Spec Parser — OpenAPI 3.x support, normalised internal model |
| 3 | Spec Parser — GraphQL and MCP endpoint discovery, unit tests |
| 4 | Test Generation Agent — ReAct loop, prompt design, structured JSON output |
| 5 | Test Generation Agent — multi-step workflow context, auth flow coverage |
| 6 | UI integration — test plan visible and editable inside API Dash |
| 7 | Test Execution Engine — Dart service, live endpoint execution, result capture |
| 8 | Test Execution Engine — contract validation, failure reporting, CLI support |
| 9 | Self-Healing Module — failure detection, spec diffing, auto-updated assertions |
| 10 | End-to-end tests across all components using real public APIs |
| 11 | Performance optimisation, documentation, demo video, final review |

**Total: 175 hours**

### Time Commitment
- **June 2026:** 60 hours (15 hrs/week) — Spec Parser, module setup
- **July 2026:** 70 hours (18 hrs/week) — Test Generation Agent, Execution Engine
- **August 2026:** 45 hours (11 hrs/week) — Self-Healing Module, docs, demo
- **Total:** 175 hours, no planned absences

### Code Sample
My most relevant project is Slash, a mobile-first GitHub AI agent built in Flutter: github.com/kiingxo/slash-ai

Slash demonstrates the same architecture patterns this proposal requires: structured prompts, tool orchestration across multiple API calls, structured outputs, and graceful degradation on errors.
