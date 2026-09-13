### About

1. **Full Name:** Syed Rayan
2. **Contact info:** isyedrayan@gmail.com
3. **Discord handle:** .syedrayan
4. **Home page:** N/A
5. **Blog:** N/A
6. **GitHub profile link:** https://github.com/isyedrayan1
7. **Socials:** [https://linkedin.com/in/isyedrayan , https://instagram.com/isyedrayan]
8. **Time zone:** IST (UTC +5:30)
9. **Link to a resume:** https://drive.google.com/file/d/15aOd45qYUGrt4F7JyzF-_LRXzwFOkzRv/view?usp=sharing

### University Info

1. **University name:** Annamacharya Institute of Technology and Sciences, Kadapa
2. **Program:** B.Tech in Artificial Intelligence & Machine Learning
3. **Year:** 3rd Year
4. **Expected graduation date:** April, 2027

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before?** I am currently diving deep into the API Dash ecosystem. I’ve been analyzing how `DashBot` handles user prompts and looking for entry points to inject a more "proactive" agentic layer that doesn't just respond, but validates.
2. **What is your one project/achievement that you are most proud of?** Developing RAG-based diagnostic tools for my college projects. My favorite moment was during a **College Science Day** demo where I showed an AI identifying a specific data-type mismatch in a pipeline—moving the AI from a "chatbot" to a "debugger."
3. **What kind of problems or challenges motivate you the most to solve them?** I am motivated by the "Blindness" of current AI coding assistants. We’ve all been there: an AI generates a `curl` command that looks perfect but fails because of a hidden header requirement or an outdated endpoint. I want to build the "Eyes" for the AI so it can verify its own work.
4. **Will you be working on GSoC full-time?** Yes, 100%. This is my primary focus for the summer.
5. **Do you mind regularly syncing up with the project mentors?** I prefer it. Building autonomous agents requires a tight feedback loop to ensure the "Self-Healing" logic is predictable and secure.
6. **What interests you the most about API Dash?** It isn't just a UI for APIs; it's becoming a bridge for AI. Most tools treat AI as an "extra," but API Dash is building for a world where AI agents are the primary users of APIs.
7. **Can you mention some areas where the project can be improved?** Currently, AI models in coding are "sandboxed"—they can't actually validate if the API they just explained actually works. I want to bridge that gap so the AI can "Execute, Observe, and Correct."
8. **Have you interacted with and helped API Dash community?** I am active on Discord (.syedrayan) and following the evolution of the Agentic AI roadmap in the GitHub discussions.

### Project Proposal Information

1. **Proposal Title:** Agentic API Testing: Bridging the AI-API Execution Gap
2. **Abstract:** I propose to build an autonomous Agentic AI library that moves beyond "Generative AI" and into "Verifiable AI." This agent won't just explain APIs; it will actively test them, maintain state across calls, and "Self-Heal" broken tests by diagnosing execution logs—solving the classic problem where AI models can write code but cannot validate its real-world execution.
3. **Detailed Description:** - **The "Disconnected AI" Problem:** I’ve faced this many times: an AI generates a request, you run it in `curl`, it fails, and you have to manually feed the error back to the AI. This "Manual Loop" is a major bottleneck in the dev cycle. Current models lack the permission or infrastructure to "touch" the API and see the result.
   - **Agentic Validation Layer:** I will build an agent that lives inside the execution loop. When an AI generates a test, the agent immediately executes it, observes the response, and—if it fails—diagnoses the issue (e.g., "The API expected a Bearer token, but you sent Basic Auth").
   - **Self-Healing Logic:** If an API contract evolves (e.g., a field changes from `user_id` to `uuid`), the agent will detect the mismatch, read the updated OpenAPI/Swagger spec, and automatically update the test assertions. This moves testing from "Script-based" to "Intent-based."
   - **Autonomous Interconnection:** The agent will be able to plan multi-step journeys (e.g., "Login -> Create Post -> Delete Post") and manage the dynamic IDs and tokens between these steps without human intervention.
   - **MCP Leverage:** Using the **Model Context Protocol (MCP)**, I will enable the agent to securely access local documentation as its "Source of Truth," ensuring it doesn't hallucinate outdated endpoints.
4. **Weekly Timeline:** - **Weeks 1-3:** Designing the "Observation Loop" and the OpenAPI spec-parsing engine.
   - **Weeks 4-6:** Implementing the State Management system (handling dynamic tokens and inter-request dependencies).
   - **Weeks 7-9:** Developing the "Investigation & Self-Healing" module that reacts to 4xx/5xx errors.
   - **Weeks 10-12:** Integration with the core UI, benchmarking agent accuracy, and final documentation.
