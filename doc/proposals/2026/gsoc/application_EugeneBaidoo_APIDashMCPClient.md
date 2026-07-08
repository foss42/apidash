# Google Summer of Code 2026 Proposal: API Dash

## About

1. **Full Name**: Eugene Baidoo
2. **Contact info**: eugenebaidoo5@gmail.com
3. **Discord handle**: Pro ESL
4. **Home page**: []
5. **Blog**: []
6. **GitHub profile link**: [https://github.com/gene-999](https://github.com/gene-999)
7. **Socials**: [https://gh.linkedin.com/in/eugene-baidoo-3765141a7](https://gh.linkedin.com/in/eugene-baidoo-3765141a7)
8. **Time zone**: [GMT]
9. **Resume**: [https://drive.google.com/file/d/1pEOU7LE6eHytHMldamBE0uFLDPFn8o5a/view?usp=drivesdk](https://drive.google.com/file/d/1pEOU7LE6eHytHMldamBE0uFLDPFn8o5a/view?usp=drivesdk)

---

## University Info

1. **University Name**: University of Ghana
2. **Program**: [BSc. Computer Science]
3. **Year**: [4th Year]
4. **Expected Graduation**: [2026]

---

## Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before?**
   - Not at the moment, but I am looking forward to contributing to API Dash.
2. **What is your one project/achievement that you are most proud of?**
   - I built/building integrion. It is an AI agent that helps teams fully test out their code before it reaches production. It would write a suite of test, run and validate them and then generate a report on the code quality. Another addition i am looking to include is the ability to fully test out the software systems in an isolated environment. This is to ensure that the code is fully tested and validated before it reaches production. I belive API Dash can be a great tool to help with this.
3. **What kind of problems or challenges motivate you the most?**
   - I am motivated by the challenge of building tools that can help developers work more efficiently. I am also interested in the potential of AI to revolutionize the way we build software.
4. **Will you be working on GSoC full-time?**
   - Yes, I would be having an internship at the same time, but I believe I would be able to work on GSoC full-time.
5. **Do you mind regularly syncing up with the project mentors?**
   - Yes, I look forward to weekly/bi-weekly syncs to ensure alignment.
6. **What interests you the most about API Dash?**
   - API Dash's focus on a lightweight, AI-first approach to API testing is unique. I am particularly excited about how it can become the "source of truth" for AI agents interacting with web services.
7. **Can you mention some areas where the project can be improved?**
   - While the GUI is excellent, the ecosystem could benefit from deeper integration with AI agent protocols like MCP to enable automated testing workflows.
8. **Have you interacted with and helped the API Dash community?**
   - No, but I am looking forward to interacting with the API Dash community.

---

## Project Proposal Information

1. **Proposal Title**: **Building an Agentic QA Bridge: Model Context Protocol (MCP) Server for API Dash**

2. **Abstract**:
   API Dash is a modern, cross-platform API client. This project aims to implement a **Model Context Protocol (MCP)** server for API Dash, enabling AI agents (like Claude Desktop, Cursor, or specialized QA agents) to interact directly with API collections. By exposing API Dash requests as tools and resources, we enable "Agentic Testing"—where AI agents can autonomously discover, execute, and validate API endpoints. Inspired by advanced QA agents (like Integrion), this server will allow developers to test endpoints from a "Postman perspective" directly within their agentic workflows, significantly accelerating PR reviews and automated quality assurance.

3. **Detailed Description**:
   
   **The Problem**: Currently, AI agents (LLMs) used in development environments have limited context about a project's API surface. Developers define requests in API Dash, but to test them via an agent, they often have to manually copy-paste details. There is no standardized "bridge" for an agent to say, "Show me all endpoints in this collection and run the 'User Login' request with these parameters."

   **The Solution**: An MCP Server built using native Dart (`mcp_dart`). This server will:
   - **Resource Discovery**: Expose `.ad` project files as MCP Resources, allowing agents to "read" the API documentation and collection structure.
   - **Request Execution**: Provide MCP Tools that allow agents to execute requests. The agent can provide dynamic overrides for headers, query parameters, and body content.
   - **Environment Awareness**: Support API Dash environments, ensuring the agent uses the correct base URLs and secrets (e.g., Staging vs. Production).
   - **Agentic QA Flow**: Enable a workflow where a QA agent (triggered by a PR) can uses API Dash as its "execution engine" to verify that new code changes haven't broken existing endpoints.

   **Technical Approach**:
   - **Native Dart implementation**: Utilizing the `mcp_dart` SDK to ensure high performance and reuse of API Dash's core request logic.
   - **CLI-First**: The MCP server will be a sub-command of the API Dash CLI, making it easy to run in any environment.
   - **Response Handling**: The server will not just return raw JSON, but formatted context that helps the LLM understand success/failure states, including visualization data where applicable.

4. **Weekly Timeline**:

   - **Week 1-2: Community Bonding & Research**
     - Deep dive into `mcp_dart` and the inner workings of API Dash's request execution engine.
     - Finalize the MCP schema (Tools vs Resources).
   - **Week 3-4: Core CLI & Project Parsing**
     - Enhance the API Dash CLI to robustly parse `.ad` project files and extract request definitions.
   - **Week 5-6: Basic MCP Server Implementation**
     - Implement the `listResources` and `readResource` capabilities to let agents "see" the API collection.
   - **Week 7-8: Tool Execution & Dynamic Parameters (Mid-term)**
     - Implement the `callTool` capability to execute requests.
     - Add support for passing dynamic arguments from the LLM to the request.
   - **Week 9-10: Environment & Variable Support**
     - Integrate API Dash environment variables into the MCP context.
     - Implement credential masking and secure handling of sensitive keys.
   - **Week 11: Agentic QA Pilot & Testing**
     - Create a "QA Agent" demo using the MCP server to verify a set of local API endpoints.
     - Comprehensive unit and integration testing of the MCP server.
   - **Week 12: Documentation & Final Polish**
     - Complete the README, user guide, and GSoC final report.
     - Record a video demonstration of the "Agentic Testing" workflow.
