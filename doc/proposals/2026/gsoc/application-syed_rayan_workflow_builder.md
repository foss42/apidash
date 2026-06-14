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

1. **Have you worked on or contributed to a FOSS project before?** I am an active AI/ML enthusiast now focusing my full technical energy on the API Dash ecosystem. I’ve been analyzing the `DashBot` code to see how my proposed "Self-Healing" agents can integrate with the existing AI features.
2. **What is your one project/achievement that you are most proud of?** Developing RAG-based diagnostic tools for my college projects. There is a specific "Eureka" moment when an AI doesn't just hallucinate an answer but actually uses provided context to solve a technical error. That is the experience I want to bring to API Dash.
3. **What kind of problems or challenges motivate you the most to solve them?** I am motivated by "Silent Failures." I’ve spent hours debugging APIs only to realize a field name was changed from `user_id` to `uuid`. This is a problem a machine should solve. I want to build software that "thinks" and "heals" so humans can focus on building features.
4. **Will you be working on GSoC full-time?** Yes, 100%. No other commitments.
5. **Do you mind regularly syncing up with the project mentors?** Yes. Building autonomous agents requires constant alignment to ensure the "Self-Healing" logic is safe and doesn't introduce side effects.
6. **What interests you the most about API Dash?** Its ambition. While other tools are just adding "AI Chatbots," API Dash is looking at **Agentic AI** and **MCP**. This is the future of how software will be tested, and I want to be part of that shift.
7. **Can you mention some areas where the project can be improved?** Currently, if an API changes, your test scripts break and you have to fix them manually. The next evolution is an agent that detects the change, reads the new OpenAPI spec, and fixes the test for you.
8. **Have you interacted with and helped API Dash community?** Active on Discord and following the development of the Agentic AI roadmap in the GitHub discussions.

### Project Proposal Information

1. **Proposal Title:** Agentic API Testing
2. **Abstract:** I propose to build an autonomous "Agentic AI Library" that moves API testing from manual scripts to intelligent quality assurance. This agent will understand API specs, maintain state across multi-step flows, and "Self-Heal" broken tests by analyzing real-time execution logs.
3. **Detailed Description:** - **The "Context Gap" Problem:** Current AI models often give generic advice because they don't see the "Full Picture" of the API contract. My project bridges this gap by feeding the **OpenAPI/Swagger** spec directly into the agent's reasoning loop.
   - **Self-Healing Logic:** When a test fails, the agent will trigger an "Investigation Mode." It will parse the error (e.g., 400 Bad Request), look at the schema, identify the mismatch, and automatically propose (or apply) a fix to the request parameters or assertions.
   - **Autonomous Strategy:** Instead of writing 50 manual tests, a user will ask the agent: *"Test the security and edge cases of my payment flow."* The agent will then autonomously generate and execute high-coverage tests for performance, security, and functional correctness.
   - **MCP Support:** I will investigate using **Model Context Protocol (MCP)** to allow these testing agents to "talk" to local project files, ensuring the AI always has the latest documentation as its "Source of Truth."
4. **Weekly Timeline:** - **Weeks 1-3:** Architecting the Agentic AI Library and the OpenAPI spec-parsing engine.
   - **Weeks 4-6:** Implementing multi-step "State Tracking" (handling Auth tokens and dynamic IDs).
   - **Weeks 7-9:** Developing the "Investigation & Healing" module for autonomous assertion updates.
   - **Weeks 10-12:** Integrating with the core UI, benchmarking the agent's accuracy, and documentation.
