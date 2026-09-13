# GSoC 2026 Application: Agentic API Testing

### About

1. **Full Name:** Ayazhan Kadessova
2. **Contact info:** kadessovaayazhan@gmail.com
3. **Discord handle:** ayazhankad
4. **Home page:** [ayazhankad.codes](https://ayazhankad.codes)
5. **Blog:** —
6. **GitHub profile link:** [github.com/ayazhankadessova](https://github.com/ayazhankadessova)
7. **LinkedIn:** [linkedin.com/in/ayazhankad](https://linkedin.com/in/ayazhankad) | **Figma:** [figma.com/@ayazhankad](https://figma.com/@ayazhankad)
8. **Time zone:** AST (UTC+3, Saudi Arabia)
9. **Link to a resume:** https://drive.google.com/file/d/1oJOcs1FLMTRuECrMj9z_0w43uZH8tGod/view?usp=sharing

### University Info

1. **University name:** King Abdullah University of Science and Technology (KAUST)
2. **Program:** MSc/PhD in Computer Science (full-ride KAUST Fellowship)
3. **Year:** 1st Year (Graduate)
4. **Expected graduation date:** 2027 May (MSc) 

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

Yes. I am a core contributor to **[Agentize](https://github.com/Synthesys-Lab/agentize)**, an open-source AI agent SDK for software development built as part of my graduate research at KAUST's Synthesys Lab. My contributions include:

- **FSM Orchestrator Architecture:** Designed and implemented a table-driven finite state machine orchestrator that replaced a monolithic dispatch chain with modular stage kernels for implementation, code review, PR, and rebase workflows. Integrated convergence tracking and checkpoint persistence. ([Agentize repo](https://github.com/Synthesys-Lab/agentize))
- **Multi-Agent Code Review System:** Designed a system using LLM agent teams — 3 specialist AI reviewers that independently analyze diffs, cross-challenge each other's findings through structured messaging, and produce consensus reports with quality gate hooks.
- **Test-Driven Development Infrastructure:** Contributed to Agentize's shell-based testing framework with 5 test categories (cli, e2e, lint, sdk, vscode), stub-based AI isolation, fixture-driven testing, and multi-shell (bash/zsh) compatibility.

**2. What is your one project/achievement that you are most proud of? Why?**

I am most proud of the **multi-agent code review system** I designed for Agentize. It creates 3 specialist agent reviewers (correctness, design, standards) that independently analyze code diffs, then enter an adversarial cross-challenge phase where each reviewer must challenge at least one finding from the others. Findings are annotated as SURVIVED, WITHDRAWN, or REVISED before final synthesis. This is the exact kind of quality-gate thinking I want to bring to API testing — where test strategies are validated through multi-perspective analysis rather than single-model generation.

**3. What kind of problems or challenges motivate you the most to solve them?**

I am drawn to the intersection of **AI reliability and software quality**. At The Trade Desk, I automated creative assignment for advertisers — generating 4,300 daily assignments at 99% uptime. At JP Morgan, I migrated trading applications and automated observability infrastructure. In my research, I build AI agent systems that must produce trustworthy outputs. The common thread is: how do you make automated systems reliable enough to trust? Agentic API testing is this exact challenge — using AI to generate comprehensive tests while ensuring deterministic, reproducible execution.

**4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

Yes, I will be working full-time.

**5. Do you mind regularly syncing up with the project mentors?**

No, it helps to iterate and get feedback, I appreciate regular syncs!

**6. What interests you the most about API Dash?**

Two things: **the agentic AI infrastructure and the Dart/Flutter stack**. API Dash already has a sophisticated multi-provider AI agent engine (`genai` package with `AIAgent` abstract class, `AIAgentService` orchestration, retry logic, and validation loops) and a conversational interface (DashBot). This is a strong foundation — but it currently lacks a closed-loop testing lifecycle where agents can reason about API specs, generate tests, execute them, and self-heal. Building that loop, especially using multi-agent patterns I've researched, is what excites me.

**7. Can you mention some areas where the project can be improved?**

1. **No closed-loop testing lifecycle.** DashBot can generate test case ideas (`generateTestCasesPrompt`), but there is no engine to execute, validate, or iterate on them. The AI suggests, but nothing acts.
2. **Single-agent limitation.** The current `APIDashAgentCaller` invokes one agent at a time. For test generation, a multi-agent approach (generator + critic + reducer) would produce higher-quality, more diverse test strategies.
3. **No workflow orchestration.** API Dash handles single request-response cycles excellently, but real-world API testing involves multi-step workflows (auth → resource creation → validation → cleanup) with state carried across steps.
4. **No KPI measurement for test quality.** There's no way to measure test coverage, assertion quality, or self-healing effectiveness — metrics that matter for agentic testing.

**8. Have you interacted with and helped API Dash community? (GitHub/Discord links)**

I am new to the API Dash community but have thoroughly studied the codebase, existing proposals, and discussion threads ([#1230](https://github.com/foss42/apidash/discussions/1230), [#1054](https://github.com/foss42/apidash/discussions/1054)). I plan to join the Discord server and contribute to the discussion before the application deadline.

---

### Project Proposal Information

**1. Proposal Title:**
Agentic API Testing: Multi-Agent Test Generation with FSM-Driven Execution and KPI Measurement

**2. Abstract:**

API testing today relies on either manual scripting or single-shot AI generation — both fragile and incomplete. This proposal introduces a **multi-agent testing architecture** to API Dash, drawing on patterns proven in [Agentize](https://github.com/Synthesys-Lab/agentize), our open-source AI agent SDK. The system uses **agent teams** (generator, critic, reducer) to produce diverse, high-quality test strategies from API specifications, a **finite state machine (FSM) engine** for deterministic multi-step workflow execution, and **KPI measurement** to track test quality, coverage, and self-healing effectiveness. MCP Apps integration enables external agents to trigger and consume test results.

The core principle: **Agents reason about what to test. An FSM executes deterministically. KPIs measure quality.**

**3. Detailed Description**

#### 3.1 Problem

API Dash's DashBot can suggest test cases, but there is no infrastructure to:
- Parse API specifications (OpenAPI/GraphQL) into structured test strategies
- Execute multi-step test workflows with state propagation
- Self-heal when APIs change
- Measure whether the generated tests are actually good

This proposal explores a **multi-agent approach to test strategy quality assurance**, inspired by the adversarial review patterns we use in Agentize. The idea is that using multiple specialized agents (generator, critic, reducer) can help produce more diverse and validated test plans than a single LLM call.

#### 3.2 Architecture Overview

```
┌──────────────────────────────────────────────────────────┐
│                  API Specification Input                  │
│           (OpenAPI 3.x / GraphQL Introspection)          │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│              Multi-Agent Test Strategy Layer              │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐             │
│  │ Generator │   │  Critic  │   │ Reducer  │             │
│  │  Agent    │──▶│  Agent   │──▶│  Agent   │             │
│  │(Breadth)  │   │(Validity)│   │(Minimal) │             │
│  └──────────┘   └──────────┘   └──────────┘             │
│          Produces validated, minimal test plan            │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│              Human-in-the-Loop Approval Gate              │
│         (DashBot UI: review, edit, approve plan)         │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│           FSM Execution Engine (Deterministic)           │
│                                                          │
│   Idle → Initializing → Executing → [Success | Diag]    │
│                                                          │
│   • Context Store: {{var}} extraction & injection        │
│   • Assertion Engine: spec-derived + AI-generated        │
│   • State persistence across workflow steps              │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│                 Diagnostic & Healing Layer                │
│                                                          │
│   On failure: AI Root Cause Analysis → Propose fix       │
│   → Human approval → Heal & re-execute (max 3 retries)  │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│                    KPI & Reporting Layer                  │
│                                                          │
│   • Test coverage (endpoints hit / total endpoints)      │
│   • Assertion quality (spec constraints covered)         │
│   • Self-heal success rate (healed / total failures)     │
│   • Agent consensus score (survived / total findings)    │
│   • Execution performance (p50/p95 response times)       │
└──────────────────────────────────────────────────────────┘
```

#### 3.3 Component Design

**Component 1: Multi-Agent Test Strategy Generation**

Instead of a single LLM call to generate tests, I use three agents in a pipeline inspired by Agentize's planning system:

1. **Generator Agent** — Reads the API spec and produces a comprehensive set of test scenarios: functional correctness, edge cases (null, empty, boundary values), error handling (4xx/5xx), security (missing auth, injection), and multi-step workflows. Produces breadth.

2. **Critic Agent** — Reviews the Generator's plan against the actual spec. Flags impossible assertions (e.g., asserting a field exists when the spec marks it optional), redundant tests, and missing critical paths. This is analogous to Agentize's `proposal-critique` agent.

3. **Reducer Agent** — Simplifies the validated plan by removing redundant tests, merging overlapping scenarios, and ensuring the final plan is minimal yet comprehensive. Follows the "less is more" philosophy from Agentize's `proposal-reducer`.

Each agent extends API Dash's existing `AIAgent` abstract class from the `genai` package and uses `APIDashAgentCaller` for execution. The multi-agent pipeline runs sequentially (Generator → Critic → Reducer) with structured JSON passed between stages.

```dart
class TestGeneratorAgent extends AIAgent {
  @override
  String get agentName => 'TestGenerator';

  @override
  String getSystemPrompt() => '''
You are an API test strategist. Given an OpenAPI specification,
generate a comprehensive test plan as structured JSON.
Include: functional, edge-case, error-handling, and workflow tests.
For each test, specify: name, method, path, body, headers,
expected_status, assertions, and extract_to_env mappings.
''';

  @override
  bool Function(String) get validator => (response) {
    try {
      final plan = jsonDecode(response);
      return plan['tests'] is List && plan['tests'].isNotEmpty;
    } catch (_) {
      return false;
    }
  };
}
```

**Component 2: FSM Execution Engine**

Drawing on the FSM orchestrator I built for Agentize, the execution engine is a pure Dart state machine with no Flutter dependencies (enabling CLI/CI use):

```
States: Idle → Initializing → Executing → Success
                                  ↓
                           DiagnosticMode → Healed → Re-Executing
                                  ↓
                               Failed
```

Key features:
- **Context Store:** A `Map<String, dynamic>` that automatically extracts variables from responses (auth tokens, IDs, pagination cursors) using JSONPath selectors and injects them into subsequent requests via `{{variable}}` template syntax.
- **Assertion Engine:** Combines spec-derived assertions (status codes, response schemas, required fields) with AI-generated assertions (semantic checks, format validation, cross-field consistency).
- **Checkpoint Persistence:** State is serialized to JSON after each step, enabling resume-on-failure and time-travel debugging (inspect the context store at any point in the workflow).

The engine uses API Dash's existing `better_networking` package for HTTP execution and `apidash_core` models for request/response handling.

**Component 3: Diagnostic & Self-Healing**

When a test step fails, the engine enters DiagnosticMode:

1. Collects: actual response, expected assertions, API spec for that endpoint, context store state
2. Sends to a Diagnostic Agent that performs root cause analysis (not the same agent that generated the test — fresh perspective)
3. The agent classifies the failure: **spec drift** (API changed), **test error** (wrong assertion), or **environment issue** (auth expired, server down)
4. For spec drift and test errors: proposes a targeted fix (update assertion, add header, modify body)
5. Fix is presented to the user in DashBot with **approve/reject** controls
6. On approval: apply fix, transition to Re-Executing state
7. Hard limit: 3 diagnostic iterations per test step, then mark as Failed with full diagnostic trace

**Component 4: KPI Measurement & Reporting**

Inspired by Agentize's structured quality assessments, every test run produces measurable KPIs:

| KPI | What it measures | How it's computed |
|-----|-----------------|-------------------|
| Endpoint Coverage | Breadth of testing | endpoints tested / total endpoints in spec |
| Assertion Density | Depth of validation | assertions per test step (target: ≥3) |
| Self-Heal Rate | Healing effectiveness | successfully healed / total failures |
| Agent Consensus | Strategy quality | critic-approved tests / generator-proposed tests |
| Response Time Distribution | Performance profile | p50, p95, p99 across all test steps |
| Workflow Completion Rate | E2E reliability | fully completed workflows / total workflows |

KPIs are displayed in a dashboard widget in DashBot and exportable as JSON for CI integration.

**Component 5: MCP Apps Integration**

API Dash acts as an MCP server exposing testing tools to external agents:

- `generate_test_plan(spec_url)` — Returns a multi-agent-validated test plan
- `execute_test_suite(plan_id, env)` — Runs a test suite and returns results with KPIs
- `get_test_report(run_id)` — Returns detailed test report with diagnostic traces
- `list_test_suites()` — Lists saved test suites in the workspace

Using the [MCP Apps specification](https://dev.to/ashita/a-practical-guide-to-building-mcp-apps-1bfm), interactive UI surfaces can be rendered in agent chat:
- **Test Plan Viewer:** Visual representation of the test strategy with approval controls
- **Live Execution Dashboard:** Real-time test progress with KPI gauges
- **Diagnostic Console:** Failure details with one-click healing approval

Implementation uses the Dart MCP SDK, with `ApiTestRunner` methods mapped to MCP tool handlers.

#### 3.4 How This Builds on API Dash

Every component reuses existing infrastructure:

| API Dash Component | How I Use It |
|---|---|
| `AIAgent` abstract class (`genai`) | Base class for Generator, Critic, Reducer, Diagnostic agents |
| `AIAgentService` orchestration | Agent execution with retry logic and validation |
| `APIDashAgentCaller` singleton | Entry point for all agent invocations |
| `better_networking` | HTTP execution in the FSM engine |
| `apidash_core` models | Request/response data structures |
| `DashBot` chat interface | Human-in-the-loop approval and KPI display |
| `ChatAction` system | Test plan review and healing approval actions |
| `Riverpod` providers | State management for test runs and results |
| `apidash_design_system` | Consistent UI for test dashboard |

#### 3.5 Key Focus Areas of This Proposal

- **Multi-agent test generation:** Using a pipeline of specialized agents (Generator → Critic → Reducer) to improve test plan quality through iterative refinement
- **FSM-based execution:** Leveraging patterns from Agentize's FSM orchestrator for deterministic, checkpoint-persistent workflow execution
- **KPI measurement:** Providing quantitative metrics (coverage, assertion density, self-heal rate) to help developers and mentors evaluate testing effectiveness
- **Research-informed design:** Drawing on graduate research experience with multi-agent systems and adversarial validation

**4. Weekly Timeline (175 hours)**

**Pre-Bonding (Mar 25 – May 8):**
- Join API Dash Discord, introduce myself, engage with mentors
- Set up development environment, run existing test suite
- Study `genai` package internals, `AIAgent` interface, `APIDashAgentCaller` flow
- Prototype OpenAPI spec parser extracting endpoint metadata
- Submit exploratory PR (bug fix or test improvement)

**Community Bonding (May 8 – Jun 1):**
- Finalize technical design with mentors
- Agree on test plan JSON schema and assertion DSL
- Set up branch and CI pipeline for the project
- Write design doc covering agent prompts, FSM states, and KPI formulas

---

**Week 1–2 (Jun 2 – Jun 15) — Multi-Agent Test Strategy Layer** *(~30 hours)*
- Implement `TestGeneratorAgent`, `TestCriticAgent`, `TestReducerAgent` extending `AIAgent`
- Build the sequential pipeline: Generator → Critic → Reducer
- Add OpenAPI 3.x spec parsing (endpoints, schemas, required fields, auth schemes)
- Output: validated test plan JSON from a real OpenAPI spec
- Unit tests for each agent's validator and the pipeline composition

**Week 3–4 (Jun 16 – Jun 29) — FSM Execution Engine** *(~30 hours)*
- Implement FSM with states: Idle → Initializing → Executing → Success/DiagnosticMode
- Build Context Store with JSONPath extraction and `{{var}}` injection
- Build Assertion Engine: spec-derived assertions + AI-generated assertions
- Wire execution to `better_networking` for real HTTP calls
- Add checkpoint persistence (JSON serialization of state after each step)
- Unit tests for FSM transitions, context store, and assertion evaluation

**Week 5–6 (Jun 30 – Jul 13) — DashBot Integration & Human-in-the-Loop** *(~25 hours)*
- Integrate test plan generation into DashBot chat flow
- Add new `ChatMessageType` for test plan review and test results
- Build approval UI: review test plan, edit individual tests, approve/reject
- Display test execution progress in DashBot with live status updates
- Widget tests for the new DashBot interactions

**Midterm Evaluation (Jul 14 – Jul 18) — Buffer & Review** *(~10 hours)*
- Merge Phase 1 (agents + FSM + DashBot integration)
- Write documentation for implemented components
- Demo to mentors, collect feedback for Phase 2
- Prepare midterm evaluation submission

**Week 7–8 (Jul 15 – Jul 28) — Diagnostic & Self-Healing** *(~25 hours)*
- Implement DiagnosticAgent with root cause analysis
- Build failure classification: spec drift vs test error vs environment issue
- Add healing proposal UI with approve/reject in DashBot
- Implement heal-and-re-execute flow with 3-retry limit
- E2E tests: trigger failure → diagnostic → heal → re-execute → success

**Week 9–10 (Jul 29 – Aug 11) — KPI Measurement & MCP Integration** *(~30 hours)*
- Implement KPI computation: coverage, assertion density, self-heal rate, consensus score
- Build KPI dashboard widget in DashBot
- Implement MCP server with `generate_test_plan`, `execute_test_suite`, `get_test_report` tools
- Add JSON export for CI/CD integration
- Integration tests against real API endpoints

**Week 11–12 (Aug 12 – Aug 25) — Polish, Documentation & Final Submission** *(~25 hours)*
- Performance optimization for large specs (batched parsing, concurrent agent calls)
- Comprehensive documentation: API reference, user guide, contributor guide
- Final testing pass: unit, widget, integration, e2e
- Record demo video showcasing the full workflow
- Prepare final evaluation submission

---

**Total: 175 hours**

#### Risks and Mitigations

| Risk | Mitigation |
|------|-----------|
| Multi-agent pipeline adds latency | Agents run sequentially but each uses streaming; Critic + Reducer are optional (user can skip for quick mode) |
| LLM output parsing failures | Reuse `AIAgentService`'s built-in retry/validation loop (5 attempts with exponential backoff) |
| Large OpenAPI specs exceed context | Batch specs by resource/tag, process independently, merge results |
| MCP SDK maturity in Dart | MCP integration is in the final phase; core testing works without it |
