---
title: "GSoC 2026 Application: Multimodal AI and Agent API Eval Framework"
student: "Vivek Kumar Garg"
github: "viv2005ek"
mentors: "@animator @ashitaprasad"
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
   Yes. I contributed to GSSOC'24 and was a mentor for GSSOC'25. I also maintain my own open‑source projects: [Thread.ai](https://github.com/viv2005ek/thread-ai), [PayPaqlu](https://github.com/viv2005ek/paypaqlu). I am currently preparing a WebSocket PoC for API Dash.

2. **What is your one project/achievement that you are most proud of? Why?**  
   IndoMate – a patented security app with 5+ SOS modules. It was pre‑incubated and presented at 7+ national competitions (including AICTE). It taught me product development, user‑centric design, and cross‑disciplinary teamwork.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   Problems at the intersection of **developer experience and AI**. I enjoy making complex tasks simpler, more visual, and accessible. This is why API Dash excites me – it's a developer tool with a great UX.

4. **Will you be working on GSoC full‑time? In case not, what will you be studying or working on while working on the project?**  
   Yes, I will be working full‑time. My academic schedule is light during the summer.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all. I actively participate in weekly connects and am available on Discord.

6. **What interests you the most about API Dash?**  
   API Dash is a beautiful, cross‑platform, open‑source API client. I love the vision of making it the “next‑gen” tool for the AI era. The focus on MCP, agents, and AI aligns with my interests.

7. **Can you mention some areas where the project can be improved?**  
   - Adding an AI evaluation framework (this proposal)  
   - Supporting real‑time protocols (my other proposal)  
   - Better visual workflow builder  
   - Enhanced documentation for contributors

8. **Have you interacted with and helped API Dash community? (GitHub/Discord links)**  
   Yes. I have joined Discord (`shadowkiller8842`), introduced myself, and submitted my first proposal PR (#1455). I’m also working on a WebSocket PoC.

---

### Project Proposal Information

1. **Proposal Title:**  
   Multimodal AI and Agent API Eval Framework for API Dash

2. **Abstract:**  
   Developers need to evaluate AI models (text, vision, voice) and agent APIs across multiple benchmarks, but existing tools are fragmented and lack unified UI. This project builds an end‑to‑end evaluation framework for API Dash, enabling users to configure test datasets, run benchmarks (e.g., lm‑harness, lighteval), visualize results, and compare models. It includes a backend (Python/FastAPI) to orchestrate evaluations asynchronously, a React/TypeScript dashboard for configuration and results, and integrates with API Dash’s existing Flutter app via REST. Deliverables: benchmark runner, dataset manager, evaluation UI, report generation, and documentation.

3. **Detailed Description:**  
   The framework consists of:
   - **Backend (Python/FastAPI)**: REST endpoints for jobs, dataset management, and benchmark integration. Uses Celery for async tasks and WebSockets for live progress.
   - **Frontend (React/TypeScript)**: Dashboard for configuring evaluations, viewing results with charts, and comparing multiple runs.
   - **Integration**: The dashboard will be embedded in API Dash (via WebView or separate page) and communicate with the backend via REST/WebSockets.

4. **Weekly Timeline:**  

| Week | Tasks |
|------|-------|
| 1–2 | Project setup: FastAPI, database models, basic CRUD. |
| 3–4 | Integrate lm‑harness and lighteval; parse results; async execution. |
| 5–6 | Dataset management: upload, validation, storage. |
| 7–8 | Job runner, WebSocket updates, cancellation, error handling. |
| 9–10 | React dashboard: job creation form, model selection. |
| 11–12 | Results view, charts, comparison view. |
| 13–14 | Embed dashboard in Flutter app; export features. |
| 15–16 | Testing, documentation, final demo. |

**Total: 350 hours.** Stretch goals: support for more benchmarks, AI‑driven result analysis.

---

**I confirm that I have read and agree to the API Dash AI Usage Policy and will abide by the community guidelines.**