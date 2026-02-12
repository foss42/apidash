### About

1. **Full Name:** Keerthi Pradyun
2. **Contact info:** kpradyun18@gmail.com
3. **Discord handle:** k.pradyun
4. **Home page:**
5. **Blog:**
6. **GitHub profile link:** https://github.com/kpradyun
7. **Twitter, LinkedIn:** https://www.linkedin.com/in/k-pradyun-736851318
8. **Time zone:** Indian Standard Time (IST) / UTC+5:30
9. **Link to a resume:** https://drive.google.com/file/d/1hICwWjVlGdOLr9SAKehIMJkKu9PcW_wy/view?usp=drive_link

### University Info

1. **University name:** University of Hyderabad
2. **Program:** Integrated M.Tech in Computer Science & Engineering
3. **Year:** 3rd Year
4. **Expected graduation date:** June 2028

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**
Yes, I have contributed to API Dash itself.
* **PR #943:** [Fixed Issue #942 - Empty UI state in AI Model Selector](https://github.com/foss42/apidash/pull/943) (Replace 943 with your actual PR number)
    * *Description:* Identified and fixed a logic error where the model selector button displayed blank text when the model state was an empty string. Updated the widget to handle both `null` and `isEmpty` states correctly.

**2. What is your one project/achievement that you are most proud of? Why?**
I developed **F1_agent**, an autonomous AI agent capable of analyzing Formula 1 telemetry and race data using natural language queries.
* **Tech Stack:** Python, LangChain (or CrewAI/LlamaIndex), OpenAI API (or Ollama/Local LLMs), FastF1/Ergast API, and Pandas/Matplotlib for data visualization.
* **Why I'm proud:** This project moved beyond simple RAG (Retrieval-Augmented Generation) to true agentic workflows. The agent can decompose complex questions like "Compare Verstappen's lap times vs. Hamilton's in Q3 of the 2023 Monaco GP" into executable code, fetch real-time telemetry data, and generate insightful visualizations on the fly. Building the reasoning loop to handle API failures and data inconsistencies taught me how to build robust, production-ready AI systems.

**3. What kind of problems or challenges motivate you the most to solve them?**
I am motivated by "Developer Experience" (DX) challenges—building tools that make other developers efficient. I enjoy solving architectural problems where system components need to interact seamlessly (e.g., connecting a local filesystem with a Flutter UI state, or synchronizing local data with remote Git repositories).

**4. Will you be working on GSoC full-time?**
Yes, I will be working full-time (40+ hours/week) on GSoC. My semester exams end in May, aligning perfectly with the GSoC coding period.

**5. Do you mind regularly syncing up with the project mentors?**
Not at all. I value feedback loops and believe regular syncs (weekly or bi-weekly) are essential to ensure the project stays aligned with the maintainers' vision.

**6. What interests you the most about API Dash?**
API Dash is unique because it's a native, privacy-first, and lightweight alternative to bloated tools like Postman. I love that it is built with Flutter, allowing for a beautiful UI that runs everywhere. The potential to turn it into a collaborative tool without forcing users into a proprietary cloud ecosystem (by using Git) is huge.

**7. Can you mention some areas where the project can be improved?**
* **Collaboration:** Currently, sharing collections requires manually sending files. Git integration is solved this.
* **Chaining Requests:** Users cannot easily use the output of Request A (e.g., auth token) as input for Request B without manual copying.
* **Observability:** There is no high-level view of how APIs are performing over time (latency/failure rates).

### Project Proposal Information

**1. Proposal Title:** Git Support, Visual Workflow Builder & Collection Dashboard

**2. Abstract:**
This project aims to transform API Dash from a single-player request runner into a collaborative ecosystem. I will implement **Git Integration** to allow version control of collections directly from the UI. Additionally, I will build a **Visual Workflow Builder** (Node-based UI) to chain API requests and a **Collection Dashboard** to visualize API health and performance metrics.

**3. Detailed Description:**

**Module A: Git Integration (The Core)**
* **File-System Mapping:** Migrate the current single-file state to a directory-based structure (one JSON per collection/request).
* **Git Wrapper:** Integrate `libgit2` or a Dart-native Git client to expose commands: `init`, `add`, `commit`, `push`, `pull`, and `checkout`.
* **UI Implementation:** Add a "Source Control" side panel showing:
    * Modified files (Dirty state).
    * Staging area.
    * Commit message input.
    * Branch switcher.

**Module B: Visual Workflow Builder**
* **Canvas UI:** Utilize `vyuh_node_flow` to create a drag-and-drop interface.
* **Node Logic:**
    * *Request Node:* Represents a saved API request.
    * *Script Node:* JS/Dart snippet to transform data.
* **Data Passing:** Implement a variable system where "Edges" (connections between nodes) pass response body/headers to the next node's parameters.
* **AI Agent:** A "Text-to-Flow" feature where users describe a workflow (e.g., "Login then fetch user profile"), and the agent auto-generates the node graph.

**Module C: Collection Dashboard**
* **Analytics Engine:** Store execution history (timestamp, latency, status code) in a local SQLite/Hive database.
* **Visualization:** Use `fl_chart` to render:
    * Success vs. Failure Rate (Pie Chart).
    * Latency Trends (Line Chart).
    * Request Volume (Bar Chart).

**4. Weekly Timeline:**

* **Community Bonding (May 1 - May 26):**
    * Deep dive into API Dash state management (Riverpod).
    * Refine JSON schema for file-based storage.
    * Set up testing environment for Git operations.

* **Phase 1: Git Integration (Weeks 1-4)**
    * *Week 1:* Refactor storage provider to support reading/writing individual JSON files from a directory.
    * *Week 2:* Implement `GitService` class (Init, Status, Add, Commit). Create basic Source Control UI.
    * *Week 3:* Implement Branching and Remote Sync (Push/Pull). Handle basic merge conflicts (UI prompts).
    * *Week 4:* Testing Git flows on Windows/Linux/macOS. Integration tests for file watchers.

* **Phase 2: Visual Workflow Builder (Weeks 5-8)**
    * *Week 5:* Integrate `vyuh_node_flow`. Create basic "Request Node" widget.
    * *Week 6:* Implement "Edge" logic for passing variables (Context extraction).
    * *Week 7:* Build the "Runner" engine to execute the graph sequentially.
    * *Week 8:* Implement "Smart Prompt" (AI Agent) to generate graphs from text.

* **Phase 3: Dashboard & Polish (Weeks 9-12)**
    * *Week 9:* Set up local analytics storage. Implement logging hooks in the HTTP client.
    * *Week 10:* Build Dashboard UI using `fl_chart`. Connect real-time data.
    * *Week 11:* Documentation (User Guide for Git & Workflows). Code cleanup and performance profiling.
    * *Week 12:* Buffer week for bug fixes and final mentor review.
