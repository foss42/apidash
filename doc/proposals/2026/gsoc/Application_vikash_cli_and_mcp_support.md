# Application: CLI & MCP Server

### About

1. **Full Name:** Vikash
2. **Contact info:** heyvkr@gmail.com
3. **Discord handle:** vortex_71
4. **Home page:** https://portvk.web.app/
5. **GitHub profile link:** https://github.com/vik05h
6. **Twitter, LinkedIn, other socials:** [LinkedIN ](https://www.linkedin.com/in/vikash-kumar-9b0819277/)
7. **Time zone:** India Standard Time (IST), UTC+5:30
8. **Link to resume:** https://drive.google.com/file/d/1We6NsRTy8fhUvCyzCaYOfWzYcMoBbiyd/view?usp=sharing

### University Info

1. **University name:** SRM Institute of Science and Technology
2. **Program you are enrolled in:** Bachelor of Technology in Computer Science & Engineering (Specialization in AI & ML)
3. **Year:** 3rd Year
4. **Expected graduation date:** MAY 2027

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

Yes, I am highly passionate about the open-source ecosystem and have
actively contributed to multiple FOSS projects.

I have contributed to **Tolgee**, an open-source localization platform,
where I submitted a pull request addressing a UI/UX issue in the platform
([PR #3362](https://github.com/tolgee/tolgee-platform/pull/3362)).
I have also contributed to **EvalAI**, a cloud-based AI evaluation platform
by Cloud-CV, through both a merged pull request
([PR #4845](https://github.com/Cloud-CV/EvalAI/pull/4845)) and a bug report
that helped improve platform reliability
([Issue #4846](https://github.com/Cloud-CV/EvalAI/issues/4846)).

Beyond these, I have been an active early contributor to **API Dash** itself.
I engaged with
[Issue #845](https://github.com/foss42/apidash/issues/845#event-22868404252)
 *"Add support for working with MCP for LLMs to access APIs"* — which was
subsequently **marked as completed** by the maintainers. Notably, a majority
of the GSoC 2026 idea list for API Dash revolves around MCP — covering areas
such as MCP server testing, CLI and MCP support, and AI-powered API
interactions — which highlights how central this area is to the project's
roadmap. My early involvement with this issue gave me deep context into the
architectural decisions around MCP integration in the codebase, and directly
informed the PoC I built for this proposal.

**2. What is your one project/achievement that you are most proud of? Why?**

I am incredibly proud of taking the initiative to teach Artificial Intelligence concepts to government school students during my summer holidays, culminating in a comprehensive report and presentation. Technically, my proudest achievement was architecting the backend for the HeatBeasts eSports and gaming community platform during my internship. It required building scalable infrastructure, which taught me how to handle real-world user data and platform stability. 

**3. What kind of problems or challenges motivate you the most to solve them?**

I am motivated by architectural decoupling and bridging human-centric developer tools with AI workflows. I thrive on challenges that require taking tightly coupled systems (like a GUI application) and extracting the core logic to make it headless, programmable, and accessible to autonomous agents. Removing repetitive developer friction is my primary drive.

**4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

Yes, I will be dedicating my time full-time to GSoC, and I can consistently commit 30 to 35 hours per week during the coding period.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all. I highly value mentor feedback and believe regular syncs are crucial for course-correcting early, discussing architectural edge cases, and ensuring alignment with the project's broader vision.

**6. What interests you the most about API Dash?**

API Dash's evolution from a standard API client into an AI-native tool is fascinating. Reading through the GSoC 2025 reports by Manas and Udhay, I was highly impressed by the implementation of the `genai` package, the SDUI component generation, and Dashbot. API Dash is perfectly positioned to be the leading open-source tool for the AI engineering era, and I want to help build the infrastructure that pushes that vision forward.

**7. Can you mention some areas where the project can be improved?**

Currently, API Dash requires developers to break their workflow and context-switch to the Flutter GUI to execute or debug requests. It lacks a headless execution environment. By adding a CLI, we can enable CI/CD integrations. By adding an MCP server, we can allow IDE agents (like Cursor or Cline) to securely interact with the user's API Dash workspaces, generating tool calls or parsing responses without leaving the code editor.

**8. Have you interacted and helped API Dash community? (GitHub/Discord links)**

Yes, I have been actively involved with the API Dash community through GitHub.

Specifically, I engaged with the MCP-related community work in **Issue #845** and have been following the broader architectural discussions around agent and MCP support:
* [Issue #845 - Activity & Engagement](https://github.com/foss42/apidash/issues/845#event-22868404252)
* [API Dash GitHub Discussions](https://github.com/foss42/apidash/discussions/1228)
  
---

### Project Proposal Information

**1. Proposal Title**

API Dash Headless Execution Engine: CLI & MCP Server Integration

**2. Abstract**

API Dash currently relies on the GUI for request execution. This project introduces a headless execution layer by adding a new package, packages/apidash_cli, to the Melos monorepo. It will provide a Dart CLI for listing and executing saved requests from terminal workflows, along with an MCP server over standard input and output so AI agents can invoke the same runtime. The implementation will reuse existing request execution logic to maintain behavior parity with the GUI, while workspace and local storage discovery will be handled through a pure Dart, cross-platform path resolution strategy. This enables developers and AI agents to execute API Dash workspaces directly from terminal and IDE environments.

**3. Detailed Description**

*Note: I have already built a working Proof of Concept (PoC) demonstrating a shared Dart execution engine running as both a CLI and an MCP server to validate this architecture.*

**System Architecture & Flow**

My architectural approach relies on the foundation laid during GSoC 2025 and prioritizes reuse over duplication.

* **Monorepo Integration:** I will add a new package at `packages/apidash_cli` and wire it into existing Melos workflows. This package will depend directly on `better_networking` to ensure consistency in request execution behavior.
* **Shared Runtime Layer:** Instead of duplicating business logic in both CLI and MCP handlers, I will create a shared headless runtime layer responsible for workspace resolution, request and environment loading, variable substitution, request execution handoff to `better_networking`, and response normalization.
* **File-Based Workspace Strategy:** To prevent concurrent access issues, the runtime will rely on a file-based architecture using a `.apidash/` directory. Workspace resolution will follow a deterministic fallback order:
  1. Explicit CLI flag path
  2. Local project workspace (`./.apidash/`)
  3. Global user workspace (`~/.apidash/` or OS-specific AppData)
* **CLI Layer:** Built using `package:args`, exposing commands such as `apidash list`, `apidash run <request_id_or_name>`, and `apidash run-url` for ad-hoc requests.
* **MCP Server Layer:** Using `mcp_dart` over `stdio` transport, exposing tools such as `list_requests`, `get_request`, `execute_api_request`, and `list_environments`.

This architecture ensures one execution path across GUI, CLI, and MCP, reducing maintenance overhead and preventing behavior drift
<img width="1161" height="461" alt="model" src="https://github.com/user-attachments/assets/8563d901-5552-4348-b6f6-07ffa7c9d3b4" />

**Proof of Concept (PoC) Implementation**

To validate the technical feasibility of this proposal, I have already built a fully functional Proof of Concept. 
* **Video Demo:** [Video](https://youtu.be/wIyiYdfZkH4?si=xTE112CmdBIRNHKb)

**What the PoC Demonstrates:**

1. **Headless Execution:** A pure Dart script that executes HTTP requests and parses responses without relying on the Flutter framework.
2. **Dual-Interface Capable:** The codebase successfully shares a core execution engine between a terminal CLI (using `package:args`) and an AI-facing server.
3. **Live MCP Integration:** Using `package:mcp_dart`, the PoC successfully registers an `execute_api_request` tool over `stdio`. In the linked demo, an AI agent (Cline) successfully discovers the tool, autonomously formats the JSON arguments, executes a live API call, and parses the response to answer a user's prompt without any manual intervention. 

<img width="863" height="214" alt="Screenshot 2026-03-22 135414" src="https://github.com/user-attachments/assets/0ddfbf63-88fd-4589-98b4-e60e901d3d57" />
<img width="370" height="753" alt="Screenshot 2026-03-22 144515" src="https://github.com/user-attachments/assets/6f2060d6-eba5-4dbb-9433-99944b529775" />

**Challenges & Solutions**

* **Architectural Blocker: Hive Concurrency & State Discovery**
  **Challenge:** Hive relies on process-level file locks and is not ideal for concurrent multi-process access. If GUI and headless tooling access the same storage simultaneously, lock conflicts can occur. Also, pure Dart CLI runtimes should not depend on Flutter-only state helpers.
  **Solution:** The headless runtime will use file-based workspace storage for requests and collections, persisted as JSON files. Workspace discovery will be deterministic and platform-safe in this order:
   1) Explicit workspace flag (e.g., `--workspace`),
   2) Local project workspace at `./.apidash/`, and
   3) Global user fallback at `~/.apidash/` under user home or OS-specific AppData path.
  **Impact:** This removes headless dependency on Flutter plugins, avoids common lock-conflict scenarios, enables version control of API assets, and works reliably across desktop and CI environments.

* **Standardizing `stdio` for MCP**
  **Challenge:** Large API payloads over `stdio` can increase memory pressure and reduce agent responsiveness.
  **Mitigation:** The MCP server will implement response size caps, truncation metadata, output-to-file support for very large responses, and structured stable error codes so JSON-RPC communication remains resilient.

* **Security & Secret Hygiene**
  **Challenge:** Agent contexts and terminal logs can unintentionally expose sensitive tokens and credentials.
  **Mitigation:** CLI and MCP outputs will pass through a sanitization layer that masks sensitive headers such as `Authorization` and `x-api-key`, and redacts secret environment values in logs, tool outputs, and error traces.
  
**4. Weekly Timeline**

**Community Bonding Period (May 8 - June 1)**
* Finalize MVP scope for a 90-hour project with mentors, review existing `better_networking` and storage flow, and freeze CLI/MCP tool schemas and acceptance criteria.

**Week 1 (June 2 - June 8)**
* Scaffold `packages/apidash_cli` inside the Melos workspace.
* Implement deterministic file-based workspace discovery (local `./.apidash/` falling back to global `~/.apidash/`).
* Build headless parsers to read API Dash collections from JSON files.
* **Deliverable:** A working script that safely reads and lists saved API Dash requests from the file system without Hive locks.

**Week 2 (June 9 - June 15)**
* Build core CLI commands using `package:args` (`list`, `run`, `run-url`).
* Wire command execution to the shared runtime and `better_networking`.
* Add structured output modes and baseline error handling.
* **Deliverable:** A functional CLI that executes saved and ad-hoc requests from terminal workflows.

**Week 3 (June 16 - June 22)**
* Implement MCP server over `stdio` using `package:mcp_dart`.
* Register core tools: `list_requests`, `get_request`, `execute_api_request`, `list_environments`.
* Connect MCP handlers to the same shared runtime used by CLI.
* **Deliverable:** A standalone MCP server that accepts and responds to JSON-RPC tool calls.

**Week 4 (June 23 - June 29)**
* End-to-end validation with real clients (for example Cursor, Cline, GitHub Copilot).
* Harden edge cases: large payload handling, truncation metadata, timeout/cancellation races, malformed tool arguments, stable error codes.
* Finalize user docs, setup guide, and final cleanup for submission.
* **Deliverable:** MVP-complete CLI and MCP integration with documentation and tested agent interoperability.

**Post-Implementation Buffer (Review and Feedback Window)**
* Address mentor review comments and minor refinements.
* Optional stretch improvements only if time remains (output polish, additional integrations, performance tuning).
* **Deliverable:** Final polished submission aligned with the 90-hour scope.
---

### About Me & Past Projects

I am Vikash, a developer focused on full-stack systems and AI-integrated tooling. I strongly believe in learning by building and I actively seek projects that demand architecture-level problem solving. 

**Relevant Projects:**
* **HeatBeasts:** Developed the core infrastructure for an eSports and gaming community platform during my tech internship, managing complex real-time data states.
* **AI Video Summarization and Quiz Generation:** Developed an AI-powered pipeline capable of parsing video content to automatically generate structured summaries and interactive quizzes, giving me hands-on experience with LLM context windows and automated data extraction.
* **Crowd Management System:** Built an AI-driven crowd management and monitoring tool, demonstrating my ability to handle real-time data streams and deploy machine learning models for practical, high-impact use cases.
