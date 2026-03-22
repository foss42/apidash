# Idea Doc: Agentic API Testing
**Applicant:** Israel Soyombo  
**GitHub:** github.com/kiingxo  
**Discord:** kiing.xo  
**Email:** israelsoyombo@gmail.com  

## Problem Statement
API testing today is script-driven and brittle. Developers write 
assertions upfront, maintain them manually, and miss edge cases 
when APIs evolve. There is no intelligent layer that understands 
API contracts and autonomously ensures quality as the API changes.

## Proposed Solution
Build a production-ready agentic testing library inside API Dash 
with four components:

**Spec Parser** — ingests OpenAPI, GraphQL, and MCP specs into a 
structured internal model.

**Test Generation Agent** — a ReAct-style agent that reasons over 
the spec to produce a prioritised test strategy covering happy 
paths, edge cases, auth flows, and multi-step workflows. Outputs 
structured JSON test cases editable before execution.

**Test Execution Engine** — a Dart service that runs tests against 
live or mocked endpoints, captures full request/response context, 
and validates against expected contracts.

**Self-Healing Module** — detects when API changes break tests, 
diffs old and new specs, and proposes updated assertions 
automatically.

## MCP Integration
Rather than only calling MCP servers from the agent, API Dash 
could expose its own test runner as an MCP server — allowing 
other tools and AI agents to trigger API Dash tests externally. 
This positions API Dash as a tool in the broader agent ecosystem, 
not just a consumer of it.

## Technical Approach
- ReAct-style agent loop for test generation reasoning
- Structured JSON output schema for portable, human-readable 
  test cases
- Dart service layer for test execution inside the Flutter app
- Spec diffing for self-healing logic
- CLI support so tests can run headlessly in CI/CD pipelines

## Relevant Experience
- **Slash** (github.com/kiingxo/slash-ai) — open source Flutter 
  GitHub AI agent using Gemini/OpenAI APIs. Same agentic patterns 
  this project requires: structured prompts, multi-step API 
  orchestration, on-device LLM inference.
- Production LLM pipelines and FastAPI microservices at FPG 
  Technologies in clinical AI domain.
- MSc Artificial Intelligence, University of Salford.

## Weekly Timeline
| Week | Focus |
|------|-------|
| 1 | Codebase setup, module structure, first contribution |
| 2 | Spec Parser — OpenAPI 3.x support |
| 3 | Spec Parser — GraphQL, MCP discovery, unit tests |
| 4 | Test Generation Agent — ReAct loop, prompt design |
| 5 | Test Generation Agent — workflows, auth flows |
| 6 | UI integration — test plan panel in API Dash |
| 7 | Test Execution Engine — live endpoint execution |
| 8 | Test Execution Engine — validation, CLI support |
| 9 | Self-Healing Module — failure detection, spec diff |
| 10 | End-to-end tests with real public APIs |
| 11 | Docs, performance optimisation, demo video |

**Total: 175 hours**