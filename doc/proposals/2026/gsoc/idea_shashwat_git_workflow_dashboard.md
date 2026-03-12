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

Currently API Dash has no collection concept — all requests live in a single flat list in `CollectionStateNotifierProvider`. The first step is introducing a `CollectionModel` that groups requests into named collections. Each collection maps to one GitHub repository — connect a collection and you version-control it, import a repo and you get a teammate's entire collection.

**Design principle:** Hive is the single source of truth. There are no local Git repos, no on-disk files to sync, no file watchers. Everything goes through the GitHub REST API over HTTPS, which means Git Support works identically on macOS, Windows, Linux, Android, iOS, and web.

**Why a serialization layer is needed:** Hive stores data in a proprietary binary format (`.hive` files) — not human-readable, not diffable, and not something Git can meaningfully track. To bridge this gap, every request model is serialized to clean, structured JSON before being pushed to GitHub. On pull or rollback, the JSON is deserialized back into Hive. This Hive ↔ JSON conversion layer is what makes the entire Git integration possible: GitHub sees a repo of readable JSON files, while the app keeps using Hive as its fast local store.

**How it works in the UI:**

A new collection dropdown sits above the sidebar's request list. Each collection has a GitHub icon button with two states:

- **Not connected** — The collection is local-only. Clicking the button opens a **Connect to GitHub** dialog where the user types a repo name and clicks Connect. If this is the first time, the app shows a short authorization code and opens the system browser to github.com/login/device — the user enters the code, clicks "Authorize", and the app picks up the token automatically (one-time, takes ~15 seconds). API Dash then creates the repo via the GitHub API, serializes all requests to JSON, and pushes them as the first commit.

- **Connected** — The collection is linked to a GitHub repo. Clicking the button opens a **Git panel** with three tabs:
  - **Commit & Push** — Lists every request that was added, modified, or deleted since the last push (for example, "POST /auth — modified", "GET /orders — new"). The user can review exactly what changed, write a commit message, and push with one click. Under the hood, API Dash serializes each request to JSON, creates blobs and a tree via the Git Data API, creates a commit object pointing to the current branch head, and fast-forwards the branch ref — all in one atomic API call sequence.
  - **History** — A scrollable list of commits on the current branch. Each row shows the commit message, author, and timestamp. Clicking any commit triggers a **one-click rollback**: API Dash fetches the full tree for that commit, deserializes every request JSON, and replaces the entire collection in Hive. The user's sidebar instantly reflects the older version.
  - **Branches** — Lists all remote branches. The user can switch branches (which triggers the same full-tree fetch and Hive replace), create a new branch from the current HEAD, or delete a branch.

There is also an **Import from GitHub** option (accessible from the collection dropdown's "+" menu). The user pastes a GitHub repo URL, API Dash fetches the default branch's tree, deserializes all request JSONs, and creates a brand-new local collection populated with those requests.

**How it works under the hood:**

A `GitHubApiAdapter` class handles all GitHub communication using the GitHub REST API. No local git CLI or `git` Dart package is used.

- **Authentication:** GitHub's OAuth device flow — the recommended approach for desktop and mobile apps with no backend server. On first connect, the app requests a short user code from GitHub, displays it in a dialog ("Go to github.com/login/device and enter code ABCD-1234"), and opens the system browser. The user enters the code and clicks "Authorize" on GitHub's page. Meanwhile, the app polls GitHub in the background until authorization completes. Only the public `client_id` is embedded in the app — no secrets, no WebView, no redirect URI, no platform-specific deep links. The resulting token is stored in `flutter_secure_storage` (encrypted, per-platform keychain — Keychain on macOS/iOS, EncryptedSharedPreferences on Android). The token never expires, so this happens **once in the app's lifetime**. Every subsequent Connect, Push, Pull, or Import call just uses the saved token — no login screen, no prompts. All API calls attach `Authorization: Bearer <token>`.

- **Push (atomic multi-file commit):** When the user pushes, the adapter: (1) serializes each request in the collection to JSON, (2) calls `POST /repos/{owner}/{repo}/git/blobs` for each file to get blob SHAs, (3) calls `POST /repos/{owner}/{repo}/git/trees` with all blob SHAs and the current branch's base tree to get a new tree SHA, (4) calls `POST /repos/{owner}/{repo}/git/commits` with the new tree SHA and the parent commit SHA, (5) calls `PATCH /repos/{owner}/{repo}/git/refs/heads/{branch}` to fast-forward the branch. This is one atomic commit containing the entire collection state.

- **Pull / Rollback / Branch switch:** All three do the same thing internally — fetch a tree at a specific commit. The adapter calls `GET /repos/{owner}/{repo}/git/trees/{tree_sha}?recursive=1` to get every file in the tree, fetches each blob's content, deserializes the JSON into `RequestModel` objects, and bulk-replaces the collection in Hive. The sidebar rebuilds instantly via Riverpod.

- **Commit history:** `GET /repos/{owner}/{repo}/commits?sha={branch}` returns the commit log. Each entry shows message, author, date, and SHA. Tapping a commit calls the pull/rollback flow with that commit's tree SHA.

- **Branches:** `GET /repos/{owner}/{repo}/branches` lists branches. Creating a branch calls `POST /repos/{owner}/{repo}/git/refs` with the current HEAD SHA. Switching branches fetches that branch's latest commit tree and replaces the collection.

**Example — How Alice, Bob, and Carol collaborate:**

Alice has 15 API requests in her "Payment API" collection. She clicks the GitHub button, selects **Connect to GitHub**, enters a repo name, and authorizes via the device flow (enters a short code in her browser — one-time). API Dash serializes all 15 requests to JSON, creates an atomic commit via the Git Data API, and pushes to `main`. Her collection now lives on GitHub. She shares the repo URL with her team.

Bob opens API Dash, clicks **Import from GitHub** in his collection dropdown, and pastes Alice's repo URL. API Dash fetches the latest tree from `main`, deserializes all 15 request JSONs, and creates a new "Payment API" collection in Bob's Hive — all 15 requests appear in his sidebar, ready to use. He edits a request, opens the Git panel, writes a commit message, and pushes.

Carol already has the collection connected. She opens her Git panel's History tab and sees Bob's new commit. She clicks **Pull** (or clicks Bob's specific commit). API Dash fetches that commit's tree, deserializes the requests, and replaces her collection in Hive. Her sidebar updates instantly. Later, Carol realizes Bob's change broke something — she scrolls down in History, clicks the previous commit, and her entire collection rolls back to Alice's original version with one click.

The key insight: the user never thinks about blobs, trees, or API calls. They think about their collection. GitHub is just a button that lets them share it, version it, and roll back with one click — and it works on every platform.

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
| 1-2 | Git Foundation | CollectionModel + collection dropdown UI, GitHub OAuth via in-app WebView, GitHubApiAdapter (push: blobs → tree → commit → update ref), Connect to GitHub dialog |
| 3-4 | Git Features | Commit history view with one-click rollback, branch list/create/switch, Import from GitHub, pull (fetch tree → replace Hive collection) |
| 5-6 | Workflow Foundation | Data models, canvas integration, node types (Request, Condition, Transform, Delay), save/load |
| 7-8 | Workflow Execution | Execution engine, real-time status on canvas, data passing between nodes |
| 9 | Workflow Advanced | AI workflow generation |
| 10-11 | Dashboard | KPI cards, response time trend, status code distribution, method breakdown, webhook reporting |
| 12 | Testing and Polish | Unit tests, integration tests, documentation, bug fixes |

---

### Technical Dependencies

| Package |
|---------|
| [`vyuh_node_flow: ^0.27.3`](https://pub.dev/packages/vyuh_node_flow)
| [`fl_chart: ^1.1.1`](https://pub.dev/packages/fl_chart) 
| [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)

