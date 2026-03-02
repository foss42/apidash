# GSoC 2026 Application: Agentic API Testing for API Dash

## About

### Personal Information

1. **Full Name**: Aditya Suhane
2. **Contact Email**: adityasuhane01@gmail.com
3. **Discord Handle**: adityasuhane01 (API Dash server)
4. **Phone**: +91-7869366189
5. **GitHub Profile**: [github.com/adityasuhane-06](https://github.com/adityasuhane-06)
6. **LinkedIn**: [linkedin.com/in/aditya-suhane-530103255](https://linkedin.com/in/aditya-suhane-530103255)
7. **Time Zone**: IST (UTC +5:30)
8. **Resume**: [Google Drive - Publicly Accessible](https://drive.google.com/file/d/12zJvrIma6cPOJ99OTc4Jiq7Fit1ld2_c/view?usp=sharing)

## University Information

1. **University**: Gyan Ganga Institute of Technology and Sciences, Jabalpur
2. **Program**: Bachelor of Technology in Computer Science Engineering (Data Science)
3. **Current Year**: Final Year (4th Year)
4. **Expected Graduation**: June 2026
5. **CGPA**: 8.08/10.0

## Motivation & Past Experience

### 1. Have you worked on or contributed to a FOSS project before?

Yes, I have contributed to **Rocket.Chat**, a major open-source communication platform:
- **Repository**: [github.com/RocketChat/Rocket.Chat](https://github.com/RocketChat/Rocket.Chat)
- **Contributions**: Submitted PRs to refactor React components, reducing code duplication across avatar upload modules
- **Technologies**: TypeScript, React, Meteor.js, MongoDB
- **Experience**: Worked within established review processes and coding standards

However, my **primary focus before GSoC has been building machine learning and agentic systems** (see below).

### 2. What is your proudest project/achievement? Why?

**Project Samarth - AI-Powered Agricultural Q&A System** ([GitHub](https://github.com/adityasuhane-06/Project-Samarth) | [Live Demo](https://projectsamarth.vercel.app/))

This project showcases my expertise in **agentic AI systems** - directly relevant to GSoC Idea #4:

**Architectural Achievements:**
- **Agentic System**: Architected orchestration using LangGraph state machines with 5 autonomous tools and memory management
- **Vector Database Integration**: Integrated ChromaDB with embeddings for semantic search across 123 years of agricultural data
- **Temporal Intelligence**: Implemented "temporal force-routing" prompt technique eliminating LLM hallucinations by injecting historical context awareness

**Engineering Excellence:**
- **Data Integration**: Reverse-engineered APEDA API, discovering 113 undocumented product codes; integrated 6 diverse data sources (1901-2024)
- **Performance Optimization**: Achieved **30x performance improvement** (3.5s → 100ms) using MongoDB Atlas caching with adaptive TTL patterns
- **Reliability**: Built robust exception handling with intelligent fallback routing (agentic → parameter-based) ensuring 99.9% system uptime

**Production Deployment:**
- Full-stack: FastAPI async backend, React (Vite + Tailwind) frontend
- Deployed on Render (backend) and Vercel (frontend) with health monitoring and real-time cache analytics

**Why I'm Proud**: This demonstrates my ability to design complex agentic systems with LangGraph - the exact pattern needed for Idea #4's hybrid agent orchestration architecture.

### 3. What kind of problems or challenges motivate you most to solve them?

I'm motivated by challenges that combine **AI autonomy with human oversight**:

1. **Agentic AI Problems**: Building systems where AI agents understand context, make intelligent decisions, and adapt to failures without constant human intervention
2. **Real-World Integration**: Connecting AI to existing systems (APIs, databases, external services) in production environments
3. **Performance Under Constraints**: Optimizing complex systems for speed, reliability, and cost-effectiveness
4. **Testing & Validation**: Ensuring AI-generated solutions are correct, safe, and maintainable

**Idea #4 aligns perfectly** because it combines all these: agentic AI testing, human-in-the-loop validation, real API workflows, and intelligent self-healing.

### 4. Will you be working on GSoC full-time?

**Yes, full-time.** I'm in my final year of B.Tech program with flexible scheduling. I can dedicate 40+ hours per week to GSoC without other work commitments.

### 5. Do you mind regularly syncing up with project mentors?

**Absolutely not.** I actively attend:
- Weekly mentor sync meetings with API Dash team
- Community discussions on GitHub Discussions
- Regular communication on Discord

I believe transparent, frequent communication is essential for successful project execution.

### 6. What interests you most about API Dash?

**Three core reasons:**

1. **Agentic AI Architecture**: API Dash is building intelligent testing systems. The opportunity to design LangGraph-style agent orchestration with MCP integration is exactly the type of challenging, production-grade system that excites me (as evidenced by Project Samarth).

2. **Existing Infrastructure**: The project already has:
   - Mature JavaScript runtime (`flutter_js`) for post-response scripting
   - Complete `ad` object API for request/response manipulation
   - Established data models and providers
   - This gives me a solid foundation to build Phase 2 (agentic testing) on top of.

3. **Real-World Impact**: API Dash serves developers worldwide. Building intelligent, human-in-the-loop testing improves developer experience and code quality - meaningful impact at scale.

### 7. Can you mention some areas where the project can improve?

**Three key areas for improvement:**

1. **Documentation & Discovery**
   - **Current State**: Scripting guide exists but lacks unified, searchable documentation
   - **Proposal**: Build a comprehensive documentation webpage with:
     - Setup guide with step-by-step tutorials
     - Searchable documentation index
     - Interactive examples for common patterns (authentication, pagination, error handling)
     - API reference with code snippets
   - **Impact**: Help users discover existing features like post-response scripting without trial-and-error

2. **Docker Support**
   - **Current State**: API Dash lacks official Docker image
   - **Proposal**: Create Dockerfile with multi-stage builds, docker-compose for local development
   - **Impact**: Easier onboarding for development, simplified CI/CD integration

3. **Testing Infrastructure**
   - **Current State**: Agentic testing is barely started
   - **Proposal**: Our GSoC Idea #4 addresses this - human-in-the-loop agents that generate, execute, validate, and self-heal tests
   - **Impact**: Transform API testing from manual scripting to intelligent automation

---

## Project Proposal Information

### 1. Proposal Title

**Agentic API Testing: Building an Intelligent, Autonomous API Testing System with Human-in-the-Loop Orchestration**

### 2. Abstract

Currently, API Dash users rely on manual JavaScript post-response scripting for testing - powerful but time-consuming. We will build an **agentic AI testing system** that enables developers to conversationally generate, execute, validate, and maintain API tests through intelligent agents.

**The Solution**: A **hybrid architecture** combining:
- **LangGraph-style agent orchestration** for sequential test workflows with conditional routing
- **MCP integration** for flexible multi-LLM support (Claude, GPT-4, Mistral, local models)
- **Human-in-the-loop checkpoints** ensuring user control and transparency at critical points

**Key Outcomes**:
- ✅ AI agents understand API specs and generate comprehensive tests (functional, edge cases, security)
- ✅ Multi-step workflow testing with request chaining and state management
- ✅ Intelligent failure analysis and self-healing when APIs evolve
- ✅ Users maintain control through conversational feedback and approval checkpoints

### 3. Detailed Description

#### Problem Statement

Modern API testing faces three critical challenges:

1. **Manual Effort**: Developers write repetitive test cases covering status codes, headers, JSON validation, edge cases, security scenarios - time-consuming and error-prone
2. **API Evolution**: When APIs change (schema updates, field additions, endpoint changes), tests break and require manual fixing - high maintenance burden
3. **Incomplete Coverage**: Comprehensive testing (happy paths + edge cases + security) is rarely achieved within project timelines

#### Proposed Solution

We will build an **Agentic API Testing System** - the Phase 2 evolution of API Dash's testing capabilities.

**Architecture Overview**:

```
┌──────────────────────────────────────┐
│        User Interface (Flutter)       │
│  - Conversational Chat Panel          │
│  - Test Review & Approval UI          │
│  - Execution Dashboard                │
└─────────────┬────────────────────────┘
              │
┌─────────────▼────────────────────────┐
│   Agent Orchestrator (LangGraph)      │
│  - State Machine (Idle → Gen → Exec)  │
│  - Human-in-Loop Checkpoints          │
│  - Workflow State Management          │
└─────────────┬────────────────────────┘
              │
    ┌─────────┼──────────┬──────────┐
    │         │          │          │
┌───▼──┐  ┌──▼──┐  ┌───▼─┐  ┌────▼──┐
│ Test │  │Test │  │Test │  │Self   │
│ Gen  │  │Exec │  │Val  │  │Heal   │
│Agent │  │Agent│  │Agent│  │Agent  │
└───┬──┘  └──┬──┘  └───┬─┘  └────┬──┘
    │        │        │         │
    └────────┴────────┴─────────┘
             │
    ┌────────▼─────────┐
    │  MCP Router      │
    │  - Cache         │
    │  - Rate Limit    │
    └────────┬─────────┘
             │
    ┌────────┴────────────────┐
    │                         │
┌───▼──┐  ┌──────┐  ┌────────▼──┐
│Claude│  │GPT-4 │  │Local LLM   │
└──────┘  └──────┘  └────────────┘
```

#### Key Components

**1. Agent Orchestrator**
- State machine managing workflow: `Idle → GeneratingTests → AwaitingTestApproval → ExecutingTests → AwaitingExecutionReview → ValidatingResults → HealingIssues → AwaitingHealingApproval → Completed`
- Human-in-loop checkpoints at test generation, execution completion, and before self-healing
- Conditional routing based on results (e.g., skip self-healing if all tests pass)

**2. Test Generator Agent**
- Receives API specification and user requirements
- Generates comprehensive test cases:
  - **Positive Tests**: Happy path, expected behavior
  - **Negative Tests**: Invalid inputs, error scenarios
  - **Edge Cases**: Boundary values, null inputs, empty arrays
  - **Security Tests**: SQL injection, XSS, authentication bypass
  - **Performance Tests**: Response time validation
- Uses MCP to call Claude/GPT-4 for test generation
- Returns test suite to user for review and refinement

**3. Test Executor Agent**
- Executes test suite against live API
- Supports sequential and parallel execution
- Manages authentication, headers, request chaining
- Captures detailed results: status codes, response bodies, timing
- Handles failures gracefully with retry logic

**4. Test Validator Agent**
- Analyzes test results and identifies issues
- Uses schema validation, assertion evaluation
- Detects performance violations, security issues
- Generates detailed validation reports
- Suggests potential root causes for failures

**5. Self-Healing Agent**
- Detects API changes (schema updates, new required fields, endpoint changes)
- Proposes test updates to maintain compatibility
- Validates fixes by re-running updated tests
- Requires user approval before applying changes
- Maintains test intent while adapting structure

**6. MCP Integration Layer**
- Abstracts AI model selection
- Supports Claude, GPT-4, Mistral, Qwen, local LLMs
- Implements caching and rate limiting
- Easy to add new models without changing agent code

#### Integration with Existing API Dash

**Leverage Existing Infrastructure**:
- Use existing `flutter_js` runtime for test execution
- Reuse `RequestModel` and collection system
- Extend HTTP client for test batching
- Build on established service patterns

**New Services**:
```
lib/services/agentic_testing/
├── orchestrator/
│   ├── workflow_orchestrator.dart
│   └── state_manager.dart
├── agents/
│   ├── test_generator_agent.dart
│   ├── test_executor_agent.dart
│   ├── validator_agent.dart
│   └── healing_agent.dart
├── mcp/
│   ├── mcp_connector.dart
│   ├── claude_connector.dart
│   ├── gpt4_connector.dart
│   └── mistral_connector.dart
└── models/
    ├── test_case.dart
    ├── test_result.dart
    ├── validation_report.dart
    └── healing_action.dart
```

#### User Workflows

**Workflow 1: Conversational Test Generation**
```
User: "Generate comprehensive tests for my authentication API"
Agent: "I found /login, /register, /refresh. What should I test?
        1. Valid credentials
        2. Invalid credentials
        3. Missing fields
        4. Rate limiting
        5. SQL injection"
User: "All of the above, plus JWT token expiration"
Agent: "Generating 12 test cases with edge cases...
        Ready for review?"
[User reviews and approves]
Agent: "Tests saved. Execute now?"
```

**Workflow 2: Multi-Step Workflow Testing**
```
Test Suite: User Registration → Login → Get Profile → Update → Delete
1. POST /register → Extract user_id, auth_token
2. POST /login → Verify token matches
3. GET /profile (with auth) → Validate user data
4. PUT /profile (with auth) → Check update reflected
5. DELETE /user (with auth) → Verify cleanup
```

**Workflow 3: Self-Healing on API Change**
```
[API Change Detected: /users now requires 'role' field]
Agent: "12 tests affected by API change.
        Proposed fix: Add required 'role' field.
        Approve?"
User: "Yes, use 'admin' as default"
Agent: "Tests updated and re-executed.
        All 12 passing ✓"
```

### 4. Weekly Timeline

**Duration**: 12 weeks (175 hours total)

#### **Week 1-2: Foundation & Architecture Setup**
- Finalize hybrid architecture with mentors
- Design data models (TestCase, TestResult, ValidationReport, HealingAction)
- Set up MCP connector skeleton
- Research LangGraph vs custom state machine implementation
- **Deliverable**: Architecture document, data models, project structure

#### **Week 3-4: Agent Orchestrator Implementation**
- Implement state machine for workflow management
- Build human-in-the-loop checkpoint system
- Create shared context management for agent transitions
- Add error handling and retry logic
- **Tests**: 10+ unit tests for state transitions
- **Deliverable**: Fully functional orchestrator with checkpoint support

#### **Week 5-6: Test Generator Agent**
- Implement prompt templates for different test types (positive, negative, edge, security, performance)
- Build MCP connector interface
- Integrate with Claude for initial testing
- Add test case data model serialization
- **Tests**: Mock LLM responses, validate test case generation
- **Deliverable**: Working test generator with prompt engineering

#### **Week 7-8: Test Executor Agent**
- Implement test execution engine (sequential and parallel)
- Integrate with existing `flutter_js` runtime
- Build request chaining and state extraction
- Add authentication handling (Bearer, API Key, OAuth)
- **Tests**: Execute against mock APIs, validate results capture
- **Deliverable**: Fully functional executor with result capture and reporting

#### **Week 9-10: Validator & Self-Healing Agents**
- Implement validation logic (status codes, schemas, performance)
- Build failure analysis with MCP calls
- Implement self-healing strategies (test adjustment, request correction, retry logic)
- Add confidence scoring for healing actions
- **Tests**: Test validation edge cases, healing strategy validation
- **Deliverable**: Functional validator and healer with approval workflow

#### **Week 11-12: MCP Integration & Polish**
- Implement MCP connectors for Claude, GPT-4, Mistral
- Add model selection UI
- Build API key management interface
- End-to-end testing of complete workflows
- Performance optimization
- Documentation and bug fixes
- **Deliverable**: Production-ready system with multi-LLM support

#### **Post-GSoC (Phase 3 roadmap)**
- Visual test builder (drag-and-drop UI)
- Test scheduling and CI/CD integration
- Team collaboration features
- Test analytics and health tracking

### Success Metrics

**Quantitative**:
- ✅ Generate 10+ test cases per endpoint
- ✅ 90%+ code coverage for agentic testing module
- ✅ Support 3+ AI models (Claude, GPT-4, Mistral)
- ✅ < 2 second test generation time (per 5 tests)
- ✅ 100% pass rate on internal test suite

**Qualitative**:
- ✅ Developers find test generation easier than manual scripting
- ✅ Generated tests catch real API bugs
- ✅ Conversational interface feels natural
- ✅ Self-healing is reliable and requires minimal user overrides

---

## Additional Context

### My Journey with API Dash

1. **Week 1**: Explored codebase, discovered existing JavaScript runtime infrastructure
2. **Week 2**: Raised PR #1223 adding tests for `APIDashAgentCaller` to understand agentic infrastructure
3. **Week 3**: Studied Idea #4 requirements in detail
4. **Week 4**: Shared comprehensive hybrid architecture proposal in Discussion #1230
5. **Current**: Preparing GSoC application with mentor feedback incorporated

### Why I'm the Right Fit

- **Agentic AI Experience**: Built Project Samarth with LangGraph state machines, 5 autonomous tools, intelligent routing
- **Architecture Design**: Familiar with hybrid systems, state machines, multi-agent orchestration patterns
- **Full-Stack Skills**: Dart/Flutter (API Dash codebase), Python (AI/ML), TypeScript (frontend), JavaScript (testing)
- **MLM Integration**: Experience with Claude/OpenAI APIs, prompt engineering, RAG systems
- **Production Mindset**: Built systems deployed to production with monitoring, caching, error handling
- **Communication**: Active community participant, clear documentation, regular sync-ups

### Commitment

I'm excited about Idea #4 and committed to delivering a production-grade agentic testing system that transforms how API Dash users test their APIs. The hybrid architecture balances AI autonomy with human oversight - creating trustworthy, maintainable tests at scale.

Looking forward to collaborating with the API Dash team!

---

**References**:
- [Project Samarth - Agentic System](https://github.com/adityasuhane-06/Project-Samarth)
- [SignSarthi - Deep Learning](https://github.com/adityasuhane-06/signature-rtsl)
- [GSoC Idea #4 Discussion](https://github.com/foss42/apidash/discussions/1230)
- [PR #1223 - APIDashAgentCaller Tests](https://github.com/foss42/apidash/pull/1223)
- [Resume](https://drive.google.com/file/d/12zJvrIma6cPOJ99OTc4Jiq7Fit1ld2_c/view?usp=sharing)
