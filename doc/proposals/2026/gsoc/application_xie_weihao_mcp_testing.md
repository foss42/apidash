### About

1. Full Name
Xie Weihao

2. Contact info (public email)
xwh9497@gmail.com

3. Discord handle in our server (mandatory)
xwell_66

4. Home page (if any)
N/A

5. Blog (if any)
N/A

6. GitHub profile link
https://github.com/Xvvln

7. Twitter, LinkedIn, other socials
GitHub: https://github.com/Xvvln

8. Time zone
Asia/Shanghai (UTC+8)

9. Link to a resume (PDF, publicly accessible via link and not behind any login-wall)
https://raw.githubusercontent.com/Xvvln/gsoc-2026-resume/main/resume_xie_weihao.pdf

### University Info

1. University name
Wenzhou Medical University

2. Program you are enrolled in (Degree & Major/Minor)
Information Management and Information System

3. Year
3rd Year

4. Expected graduation date
2027

### Motivation & Past Experience

1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?
Yes. I have worked on and contributed to several open-source projects related to AI tooling, API infrastructure, and developer-facing systems.

Relevant repositories and contributions include:
- CLIProxyAPI: https://github.com/Xvvln/CLIProxyAPI
- CLI Proxy API Management Center: https://github.com/Xvvln/Cli-Proxy-API-Management-Center
- Merged PR in router-for-me/CLIProxyAPI: https://github.com/router-for-me/CLIProxyAPI/pull/2293
- Merged PR in router-for-me/Cli-Proxy-API-Management-Center: https://github.com/router-for-me/Cli-Proxy-API-Management-Center/pull/166
- Merged PR in cubezhao/ai-tools-mng: https://github.com/cubezhao/ai-tools-mng/pull/46

My open-source work has mainly focused on:
- multi-provider AI API compatibility
- management panels and developer tooling
- MCP-related tooling
- practical AI infrastructure and integrations

2. What is your one project/achievement that you are most proud of? Why?
The project I am most proud of is CLIProxyAPI and the surrounding tooling I built around it.

This project is meaningful to me because it deals with real API compatibility challenges across multiple providers such as OpenAI, Gemini, Claude, Codex, and others. It also involves management APIs, developer workflows, authentication, routing, and operational usability.

I am proud of it because it reflects the kind of engineering work I enjoy most: building practical infrastructure that makes complex AI systems easier for developers to use, test, and manage.

3. What kind of problems or challenges motivate you the most to solve them?
I am most motivated by problems that sit between systems, protocols, and developer experience.

I enjoy working on challenges such as:
- making different systems interoperable
- turning complex workflows into usable tools
- improving testing and reliability for developer-facing infrastructure
- reducing friction in AI and API workflows

Problems like MCP testing are especially motivating to me because they combine protocol understanding, implementation detail, usability, and ecosystem thinking.

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?
Yes, I plan to work on GSoC full-time and dedicate focused effort to the project.

5. Do you mind regularly syncing up with the project mentors?
Not at all. I am happy to regularly sync with mentors, discuss progress, get feedback, and adjust direction based on project needs.

6. What interests you the most about API Dash?
What interests me most about API Dash is that it is not just an API client, but a broader API development and testing platform that is evolving toward modern AI, agent, and tooling workflows.

I especially like that API Dash is exploring areas such as MCP, agentic workflows, multimodal APIs, and developer tooling. This makes it a very strong place to work on practical infrastructure that can be useful for a growing ecosystem.

7. Can you mention some areas where the project can be improved?
From my current understanding, one important improvement area is strengthening support for standardized testing workflows around emerging AI-facing interfaces such as MCP.

I think API Dash can add strong value by improving:
- MCP server/client testing workflows
- repeatable protocol validation and compatibility checks
- richer debugging and inspection for tool calls and outputs
- better support for multimodal and cross-provider test scenarios
- reusable test case definitions for developer-facing workflows

8. Have you interacted with and helped API Dash community? (GitHub/Discord links)
Yes. I introduced myself in the API Dash Discord community while preparing my GSoC application and shared my interest in Idea #1 MCP Testing. Although I joined the conversation relatively late, I came with a sincere intention to participate seriously and contribute over time. I am looking forward to contributing further through discussions, implementation work, and continued collaboration with the community.

### Project Proposal Information

1. Proposal Title
MCP Testing Workflows for APIDash

2. Abstract: A brief summary about the problem that you will be tackling & how.
The Model Context Protocol (MCP) is becoming an important interface layer for AI systems, tools, and agent workflows. As the MCP ecosystem grows, developers need better ways to create, inspect, validate, and test MCP servers and clients in a reproducible and developer-friendly manner.

This project proposes building MCP testing capabilities in API Dash, with a focus on server/client testing workflows, protocol-level validation, request/response inspection, reusable test cases, and cross-provider multimodal scenarios. The goal is to help developers use API Dash not only as an API tool, but also as a practical environment for testing MCP applications and workflows.

A key part of the project will be designing reusable testing flows and demonstrating them with concrete scenarios, including multimodal test cases such as image-generation-related MCP workflows using providers like GPT and Gemini. These scenarios will be used as representative validation targets rather than as isolated features, helping ensure that API Dash can support realistic MCP development and debugging workflows.

3. Detailed Description
#### Background and Problem
MCP is increasingly important as a standard interface for AI tools, agents, and developer workflows. However, the tooling ecosystem for MCP testing is still early.

Today, developers often face several practical issues:
- difficulty validating MCP request/response behavior consistently
- lack of reusable test cases for server/client workflows
- limited visibility into tool execution details and protocol-level behavior
- poor support for comparing behavior across different providers or multimodal workflows
- friction when debugging failures in real MCP applications

API Dash is well positioned to help solve these problems because it already focuses on API development, testing, and developer experience. Extending API Dash with MCP testing support would make it more useful for developers building modern AI-connected systems.

#### Goals
The project aims to add MCP testing support into API Dash through the following directions:

1. MCP testing workflow support
- provide a structured way to configure and run MCP-oriented tests
- support both MCP server and MCP client related testing flows where applicable
- allow repeatable execution of test cases

2. Request/response and execution inspection
- make MCP interactions easier to inspect and debug
- expose protocol-level information clearly for developers
- capture relevant metadata from test runs

3. Reusable test case definitions
- enable users to define and rerun MCP testing scenarios
- support test inputs, expected outputs, and validation-oriented metadata
- improve reproducibility and regression testing

4. Cross-provider and multimodal test scenarios
- include practical MCP testing scenarios that go beyond plain text-only cases
- design representative multimodal scenarios, such as image-generation-oriented MCP workflows using providers like GPT and Gemini
- use these scenarios to validate compatibility, parameter handling, output capture, and failure behavior

5. Developer experience and extensibility
- keep the implementation modular so that more MCP testing scenarios can be added later
- align with API Dash’s product direction and developer-facing UX

#### Proposed Approach
I would approach this project in phases.

##### Phase 1: Research and architecture alignment
- study the current API Dash architecture and existing related code paths
- identify where MCP testing concepts fit best in the current product
- define scope boundaries for the 175-hour project
- review MCP server/client usage patterns and common testing needs
- discuss expectations with mentors and refine milestones early

##### Phase 2: Test model and workflow design
- define the core structure for MCP test scenarios
- design how a test case should describe:
  - inputs
  - target MCP endpoint/server/client context
  - expected validation points
  - captured outputs and metadata
- decide how test cases should be stored, replayed, and inspected

##### Phase 3: Core implementation
- implement the core MCP testing workflow inside API Dash
- support running tests and inspecting results
- add useful debugging and validation views
- make the workflow usable for practical iteration

##### Phase 4: Cross-provider multimodal validation scenarios
- create representative test scenarios for realistic MCP usage
- include at least one multimodal test direction, such as image-generation-related MCP workflows across providers like GPT and Gemini
- focus on validating testability, compatibility, output capture, and reproducibility
- ensure these scenarios act as examples and regression assets

##### Phase 5: Polish, documentation, and feedback iteration
- improve UX and fix issues found during testing
- document how to use MCP testing in API Dash
- gather mentor/community feedback and refine the implementation

#### Why I am a good fit
My previous work strongly overlaps with this project:
- I have worked on MCP-related tooling, including an MCP server project.
- I have built and contributed to multi-provider AI API compatibility infrastructure.
- I have worked on developer-facing management UIs and operational tooling.
- I have experience with multimodal AI-related backends and integrations.
- I have practical experience with protocol adaptation, developer workflows, and usability-oriented engineering.

In addition, although I study at a university best known for medicine rather than computer science, I have remained deeply interested in open-source projects, developer tools, and AI infrastructure. Outside the classroom, I have spent significant time self-learning through documentation, source code reading, implementation, and open-source contribution. I also believe that one of my key strengths is my ability to learn independently and keep improving through practice.

4. Weekly Timeline: A week-wise timeline of activities that you would undertake.
#### Community Bonding Period
- understand the codebase and architecture in more depth
- discuss final scope and milestones with mentors
- finalize technical design and implementation breakdown
- identify the first deliverable and testing strategy

#### Week 1
- review API Dash architecture and existing relevant modules
- identify insertion points for MCP testing workflows
- finalize initial implementation plan

#### Week 2
- design data structures and workflow model for MCP test definitions
- prepare initial UI and execution flow ideas
- validate design with mentors

#### Week 3
- implement the first version of MCP test configuration and execution flow
- establish the foundation for storing and replaying tests

#### Week 4
- add result capture and inspection views
- improve protocol-level visibility for debugging

#### Week 5
- support reusable MCP test scenarios and rerun workflows
- begin validation-oriented result structuring

#### Week 6
- refine execution reliability and improve developer experience
- add better error reporting and inspection support

#### Week 7
- implement initial cross-provider MCP scenario coverage
- test compatibility-oriented workflows

#### Week 8
- add multimodal MCP scenario coverage
- prototype image-generation-oriented validation scenarios across providers such as GPT and Gemini

#### Week 9
- improve test case reusability, result display, and workflow polish
- fix issues discovered during internal testing

#### Week 10
- write and improve documentation
- prepare examples and usage guidance

#### Week 11
- incorporate mentor and community feedback
- improve UX and implementation quality

#### Week 12
- stabilize the project
- address remaining bugs and edge cases
- finalize deliverables and polish

#### Final Phase
- documentation cleanup
- final testing and bug fixes
- submit final project report and deliverables
