# Initial Idea Submission

**Full Name:** Himanshu Ravindra Iwanati

**University Name:** Indian Institute of Technology, Kharagpur

**Program you are enrolled in (Degree & Major/Minor):** B.Tech, Department of Electrical Engineering

**Year:** 3rd Year

**Expected Graduation Date:** May 2027

---

# Agentic API Testing for API Dash — GSoC 2026 Proposal

---

## 1. Title & Abstract

### 1.1 Project Title

**Agentic API Testing for API Dash: An Autonomous, Self-Healing Test Generation Framework**

### 1.2 Abstract

#### 1.2.1 Problem Statement: Manual API Testing Limitations

Modern API development faces a critical bottleneck: **manual test creation consumes 30–50% of developer time** while producing brittle, unmaintainable test suites that fracture under the slightest schema evolution. Traditional approaches require developers to manually translate API specifications into executable tests, maintain hardcoded assertions, and continuously repair broken tests when APIs change—a process that scales linearly with API complexity and becomes unsustainable for microservices architectures with hundreds of interdependent endpoints.

#### 1.2.2 Proposed Solution: Agentic AI Layer Integration

This proposal introduces **Agentic API Testing**, a comprehensive AI-powered testing framework natively integrated into API Dash. The system leverages **large language models (LLMs)** with **structured tool-calling capabilities** to autonomously parse API specifications (OpenAPI 3.x, Postman Collections, GraphQL schemas), generate intelligent test strategies covering happy paths, edge cases, and security scenarios, execute multi-step workflows with dynamic context propagation, and **self-heal** when APIs evolve—automatically detecting schema drift and updating assertions without human intervention.

---

## 2. Motivation & Problem Statement

#### 2.1 Dynamic Adaptation Without Human Intervention

The defining capability of agentic testing is **self-healing**—automatic detection. When an API changes, the system does not simply fail and await human repair; it **detects the nature of the change**, assesses whether existing tests remain valid, and **automatically updates or regenerates** affected test components. This requires:

1. **Schema drift detection** through continuous monitoring of API responses
2. **Semantic understanding** to distinguish breaking changes from non-breaking additions
3. **Test case mutation** to adapt assertions and data generation to new specifications
4. **Validation** that healed tests remain correct through execution against the updated API

#### 2.2 Natural Language Interface for Test Specification

Agentic systems enable a **radical simplification of test specification**. Rather than writing code, users describe testing goals in natural language:

> *"Test the user registration flow including email verification, password validation, and duplicate account handling"*

This interface **democratizes API testing**, enabling product managers, QA analysts, and less technical stakeholders to specify comprehensive test coverage without programming expertise.

### 2.5 Real-World Failure Scenarios

#### 2.5.1 Schema Drift in Production APIs

**Scenario**: E-commerce platform "ShopFlow" releases API v2.3, changing `order.total` from `number` to `object` with `currency` and `amount` fields. Existing integration tests assert `typeof response.total === 'number'`, causing **100% test suite failure** despite API correctness. Developers spend **8 hours** diagnosing the intentional change. Meanwhile, production monitoring lacks coverage for the new structure, causing **$47K in incorrect international charges** before detection.

**Agentic Prevention**: The self-healing engine detects the type migration during canary deployment, generates updated assertions for the new structure, flags the semantic change in `currency` default for human review, and maintains **continuous coverage** without CI breakage.

#### 2.5.2 Broken Authentication Flows in Multi-Step Workflows

**Scenario**: Fintech "PaySecure" implements OAuth 2.0 with PKCE for mobile clients. A **manual test suite** validates each step independently but never exercises the **full chain**: refresh → immediate API call with new token → verify no 401. When the token endpoint begins returning `expires_in` as string `"3600"` rather than number `3600`, the mobile client's parsing fails. **Production users experience random logouts**; **2-star app rating crash** costs an estimated **$200K in acquisition spend waste**.

**Agentic Prevention**: The workflow executor maintains **execution context** across steps, validating that `access_token` successfully authenticates subsequent requests. Schema validation on the token response catches the type discrepancy.

#### 2.5.3 Undetected Rate Limiting Edge Cases

**Scenario**: SaaS "DataStream" implements tiered rate limits: 100 req/min for free, 1000 req/min for pro. Manual tests verify limits at **steady-state** but miss **burst behavior**: the pro tier's 1000 req/min is enforced as a **100 req/6sec sliding window**, causing **unexpected 429 responses** for legitimate burst patterns. Support spends **40 hours** reproducing before engineering identifies the window implementation. **3 enterprise trials churn** due to reliability concerns.

**Agentic Prevention**: The test strategy planner generates **edge case scenarios** including burst patterns, sliding window verification, and backoff behavior.

---

## 3. Proposed Solution

### 3.1 High-Level System Narrative

#### 3.1.1 Autonomous Test Generation from API Specifications

The Agentic API Testing system transforms **static API specifications into dynamic, intelligent test suites** through a multi-stage pipeline. Upon specification ingestion, the **SpecParser** normalizes diverse formats into a unified **AgentTask graph**—a directed acyclic graph representing API operations, their dependencies, and data flows.

The **TestStrategyPlanner** then operates on this graph as a planning problem. Using an LLM with tool-calling capabilities, it generates **test strategies** for each operation considering: happy path validation, boundary value analysis, equivalence class partitioning, error injection, security testing, and performance baseline establishment.

Each strategy is instantiated into **concrete test cases** with generated test data, expected response assertions, and dependency specifications. The result is a **comprehensive, prioritized test suite** that maximizes coverage within execution time constraints.

### 3.2 System Architecture Overview

#### 3.2.1 Component Interaction Model

![Workflow](images/hihry_workflow.png)


#### 3.2.2 Data Flow Directionality

| Flow Direction | Data Type | Purpose |
|---|---|---|
| Input → Parser | Raw spec files (JSON/YAML) | Normalization and validation |
| Parser → Core | `AgentTask` graph | Structured workflow representation |
| Core → Planner | Task metadata + user intent | Test strategy generation |
| Planner → Executor | `APITestCase` instances | Executable test definitions |
| Executor → Context | Runtime state (tokens, variables) | Cross-step persistence |
| Executor → Healing | Response snapshots + failures | Drift detection input |
| Healing → Executor | Updated assertions + paths | Remediation output |
| Executor → Reporter | Execution traces + results | Structured reporting |
| Core ↔ UI | State updates + user commands | Interactive control |

### 3.3 Core Component Specifications

#### 3.3.1 AgentCore: Orchestration and Workflow Decomposition

The `AgentCore` serves as the **central nervous system**, coordinating all other components. Its responsibilities include:

- **Session management**: Maintaining user context across multiple test generation and execution requests
- **Workflow decomposition**: Breaking complex natural language objectives into discrete, ordered tasks with dependency analysis
- **State machine enforcement**: Ensuring valid transitions between IDLE, PARSING, PLANNING, EXECUTING, VALIDATING, REPORTING, and HEALING states
- **Resource scheduling**: Prioritizing test execution based on risk, coverage gaps, and user-specified urgency
- **Error aggregation**: Collecting and categorizing failures across components for unified reporting

#### 3.3.2 SpecParser: Multi-Format Schema Ingestion

| Format | Version | Features | Complexity |
|---|---|---|---|
| OpenAPI | 3.0.x, 3.1.x | Full schema, links, callbacks, webhooks | High |
|  Collection folders | v2.1 | Variables, scripts, auth, folders | Medium |
| GraphQL | Introspection | Queries, mutations, subscriptions, fragments | High |
| API Blueprint | 1A | Legacy support for migration scenarios | Low |

#### 3.3.3 TestStrategyPlanner: LLM-Powered Test Strategy Generation

| Test Type | Trigger | LLM Prompt Focus |
|---|---|---|
| Happy path | All endpoints | Verify nominal behavior with valid inputs |
| Boundary value | Numeric/string parameters | Test min, max, and edge values |
| Error injection | Error-prone operations | Verify graceful failure handling |
| Security probe | Auth-required endpoints | Test authentication bypass, injection, traversal |
| Rate limit | Documented limits | Verify throttling behavior and headers |
| Schema validation | All responses | Validate against specification with strictness tiers |

#### 3.3.4 WorkflowExecutor: Multi-Step API Call Chain Execution

- **Context management**: Maintaining `ExecutionContext` with token storage, variable substitution, and cross-step data extraction
- **Dynamic substitution**: Supporting template expressions (`{{step1.response.body.id}}`, `{{env.BASE_URL}}`, `{{random.email}}`)
- **Parallel execution**: Using Dart isolates for CPU-bound operations while maintaining async I/O for network requests
- **Resilience patterns**: Exponential backoff, circuit breaking, and timeout handling with configurable policies

#### 3.3.5 SelfHealingEngine: Schema Drift Detection and Auto-Remediation

| Drift Severity | Automated Action | Human Notification |
|---|---|---|
| Cosmetic (whitespace, ordering) | Silent acceptance | None |
| Compatible (new optional fields) | Test update | Summary digest |
| Breaking (required changes) | Proposed patch | Immediate alert with diff |
| Architectural (endpoint removal) | Suite restructuring | Blocking review required |

#### 3.3.6 ReportGenerator: Multi-Format Output

- **JSON**: Machine-parseable for CI/CD integration, with detailed execution traces and timing
- **HTML**: Rich visualization with collapsible request/response details, coverage heatmaps, and trend comparison
- **Markdown**: Repository-friendly for documentation, PR descriptions, and issue comments

### 3.4 End-User Workflow Description

#### 3.4.1 Specification Import and Parsing

A developer opens API Dash and navigates to the **Agent panel**. They select "Import Specification" and upload their `openapi.yaml` file. The `SpecParser` validates syntax, displays a **structure preview**, and highlights any parsing warnings. The developer confirms import, and the system generates an initial **coverage assessment**.

#### 3.4.2 Natural Language Test Generation Request

In the agent chat, the developer types:

> *"Generate comprehensive tests for the payment endpoints, focusing on error handling and security, but skip the webhook callbacks for now."*

The planner responds with a **strategy preview**: 12 happy path tests, 8 boundary value tests, 6 security probes, 4 error injection scenarios—**28 total, estimated 4.2 minutes execution**.

#### 3.4.3 Autonomous Test Execution and Validation

The `WorkflowExecutor` begins **parallel execution** with real-time progress display. Tests complete with **94% pass rate**; two failures are flagged: a **schema drift** in refund response and an **authentication edge case**. The `SelfHealingEngine` automatically patches the schema assertion.

#### 3.4.4 Report Review and Iterative Refinement

The developer reviews the **HTML report**, noting improved coverage from **34% to 87%**. They export Markdown for the team wiki and schedule **nightly execution** via CI integration. The entire workflow—from import to committed tests—completes in **12 minutes versus 4+ hours manual effort**.

---

## 4. Technical Implementation Details

### 4.1 Agent Workflow State Machine

![State Machine](images/hihry_stateMachine.png)

#### 4.4.1 State Transition Table

| Transition | Condition | Action |
|---|---|---|
| IDLE → PARSING | User submits specification | Initialize parser, validate format hint |
| PARSING → PLANNING | Parser returns valid AgentTaskGraph | Load templates, initialize LLM client |
| PARSING → FAILED | ParseException or timeout | Log error, notify user with diagnostics |
| PLANNING → EXECUTING | Non-empty strategy generated | Initialize execution context, queue tests |
| EXECUTING → HEALING | Schema mismatch detected with drift pattern | Pause execution, invoke healing analysis |
| HEALING → EXECUTING | Patch validated with confidence ≥ threshold | Apply patch, resume from failed test |
| HEALING → FAILED | Max iterations (default: 3) exceeded | Escalate to human with full context |
| Any → FAILED | Unhandled exception or cancellation | Cleanup resources, preserve partial state |

### 4.7 Error Handling and Fallback Strategies

#### 4.7.1 LLM Output Validation and Retry Logic

| Failure Mode | Detection | Retry Strategy | Escalation |
|---|---|---|---|
| Invalid JSON | ParseException | Retry with stricter temperature (0.0) | After 3 retries: use JSON mode fallback |
| Missing required fields | Schema validation failure | Retry with explicit field enumeration | After 2 retries: rule-based generation |
| Hallucinated endpoints | Unknown taskId references | Cross-reference with input graph | After 2 retries: filter invalid, continue |
| LLM API failure | Timeout, rate limit, 5xx | Exponential backoff with provider switch | After all providers fail: offline mode |

#### 4.7.2 Graceful Degradation to Rule-Based Testing

| Rule Category | Implementation | Coverage |
|---|---|---|
| Required field presence | Generate tests with all required fields, then omit each | Basic validation coverage |
| Type-based boundaries | Min/max for numbers, length limits for strings | Boundary value coverage |
| Status code enumeration | Test all documented success and error codes | Status coverage |
| Security scheme application | Apply each security scheme, test without authentication | Security baseline |

---

## 5. Flutter UI Integration

### 5.1 UI Architecture

![User Interface](images/hihry_ui.png)

For Now I have just roughly draw it on Excalidraw

## 6. Risks & Mitigation

### 6.1 LLM Hallucination in Test Generation

**Risk**: Large language models may generate test cases that appear plausible but are semantically invalid—requesting non-existent endpoints, using incorrect parameter types, or asserting properties that don't match API behavior.

**Mitigation:**

| Layer | Implementation | Effectiveness |
|---|---|---|
| Structural validation | JSON Schema validation of LLM output | Catches 90%+ of format errors |
| Semantic validation | Cross-reference with parsed spec | Catches invalid endpoint/method references |
| Multi-shot prompting | Retry with error feedback | 50%+ recovery from initial failures |
| Confidence thresholding | Low confidence → human review | Final safety net for uncertain cases |

### 6.2 API Specification Ambiguity

**Risk**: Real-world API specifications often contain ambiguities: unspecified error codes, undocumented behavior, or contradictory examples.

**Mitigation:**

| Strategy | Implementation | When Applied |
|---|---|---|
| Conservative defaults | Skip unspecified behaviors rather than assume | Error codes without documented response |
| Explicit uncertainty | Flag ambiguous areas in generated tests | Multiple conflicting examples |
| Interactive clarification | Prompt user for guidance | High-impact ambiguity detected |

### 6.3 LLM Provider API Instability

**Risk**: LLM providers may modify APIs, deprecate models, or change pricing. Service outages may block test generation entirely.

**Mitigation**: Unified `LlmClient` abstraction; provider health monitoring; pre-configured fallback chain (Primary → Secondary → Local Ollama); SHA-indexed generation cache for unchanged specs.

---

## 7. MCP Apps Integration: Bidirectional UI Layer for Agentic Workflows

The agentic pipeline described in Section 3 produces two categories of output that are fundamentally ill-suited to plain text rendering inside a chat interface:

1. **Structured Decision Points** — After `TestStrategyPlanner` generates a test suite of 20–50 test cases, the developer must selectively approve, reject, or reprioritize individual tests before execution. Presenting this as a numbered list in the Agent Chat Interface forces the user to type case-by-case exclusions in natural language—a fragile, error-prone interaction pattern that reintroduces manual effort the framework is designed to eliminate.

2. **Structured Diff Review** — When `SelfHealingEngine` proposes a patch to a broken assertion, the developer must compare the old and new assertion to make an informed approve/reject decision. A text description of the diff is semantically lossy and cognitively demanding; it fails to surface the spatial relationship between what changed and why.

Both cases share the same root problem: **the information the agent produces is inherently visual and interactive, but the only available output channel is linear text.** The Model Context Protocol (MCP) Apps extension directly addresses this gap.

---

### 7.1 What MCP Apps Provide

MCP Apps extend the open-source Model Context Protocol with a standardized mechanism for MCP servers to deliver **rich, bidirectional UI components**—HTML rendered as sandboxed iframes natively inside AI hosts—without requiring external web apps, custom authentication, or broken conversational context.

---

### 7.2 Integration Points in the Agentic Pipeline

#### 7.2.1 Node 1 — `TestStrategyPlanner`: Interactive Test Review & Approval

**Problem without MCP Apps:**
The `TestStrategyPlanner` outputs a list of `APITestCase` objects. Displaying these as raw text in the Agent Chat Interface gives the developer no ergonomic way to selectively approve tests without manually typing exclusions. Mistyped or ambiguous natural language exclusions risk silently including unwanted tests in execution.

**Solution with MCP Apps:**
When the `plan_tests` tool fires, the host renders the `test-review` MCP App—a sandboxed HTML table where each generated test case is a toggleable row. The developer interacts with the table and confirms their selection; the iframe then sends the filtered list back into the agent's context via `ui/update-model-context` as structured JSON. `AgentCore` receives this payload and transitions to `EXECUTING` only with the approved test cases.

**MCP App: `test-review`**

| UI Element | Data Source | Interaction |
|---|---|---|
| Test name column | `APITestCase.name` | Read-only label |
| Type badge | `APITestCase.type` (happy path, security, boundary...) | Color-coded badge |
| Priority indicator | Planner-assigned risk score | Star/dot indicator |
| Toggle switch | Default: ON | User can disable individual tests |
| Endpoint tag | `APITestCase.method` + `APITestCase.path` | Read-only `GET /users/{id}` |
| Confirm button | Selected subset | Sends `ui/update-model-context` with approved list |
| Select All / None | Bulk action | Shortcut toggles |

---

#### 7.2.2 Node 2 — `SelfHealingEngine`: Visual Diff Review & Patch Approval

**Problem without MCP Apps:**
When the `SelfHealingEngine` generates a patch for a drifted assertion, the state machine (Section 4.1) requires human review for `BREAKING` and `ARCHITECTURAL` severity drifts. Presenting the proposed patch as text forces the developer to mentally reconstruct the before/after relationship, a cognitively expensive task especially for nested JSON schema changes.

**Solution with MCP Apps:**
When `patchRequiresReview` is triggered, the `SelfHealingEngine` invokes the `review_patch` tool. The host renders the `healing-diff` MCP App—a side-by-side diff viewer with color-coded removals (red) and additions (green), structured by assertion path. The developer reviews and makes one of three decisions: **Approve** (patch applied, execution resumes), **Reject** (escalate to FAILED), or **Edit** (open in Test Wizard for manual correction). The decision is sent back to the agent via `ui/message`.

**MCP App: `healing-diff`**

| UI Element | Data Source | Interaction |
|---|---|---|
| Diff header | Endpoint path + HTTP method | Read-only |
| Severity badge | `DriftSeverity` enum | Color: yellow (compatible) / red (breaking) |
| Left panel (Before) | Original assertion JSON | Syntax-highlighted, read-only |
| Right panel (After) | Proposed patched assertion | Syntax-highlighted, read-only |
| Changed fields | Diff delta lines | Highlighted in red (removed) / green (added) |
| Confidence score | `SelfHealingEngine.confidenceScore` | Shown as `87% confidence` indicator |
| Approve button | — | Sends `ui/message` with `{ decision: "approve" }` |
| Reject button | — | Sends `ui/message` with `{ decision: "reject" }` |
| Edit button | — | Opens patched assertion in Test Wizard for manual correction |
| Context note | LLM explanation of why the drift occurred | Collapsible text block |

---

### 7.3 MCP Apps Protocol Integration in Flutter (API Dash as MCP Host)

API Dash is a Flutter application. The MCP Apps specification defines the **host-side responsibilities**: rendering the sandboxed iframe, mediating the JSON-RPC bridge, and injecting `hostContext` CSS variables. To implement this in Flutter:

#### 7.3.1 Flutter WebView as MCP App Host

API Dash will embed `webview_flutter` to render MCP App HTML resources. The WebView acts as the sandboxed iframe equivalent, with all external network access controlled via the `_meta.ui.csp` declaration on each registered resource.

### 7.4 DashBot Integration

API Dash's existing **DashBot** AI assistant is the natural host for the `AgentCore` natural language interface described in Section 3.4.2. The MCP Apps layer enhances DashBot's existing capabilities by adding structured visual output at key decision points, without replacing its conversational interface.

| DashBot Existing Capability | Agentic Testing Extension | MCP App Enhancement |
|---|---|---|
| Natural language API queries | Natural language test generation requests | `test-review` MCP App for approval |
| Response explanation | Test failure explanation | `healing-diff` MCP App for patch review |
| Collection browsing | Spec ingestion from collections | `execution-monitor` MCP App for live progress |
| Environment variable hints | Dynamic variable substitution in `WorkflowExecutor` | None (handled internally) |

---

## 8. About the Contributor

Hi, This is Himanshu Ravindra Iwanati I am a Third Year Graduate student, I have interest in building multiple-system AI agents throuhg LangGraph and implementing RAG pipelines, I also have a knee interest in robotics, I have also contributed to Moveit2 which is a industry standard robotics framework widely followed

### 8.1 Contact and Portfolio

| Channel | Value |
|---|---|
| **GitHub** | https://github.com/hihry |
| **LinkedIn** | https://www.linkedin.com/in/himanshu-iwanati-87459b282/ |
| **Timezone** | IST (UTC+5:30) |

---

