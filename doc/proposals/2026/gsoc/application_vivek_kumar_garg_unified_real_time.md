---
title: "GSoC 2026 Application: Unified Real‑Time Protocol Support & Visual Workflow Builder"
student: "Vivek Kumar Garg"
github: "viv2005ek"
mentors: "@animator @Ashita"
---

### About

1. **Full Name:** Vivek Kumar Garg  
2. **Contact info (public email):** viv2005ek@gmail.com  
3. **Discord handle in our server (mandatory):** shadowkiller8842
4. **Home page:** [https://vivekfolio-six.vercel.app/](https://vivekfolio-six.vercel.app/) 
5. **GitHub profile link:** [https://github.com/viv2005ek](https://github.com/viv2005ek)  
6. **LinkedIn:** [https://www.linkedin.com/in/vivek-kumar-garg-097677280/](https://www.linkedin.com/in/vivek-kumar-garg-097677280/)

7. **Time zone:** IST (UTC+5:30)  
8. **Link to a resume (PDF):** [https://vivekfolio-six.vercel.app/Resume.pdf](https://vivekfolio-six.vercel.app/Resume.pdf)

---

### University Info

1. **University name:** Manipal University Jaipur  
2. **Program:** B.Tech in Computer Science and Engineering  
3. **Year:** 3rd (Pre‑final year)  
4. **Expected graduation date:** May 2027

---

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
   Yes. I have contributed to several open‑source projects. Most notably, I was a **GSSOC'24 contributor** (GirlScript Summer of Code) and served as a **GSSOC'25 mentor**. I am currently preparing a small PoC for API Dash to demonstrate WebSocket integration.

2. **What is your one project/achievement that you are most proud of? Why?**  
   My proudest project is **IndoMate** – a patented, pre‑incubated security application with 5+ SOS modules. I presented it at 7+ national‑level competitions (including the AICTE National Round). It taught me how to build a product from idea to execution, handle user‑centric design, and manage cross‑disciplinary collaboration. It also deepened my commitment to building tools that have real‑world impact.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   I am most motivated by problems at the intersection of **developer experience and AI**. Anything that makes complex technical tasks simpler, more visual, or more accessible excites me. That’s why I’m drawn to API Dash – it’s a tool for developers, and I want to help make it the go‑to for real‑time API testing.

4. **Will you be working on GSoC full‑time? In case not, what will you be studying or working on while working on the project?**  
   Yes, I will be working full‑time during the GSoC coding period. My academic schedule is light during the summer, and I have no other internships or commitments that would conflict.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all. I actively participate in the weekly connects and am always available on Discord. I value regular feedback and iterative development.

6. **What interests you the most about API Dash?**  
   API Dash is a beautiful, cross‑platform, open‑source API client that already does HTTP/GraphQL/SSE well. I love the vision of making it the “next‑gen” tool for the AI era. The fact that it’s built in Flutter and the team is actively exploring MCP and agentic AI aligns perfectly with my interests.

7. **Can you mention some areas where the project can be improved?**  
   - **Real‑time protocol support** (WebSocket, MQTT, gRPC) – this is what I’m proposing.  
   - **Visual workflow builder** for testing multi‑step interactions without code.  
   - **Better feedback for long‑running operations** (e.g., loading states, cancelation).  
   - **Improved testability** of the core request/response flow.  
   - **Documentation** for contributors (I plan to help improve it as I learn).

8. **Have you interacted with and helped API Dash community? (GitHub/Discord links)**  
   Yes. I have joined the Discord server (`#gsoc-foss-apidash`), introduced myself, and am actively following the weekly connects. I have also forked the repository and am currently working on a small PoC (WebSocket manual testing) which I will submit as a PR soon. You can see my engagement in Discord.

---

### Project Proposal Information

1. **Proposal Title:**  
   Unified Real‑Time Protocol Support & Visual Workflow Builder for API Dash

2. **Abstract:**  
   API Dash currently supports HTTP, GraphQL, and SSE, but real‑time protocols like WebSocket, MQTT, and gRPC are essential for modern applications (IoT, streaming, microservices). This project adds first‑class support for these protocols through a **unified Dart abstraction layer**, providing consistent manual testing UI for each. Additionally, a **visual workflow builder** enables users to create multi‑step interaction sequences (connect, send, receive, assert, delay) without writing code. Workflows can be executed, debugged, and exported as code snippets (Dart/JavaScript). The outcome is a truly cross‑protocol API client that aligns with API Dash’s 2026 focus on AI and workflow automation, delivered within 175 hours.

3. **Detailed Description:**  
   The project will be built in three layers:  
   - **Core Protocol Abstraction** – Define abstract classes (`Connection`, `Message`, `Subscription`) that each protocol implements. This ensures a consistent interface for the UI and future extensions.  
   - **Manual Testing UIs** – For WebSocket, MQTT, and gRPC (unary calls first). Each will have its own tab with connection configuration, message composer, and live log.  
   - **Visual Workflow Builder** – A node‑based canvas where users drag actions (connect, send, receive, assert, delay) and connect them to form sequences. An execution engine runs the workflow step by step, supports variable binding, and displays progress. Completed workflows can be saved and exported as code snippets.  

   The implementation will be done in Flutter/Dart, reusing the existing state management and persistence layers. I will write unit and integration tests, and provide documentation. Stretch goals include gRPC streaming and AI‑assisted workflow generation.

4. **Weekly Timeline:**  

| Week | Tasks |
|------|-------|
| 1–2 | **Core Abstraction & WebSocket** – Define abstract classes; implement WebSocket using `web_socket_channel`. Build manual testing UI (URL, send, log). Unit tests. |
| 3–4 | **MQTT** – Add MQTT implementation via `mqtt_client`. Support MQTT 3.1.1 and 5.0, QoS 0/1/2. Extend manual UI for topic subscription and publish. |
| 5–6 | **gRPC** – Implement unary calls using `grpc`. Provide `.proto` file upload, list services/methods, and convert JSON to protobuf. (Streaming as stretch goal.) |
| 7–8 | **Visual Workflow Builder** – Build canvas with drag‑and‑drop nodes, connections, and JSON serialization. Basic node library (connect, send, receive). |
| 9–10 | **Execution Engine** – Implement runner that executes workflows, handles variable binding, and logs progress. Integrate with protocol implementations. |
| 11–12 | **Advanced Nodes & Error Handling** – Add Assert, Delay, and conditional branching. Implement timeouts, disconnection recovery, and detailed error reporting. |
| 13–14 | **Code Generation & Polish** – Generate Dart/JavaScript snippets from workflows. Improve UI with progress indicators, history, and import/export. Write user documentation. |
| 15–16 | **Testing & Final Delivery** – Cross‑platform testing (Windows, macOS, Linux). Integration tests. Bug fixes. Final PR preparation. |

**Total: 175 hours.** Stretch goals: gRPC streaming, more advanced workflow nodes (loops, parallel execution), and AI‑assisted workflow generation (leveraging my LLM experience).

---

**I confirm that I have read and agree to the API Dash AI Usage Policy and will abide by the community guidelines.**