# GSoC 2026 Application: MCP Testing Suite for API Dash

### About
1. **Full Name:** Gaurav Sethi
2. **Contact info:** gauravsethi4627@gmail.com
3. **Discord handle:** phoenix2490
4. **Home page:** https://gauravsethi.is-a.dev/
5. **Blog:** N/A
6. **GitHub profile link:** https://github.com/Gaurav5189
7. **LinkedIn:** https://www.linkedin.com/in/gaurav-s-4b36b624b
8. **Time zone:** UTC +05:30 (IST)
9. **Link to a resume:** [View Resume](https://drive.google.com/file/d/1OXlj5-6AMOooqf9P0NfVJzZ-6KT1UDDx/view?usp=drivesdk)

### University Info
1. **University name:** Ravenshaw University
2. **Program enrolled in:** Master of Computer Applications (MCA)
3. **Year:** Enrolled in 2025 (1st Year)
4. **Expected graduation date:** May 2027

### Motivation & Past Experience

**What kind of problems or challenges motivate you the most to solve them?**

I am deeply motivated by infrastructure and automation challenges. Building robust backend architectures, designing secure APIs, and creating CI/CD testing pipelines (specifically finding edge cases where systems break) are the areas where I thrive. I recently enjoyed the challenge of bridging asynchronous Playwright testing within Django's synchronous core framework, dealing heavily with event-loop management and protocol boundaries. 

**Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

I will be dedicating roughly 15-20 hours a week to this project alongside my MCA coursework, comfortably fulfilling the 175-hour requirement for this Medium/High-size project. My coursework directly aligns with the backend/testing nature of this project, allowing for excellent synergy.

**Do you mind regularly syncing up with the project mentors?**

Not at all. I believe in over-communication, especially during architectural planning. Weekly syncs and asynchronous updates on Discord/GitHub are essential for keeping the project aligned with the core team's vision.

**What interests you the most about API Dash?**

I love how API Dash brings the structure and predictability of REST/GraphQL clients into the highly experimental and often messy world of Agentic AI. By treating AI interactions as structured API calls, it provides a level of deterministic testing and workflow automation that the AI ecosystem desperately needs right now.

**Can you mention some areas where the project can be improved?**

Currently, debugging an MCP server feels like a "black box" exercise. Developers rely on trial-and-error by prompting LLMs in Claude Desktop to see if their tools trigger correctly. API Dash can drastically improve this by providing a deterministic, LLM-free execution environment where developers can manually trigger JSON-RPC payloads to test their MCP primitives (Tools, Resources, Prompts) and view the raw `stdio`/`sse` protocol streams.

**Have you interacted with and helped the API Dash community?**

Yes, I am active on the Discord server (`#introduce-yourself` and `#gsoc-foss-apidash`) and have been analyzing the existing issues related to the Model Context Protocol to prepare for this proposal.

---

### Project Proposal Information

**1. Proposal Title**

MCP DevEnv: A Deterministic Execution and Testing Engine for Model Context Protocol

**2. Abstract**

The Model Context Protocol (MCP) is rapidly becoming the standard for Agentic AI, yet developers lack the tooling to test their servers deterministically. Currently, testing relies on unpredictable "vibe checks" via LLM prompts. This project will integrate a Node/TypeScript-based execution engine into API Dash that establishes direct JSON-RPC connections (via `stdio` and HTTP/SSE) to local and remote MCP servers. It will auto-discover server primitives (Tools, Resources, Prompts) and generate a UI where developers can construct specific JSON payloads, execute tools bypassing the LLM, and inspect the raw protocol stream to debug edge cases and schema validations.

**3. Detailed Description**

My approach focuses heavily on the underlying **Execution Core** before touching the React UI. To build a reliable testing suite, the system must handle the asynchronous, bidirectional nature of the MCP protocol without crashing the main API Dash thread.

**Phase 1: The Execution Core & Protocol Adapter (Node/TS)**
- Implement the `@modelcontextprotocol/sdk`.
- Build a robust Connection Manager that can spawn local MCP server processes (e.g., `uv run server.py` or `npx ...`) using Node's `child_process`, capturing `stdin`/`stdout` for JSON-RPC communication.
- Implement HTTP/SSE fallback for remote servers.
- **Crucial Challenge:** Ensure the adapter cleanly handles the event loop and gracefully kills child processes upon disconnection to prevent memory leaks or orphaned servers.

**Phase 2: Discovery & Schema Parsing**
- Once a handshake (`initialize`) is complete, the engine will query the server’s capabilities (`tools/list`, `resources/list`, `prompts/list`).
- Parse the returned JSON Schemas (which dictate the arguments a tool expects) and pass this state to the React frontend.

**Phase 3: The Testing Interface (React)**
- Build a "Server Workspace" dashboard in API Dash.
- Dynamically render input forms based on the parsed JSON Schemas from Phase 2.
- Allow users to execute a Tool with manual arguments and display the raw response (Success, Error codes, Latency).
- Include a "Protocol Stream" view (similar to a Network tab) that shows the raw JSON-RPC messages being exchanged between API Dash and the MCP server for deep debugging.

**Phase 4: Automated Edge-Case Validation**
- Implement basic automated checks: If a tool requires a `string`, what happens if the UI sends an `int` or `null`? The testing suite will flag if the MCP server handles the error gracefully or crashes.

**4. Weekly Timeline (175 Hours / 12 Weeks)**

* **May (Community Bonding):** Finalize the exact architecture of the Node.js Connection Manager with mentors. Set up the local development environment and study the existing API Dash codebase.
* **Week 1-3 (Execution Core):** Build the Node/TS backend adapter to handle `stdio` and `SSE` connections using the official MCP SDK. Ensure robust child process management for local servers.
* **Week 4-6 (Discovery & Parsing):** Implement the handshake logic. Extract and parse the JSON schemas for Tools, Resources, and Prompts, normalizing the data for the frontend.
* **Week 7-9 (React UI & Integration):** Build the MCP Testing Dashboard in API Dash. Connect the UI to the backend engine to allow manual tool execution and display the JSON-RPC protocol stream.
* **Week 10-11 (Validation & Edge Cases):** Add schema validation checks. Ensure the UI cleanly handles and displays MCP error codes (e.g., -32600, -32601) when a server fails.
* **Week 12 (Documentation & Polish):** Write user documentation on how to test MCP servers within API Dash. Clean up code, increase test coverage, and submit final evaluations.
