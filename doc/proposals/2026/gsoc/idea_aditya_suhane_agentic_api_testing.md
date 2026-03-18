### Initial Idea Submission

**Full Name:** Aditya Suhane
**University name:** Gyan Ganga Institute of Technology and Sciences
**Program you are enrolled in (Degree & Major/Minor):** Bachelor of Technology in Computer Science Engineering (Data Science)
**Year:** 4th
**Expected graduation date:** June 2026

**Project Title:** Agentic API Testing with MCP Apps Integration

**Relevant issues:**
- [#100 - Stress Testing](https://github.com/foss42/apidash/issues/100)
- [#96 - API Test Automation](https://github.com/foss42/apidash/issues/96)
- [#1158 - GSoC 2026 Idea #4](https://github.com/foss42/apidash/issues/1158)

---

## Idea Description

### The Vision: API Dash as an AI Testing Platform

My proposal transforms API Dash from a standalone API client into an **AI-accessible testing platform** through MCP (Model Context Protocol) integration. External AI agents (Claude Desktop, VS Code Copilot, Cursor) can orchestrate API testing workflows through API Dash without users leaving their preferred environment.

```
┌─────────────────────────────────────────────────────────────────┐
│                    External AI Hosts                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ Claude   │  │ VS Code  │  │  Cursor  │  │  Custom  │       │
│  │ Desktop  │  │ Copilot  │  │   IDE    │  │  Agents  │       │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘       │
│       │             │             │             │               │
│       └─────────────┴──────┬──────┴─────────────┘               │
│                            │ MCP Protocol                       │
└────────────────────────────┼────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                   API Dash MCP Server                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    MCP Tools                             │   │
│  │  • execute_request  • generate_tests  • run_tests       │   │
│  │  • analyze_spec     • get_collection  • validate_results│   │
│  └─────────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                 MCP Apps (Rich UIs)                      │   │
│  │  • Test Configuration Panel  • Results Dashboard        │   │
│  │  • Approval Checkpoints      • Self-Healing Review      │   │
│  └─────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                 Agent Orchestration Layer                        │
│         (LangGraph-style State Machine + HITL Checkpoints)      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │Test Gen  │─▶│ Executor │─▶│Validator │─▶│ Healer   │       │
│  │  Agent   │  │  Agent   │  │  Agent   │  │  Agent   │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

### Why MCP Apps? (My Unique Angle)

Most agentic testing proposals focus only on the agent logic. I propose integrating **MCP Apps** - rich, interactive UI components that render inside AI hosts:

| Feature | Without MCP Apps | With MCP Apps |
|---------|------------------|---------------|
| Test approval | Text-only in chat | Interactive checklist UI |
| Results review | JSON dump | Visual dashboard with charts |
| Self-healing | Accept/reject text | Side-by-side diff viewer |
| Configuration | Manual prompting | Form-based config panel |

**Example: Test Approval Checkpoint**
```
User in Claude Desktop: "Test my authentication API"

Claude: "I've generated 8 test cases for /api/auth/*"
        [MCP App: Interactive Test Review Panel]
        ┌─────────────────────────────────────────┐
        │ Generated Tests                    [✓] All │
        │ ┌─────────────────────────────────────┐ │
        │ │ [✓] Valid login credentials         │ │
        │ │ [✓] Invalid password                │ │
        │ │ [✓] Missing auth header             │ │
        │ │ [ ] SQL injection attempt           │ │
        │ │ [✓] Rate limiting (10 req/sec)      │ │
        │ └─────────────────────────────────────┘ │
        │        [Run Selected] [Regenerate]      │
        └─────────────────────────────────────────┘
```

### Core Architecture: Hybrid Approach

I follow the hybrid architecture specified in the project requirements:

#### High-Level Architecture

```mermaid
flowchart TB
    subgraph External["External AI Hosts"]
        Claude["Claude Desktop"]
        VSCode["VS Code Copilot"]
        Cursor["Cursor IDE"]
    end

    subgraph MCP["API Dash MCP Server"]
        Tools["MCP Tools<br/>execute_request | generate_tests | run_tests"]
        Apps["MCP Apps (Rich UIs)<br/>Config Panel | Dashboard | Approval UI"]
    end

    subgraph Agents["Agent Orchestration Layer"]
        Gen["Test Generator"]
        Exec["Test Executor"]
        Valid["Validator"]
        Heal["Self-Healer"]
    end

    subgraph AI["AI Providers"]
        LLM["Claude | GPT-4 | Mistral | Ollama"]
    end

    External -->|"MCP Protocol"| MCP
    MCP --> Agents
    Agents -->|"Prompts"| AI
    AI -->|"Responses"| Agents

    Gen --> Exec --> Valid --> Heal
    Heal -.->|"If needs fix"| Gen
```

#### Agent Workflow State Machine

```mermaid
stateDiagram-v2
    [*] --> Idle

    Idle --> AnalyzingSpec: Upload OpenAPI Spec
    AnalyzingSpec --> GeneratingTests: Spec Parsed

    GeneratingTests --> AwaitingTestApproval: Tests Generated
    AwaitingTestApproval --> GeneratingTests: User Requests Changes
    AwaitingTestApproval --> ExecutingTests: User Approves

    ExecutingTests --> AwaitingResultsReview: Execution Complete
    AwaitingResultsReview --> ExecutingTests: User Re-runs
    AwaitingResultsReview --> ValidatingResults: User Proceeds

    ValidatingResults --> HealingTests: Failures Detected
    ValidatingResults --> Completed: All Passed

    HealingTests --> AwaitingHealingApproval: Fixes Proposed
    AwaitingHealingApproval --> HealingTests: User Requests Different Fix
    AwaitingHealingApproval --> ExecutingTests: User Approves Fix

    Completed --> [*]

    note right of AwaitingTestApproval: HITL Checkpoint 1
    note right of AwaitingResultsReview: HITL Checkpoint 2
    note right of AwaitingHealingApproval: HITL Checkpoint 3
```

#### Human-in-the-Loop Flow

```mermaid
sequenceDiagram
    actor User
    participant AI as AI Host (Claude/Copilot)
    participant MCP as API Dash MCP Server
    participant Agent as Agent Orchestrator

    User->>AI: "Test my /users API"
    AI->>MCP: tools/call: analyze_spec
    MCP->>Agent: Parse OpenAPI spec
    Agent-->>MCP: 5 endpoints found
    MCP-->>AI: Spec analysis complete

    AI->>MCP: tools/call: generate_tests
    Agent->>Agent: Generate test cases
    MCP-->>AI: 12 tests generated

    rect rgb(255, 235, 205)
        Note over User,AI: CHECKPOINT 1: Test Approval
        AI->>User: Shows MCP App: Test Config Panel
        User->>AI: Approves 10 tests, skips 2
    end

    AI->>MCP: tools/call: run_tests
    Agent->>Agent: Execute tests
    MCP-->>AI: 8 passed, 2 failed

    rect rgb(255, 235, 205)
        Note over User,AI: CHECKPOINT 2: Results Review
        AI->>User: Shows MCP App: Results Dashboard
        User->>AI: "Why did auth test fail?"
    end

    AI->>MCP: tools/call: heal_tests
    Agent->>Agent: Analyze failures, propose fixes
    MCP-->>AI: Fix: Update expected status 401→403

    rect rgb(255, 235, 205)
        Note over User,AI: CHECKPOINT 3: Healing Approval
        AI->>User: Shows MCP App: Diff Viewer
        User->>AI: Approves fix
    end

    AI->>MCP: tools/call: run_tests (retry)
    Agent->>Agent: Re-execute
    MCP-->>AI: 10/10 passed ✓
    AI->>User: "All tests passing!"
```

#### MCP Apps Integration

```mermaid
flowchart LR
    subgraph Host["AI Host (VS Code / Claude Desktop)"]
        Chat["Chat Interface"]
        Frame["Sandboxed iframe"]
    end

    subgraph Server["API Dash MCP Server"]
        Handler["Request Handler"]
        Resources["MCP Resources"]
    end

    subgraph Apps["MCP Apps (HTML/JS)"]
        Config["Test Config Panel"]
        Runner["Execution Dashboard"]
        Healer["Healing Approval"]
    end

    Chat -->|"1. User: 'Test my API'"| Handler
    Handler -->|"2. tools/call"| Resources
    Resources -->|"3. Return UI resource"| Frame
    Frame -->|"4. Render interactive UI"| Apps
    Apps -->|"5. User clicks [Run Tests]"| Handler
    Handler -->|"6. Execute & stream results"| Frame
    Frame -->|"7. Real-time updates"| Chat
```

**1. LangGraph-Style Agent Orchestration**
- State machine managing workflow transitions
- Conditional routing (skip healing if all tests pass)
- Shared context across agent nodes
- Cyclic flows for iterative refinement

**2. MCP Integration for AI Flexibility**
- Multi-model support (Claude, GPT-4, Mistral, Ollama)
- Users choose preferred AI provider
- Cost optimization (cheap models for simple tasks)
- Local LLMs for privacy-sensitive testing

**3. Human-in-the-Loop Checkpoints**
- After test generation → User approves/edits tests
- After execution → User reviews failures
- Before healing → User confirms proposed fixes

### Implementation Strategy

#### Timeline (12 Weeks)

```mermaid
gantt
    title GSoC 2026 - Agentic API Testing Implementation
    dateFormat  YYYY-MM-DD
    section Phase 1: Foundation
    Assertion Engine           :done, p1a, 2026-05-27, 7d
    Agent Interfaces           :p1b, after p1a, 7d
    MCP Server Skeleton        :p1c, after p1b, 7d
    section Phase 2: Test Generator
    OpenAPI Parser             :p2a, after p1c, 7d
    Prompt Templates           :p2b, after p2a, 7d
    MCP App: Config Panel      :p2c, after p2a, 7d
    section Phase 3: Executor
    HTTP Integration           :p3a, after p2b, 7d
    Execution Modes            :p3b, after p3a, 7d
    MCP App: Dashboard         :p3c, after p3a, 7d
    section Phase 4: Validator & Healer
    Validation Logic           :p4a, after p3b, 7d
    Healing Strategies         :p4b, after p4a, 7d
    MCP App: Approval Panel    :p4c, after p4b, 7d
    section Phase 5: Polish
    E2E Testing                :p5a, after p4c, 7d
    Documentation              :p5b, after p5a, 7d
```

#### Test Generation Strategy

```mermaid
flowchart TD
    Spec["OpenAPI Spec"] --> Parse["Parse Endpoints"]
    Parse --> Analyze["Analyze Each Endpoint"]

    Analyze --> Functional["Functional Tests"]
    Analyze --> Edge["Edge Cases"]
    Analyze --> Security["Security Tests"]
    Analyze --> Perf["Performance Tests"]

    Functional --> F1["✓ Valid inputs → 200"]
    Functional --> F2["✓ CRUD operations"]
    Functional --> F3["✓ Auth flows"]

    Edge --> E1["✓ Boundary values"]
    Edge --> E2["✓ Null/empty inputs"]
    Edge --> E3["✓ Array edge cases"]

    Security --> S1["✓ SQL injection"]
    Security --> S2["✓ XSS attempts"]
    Security --> S3["✓ Auth bypass"]

    Perf --> P1["✓ Response time < 500ms"]
    Perf --> P2["✓ Concurrent requests"]

    F1 & F2 & F3 & E1 & E2 & E3 & S1 & S2 & S3 & P1 & P2 --> Suite["Test Suite"]
    Suite --> Execute["Execute via API Dash"]
```

#### Phase 1: Foundation (Weeks 1-3)
- Implement assertion engine (I've already prototyped this with 15 passing tests)
- Create agent base interfaces and state machine
- Set up MCP server skeleton with stdio/HTTP transport

#### Phase 2: Test Generation Agent (Weeks 4-5)
- OpenAPI/Swagger spec parsing
- Prompt templates for test types (functional, edge, security)
- First MCP App: Test Configuration Panel
- Human checkpoint: Test approval UI

#### Phase 3: Test Executor Agent (Weeks 6-7)
- Integration with API Dash's existing HTTP client
- Sequential/parallel execution modes
- Second MCP App: Execution Progress Dashboard
- Human checkpoint: Results review UI

#### Phase 4: Validator & Self-Healer (Weeks 8-10)
- Validation logic with severity scoring
- Healing strategies (adjust expectations, fix requests, report bugs)
- Third MCP App: Healing Approval Panel
- Confidence scoring for proposed fixes

#### Self-Healing Logic

```mermaid
flowchart TD
    Fail["Test Failed"] --> Analyze["Analyze Failure"]

    Analyze --> Q1{"API Schema<br/>Changed?"}
    Q1 -->|Yes| SchemaChange["Schema Change Detected"]
    Q1 -->|No| Q2{"Response<br/>Different?"}

    Q2 -->|Yes| ResponseChange["Response Pattern Changed"]
    Q2 -->|No| TestBug["Likely Test Bug"]

    SchemaChange --> S1["Strategy: Update Assertions"]
    ResponseChange --> S2["Strategy: Adjust Expectations"]
    TestBug --> S3["Strategy: Fix Test Logic"]

    S1 --> Confidence["Calculate Confidence Score"]
    S2 --> Confidence
    S3 --> Confidence

    Confidence --> Q3{"Score > 0.8?"}
    Q3 -->|Yes| AutoFix["Propose Auto-Fix"]
    Q3 -->|No| Manual["Request Human Review"]

    AutoFix --> HITL["HITL Checkpoint"]
    Manual --> HITL

    HITL --> Q4{"User Approves?"}
    Q4 -->|Yes| Apply["Apply Fix & Re-run"]
    Q4 -->|No| Revise["Revise Strategy"]
    Revise --> Analyze
```

#### Phase 5: MCP Apps & Polish (Weeks 11-12)
- Complete MCP Apps with sandboxed iframes
- End-to-end testing across AI hosts
- Documentation and examples
- Performance optimization

### What I've Already Built

To demonstrate my capability, I've been contributing to API Dash:

**1. Assertion Framework (Prototyped)**
- 5 assertion types: statusCode, responseTime, bodyJson, bodyText, header
- 10 operators: equals, contains, greaterThan, exists, etc.
- JSON path navigation: `user.orders[0].items[1].price`
- 15 comprehensive test cases passing

**2. Testing Documentation (PR #1248 - Open)**
- Added Testing and Assertions guide to scripting documentation
- 10+ real-world examples covering common patterns
- Demonstrates understanding of existing post-response scripting

**3. APIDashAgentCaller Tests (PR #1223 - Open)**
- Added test coverage for existing agentic services
- Shows familiarity with the AI integration architecture

### Why This Approach Works

**Separation of Concerns:**
- AI handles reasoning and test planning
- Dart handles deterministic HTTP execution
- MCP Apps handle human interaction
- No AI hallucination of network calls

**Incremental Value:**
- Each phase delivers usable functionality
- MCP server useful even without full agent system
- Assertion engine standalone package

**Real-World Usability:**
- Users stay in their preferred AI environment
- Rich UIs for complex decisions
- Clear audit trail of agent actions

### Technical Differentiators

| Aspect | My Approach | Why It Matters |
|--------|-------------|----------------|
| **MCP Apps** | Rich interactive UIs | Better UX than text-only |
| **Platform model** | API Dash as MCP server | External agents can use it |
| **Working code** | Assertion framework built | Proof of execution ability |
| **Layered design** | Deterministic + AI | Reliable, testable, trustworthy |

### References

- [MCP Specification](https://modelcontextprotocol.io/docs)
- [MCP Apps Documentation](https://modelcontextprotocol.io/docs/concepts/mcp-apps)
- [LangGraph Concepts](https://langchain-ai.github.io/langgraph/)
- [API Dash Scripting Guide](https://github.com/foss42/apidash/blob/main/doc/user_guide/scripting_user_guide.md)

---

**Contact:** [GitHub: @adityasuhane-06](https://github.com/adityasuhane-06)
