# GSoC 2026 Proposal — MCP Testing Playground & CLI Toolkit for API Dash

## 👤 Applicant

Vansh Kaushal

---

## 🧠 Introduction

The Model Context Protocol (MCP) ecosystem is rapidly evolving, enabling agents, IDE integrations, and developer tools to interact with external systems via structured tool interfaces. As MCP servers grow in complexity and adoption, developers increasingly need robust workflows for discovering, testing, validating, and benchmarking MCP tools.

Currently, there is no standardized developer experience for:

* Interactive testing of MCP tools
* Schema inspection and validation
* Regression testing automation
* Performance benchmarking
* Structured debugging and response diffing

Testing MCP servers often involves writing ad-hoc scripts or manually invoking tools via agent interfaces, which leads to inefficient debugging cycles and lack of reproducibility.

To address this gap, this proposal introduces an **MCP Testing Toolkit** inside API Dash — consisting of:

1. **MCP Testing Playground (MCP App)** for interactive exploratory testing
2. **CLI-based MCP Test Runner** for automated regression validation
3. **Shared Test Specification Schema** enabling seamless transition from manual exploration to automated testing
4. A modular architecture forming the foundation of a reusable **MCP Developer Toolkit**

This approach aligns with MCP philosophy where tools can return **rich interactive developer experiences**, not just raw data.

---

## 🎯 Project Goals

* Enable interactive discovery and testing of MCP tools
* Provide schema visualization and dynamic parameter form generation
* Improve debugging through structured response inspection and diffing
* Enable automated regression testing via CLI workflows
* Capture performance metrics such as latency and execution reliability
* Provide extensible reporting pipelines
* Establish API Dash as a primary developer tool in the MCP ecosystem

---

## 🏗️ Proposed Architecture

```
apidash/
│
├── mcp/
│   ├── server/
│   │   ├── index.ts
│   │   ├── tool-registry.ts
│   │   ├── test-mcp-server.tool.ts
│   │   └── protocol-adapter.ts
│
├── playground/
│   ├── app/
│   │   ├── index.html
│   │   ├── main.ts
│   │   ├── rpc-bridge.ts
│   │   └── components/
│   │       ├── ToolList.tsx
│   │       ├── SchemaViewer.tsx
│   │       ├── ParamForm.tsx
│   │       ├── ResponsePanel.tsx
│   │       ├── TestHistory.tsx
│   │       └── BatchRunner.tsx
│
├── testing/
│   ├── core/
│   │   ├── test-runner.ts
│   │   ├── validator.ts
│   │   ├── snapshot.ts
│   │   └── performance.ts
│   │
│   ├── specs/
│   │   ├── schema.ts
│   │   └── template-generator.ts
│
├── cli/
│   ├── index.ts
│   └── commands/
│       ├── discover.ts
│       ├── run.ts
│       ├── generate.ts
│       └── report.ts
│
├── storage/
│   ├── test-case-store.ts
│   └── cache.ts
│
└── reporters/
    ├── html.ts
    ├── json.ts
    └── markdown.ts
```

---

## 🔍 MCP Tool Discovery Flow

1. CLI or MCP App connects to MCP server via protocol adapter
2. Tool registry fetches available tool metadata
3. Metadata cached locally for faster interactions
4. Test templates generated automatically using schema definitions

---

## 🧪 Manual Testing Workflow (MCP App)

```
MCP Host
   ↓
test_mcp_server tool invoked
   ↓
Interactive Playground UI rendered
   ↓
Tool selection → Dynamic parameter form generation
   ↓
Tool execution via RPC bridge
   ↓
Structured response inspection
   ↓
Test case persistence
```

Capabilities:

* Auto-discovery of tools
* Schema visualization
* Dynamic form generation
* Error diagnostics
* Response diffing
* Batch execution
* Test history replay

---

## 🤖 Automated CLI Testing Workflow

```
CLI command executed
   ↓
Discover MCP tools
   ↓
Generate test templates
   ↓
Run test suite
   ↓
Validate responses (schema + snapshot)
   ↓
Capture performance metrics
   ↓
Generate reports
```

CLI commands:

* `discover` → fetch tool metadata
* `generate` → create test templates
* `run` → execute test suites
* `report` → visualize results

---

## 📄 Shared Test Specification Schema

Test cases defined in JSON/YAML:

* Tool name
* Input parameters
* Expected schema constraints
* Snapshot expectations
* Performance thresholds
* Retry policies

This enables seamless transition from manual exploratory testing to automated regression pipelines.

---

## ⚙️ Technology Stack

* TypeScript (core implementation)
* React + Vite (Playground UI)
* JSON-RPC transport layer
* AJV / Zod for schema validation
* Commander / Yargs for CLI framework
* File-based persistence + caching
* Snapshot diffing engine
* HTML/JSON/Markdown reporting modules

---

## 📦 Deliverables

### Phase 1 — MCP Integration

* Protocol adapter
* Tool discovery registry
* CLI discover command
* Metadata caching layer

### Phase 2 — Playground MVP

* Tool list UI
* Schema viewer
* Dynamic parameter forms
* Tool execution pipeline

### Phase 3 — Testing Engine

* Test runner core
* Snapshot validation
* Performance metrics capture
* Batch execution

### Phase 4 — Automation & Reporting

* CLI run command
* Report generation
* Test persistence
* Documentation and demos

---

## 📅 Proposed Timeline

**Community Bonding Period**

* Deep dive into API Dash architecture
* MCP protocol experimentation
* Finalize design decisions with mentors

**Weeks 1–2**

* Implement protocol adapter
* Tool registry + discovery CLI

**Weeks 3–5**

* Playground UI MVP
* Dynamic schema-driven forms

**Weeks 6–7**

* Test runner engine
* Snapshot validation logic

**Weeks 8–9**

* Batch execution
* Performance tracking

**Weeks 10–11**

* CLI automation pipeline
* Reporting modules

**Week 12**

* Polishing
* Documentation
* Demo video
* Final evaluation preparation

---

## 🚀 Future Scope

* CI/CD Integration for MCP regression pipelines
* Performance benchmarking dashboards
* Multi-server orchestration testing
* Remote test execution environments
* Integration with AI evaluation frameworks
* Plugin-based reporter ecosystem

---

## ✅ Conclusion

The MCP Testing Toolkit will significantly improve developer productivity in the MCP ecosystem by providing a unified workflow for discovery, testing, debugging, and automation.

By embedding interactive testing as an MCP App and enabling automated validation through a CLI runner, API Dash can become a central developer platform for MCP tool development and validation.

This project aims to deliver a robust, extensible foundation that can evolve into a comprehensive MCP Developer Toolkit benefiting the broader ecosystem.

---
