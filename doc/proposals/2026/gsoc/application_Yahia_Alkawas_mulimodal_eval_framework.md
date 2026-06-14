### About

1. Yahia Ayman Ahmad Mohammad Alkawas
2. yahia.alkawas.w@gmail.com
3. Yahia Al-Kawas
4. Home page (N/A)
5. Blog (I typically post on linkedin)
6. https://github.com/YahyaElKawas
7. https://www.linkedin.com/in/yahya-ayman-5855701a6/
8. Time zone: UTC +2 EET, (Cairo)
9. CV link: https://drive.google.com/file/d/1ketWSvu-cDoIqczx5d-ECbUM_RfmKt8Z/view?usp=drive_link
   Side note: Yaya is easier in pronunciation that's why I typed it in the CV

### University Info

1. Cairo University
2. Artificial intelligence department at faculty of computers and artificial intelligence 
3. Enrolled in 2022
4. 2027 (Because switched from IT to Ai)

### Motivation & Past Experience

Short answers to the following questions (Add relevant links wherever you can):
1. Contribution: Built a real-time Multimodal AI Evaluation Framework PoC, integrating a FastAPI backend with a
React/TypeScript frontend: https://github.com/YahyaElKawas/apidash/blob/idea-multimodal-eval-framework/doc/proposals/2026/gsoc/yahia_alkawas_multimodal_eval_framework.md#-proof-of-concept-poc 
2. Achievements: I successfully solved most algorithmic problems (100+) in structured programming course in University (The professer was a high achieving Competitive programming coach) because it was within a tight deadline and competing with my colleagues 
   and have successfully got my certificate of achievement in a diploma in algorithms and data structures in which I have solved (200+) problems because it really needed time management between it and university (this semester I am making the university load less to balance between it and GSoC) 
   and have built and delivered e-commerce application within a tight deadline
3. Software engineering design and architecture problems are the most problems that inspire me, this is the mindset I love (inspired by Dr Soha Makady)
4. I will be studying in university while working on GSoC, but I think I can successfully build and deliver a large project because I am used to time management
5. I think syncing up with the project mentors is the most important communication skill to have because I believe that consistent communication is the key to staying aligned with the project goals and catching technical blockers early, I am also available weekly or bi-weekly via google meet or discord, and I will say daily what I have done in the project
6. What interests me the most about API Dash?
   I think it's unique next-generation ai-native api client, unlike traditional tools, API Dash is the only open-source client I’ve found that truly prioritizes multimedia and streaming responses (like PDF, Audio, and SSE)—features I’ve already begun experimenting with in my own PoC, I am particularly inspired by the organization’s 2026 roadmap, which focuses on the Model Context Protocol (MCP) and Agentic AI. I believe that as APIs shift from simple 'data fetchers' to 'agentic tools,' the industry will desperately need a Multimodal Evaluation Framework like the one I am proposing.
   Finally, the developer-centric UI is beautiful and high-performance, and the welcoming community and mentors have created an environment where I feel empowered to tackle complex technical challenges alongside experienced contributors and mentors (high performing community). I want my GSoC project to be the backbone that allows the community to safely test and deploy the AI Agents they are building.
8. Improvements: While API Dash is already a high-performance tool, I believe it can be improved in its handling of high-frequency real-time data. Currently, many API clients struggle with the UI overhead of streaming massive logs or real-time AI 'thinking' processes. Improving the efficiency of the streaming response parser and implementing a more robust virtualized terminal component would allow developers to handle long-running agentic tasks without lag.

9. Additionally, as the industry moves toward Agentic AI, API Dash can be improved by adding a dedicated Evaluation layer. Currently, testing multimodal models is largely manual; automating this through a standardized framework (like my proposed project) would make API Dash the go-to tool for AI engineers.
9. Have you interacted with and helped API Dash community? (GitHub/Discord links)
   I have been active in the Discord community, specifically engaging in technical discussions regarding the Multimodal AI and Agent API Eval Framework project. I have shared my functional Proof of Concept (PoC) video on Discord to demonstrate my ability to implement Server-Sent Events (SSE) and real-time React UIs, which received valuable feedback from the mentors. I have also liked to move toward MCP and reading the article on it.
   https://discord.com/channels/920089648842293248/942975979595395123/1488204858367545635
   And I am very fast-learner and have good experience with web and ai projects, and also good expeirience in solving algorithmic problems which is the mindset for any high performing software engineer, so I think this project is the most suitable to me.
### Project Proposal Information
PoC: https://drive.google.com/drive/folders/10PjfgWreAYQL0iB-CqWpIKKQcUAGmBJM?usp=drive_link
1. Title: Building a Real-Time Multimodal AI and Agentic Evaluation Framework for API Dash
2. Abstract: As AI models transition from simple text-based responses to complex, multimodal 'Agents' that use tools via the Model Context Protocol (MCP), there is a critical need for a standardized way to evaluate their performance. This project aims to build a lightweight, real-time evaluation framework within API Dash. By leveraging a FastAPI backend and a React frontend with Server-Sent Events (SSE), the framework will allow developers to run, stream, and visualize the accuracy of multimodal model outputs and tool-calling logic in real-time.
3. The project focuses on three core technical pillars:
Real-Time Execution Engine: Using Python’s subprocess and FastAPI’s StreamingResponse, I will build an engine that executes evaluation scripts and streams logs back to the UI instantly. This ensures a 'zero-latency' feedback loop for developers.
Multimodal UI Dashboards: I will develop specialized React components to visualize model accuracy across different modalities (Image, Audio, Text). This includes a terminal-style component for log streaming and a 'Metric Card' system for visualizing success/failure rates.
Agentic/MCP Integration: Following the 2026 roadmap, the framework will be designed to evaluate MCP-compatible agents. It will test if an agent successfully invokes the correct 'tools' and how it handles external context.
Architecture: The framework is designed to be dependency-lite, ensuring it remains portable and high-performance within the existing API Dash ecosystem."
5. Weekly Timeline:
  May 4 - June 1:  Community Bonding: Finalize JSON schema for eval metrics; set up local dev environment with mentors.
  Week 1-2:  Backend Scaffolding: Build the FastAPI core for executing and monitoring Python-based eval scripts.
  Week 3-4:  SSE Implementation: Implement the Server-Sent Events (SSE) pipeline to stream live logs from backend to frontend.
  Week 5-6:  Frontend Core: Develop the React 'Terminal' and 'Dashboard' layout following the API Dash Design Guidelines.
  Week 7-8:  Metric Visualization: Build the charting and visualization layer for multimodal results (accuracy, latency, cost).
  Week 9-10:  MCP Integration: Implement specific test cases for Agentic AI and MCP tool-calling evaluation.
  Week 11:  Refinement & Testing: Optimization of UI performance for large log files and high-frequency updates.
  Week 12:  Final Documentation: Complete user guides, API documentation, and the final project report.
