### Initial Idea Submission

**Full Name:** Shashwat Pratap Singh
**University name:** APJ Abdul Kalam University (AKTU)
**Program you are enrolled in (Degree & Major/Minor):** Bachelor of Technology
**Year:** 3rd year
**Expected graduation date:** 2027

**Project Title:** Git Support, Visual Workflow Builder & Collection Dashboard
**Relevant Issues:** [#502](https://github.com/foss42/apidash/issues/502), [#120](https://github.com/foss42/apidash/issues/120)
**Discussion:** [#1054 — Idea #3](https://github.com/foss42/apidash/discussions/1054)

---

## Idea Description

### Approach

This project has three pillars: **Git Support**, **Workflow Builder**, and **Collection Dashboard**.

---

#### 1. Git Support — Every Collection Gets a GitHub Button

Currently API Dash has no collection concept — all requests live in a single flat list in `CollectionStateNotifierProvider`. The first step is introducing a `CollectionModel` that groups requests into named collections. Each collection then maps to one Git repo — clone a repo and you get a teammate's entire collection, push and you share yours.

**How it works in the UI:**

Every collection's sidebar header gets a new GitHub button. This button has two states:

- **Not connected** — The collection is local-only. Clicking the button opens a Connect to GitHub dialog where the user can either initialize a new repository for this collection, or clone an existing repository URL to import a teammate's collection.

- **Connected** — The collection is linked to a Git remote. Clicking the button opens a full Git dialog with three tabs: Changes (staged/unstaged files with diff preview, commit message input, commit/push/pull buttons), History (commit log), and Branches (list, create, switch). Modified requests show a dot indicator in the sidebar so the user knows what changed since the last commit.

**How it works:**

PR #1061 already stores each request independently in a Hive LazyBox. We add a FileSyncService that hooks into the same autosave path. Every time a request saves to Hive, it also writes a JSON file to disk. This means each request becomes an individual, human-readable, diffable file that Git can track. A manifest file stores the request ordering and collection metadata. A `.gitignore` is auto-generated to exclude Hive binary files and lock files.

A GitService wraps the git package which calls the local git CLI. It handles init, clone, commit, push, pull, branch management, and reading changed files. A FileWatcherService detects when files change on disk after a pull or branch switch, and triggers a re-import into Hive so the UI updates automatically.

**Example — How Alice, Bob, and Carol collaborate:**

Alice has 15 API requests in her collection. She clicks the GitHub button, selects Initialize repository, enters her GitHub repo URL, and pushes. Now her collection lives on GitHub as a set of JSON files. She shares the repo URL with her team.

Bob opens API Dash, clicks the GitHub button on an empty collection, selects Clone existing repository, and pastes Alice's URL. API Dash clones the repo, reads all the JSON files, imports them into Hive, and Bob sees all 15 requests in his sidebar, ready to use. He edits a request, clicks the GitHub button, writes a commit message, commits, and pushes.

Carol already has the collection. She clicks her GitHub button, sees one commit behind, clicks Pull. Her collection updates with Bob's changes. If both Carol and Bob edited the same request, the dialog shows a conflict and lets Carol pick theirs or mine to resolve it.

The key insight: the user never thinks about files or repos. They think about their collection. Git is just a button that lets them share it and stay in sync.

---

#### 2. Workflow Builder — Chain Requests into Executable Flows

The Workflow Builder gets its own item in the nav rail (alongside Requests, Variables, History, etc.). It uses a visual canvas where users drag and connect nodes to build API workflows.

**What a workflow looks like:**

A workflow is a graph of connected nodes. Each node represents one step:

- **Request node** — linked to an existing request from the collection. When the workflow runs, it sends that request and captures the response.
- **Condition node** — checks something about the previous response (for example, was the status code 200?). It branches the flow into yes and no paths.
- **Transform node** — takes data from a previous response and passes it to the next request (for example, extract a login token and set it as a header for the next call).
- **Delay node** — pauses for a specified duration before continuing.

The screen is a split-view: a sidebar lists saved workflows, and the main area is the visual canvas powered by vyuh_node_flow (a Flutter package with built-in JSON serialization, minimap, undo/redo, and a verified publisher). Users add nodes from a palette, drag them around the canvas, and draw connections between them.

**How execution works:**

When the user clicks Run, an execution engine walks the graph from the first node. For each node, it sends the request (or evaluates the condition, or applies the transform), updates the node's status on the canvas in real-time (pending to running to success or failed), and moves to the next node. The user watches the workflow progress live — each node lights up as it completes.

Data flows between nodes through a shared context. A login node's response can feed into a transform node that extracts a token, which then gets injected as a header into the next request node. This lets users build realistic multi-step API flows like authenticate, fetch user, fetch orders.

**Example — A login-then-fetch flow:**

A user has three requests: POST /auth, GET /users/me, and GET /orders. They create a workflow: first node is POST /auth. A condition node checks if the response is 200. If true, a transform node extracts the auth token from the response body. Then GET /users/me runs with that token as a Bearer header. Another transform extracts the user ID, and finally GET /orders/{userId} runs. The user clicks Run and watches each node light up green as it succeeds.

A user describes a workflow in natural language (for example, Login, then if successful fetch the user profile, then fetch their orders) and DashBot generates the workflow structure, placing the right nodes on the canvas with proper connections. Since DashBot already has action schemas for the app, this would be a new action type.

---

#### 3. Collection Dashboard — Visualize API Health at a Glance

The Dashboard also gets its own nav rail item. It aggregates data from the existing request history (API Dash already stores every sent response) and presents it visually:

- **KPI cards** — total requests sent, average response time, success rate, number of environments configured
- **Response time trend** — a line chart showing response times over time, helping users spot performance regressions
- **Status code distribution** — a pie or bar chart breaking down 2xx, 3xx, 4xx, 5xx responses
- **Method distribution** — a visual breakdown of GET, POST, PUT, DELETE requests in the collection
- **Webhook reporting (stretch goal)** — configure a webhook URL to send dashboard metrics to Slack or a CI/CD pipeline for automated monitoring

All data is derived from what API Dash already stores — no new data collection needed. Charts are rendered with fl_chart (7K+ likes, MIT license), the most popular Flutter charting library.

### Timeline (175 hours over 12 weeks)

| Week | Focus | Deliverables |
|------|-------|-------------|
| 1-2 | Git Foundation | FileSyncService (Hive to JSON), GitService wrapper, GitHub button with Connect dialog |
| 3-4 | Git Features | Commit, push, pull, branch management, diff view, commit history, conflict resolution |
| 5-6 | Workflow Foundation | Data models, canvas integration, node types (Request, Condition, Transform, Delay), save/load |
| 7-8 | Workflow Execution | Execution engine, real-time status on canvas, data passing between nodes |
| 9 | Workflow Advanced | AI workflow generation |
| 10-11 | Dashboard | KPI cards, response time trend, status code distribution, method breakdown, webhook reporting |
| 12 | Testing and Polish | Unit tests, integration tests, documentation, bug fixes |

---

### Technical Dependencies

| Package |
|---------|
| [`git: ^2.3.2`](https://pub.dev/packages/git) 
| [`vyuh_node_flow: ^0.27.3`](https://pub.dev/packages/vyuh_node_flow)
| [`fl_chart: ^1.1.1`](https://pub.dev/packages/fl_chart) 

