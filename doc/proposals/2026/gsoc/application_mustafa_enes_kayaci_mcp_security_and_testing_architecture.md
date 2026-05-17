# Application: Zero-Hallucination MCP Testing, Security & CI/CD Suite

### About

1. **Full Name:** Mustafa Enes Kayaci
2. **Contact info:** [mustafa.enes2028@gmail.com](mailto:mustafa.enes2028@gmail.com)
3. **Discord handle:** mustafaeneskayaci
4. **Home page:** [enesy.online](https://enesy.online)
5. **Blog:** [enesy.online](https://enesy.online)
6. **GitHub profile link:** [MustafaEnes123](https://github.com/MustafaEnes123)
7. **Twitter, LinkedIn, other socials:** [LinkedIn Profile](https://www.linkedin.com/in/mustafa-enes-kayaci/)
8. **Time zone:** GMT+3 (Turkey / Istanbul)
9. **Link to a resume:** [View Resume (PDF)](https://drive.google.com/file/d/1pi1-BXRgFJKc92tc2v6a6iYMPxC7Chko/view?usp=sharing)

### University Info

1. **University name:** Arizona State University (ASU)
2. **Program you are enrolled in:** Bachelor of Science (B.S.), Computer Software Engineering
3. **Year:** Freshman (1st Year)
4. **Expected graduation date:** June 2029

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**
Yes. I actively develop and maintain open-source projects. As the Lead Architect and Hack Club Leader of "Raw Logic Labs", I manage a 12-person engineering team, reviewing PRs and maintaining open-source repositories focused on AI and workflow automation. 
* [View my GitHub Contributions](https://github.com/MustafaEnes123) 
*(I am currently setting up the local environment for API Dash and exploring the `lib/` directory to prepare for my first transport-layer PR).*

**2. What is your one project/achievement that you are most proud of? Why?**
I am most proud of building "Cortex," an autonomous AI infrastructure that bypasses manual data entry by utilizing the Claude API and n8n to orchestrate complex B2B workflows. This project, along with winning 3 major AI-focused hackathons, proved my core philosophy: intelligent, schema-validated system architecture always beats manual templates.

**3. What kind of problems or challenges motivate you the most to solve them?**
I am driven by "System Bottlenecks" and data vulnerabilities. I despise repetitive, manual tasks and "vibe testing" in AI. Building zero-hallucination bridges between LLMs and external systems—where type-safety and schema validation are guaranteed before execution—is the exact type of architectural challenge I love.

**4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**
Yes. I am dedicating 100% of my summer working hours to GSoC. I have deliberately structured my academic and professional schedule to comfortably dedicate the required 175+ hours to API Dash.

**5. Do you mind regularly syncing up with the project mentors?**
Not at all. As a Software Architect, I believe strict architectural alignment with mentors is the only way to build production-ready software. I welcome frequent syncs, code reviews, and pair programming sessions.

**6. What interests you the most about API Dash?**
API Dash is positioning itself as the ultimate bridge for AI-powered development. The specific focus on adding Agentic AI features, adopting the Model Context Protocol (MCP), and establishing a robust ecosystem for **testing MCP Apps** aligns perfectly with my daily tech stack (TypeScript, Node, React, AI APIs) and my role as an Anthropic AI Architecture Mentor.

**7. Can you mention some areas where the project can be improved?**
Currently, the MCP ecosystem relies heavily on manual debugging. API Dash can step ahead of the entire market by implementing: 
1. **Comprehensive MCP Apps Testing** (simulating client-side agentic interactions).
2. **Pre-flight Schema Validation** (blocking AI hallucinations before tool execution).
3. **Security Profiling** (warning users before exposing destructive tools like `drop_table` to LLMs).
4. **Headless Test Exporting** (allowing MCP test suites to run in CI/CD pipelines).

### Project Proposal Information

**1. Proposal Title:** Zero-Hallucination MCP Testing, Security & CI/CD Suite
**2. Abstract:** Current MCP testing tools rely on manual execution, ignoring AI hallucinations and security risks. I propose building a resilient Node.js/TypeScript backend for API Dash handling `stdio` and `SSE` transports, coupled with a Zod-powered Validation Engine and a Security Profiler. This allows developers to thoroughly **test MCP Apps**, prevent malformed AI requests, sandbox destructive operations, and export test suites for CI/CD environments.
**3. Detailed Description:**
The architecture will expand beyond basic connection testing, introducing enterprise-grade modules:
* **The Transport Layer (Node.js/TS):** Bidirectional JSON-RPC 2.0 communication for local (`stdio`) and remote (`SSE`) MCP servers.
* **MCP Apps Testing Ecosystem:** A dedicated workflow to test not just the server, but the MCP Apps themselves. This will allow developers to simulate agentic interactions, validate context passing, and ensure their apps meet the latest community guidelines.
* **The "Zero-Hallucination" Engine (Zod):** Dynamically parses the MCP server's exposed JSON schema. Any tool execution request is strictly validated pre-flight. Malformed AI parameters are blocked natively.
* **Automated Security Profiling:** Automatically flags high-risk capabilities (e.g., Code Execution, File System Writes) so developers can sandbox them.
* **The React Client UI:** A visual workspace featuring a dynamic Tool Executor, Protocol Telemetry Stream, and a "Save Test Case" function for regression testing.

**4. Weekly Timeline (175 Hours - Medium/Hard):**
* **Community Bonding (Weeks 1-3):** Finalize MVP scope, review MCP Apps testing standards from recent documentation, decide transport priorities (`stdio` vs `SSE`), and align on TypeScript interfaces for the Zod schema parser.
* **Phase 1: Core Transport & Discovery (Weeks 4-6):** Build the Node.js adapters for `stdio` and `SSE`. Implement the `initialize` handshake and capabilities discovery parsing.
* **Phase 2: Security & Validation Engines (Weeks 7-8):** Integrate Zod middleware for strict pre-flight payload validation. Build the Security Profiling algorithm for destructive tools.
* **Phase 3: The Interactive React Workspace & MCP Apps Testing (Weeks 9-10):** Develop the dynamic UI (Tool Executor, Resource Explorer, real-time Telemetry Stream) within API Dash, specifically ensuring the interface supports robust **MCP Apps testing workflows**.
* **Phase 4: Automation & Delivery (Weeks 11-12):** Implement "Export to CI/CD" logic. Conduct extensive unit testing on the transport layer (handling broken pipes/disconnects). Finalize the API Dash user documentation and submit the final PR.
