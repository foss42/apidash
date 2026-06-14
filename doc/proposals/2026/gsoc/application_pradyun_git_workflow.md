# GSoC 2026 Application: Git Support, Visual Workflow Builder & Collection Dashboard

---

## About

1. **Full Name:** Keerthi Pradyun
2. **Contact Info:** kpradyun18@gmail.com
3. **Discord Handle:** k.pradyun (API Dash server)
4. **Home Page:** N/A
5. **Blog:** N/A
6. **GitHub Profile:** [github.com/kpradyun](https://github.com/kpradyun)
7. **Other Socials:** N/A
8. **Time Zone:** IST (UTC+5:30)
9. **Resume:** [View Resume (PDF)](https://drive.google.com/file/d/1hICwWjVlGdOLr9SAKehIMJkKu9PcW_wy/view?usp=drive_link)

---

## University Info

1. **University:** University of Hyderabad
2. **Program:** Integrated M.Tech, Computer Science Engineering
3. **Year:** 3rd Year
4. **Expected Graduation:** June 2028

---

## Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

Yes. My primary open-source contribution has been to API Dash itself. I submitted and had merged [PR #1241](https://github.com/foss42/apidash/pull/1241) — the GSoC 2026 idea proposal for Idea 3 (Git Support, Visual Workflow Builder & Collection Dashboard). This involved studying the existing codebase in depth, understanding the Hive-based state architecture (`CollectionStateNotifierProvider`, `hive_services.dart`), and producing a detailed, mentor-reviewed technical architecture document that was accepted into the main branch.

**2. What is your one project/achievement that you are most proud of? Why?**

My proudest project is the **F1 Race Engineer Agent** ([github.com/kpradyun/F1_agent](https://github.com/kpradyun/F1_agent)). It is an intelligent Formula 1 data analysis agent built with LangChain, FastF1, the OpenF1 real-time API, and a local LLM via Ollama. The system answers natural language queries about F1 telemetry, race strategy, historical records, and live race data. It features:

- A suite of **~25 specialized tools** covering reference lookups, race analysis, session data, live telemetry, and team radio processing.
- A **RAG engine** using FAISS vector storage and HuggingFace embeddings (`all-MiniLM-L6-v2`) for precise retrieval over 2026 FIA Technical, Sporting, and Financial Regulations.
- An **interactive 2D race replay engine** built with the Arcade library.
- A multi-level caching layer, bringing Quick Lookup queries to under 1ms.

I am most proud of this project because it required stitching together multiple complex systems — an agentic tool-calling framework, a live external API, a vector database, and a visualization engine — into a coherent, production-quality application. The experience gave me direct hands-on understanding of how AI agents interface with real-world APIs, which is directly relevant to this GSoC proposal.

**3. What kind of problems or challenges motivate you the most?**

I am most motivated by problems that sit at the intersection of developer tooling and real-world workflows. Working on the F1 Agent taught me how friction-heavy API consumption can be — constantly stitching together multiple endpoints, managing authentication tokens across calls, and losing track of which version of a request actually worked. Discovering API Dash and realizing that a Git-backed, visually orchestrated version of it would solve exactly these problems for every developer — not just F1 data consumers — is what drew me deeply into this proposal.

**4. Will you be working on GSoC full-time?**

No. I will be pursuing my 4th year of my Integrated M.Tech alongside GSoC. However, my academic load in the summer semester is lighter, and I am fully committed to dedicating a consistent **25–30 hours per week** to the project. I have accounted for this in my weekly timeline, which is structured to be realistic and deliverable within the part-time commitment.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all — I actively look forward to it. I have already joined the weekly GSoC connect calls and the Discord server. Regular sync-ups are critical for a project of this architectural depth, and I plan to proactively raise blockers early rather than waiting until reviews.

**6. What interests you most about API Dash?**

What fascinates me most about API Dash is that it is one of the very few API clients built natively in Flutter, which means it targets all platforms (desktop, mobile, web) from a single codebase. After my experience building the F1 Agent — where I was constantly juggling multiple chained API calls — I was struck by how much API Dash already gets right: clean request management, code generation, and a thoughtful UI. The Git integration and workflow builder, which are the core of this proposal, feel like the natural next evolution of the tool. They would take API Dash from a single-request explorer to a true platform for collaborative API development — something no other open-source Flutter-based API client currently offers.

**7. Areas where the project can be improved (beyond Idea 3):**

- **Import/Export Parity:** Full OpenAPI 3.x bi-directional import and export would make API Dash a first-class citizen in existing API-first teams. Currently, importing complex specs with nested `$ref` schemas can silently drop fields.
- **Environment Variable Scoping:** A hierarchical environment system (Global → Collection → Request) similar to Postman's would reduce duplication for teams managing multiple deployment targets.
- **Response Diffing:** A built-in response differ to compare two historical responses side-by-side would be extremely valuable during API contract migrations.
- **Test Assertions UI:** A no-code assertion builder (e.g., "assert `status == 200` AND `body.user.id` is not null") would lower the barrier for non-developer API testers.

---

## Project Proposal Information

### 1. Proposal Title
**Git Support, Visual Workflow Builder & Collection Dashboard for API Dash**

---

### 2. Abstract

API Dash is a powerful API client, but today it operates in isolation: requests are stored in a monolithic Hive binary box with no version history, no way to chain requests together, and no observability layer over how collections behave over time. This proposal addresses all three gaps.

The plan is to evolve API Dash from a single-request executor into a collaborative, version-controlled API orchestration platform in three phases:

1. **Git Integration** — Decouple the Hive state layer into individual diffable JSON files and build a native Dart Git interface so developers can commit, push, pull, and branch their API collections like code.
2. **Visual Workflow Builder** — Build a DAG-based node canvas powered by `vyuh_node_flow` that lets users chain requests with variable passing, conditional logic, and an AI "Smart Prompt" that auto-generates workflows from plain English.
3. **Collection Dashboard** — Build an observability screen that aggregates execution history into `fl_chart` visualizations (latency trends, status code distributions) and a Webhook dispatcher to push automated reports to Slack or Discord.

---

### 3. Detailed Description

#### Background: The Current Architecture

Before outlining changes, it is important to be specific about what exists today:

- **State Management:** API Dash uses [Riverpod](https://riverpod.dev/). The primary collection state is managed via `CollectionStateNotifierProvider` in `lib/providers/collection_providers.dart`. Requests are stored and retrieved using `hive_services.dart`, which wraps a Hive `LazyBox<HttpRequestModel>`.
- **Data Models:** `HttpRequestModel` (in `lib/models/`) is the central data object. It is currently serialized to Hive binary format. It already implements `copyWith`, which will be leveraged extensively.
- **No File-System Presence:** There is currently no file-system representation of collections. All data lives inside the Hive binary box at the platform's application data directory.
- **No Execution Chaining:** Requests are executed independently. There is no mechanism for passing the output of one request as input to another.

---

#### Phase 1: Git Integration & State Decentralization

**The Core Problem:** Git tracks changes in text files. Hive stores data in a binary format. These are fundamentally incompatible. The solution is not to replace Hive — it is fast and works well for in-app state — but to add a mirrored file-system layer that Git can track.

**Step 1 — Data Model Update (`lib/models/http_request_model.dart`)**

Add `json_serializable` annotations and `equatable` mixin for structural equality:

```dart
// lib/models/http_request_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'http_request_model.g.dart';

@JsonSerializable()
class HttpRequestModel extends Equatable {
  final String id;
  final String name;
  final HTTPVerb method;
  final String url;
  final List<NameValueModel> headers;
  final List<NameValueModel> params;
  final RequestBodyContentType bodyContentType;
  final String? body;
  // ...

  @override
  List<Object?> get props => [id, name, method, url, headers, params, body];

  factory HttpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$HttpRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$HttpRequestModelToJson(this);
}
```

The `equatable` mixin is critical: it allows the `FileSyncService` to compare old vs. new model states before writing to disk, preventing unnecessary file system writes (and therefore spurious Git dirty states).

**Step 2 — File Sync Service (`lib/services/file_sync_service.dart`)**

This service is the bridge between Hive and the file system:

```dart
// lib/services/file_sync_service.dart
class FileSyncService {
  final Directory workspaceDir;

  FileSyncService(this.workspaceDir);

  /// Called by hive_services.dart on every save.
  Future<void> syncRequest(String collectionId, HttpRequestModel model) async {
    final collectionDir = Directory('${workspaceDir.path}/$collectionId');
    if (!await collectionDir.exists()) {
      await collectionDir.create(recursive: true);
    }
    final file = File('${collectionDir.path}/${model.id}.json');
    final newJson = const JsonEncoder.withIndent('  ').convert(model.toJson());

    // Only write if content has actually changed (prevents spurious git diffs)
    if (await file.exists()) {
      final existing = await file.readAsString();
      if (existing == newJson) return;
    }
    await file.writeAsString(newJson);
  }

  /// Called when a request is deleted.
  Future<void> deleteRequest(String collectionId, String requestId) async {
    final file = File('${workspaceDir.path}/$collectionId/$requestId.json');
    if (await file.exists()) await file.delete();
  }

  /// Auto-generates a .gitignore inside the workspace directory.
  Future<void> ensureGitignore() async {
    final gitignore = File('${workspaceDir.path}/.gitignore');
    if (!await gitignore.exists()) {
      await gitignore.writeAsString(
        '# API Dash — auto-generated\n*.hive\n*.lock\n.env\n.env.*\n',
      );
    }
  }
}
```

`hive_services.dart` will be updated to inject and call `FileSyncService` on every `put` and `delete` operation.

**Step 3 — Reactive File System Watcher (`lib/providers/workspace_providers.dart`)**

This `StreamProvider` watches the workspace directory for external changes (e.g., `git pull`, `git checkout`):

```dart
// lib/providers/workspace_providers.dart
final workspaceDirChangesProvider = StreamProvider<FileSystemEvent>((ref) {
  final workspaceDir = ref.watch(workspaceDirProvider);
  return workspaceDir.watch(recursive: true);
});
```

`CollectionStateNotifier` subscribes to this stream. When the stream fires (meaning a `git pull` just modified files on disk), it re-reads the affected `.json` files and rebuilds the in-memory Riverpod state without requiring an app restart. This is the key to making Git feel native and seamless inside the app.

**Step 4 — Git Operations Service (`lib/services/git_service.dart`)**

This service wraps `dart_git` (primary) with a `process_run` fallback for environments where the local Git CLI is available:

```dart
// lib/services/git_service.dart
abstract class GitService {
  Future<void> init(Directory dir);
  Future<List<GitStatus>> status();
  Future<void> stageAll();
  Future<void> commit(String message);
  Future<void> push(String remote, String branch);
  Future<void> pull(String remote, String branch);
  Future<List<String>> branches();
  Future<void> checkout(String branch, {bool create = false});
  Future<List<CommitSummary>> log({int limit = 20});
  Future<String> diff(String filePath);
}

class DartGitService implements GitService {
  // Implementation using the `dart_git` package
}

class ProcessRunGitService implements GitService {
  // Fallback using process_run to shell out to system git
}
```

A `gitServiceProvider` in Riverpod will select between implementations at runtime based on whether `dart_git` succeeds on initialization.

**Step 5 — Version Control UI**

A new "Git" icon in the collection sidebar header opens a `ModalBottomSheet` with three tabs:

```
┌──────────────────────────────────────────────────────────┐
│  📦 My API Collection               [main ▾]  [⎇ Git]   │
├──────────────────────────────────────────────────────────┤
│  🟢 GET  /users/me                                        │
│  🟡 POST /auth/login                     [Modified *]     │
│  🔴 GET  /orders/{id}                    [Untracked +]    │
└──────────────────────────────────────────────────────────┘

         ┌─── Git Panel (Bottom Sheet) ───────────────────┐
         │  [ Changes ] [ History ]  [ Branches ]         │
         ├────────────────────────────────────────────────┤
         │  CHANGES                                        │
         │  M  auth/login.json                            │
         │  A  orders/get_order_by_id.json                │
         │                                                 │
         │  Commit message: ______________________________ │
         │                               [ Stage & Commit ]│
         ├────────────────────────────────────────────────┤
         │  HISTORY                                        │
         │  a1b2c3d  Add auth endpoints       2h ago       │
         │  d4e5f6g  Initial collection       1d ago       │
         ├────────────────────────────────────────────────┤
         │  BRANCHES                                       │
         │  * main                                         │
         │    feature/payment-api                          │
         │                        [ + New Branch ] [ Push ]│
         └────────────────────────────────────────────────┘
```

**Proof of Concept — Git Integration:**

A standalone Dart CLI script will demonstrate the core loop:
1. Create a temporary directory.
2. Instantiate `FileSyncService` and write three `HttpRequestModel` objects as JSON.
3. Call `GitService.init()`, `stageAll()`, and `commit("Initial collection")`.
4. Modify one model, call `syncRequest()`, and call `GitService.diff()` — proving a clean, human-readable diff is produced.
5. Print the diff output to stdout.

This PoC can be run independently of the Flutter app and will be included in the PR.

---

#### Phase 2: Visual Workflow Builder & Agentic Orchestration

**The Core Problem:** Real-world API usage is rarely a single call. Authentication flows, paginated fetches, and data transformation pipelines require chaining. Today, API Dash has no mechanism for this.

**Step 1 — DAG Data Models (`lib/models/workflow/`)**

```dart
// lib/models/workflow/workflow_graph.dart
class WorkflowGraph {
  final String id;
  final String name;
  final List<WorkflowNode> nodes;
  final List<WorkflowEdge> edges;
}

// Node types
sealed class WorkflowNode {
  final String id;
  final Offset canvasPosition;
}

class ApiRequestNode extends WorkflowNode {
  final String requestId; // references an HttpRequestModel.id
  WorkflowExecutionResult? lastResult;
}

class TransformNode extends WorkflowNode {
  final String jsonPathExpression; // e.g. "$.data.token"
  final String outputVariableName; // e.g. "auth_token"
}

class ConditionNode extends WorkflowNode {
  final String condition; // e.g. "statusCode == 200"
  final String trueEdgeId;
  final String falseEdgeId;
}

// Edge
class WorkflowEdge {
  final String id;
  final String sourceNodeId;
  final String targetNodeId;
  final String? sourcePort; // for condition nodes: "true" | "false"
}
```

**Step 2 — Canvas UI (`lib/screens/workflow_builder/workflow_canvas_screen.dart`)**

Integration with `vyuh_node_flow` to render `WorkflowGraph` on a pannable, zoomable canvas:

```dart
// lib/screens/workflow_builder/workflow_canvas_screen.dart
class WorkflowCanvasScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(activeWorkflowProvider);
    return Scaffold(
      appBar: _WorkflowAppBar(),
      body: Row(
        children: [
          _NodePalette(), // Drag-from sidebar: ApiRequestNode, TransformNode, ConditionNode
          Expanded(
            child: NodeFlowCanvas(
              nodes: graph.nodes.map(_toCanvasNode).toList(),
              edges: graph.edges.map(_toCanvasEdge).toList(),
              onNodeDropped: (type, position) =>
                  ref.read(workflowNotifierProvider.notifier).addNode(type, position),
              onEdgeConnected: (src, dst) =>
                  ref.read(workflowNotifierProvider.notifier).addEdge(src, dst),
            ),
          ),
          _ExecutionPanel(), // Live execution log panel on the right
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(workflowExecutorProvider.notifier).run(graph),
        label: const Text('Run Workflow'),
        icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}
```

**Step 3 — Context-Passing Execution Engine (`lib/services/workflow_executor.dart`)**

The engine performs a topological sort (Kahn's algorithm) on the `WorkflowGraph` and executes nodes in dependency order:

```dart
// lib/services/workflow_executor.dart
class WorkflowExecutor {
  final ApiService apiService;
  final Map<String, dynamic> _executionContext = {};

  Future<WorkflowExecutionResult> run(WorkflowGraph graph) async {
    final sortedNodes = _topologicalSort(graph);

    for (final node in sortedNodes) {
      switch (node) {
        case ApiRequestNode n:
          // Interpolate {{variables}} in URL, headers, body from _executionContext
          final interpolated = _interpolate(n.requestId, _executionContext);
          final result = await apiService.sendRequest(interpolated);
          _executionContext['node_${n.id}_response'] = result.body;
          _executionContext['node_${n.id}_status'] = result.statusCode;

        case TransformNode n:
          // Extract value using json_path package
          final value = JsonPath(n.jsonPathExpression)
              .read(jsonDecode(_executionContext['node_${_sourceNodeId(graph, n.id)}_response']))
              .first.value;
          _executionContext[n.outputVariableName] = value;

        case ConditionNode n:
          // Evaluate condition and prune edges accordingly
          final passes = _evaluate(n.condition, _executionContext);
          // Skip downstream branch if condition fails
      }
    }
    return WorkflowExecutionResult(context: _executionContext);
  }
}
```

**Step 4 — AI Smart Prompt (`lib/services/ai_orchestrator.dart`)**

Hooks into the existing Dashbot LLM integration. The user types a plain English description (e.g., *"Login with credentials, extract the token, then fetch the user profile"*). The orchestrator sends:

```json
{
  "prompt": "Login with credentials, extract the token, then fetch the user profile",
  "available_requests": [
    { "id": "req_001", "name": "POST /auth/login", "method": "POST", "url": "{{base_url}}/auth/login" },
    { "id": "req_002", "name": "GET /users/me",    "method": "GET",  "url": "{{base_url}}/users/me"    }
  ],
  "output_format": "WorkflowGraph JSON"
}
```

The LLM returns a `WorkflowGraph`-shaped JSON which is directly deserialized into the model and rendered on the canvas. The user can then edit nodes manually before running.

**UI Mockup — Workflow Canvas:**

```
┌─────────────────────────────────────────────────────────────────────────┐
│  Workflow: Auth & Profile Fetch        [✨ AI Prompt] [▶ Run] [💾 Save]  │
├───────────────┬─────────────────────────────────────────┬───────────────┤
│  Node Palette │           Canvas                        │  Execution    │
│               │                                         │  Log          │
│  [API Request]│   ┌──────────────────┐                  │               │
│  [Transform ] │   │ POST /auth/login  │                  │  ✅ Node 1    │
│  [Condition ] │   │ Status: 200 OK   │                  │  200 OK       │
│               │   └────────┬─────────┘                  │  120ms        │
│               │            │                            │               │
│               │   ┌────────▼──────────────────┐         │  ⏳ Node 2    │
│               │   │ Transform: $.data.token    │         │  Running...   │
│               │   │ → auth_token               │         │               │
│               │   └────────┬──────────────────┘         │               │
│               │            │                            │               │
│               │   ┌────────▼──────────────┐             │               │
│               │   │ GET /users/me          │             │               │
│               │   │ Header: Bearer         │             │               │
│               │   │   {{auth_token}}       │             │               │
│               │   └───────────────────────┘             │               │
└───────────────┴─────────────────────────────────────────┴───────────────┘
```

---

#### Phase 3: Collection Dashboard & Webhooks

**Step 1 — History Aggregation (`lib/providers/dashboard_providers.dart`)**

The existing `HistoryBox` in Hive stores `HttpRequestModel` and response metadata. A `FutureProvider` aggregates this data using Dart Isolates (`compute`) to avoid blocking the UI thread:

```dart
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final historyBox = ref.watch(historyBoxProvider);
  return compute(_aggregateHistory, historyBox.values.toList());
});

DashboardStats _aggregateHistory(List<HistoryEntry> entries) {
  // Runs in separate isolate
  final grouped = groupBy(entries, (e) => e.requestId);
  return DashboardStats(
    totalRequests: entries.length,
    avgLatencyMs: entries.map((e) => e.latencyMs).average,
    successRate: entries.where((e) => e.statusCode < 400).length / entries.length,
    latencyByDay: _groupByDay(entries),
    statusCodeDistribution: _countByCodes(entries),
  );
}
```

**Step 2 — Dashboard UI (`lib/screens/dashboard/dashboard_screen.dart`)**

```
┌────────────────────────────────────────────────────────────────────────┐
│  Collection Dashboard                              [ Export ] [ Webhook]│
├──────────────────────┬─────────────────────────┬───────────────────────┤
│  Total Requests      │  Avg Latency            │  Success Rate         │
│  1,240               │  210ms                  │  94.2%                │
├──────────────────────┴─────────────────────────┴───────────────────────┤
│  Latency Trend (Last 7 Days)                                            │
│                                                                         │
│  300ms ┤                  /\                                            │
│  200ms ┤    /\/\    /\/\ /  \   /\                                      │
│  100ms ┤───/    \__/    /    \_/  \______                               │
│         Mon   Tue   Wed   Thu   Fri   Sat   Sun                        │
├─────────────────────────────┬──────────────────────────────────────────┤
│  Status Code Distribution   │  Slowest Endpoints                       │
│                             │                                           │
│  ████████████████  2xx 94%  │  1. POST /auth/login      avg 340ms      │
│  ██  4xx  5%       ██ 5xx 1%│  2. GET  /orders/{id}     avg 280ms      │
│                             │  3. GET  /products        avg 190ms      │
└─────────────────────────────┴──────────────────────────────────────────┘
```

`fl_chart` powers both the line chart (latency trend) and the pie/bar chart (status code distribution). Each chart is wired to `dashboardStatsProvider` and rebuilds reactively.

**Step 3 — Webhook Dispatcher (`lib/services/webhook_service.dart`)**

```dart
class WebhookService {
  Future<void> dispatch(WebhookConfig config, WorkflowExecutionResult result) async {
    final payload = {
      'workflow': result.workflowName,
      'timestamp': DateTime.now().toIso8601String(),
      'success_rate': result.successRate,
      'avg_latency_ms': result.avgLatencyMs,
      'nodes': result.nodeResults.map((n) => n.toJson()).toList(),
    };
    await http.post(
      Uri.parse(config.url),
      headers: {'Content-Type': 'application/json', ...config.customHeaders},
      body: jsonEncode(payload),
    );
  }
}
```

Users configure webhook URLs via a settings panel. On workflow completion, `WebhookService.dispatch()` is called automatically in a background isolate.

---

### 4. Testing Strategy

- **Unit Tests** for `FileSyncService`: Assert that writing an `HttpRequestModel` produces a correctly formatted JSON file, and that an identical model write is a no-op (idempotency).
- **Unit Tests** for `WorkflowExecutor`: Construct a mock `WorkflowGraph` with `ApiRequestNode → TransformNode → ApiRequestNode` and assert that `_executionContext` contains the correct extracted value after execution.
- **Unit Tests** for `GitService`: Using a temporary directory, assert that `init`, `commit`, and `diff` produce expected outputs.
- **Widget Tests** for `WorkflowCanvasScreen`: Verify nodes and edges render correctly from a given `WorkflowGraph` state.
- **Manual E2E Verification**: Full auth → token extraction → profile fetch workflow executed against a live mock server.

---

### 5. Weekly Timeline (175 Hours)

| Week | Focus | Deliverables |
|:-----|:------|:-------------|
| **Week 1** | Codebase Study & Setup | Deep-dive into `hive_services.dart`, `collection_providers.dart`, existing `HttpRequestModel`. Set up dev environment. Define final file-system directory structure. |
| **Week 2** | Data Model Refactoring | Add `json_serializable` + `equatable` to `HttpRequestModel`. Write + run codegen. Add unit tests for JSON round-trip. |
| **Week 3** | FileSyncService | Implement `FileSyncService`. Hook into `hive_services.dart`. Write unit tests for create / update / delete / idempotency. Verify `.gitignore` auto-generation. |
| **Week 4** | Reactive File Watcher | Implement `Directory.watch()` `StreamProvider`. Wire to `CollectionStateNotifier`. Test that external file edits trigger UI rebuild. |
| **Week 5** | GitService (Core) | Implement `DartGitService` (init, status, stage, commit, log). Add `ProcessRunGitService` fallback. Write unit tests using temp directories. |
| **Week 6** | GitService (Remote) + UI Shell | Add push/pull/branch/checkout. Build Git Panel bottom sheet UI shell (3 tabs: Changes, History, Branches). |
| **Week 7** | Git UI (Complete) + Diff Viewer | Wire Changes tab to live `GitService.status()`. Implement inline diff viewer for `.json` files. Wire History tab to `GitService.log()`. |
| **Week 8** | Workflow DAG Models + Canvas Init | Define `WorkflowGraph`, `WorkflowNode` sealed class, `WorkflowEdge`. Integrate `vyuh_node_flow`. Render a static test graph on the canvas. |
| **Week 9** | Execution Engine (Core) | Implement topological sort. Build `WorkflowExecutor` with `ApiRequestNode` execution and context map. Write unit tests. |
| **Week 10** | Transform + Condition Nodes + AI Prompt | Implement `TransformNode` with `json_path`. Implement `ConditionNode` with branch pruning. Build AI Smart Prompt integration with Dashbot. |
| **Week 11** | Dashboard — Data Layer | Implement `dashboardStatsProvider` with Dart Isolate aggregation. Write unit tests for aggregation logic. |
| **Week 12** | Dashboard — UI + Webhooks + Polish | Build `DashboardScreen` with `fl_chart`. Implement `WebhookService`. Final E2E testing. Documentation. Buffer for review feedback. |

---

### Related Issues

- [#502 — Add GIT integration](https://github.com/foss42/apidash/issues/502)
- [#120 — Add a Drag & Drop UI API workflow builder & runner](https://github.com/foss42/apidash/issues/120)

### Prior Work

- [PR #1241 — Merged idea doc](https://github.com/foss42/apidash/pull/1241) (this applicant's merged contribution to API Dash)
