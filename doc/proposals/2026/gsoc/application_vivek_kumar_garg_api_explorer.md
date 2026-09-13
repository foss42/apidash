---
title: "GSoC 2026 Application: API Explorer – Curated API Library & Automation Pipeline"
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
   Yes. I contributed to GSSOC'24 and was a mentor for GSSOC'25. I also maintain my own open‑source projects. I’m currently working on a WebSocket PoC for API Dash and engaging with the community.

2. **What is your one project/achievement that you are most proud of? Why?**  
   IndoMate – a patented security app with 5+ SOS modules. It taught me product development, automation, and user‑centric design.

3. **What kind of problems or challenges motivate you the most to solve them?**  
   I love building tools that improve developer experience – especially automating repetitive tasks and curating knowledge to make it accessible.

4. **Will you be working on GSoC full‑time? In case not, what will you be studying or working on while working on the project?**  
   Yes, I will work full‑time during the GSoC coding period.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all. I am active on Discord and will attend weekly connects.

6. **What interests you the most about API Dash?**  
   API Dash is a beautiful, cross‑platform API client with a strong focus on developer experience. The idea of an “API Explorer” fits my passion for making APIs discoverable and easy to use.

7. **Can you mention some areas where the project can be improved?**  
   - Curated library of public APIs with templates (this proposal)  
   - Better onboarding for new users (API Explorer reduces setup friction)  
   - Community contribution workflow for adding new APIs

8. **Have you interacted with and helped API Dash community? (GitHub/Discord links)**  
   Yes. I have joined Discord (`shadowkiller8842`), introduced myself, and opened two proposal PRs (#1455 and #…). I’m actively working on a WebSocket PoC.

---

### Project Proposal Information

1. **Proposal Title:**  
   API Explorer – Curated API Library & Automation Pipeline

2. **Abstract:**  
   Developers often waste time manually configuring API requests for popular services. This project builds an **API Explorer** within API Dash: a curated library of public APIs (AI, finance, weather, etc.) with pre‑configured templates. Users can discover, search, and import endpoints directly into their workspace. The core is an automation pipeline (Python) that parses OpenAPI specs and HTML documentation, auto‑tags, and generates request templates. A React/TypeScript UI will display the library, support search/filters, and allow one‑click import into API Dash.

3. **Detailed Description:**  
   The project consists of:
   - **Automation Pipeline (Python)**: Crawls public API directories (e.g., APIs.guru), parses OpenAPI/HTML, extracts endpoints, and enriches metadata (category, authentication, sample payload). Stores results in JSON or a database.
   - **Library UI (React/TypeScript)**: A new section in API Dash (embedded via WebView or separate component) showing the curated APIs with categories, search, and ratings. Each entry shows a preview and a button to import as a new request.
   - **Integration**: Imports will create a request in the user’s workspace using API Dash’s existing request model.

   The pipeline will be designed to be extensible so the community can contribute new API sources.

4. **Weekly Timeline (90 hours – 8 weeks coding):**  

| Week | Tasks |
|------|-------|
| **1–2** | Pipeline setup: Python scraper using `requests` and `openapi-spec-validator`. Parse a few sample APIs; output JSON. |
| **3–4** | Add auto‑tagging (keyword extraction) and enrich with sample payloads. Store data in a simple DB (SQLite or JSON). |
| **5–6** | Build React UI: list view, search, filters, categories. Display API details. |
| **7–8** | Integration with API Dash: add a new sidebar section, embed the React app (WebView or separate route), implement import functionality. Final polish, documentation. |

**Stretch goals:** community submission form, user ratings, and automatic updates from API sources.

---

**I confirm that I have read and agree to the API Dash AI Usage Policy and will abide by the community guidelines.**