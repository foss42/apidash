### About

1. 
**Full Name** - Shreyansh Jain 


2. 
**Contact info** - shreyansh_jain2005@yahoo.com 


3. **Discord handle** - shreyanshjain05
4. **Home page** - [shreyanshjain05.vercel.app](https://www.google.com/search?q=https://shreyanshjain05.vercel.app) 


5. **Blog** - [medium.com/@shreyanshjain05](https://medium.com/@shreyanshjain05) 


6. **GitHub profile link** - [github.com/shreyanshjain05](https://github.com/shreyanshjain05) 


7. **Twitter, LinkedIn, other socials** - [linkedin.com/in/shreyanshjain05/](https://www.linkedin.com/in/shreyanshjain05/) 

8. **Time zone** - IST
9. **Link to a resume** - [Publicly accessible Google Drive link](https://drive.google.com/file/d/1EFNRZi6JoXDTUqqfnwoDdD-Ujq116pLs/view?usp=share_link)

### University Info

1. 
**University name** - SRM Institute of Science and Technology 


2. 
**Program you are enrolled in** - B.Tech in Computer Science and Engineering 


3. 
**Year** - 3rd year 


4. 
**Expected graduation date** - May 2027 



### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

I didn’t nt worked on any FOSS project in past but I have developed and maintained two independent open-source initiatives published on PyPI:


* ModelViz-AI: A library for 2D/3D visualization of deep learning architectures.


* Apple Reminder MCP Server: MCP server enabling AI agents like Claude Code to manage tasks via natural language.

**2. What is your one project/achievement that you are most proud of? Why?**

Being a finalist in the **Smart India Hackathon 2025** among 800,000+ participants. Working on a problem statement from **ISRO** and receiving direct mentorship from ISRO scientists was a transformative experience that taught me how to solve complex, real-world research problems with high-precision AI/ML forecasting models.

**3. What kind of problems or challenges motivate you the most to solve them?**

I love building tools that empower the community to understand and interact with AI more effectively, as seen in my project **ModelViz-AI**, which helps beginners visualize deep learning architectures.

**4. Will you be working on GSoC full-time?**

I will be working on GSoC part-time. I will balance my hours alongside my college coursework and my current **AI Research Internship** at O6AI Labs.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all. I have a "builder's perspective" on research problems and would value brainstorming sessions to ensure the implementation is flawless and production-ready.

**6. What interests you the most about API Dash?**

API Dash stands out because it matches my technical stack and fills a critical gap in the market. While legacy platforms like Postman are widespread, they often lack native **AI-supported testing** or **multimodal capabilities**. Being open-source allows for specialized modifications that the community actually needs for modern, agentic workflows.

**7. Can you mention some areas where the project can be improved?**

Currently, API Dash lacks a formal **Model Context Protocol (MCP)** bridge, which limits its ability to integrate with AI-native platforms like Claude Code or Microsoft Copilot. Establishing this connection is essential for making it a "first-class citizen" in the AI agent ecosystem.


### Project Proposal Information

**1. Proposal Title** - MCP Testing & Multimodal API Validation

**2. Abstract**
The rapid evolution of AI agents necessitates a standardized way for models to interact with external tools and data. Currently, API Dash lacks a formal bridge to these platforms, limiting its utility in agentic workflows. This proposal tackles the problem by developing a robust **MCP Server** for API Dash using **Python** and **FastMCP**. The server will expose core REST and GraphQL capabilities as "Agentic Skills," allowing LLMs to autonomously send requests, generate code, and manage collections. A key innovation is the introduction of **Multimodal API Validation**—enabling agents to verify images and videos returned by APIs—and a **Meta-Testing Engine** that allows the agent to autonomously validate the protocol compliance of other MCP servers.

**3. Detailed Description**

**Technical Foundation**
The project will be built using **FastMCP**  to create a server that follows the Model Context Protocol standards. 

**Core Components:**

* **Execution Engine**: Tools like `send_request` and `test_endpoint` will allow the agent to perform full-cycle API testing (REST/GraphQL) through natural language.
* **Workspace Management**: Utilizing an **Import Parser**, the agent will be able to ingest **OpenAPI** or **Postman** collections directly into API Dash, allowing it to "learn" a new API surface area instantly.
* **Multimodal Validation**: The agent will use tools like `analyze_visual_response` (powered by vision LLMs and libraries like **Pillow**) to verify that API-generated images or videos match the requested business logic.

* **Meta-Testing Engine**: A specialized "Alignment Layer" that allows the agent to probe external MCP servers. It will check for protocol compliance and schema accuracy, ensuring the reliability of the entire agent-tool ecosystem.

![Architecture Diagram](images/shreyansh_mcp_architecture.png)



**4. Weekly Timeline**
| Week | What I'll be doing |
|------|--------------------|
| **1** | Project setup — FastMCP scaffolding, `pyproject.toml`, directory structure. Implement `send_request` for REST + GraphQL. Get it talking to Claude Code over stdio. |
| **2** | Build `test_endpoint` and `inspect_response`. Add proper error handling, timeouts. Write unit tests for core tools. |
| **3** | Implement `generate_code` tool and collection management (`save_to_collection`, `run_collection`). Add environment variable support. |
| **4** | Build the import parser for OpenAPI/Postman collections. Set up MCP Resources (collections, history, environments). |
| **5** | Multimodal foundation — implement `media_metadata_inspector` and the binary/media cache layer. |
| **6** | Integrate Vision LLM support for `analyze_visual_response`. Add `ocr_validation` for document APIs. |
| **7** | Build MCP meta-testing tools — `validate_mcp_server`, `test_mcp_tool`, `test_mcp_server`. Write integration tests. |
| **8** | Docs, Claude/Copilot/Codex setup guides, edge-case fixes, PyPI packaging, final cleanup and submission. |
