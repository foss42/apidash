# GSoC 2026 Application

## About

1. **Full Name**  
   Avinav Verma

2. **Contact info (public email)**  
   avinavverma810@gmail.com

3. **Discord handle in our server (mandatory)**  
   tarfarian

4. **Home page (if any)**  
   N/A

5. **Blog (if any)**  
   N/A

6. **GitHub profile link**  
   https://github.com/avinavverma

7. **Twitter, LinkedIn, other socials**  
   LinkedIn: https://www.linkedin.com/in/avinavverma/  
   Twitter/X: N/A  
   Other: N/A

8. **Time zone**  
   Asia/Kolkata (IST, UTC+5:30)

9. **Link to a resume (PDF, publicly accessible via link and not behind any login-wall)**  
   https://drive.google.com/file/d/1w-CKnDKdKRQjKR7XJLc2QWTH_NdAOD30/

---

## University Info

1. **University name**  
   Indian Institute of Information Technology and Management (ABV-IIITM), Gwalior

2. **Program you are enrolled in (Degree & Major/Minor)**  
   Integrated B.Tech in Information Technology + MBA

3. **Year**  
   3rd Year

4. **Expected graduation date**  
   June 2028

---

## Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
   Before contributing to API Dash, I did not have significant formal FOSS contribution experience. API Dash has been my main hands-on open-source learning experience, and through it I have learned how to understand an existing codebase, work with maintainers through review feedback, and contribute changes in a collaborative way.

   Relevant API Dash links:  
   - Repository: https://github.com/foss42/apidash  
   - Merged PR: https://github.com/foss42/apidash/pull/1104  
   - Merged PR: https://github.com/foss42/apidash/pull/1345  
   - Related issue: https://github.com/foss42/apidash/issues/1090  
   - Related issue: https://github.com/foss42/apidash/issues/1103

2. **What is your one project/achievement that you are most proud of? Why?**  
   I am most proud of the work I have done on API-related systems and my contributions to API Dash. What makes that meaningful to me is not just solving an isolated technical problem, but contributing to tooling that directly improves how developers work. I enjoy building systems that reduce friction, improve clarity, and make workflows more reusable, which is also why this GSoC project strongly interests me.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   I am most motivated by problems where the current workflow is fragmented, repetitive, or unnecessarily manual. I enjoy understanding where developers lose time or context, and then designing solutions that make the process more structured, reliable, and intuitive. Problems in developer tooling, system design, workflow automation, and usability especially motivate me because a good solution can help many users at once.

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**  
   Yes, I plan to work on GSoC full-time and dedicate the required effort consistently during the coding period. If any academic commitments come up, I will communicate them early and plan my milestones so they do not affect delivery.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all. I value regular syncs and feedback, especially for a project that touches architecture, developer experience, and UI. I am comfortable discussing progress frequently, sharing intermediate designs, and adjusting implementation based on mentor feedback.

6. **What interests you the most about API Dash?**  
   What interests me most about API Dash is that it focuses on a practical developer workflow. It is a tool where both technical correctness and product experience matter. I also like that it has room to grow in meaningful directions, especially around API discovery, request reuse, debugging, and automation. That makes it a very exciting project to contribute to.

7. **Can you mention some areas where the project can be improved?**  
   I think API Dash can be improved by supporting more of the full API interaction lifecycle, not just individual request execution. Some areas that can be strengthened are:
   - easier API discovery through OpenAPI import
   - reusable request templates
   - better credential/profile management
   - support for multi-step request workflows
   - structured response-to-request data transfer
   - stronger debugging visibility for chained API interactions

   My proposal is directly focused on these areas.

8. **Have you interacted with and helped API Dash community? (GitHub/Discord links)**  
   Yes. I have interacted with API Dash through GitHub contributions and issue-related work, and I would like to continue contributing more deeply through GSoC.

   Relevant links:  
   - PR: https://github.com/foss42/apidash/pull/1104  
   - PR: https://github.com/foss42/apidash/pull/1345  
   - Issue: https://github.com/foss42/apidash/issues/1090  
   - Issue: https://github.com/foss42/apidash/issues/1103

---

## Project Proposal Information

1. **Proposal Title**  
   API Explorer and Workflow Automation System for API Dash

2. **Abstract: A brief summary about the problem that you will be tackling & how.**  
   This project proposes the development of an integrated API Explorer and Workflow Automation System for API Dash. The problem it addresses is that modern API usage often involves multiple dependent requests, authentication handling, and response-to-request data transfer, but these tasks are usually split across different tools or handled manually.

   To solve this, I propose two tightly connected additions to API Dash:
   - an OpenAPI-based API Explorer that parses specifications and generates reusable request templates
   - a workflow automation system that allows users to build and execute multi-step API workflows inside API Dash

   The system will also include secure credential profile management, automatic auth injection, and a JSONPath-based mapping layer for extracting values from one response and using them in subsequent requests. The goal is to make API Dash a more complete developer workflow tool for discovering, configuring, executing, and automating APIs.

3. **Detailed Description**  
   APIs are a core part of modern software systems, but real-world API usage is rarely limited to one isolated request. Developers often need to authenticate, call an endpoint, extract a token or identifier from the response, and use that value in one or more later requests. They may also need to repeat the same sequence many times while testing an integration or debugging a workflow.

   Existing tools usually address only one slice of this process. API clients such as Postman and Insomnia are strong for request construction and inspection, while workflow tools such as Zapier and n8n support chained automation. However, there is still a gap between detailed request-level control and structured multi-step execution. That gap creates unnecessary manual work and poor repeatability.

   This project aims to fill that gap in API Dash through two major subsystems.

   ### API Explorer
   The API Explorer will parse OpenAPI specifications and convert them into structured endpoint definitions that can be imported into API Dash as reusable request templates. This reduces the need for manual request construction and makes onboarding to new APIs much faster.

   The explorer will support:
   - parsing OpenAPI specs
   - extracting endpoint metadata such as method, path, parameters, and request body details
   - generating reusable request templates
   - making imported endpoints easier to browse and reuse

   Illustrative parsing flow:

   ```python
   import json

   def parse_openapi(file_path):
       with open(file_path) as f:
           spec = json.load(f)

       endpoints = []
       for path, methods in spec.get("paths", {}).items():
           for method, details in methods.items():
               endpoints.append({
                   "path": path,
                   "method": method.upper(),
                   "parameters": details.get("parameters", []),
                   "requestBody": details.get("requestBody", {})
               })
       return endpoints
   ```
   Illustrative Template Generation:

   ```python
   def generate_template(endpoint):
    return {
        "url": endpoint["path"],
        "method": endpoint["method"],
        "headers": {},
        "params": {},
        "body": {}
    }
   ```
   
   ### Workflow Automation System
   The workflow system will let users chain multiple requests into a structured sequence. Each workflow step will reference a request template, optionally use a credential profile, and optionally extract values from the response for later steps.

   The execution model will be state-driven, with each step moving through states such as:
   - Pending
   - Running
   - Completed
   - Failed
   - Retrying

   This makes the system easier to debug and gives users clearer visibility into what happened during execution.

   Illustrative Executor Logic:

   ```python
   class WorkflowExecutor:
    def __init__(self, workflow, templates, credential_manager):
        self.workflow = workflow
        self.templates = templates
        self.credential_manager = credential_manager
        self.state = {}

    async def run(self):
        for step in self.workflow["steps"]:
            result = await self.execute_step(step)
            if result["status"] == "failed":
                return result
            self.state[step["id"]] = result["data"]
        return {"status": "success", "state": self.state}
   ```

   ### Data Mapping Layer
   A key part of the workflow system is transferring data between steps. I plan to use JSONPath-based extraction so that values from one response can be mapped into later requests.

   Example:

   ```python
   from jsonpath_ng import parse
   def extract(json_data, path):
    expr = parse(path)
    matches = [match.value for match in expr.find(json_data)]
    return matches[0] if matches else None
   ```

   This can support workflows such as:
   - auth token retrieval followed by authenticated requests
   - resource creation followed by resource lookup or update
   - extracting IDs, cities, user handles, or other response fields into later requests

   ### Credential Manager
   The system will include a credential manager with support for multiple profiles. Credentials will be stored securely and kept separate from workflow definitions so that workflows remain reusable while secrets stay local.

   MVP auth support will include:
   - API key headers
   - bearer tokens
   - static header injection

   This makes it easier to reuse credentials across standalone requests and multi-step workflows.

   ### Workflow Builder UI
   For the MVP, I plan to build a step-based workflow builder instead of a full graph editor. This keeps the scope realistic while still being very useful.

   The builder will allow users to:
   - add and reorder steps
   - assign request templates
   - define extraction rules
   - choose credential profiles
   - run workflows and inspect outputs

   This approach is simpler to implement, easier to review, and better aligned with the GSoC timeline.

   ### Why this project is valuable
   This project helps API Dash evolve from a request-focused API client into a more complete developer workflow platform. It improves:
   - API onboarding
   - request reuse
   - credential handling
   - automation of repeated API sequences
   - debugging visibility for multi-step execution

   It also lays the groundwork for future improvements such as graph-based workflows, conditional branching, and parallel execution.

3. **Weekly Timeline: A week-wise timeline of activities that you would undertake.**

   ### Community Bonding Period
   - Get deeper familiarity with API Dash architecture and relevant request/data models
   - Discuss final design boundaries with mentors
   - Review relevant issues, previous discussions, and code paths
   - Finalize milestone breakdown and PR plan

   ### Week 1
   - Set up local development workflow for the project
   - Study request execution flow and storage patterns in the codebase
   - Finalize data models for templates and workflows

   ### Week 2
   - Implement initial OpenAPI parser
   - Extract basic endpoint metadata: path, method, parameters, request body

   ### Week 3
   - Add template generation from parsed endpoints
   - Handle incomplete spec cases and validation fallback
   - Prepare first PR for parser/template foundation

   ### Week 4
   - Design and implement credential profile model
   - Add support for secure local credential storage
   - Start auth injection support for requests

   ### Week 5
   - Complete credential integration with request execution
   - Add support for API key and bearer token workflows
   - Submit PR for credential manager system

   ### Week 6
   - Define workflow schema and execution state model
   - Implement sequential workflow executor foundation

   ### Week 7
   - Add step execution handling, state updates, and fail-fast behavior
   - Add retry support for failed steps
   - Submit PR for workflow executor core

   ### Week 8
   - Implement JSONPath-based extraction layer
   - Add variable propagation from one step to another

   ### Week 9
   - Add mapping validation and clearer failure reporting
   - Integrate extraction results with request preparation
   - Submit PR for data mapping layer

   ### Week 10
   - Build initial workflow builder UI
   - Support adding steps, selecting templates, and assigning profiles

   ### Week 11
   - Add extraction configuration and workflow execution view
   - Improve UI feedback for running/completed/failed states

   ### Week 12
   - Integrate UI with workflow engine end to end
   - Submit PR for workflow builder MVP

   ### Week 13
   - Add tests for parser, executor, mapping, and credential flow
   - Improve error messages, edge-case handling, and polish

   ### Week 14
   - Write documentation for users and contributors
   - Fix review feedback and finalize integration work

   ### Final Week
   - Buffer for mentor feedback, bug fixes, final cleanup, and submission preparation

---

## Additional Notes

### Risks and Mitigation
- **Incomplete OpenAPI specs**: I will provide validation and fallback behavior, including manual template adjustment where needed.
- **Mapping failures**: I plan to add validation and clearer error reporting for JSONPath extraction.
- **Authentication variability**: The MVP will focus on core auth strategies first, while keeping the design extensible.
- **Scope growth**: I will keep the initial implementation focused on sequential workflows and a step-based builder rather than advanced graph features.

### Out of Scope for MVP
- Graph-based drag-and-drop workflow builder
- Parallel execution
- Advanced conditional branching
- Scheduling and analytics dashboards
- Full OAuth lifecycle automation
