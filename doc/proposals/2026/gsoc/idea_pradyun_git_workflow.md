# GSoC 2026 Idea Proposal: Git Support, Visual Workflow Builder & Collection Dashboard

**Full Name:** Keerthi Pradyun  
**University:** University of Hyderabad  
**Program:** Integrated M.Tech in CSE Major (3rd Year, Exp. June 2028)  
**Project Info:** 175 hours | Medium-Hard | Issues: #502, #120

---

## Executive Summary
This proposal outlines a deep architectural evolution of **API Dash** mapped directly to the current `HEAD` branch. It transitions the application from a localized, single-request executor stored in a monolithic Hive box into a decentralized, Git-versioned orchestration platform. 

The core of this project is dedicated to two massive undertakings:
1. **State Decentralization:** Migrating the state layer to the file system for Git compatibility.
2. **Visual Workflow Builder:** Building a robust execution engine for a DAG-based visual orchestration.

The final phase introduces an **Observability Dashboard** built on top of the new execution history.

---

## Technical Architecture & Codebase Implementation Plan

### 1. Git Integration & State Decentralization
Currently, API Dash manages state via `CollectionStateNotifierProvider` and stores requests in a Hive `LazyBox`. To support Git, this must be decoupled into individual, diffable files on the local disk without breaking existing Hive performance.

#### **Codebase Implementation Steps:**
1. **Data Model Refactoring (`lib/models/`):**
   - Update `HttpRequestModel` to use `json_serializable` and `equatable` for strict equality checks during state diffs.
2. **File-System Sync Layer (`lib/services/file_sync_service.dart`):**
   - Create a service that mirrors Hive writes. When `hive_services.dart` saves a request, this service simultaneously writes it to `<workspace_dir>/<collection_name>/<request_id>.json`.
   - Auto-generate a `.gitignore` to exclude `.hive` binaries and `.env` files.
3. **Reactive State Synchronization (`lib/providers/workspace_providers.dart`):**
   - Implement a `StreamProvider` hooked into `Directory.watch()`. 
   - When a `git pull` or `git checkout` mutates the underlying `.json` files, the stream emits the new directory state. 
   - The `CollectionStateNotifier` listens to this stream to seamlessly rebuild the UI without requiring an app reload.
4. **Git Operations Wrapper (`lib/services/git_service.dart`):**
   - Implement a Dart-native interface wrapping `dart_git` (or `process_run` for local Git CLI fallback) to handle `init`, `commit`, `push/pull`, and `branch` management natively.

#### **UI Mockup: Git Version Control Sidebar**
```text
┌───────────────────────────────────────────────┐
│ 📦 Collections                 [ + ] [ Git]   │
├───────────────────────────────────────────────┤
│ ▼ Startup API                  [Branch: main] │
│   🟢 GET  /users/me                           │
│   🟡 POST /auth/login             [Unsaved *] │
│   🔴 GET  /orders/{id}            [Modified *]│
└───────────────────────────────────────────────┘

Note: Clicking the "Git" GitHub icon opens a bottom sheet with 
3 tabs: Changes (Diff viewer), History (git log), and Branches.
```

---

### 2. Visual Workflow Builder & Agentic Orchestration
This module builds an asynchronous execution engine that chains requests together, moving beyond individual manual execution.

#### **Codebase Implementation Steps:**
1. **DAG Models (`lib/models/workflow/`):**
   - Define a `WorkflowGraph` object containing `NodeModel` and `EdgeModel`.
   - Create specific node types: `ApiRequestNode`, `TransformNode`, and `ConditionNode`.
2. **Canvas UI Integration (`lib/screens/workflow_builder/`):**
   - Integrate the `vyuh_node_flow` package. 
   - Map `ApiRequestNode` data to visual canvas nodes, allowing users to drag and drop requests from the collection sidebar directly onto the DAG.
3. **Context-Passing Execution Engine (`lib/services/workflow_executor.dart`):**
   - Maintain a `Map<String, dynamic> executionContext`.
   - The engine traverses the graph, utilizing the existing `ApiService` to execute HTTP calls.
   - Use the `json_path` package inside a `TransformNode` to extract variables (e.g., `$.data.token` from Node A) and inject them into the `executionContext` for Node B's headers.
4. **Agentic 'Smart Prompt' (`lib/services/ai_orchestrator.dart`):**
   - Hook intoDashbot. 
   - Send the user's natural language prompt alongside a JSON schema of the current `CollectionModel`. 
   - Enforce a structured JSON output from the LLM that directly deserializes into a `WorkflowGraph` object to auto-generate the canvas UI.

#### **UI Mockup: Workflow Canvas**
```text
┌─────────────────────────────────────────────────────────────┐
│ [✨ AI: "Login, extract token, fetch user"]                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌────────────────┐       ┌───────────────────────┐         │
│  │ POST /auth     │───▶   │ Transform: JSONPath   │         │
│  │ Status: 200 OK │       │ Extract: $.data.token │         │
│  └────────────────┘       └──────────┬────────────┘         │
│                                      │ (Pass Token)         │
│                                      ▼                      │
│                           ┌───────────────────────┐         │
│                           │ GET /users/me         │         │
│                           │ Header: Bearer {token}│         │
│                           └───────────────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

---

### 3. Collection Dashboard & Webhooks
A centralized telemetry hub that aggregates execution data generated by the new workflow engine and existing manual requests.

#### **Codebase Implementation Steps:**
1. **History Aggregation (`lib/providers/dashboard_provider.dart`):**
   - Iterate through the existing `HistoryBox` in Hive to extract `timestamp`, `latency_ms`, and `statusCode`. 
   - Use Dart Isolates (via `compute`) to calculate averages and distributions to prevent main-thread UI jank.
2. **Dashboard UI (`lib/screens/dashboard_screen.dart`):**
   - Implement `fl_chart` to render the aggregated history data into visual Line and Pie charts.
3. **Webhook Dispatcher (`lib/services/webhook_service.dart`):**
   - Create a background task that fires an `http.post` to a user-defined URL upon workflow completion.
   - Payload example: `{"workflow": "CI Check", "success_rate": 100, "avg_latency": "240ms"}`.

#### **Collection Dashboard Mockup**
![API Dash Collection Dashboard Mockup](/home/pradyun/.gemini/antigravity/brain/feefcf28-66a8-46bf-9fce-eff4c3e0132b/api_dash_dashboard_mockup_1772878204534.png)

#### **UI Mockup (ASCII Version):**
```text
┌─────────────────────────────────────────────────────────────┐
│  [Total Requests: 1,240] [Avg Latency: 210ms] [Success: 94%]│
├─────────────────────────────────────────────────────────────┤
│  Latency Trend (7 Days)        |  Status Codes              │
│   /\       /^\                 |      [ 2xx ] 94%           │
│  /  \  /\ /   \                |      [ 4xx ] 5%            │
│ /    \/  \     \               |      [ 5xx ] 1%            │
└─────────────────────────────────────────────────────────────┘
```

---

## Implementation Timeline (175 Hours)

The architectural shifts required for **Git Integration** (Phase 1) and the **Workflow Builder** (Phase 2) are structurally complex. To ensure stability and backward compatibility, these foundational projects will be developed iteratively.

| Phase | Weeks | Focus Area | Technical Deliverables |
| :--- | :--- | :--- | :--- |
| **Phase 1** | Weeks 1-5 | Core Architecture (Git & DAG) | Decouple Hive state into `.json` files. Implement Riverpod `Directory.watch()`. Define `WorkflowGraph` models and initialize the `vyuh_node_flow` canvas. |
| **Phase 2** | Weeks 6-10 | Execution Engines & AI | Build native Git interfaces (Commit/Diff UI). Write DAG topological sorter, variable context passing, and LLM mapping for the Smart Prompt. |
| **Phase 3** | Weeks 11-12 | Observability & Polish | Aggregate Hive history, implement `fl_chart` dashboards, build Webhook dispatcher, and conduct rigorous end-to-end integration testing. |
