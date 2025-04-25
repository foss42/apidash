# GSoC Proposal
## DashBot - AI-Powered API Assistant


## About

1. **Full Name**: Loghadhith J R
2. **Email**: logha6824@gmail.com  
3. **Phone-no**: +91-6380572051
4. **Discord Handle**: Loghadhith
5. **Home Page**: nil
6. **Blog**: nil
7. **GitHub Profile Link**: [github.com/Loghadhith](https://github.com/Loghadhith/)  
8. **Twitter**: nil
9. **LinkedIn**: nil
10. **Time Zone**: Indian Standard Time (IST, UTC+5:30)  
11. **Link to a Resume**: [Resume](https://drive.google.com/file/d/19UzV2vpNRMRkDMYV2NbjoB06mdw_GJgR/view?usp=sharing)  
---
## University Info
- **University Name**: Chennai Insititute of Technology
- **Program**: B.E in Computer Science and Engineering (Artificial Intelligence and Machine Learning) 
- **Year**: 3rd Year (Started in 2022)
- **Expected Graduation Date**: May 2026  
---
## Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
   No

2. **What is your one project/achievement that you are most proud of? Why?**  
One project I’m most proud of is THREADS, an open-source e-commerce assistant that uses similarity search and voice assistance to guide non-tech savvy users. It taught me how to design complex architecture with LLMs, and I'm proud of how it combines technology with real-world user experience to make online shopping more accessible.
   

3. **What kind of problems or challenges motivate you the most to solve them?**
I’m motivated by challenges that simplify complex systems and improve user experience, especially for non-tech savvy individuals. Solving problems with new technologies, like LLMs, excites me because it allows me to create impactful, accessible solutions.
   

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**  
   Yes, I’ll be working full-time on GSoC.

5. **Do you mind regularly syncing up with the project mentors?**  
   Not at all, I’m happy to sync up regularly.

6. **What interests you the most about API Dash?**  
   Its lightweight, developer-focused design and potential for smart automation.

7. **Can you mention some areas where the project can be improved?**  
   Add LLM-powered plugins for automated insights, testing, and integration.
---
## Project Proposal Information

### 1. Proposal Title  
**DashBot - AI-Powered API Assistant for API Dash**

### 2. Abstract  
API Dash simplifies API interaction, but repetitive tasks like debugging, documentation, and testing still demand developer effort. DashBot introduces a natural-language-based AI assistant inside API Dash that helps explain, debug, document, test, and visualize APIs. By leveraging LLMs and context-aware routing, DashBot will supercharge developer productivity and reduce cognitive load.

### 3. Detailed Description
DashBot will be a modular AI assistant built into API Dash to handle natural-language queries and automate critical but repetitive developer tasks. It will support the following core features:
- **Response Explanation:** Converts raw API responses into easy-to-understand English.
- **Debugging Assistant:** Diagnoses failed API calls using status codes and error messages.
- **Documentation Generator:** Produces markdown/OpenAPI-style docs automatically.
- **Test Generator:** Creates integration/unit test code based on API behavior.
- **Visualizer:** Generates plots from JSON responses.
- **Frontend Integration Code Generator:** Outputs working code snippets for frameworks like React, Vue, Flutter, etc.

DashBot will include:
- An **NLP + prompt generation layer** to parse natural language.
- A **modular routing system** to direct tasks to appropriate LLM-backed modules.
- Integration hooks to read request/response data from API Dash’s store.
- UI components to embed DashBot seamlessly inside Apidash’s existing interface.

The entire system will be modular and extensible, ensuring future contributions and new features can plug into the core easily.

---
### 4. Architecture Diagram
![1743958514](https://github.com/user-attachments/assets/ef3d1d7c-5c58-4183-864a-8711bcd1f62e)
---

### 5. Weekly Timeline (12 Weeks)

| Week | Activities |
|------|------------|
|  1  | Finalize architecture, scope, and module breakdown |
|  2  | Build DashBot UI inside Apidash; develop NLP intent router |
| 3–4  | Implement Orchestration Layer + LLM Gateway |
| 4–5  | Develop core modules: Explainer, Debugger, Test Generator |
| 6–7| Build Visualizer & Frontend Code Generator modules |
| 8–9| Documentation generator + context-aware prompt enhancements |
| 10-11   | Logging, feedback collection, performance improvements |
| 11   | End-to-end testing with real APIs; edge case handling |
| 12   | Final polish, documentation, and MVP release 🎉 |

---

#### **Week 1 – Planning & Architecture**
- Community bonding period
- Finalize overall scope based on GSoC proposal.
- Define system architecture: DashBot core, AI modules, orchestration layer, LLM integration, UI interface.
- Plan modular structure for each feature (e.g., explainer, visualizer).
- Choose tech stack, finalize third-party API providers (OpenAI, Ollama, etc.).
- Setup project skeleton: repository structure, linting, CI, and code quality tools.

---

#### **Week 2 – UI & Intent Recognition**
- Design and integrate DashBot’s user interface within Apidash:
  - Natural language input box
  - Output/response pane
  - Quick-action suggestions
- Implement an **Intent Router**:
  - Parse natural language to route user queries (e.g., "Explain this response", "Generate test")
  - Map intents to module calls using regex or lightweight NLP libraries.

---

#### **Weeks 3–4 – Orchestration Layer & LLM Gateway**
- Develop the **Orchestration Layer** to:
  - Receive user input
  - Call appropriate AI module
  - Return result to frontend
- Build a **pluggable LLM gateway** to support multiple model providers (OpenAI, Claude, Gemini, Ollama).
- Add retry logic, error handling, and token usage monitoring.

---

#### **Weeks 4–5 – Core Modules: Explainer, Debugger, Test Generator**
- **Explainer**: Parses API response and uses LLM to output plain-English explanations.
- **Debugger**: Analyzes failed requests based on status code, headers, and error messages. Suggests causes and fixes.
- **Test Generator**: Produces unit/integration test cases using popular frameworks (e.g., Jest, Postman, or Python’s `unittest`).

---

#### **Weeks 6–7 – Visualizer & Frontend Code Generator**
- **Visualizer**:
  - Extracts structured data from JSON
  - Generates basic plots (line, bar, pie) using lightweight charting libs
  - Allows user customization (fields, chart type)
- **Frontend Code Generator**:
  - Converts API call structure into ready-to-use code snippets
  - Supports React (fetch/axios), Flutter (Dio/http), Vue, etc.
  - Customizes auth headers, parameters, and error handling

---

#### **Weeks 8–9 – Documentation & Context Enhancements**
- **Documentation Generator**:
  - Automatically converts API calls and responses into structured Markdown or OpenAPI-style documentation.
  - Supports headers, body, query params, and sample responses.
- Enhance prompts and modules using **context-aware input**:
  - Include request metadata (method, headers, params) in prompt
  - Maintain short-term context history (last few interactions)

---

#### **Weeks 10–11 – Logging, Feedback & Edge Cases**
- Implement:
  - Logging system to track DashBot usage and performance
  - Anonymous feedback system for collecting suggestions/ratings
- Improve:
  - Prompt quality (edge case prompts)
  - Error-handling for null/undefined/malformed responses
- Optimize:
  - Caching repeated LLM outputs for performance
  - Limit token usage for cost efficiency

---

#### **Week 12 – Final Polish & MVP Release**
- Finalize UX for all modules.
- Conduct full test suite (unit, integration, manual flows).
- Clean up codebase, remove dev tools, finalize docs.
- Release DashBot MVP with full documentation and usage instructions.
- Prepare final demo and handoff plan (if needed).

---

## 6.Techstack


#### 1. **NLP Module (Intent + Entity Extraction)**
- **SpaCy**: For tokenization and entity recognition.
- **Hugging Face Transformers**: For intent detection with pre-trained models (e.g., BERT, GPT).
- **Rasa/Dialogflow**: For conversational AI (optional).

#### 2. **AI Feature Modules (Response Explainer, Debugging, etc.)**
- **OpenAI API**: For text generation (GPT-3/4, Codex for code).
- **LangChain**: For complex chaining and interactions of LLMs.
- **GPT-J**: Open-source alternative for local processing.

#### 3. **Orchestration Layer**
- **Celery**: For managing asynchronous tasks.
- **Redux** (Flutter equivalent: **Riverpod** or **Provider**): For state management and conversation context.
- **BullMQ**: For background task management (Node.js backend, if any).
  
#### 4. **Knowledge Base / Contextual Data Store**
- **Elasticsearch**: For indexing and searching API specs, logs.
- **MongoDB**: Flexible NoSQL database for storing user interactions and configurations.
- **Redis**: For quick access to session and context data.
- **SQLite**: Lightweight local database for storing interaction history.

#### 5. **Logging & Feedback**
- **Sentry**: For error monitoring and real-time feedback.
- **LogRocket**: For frontend user session logging (Flutter can integrate via native bridge).
- **Google Analytics / Mixpanel**: For usage analytics and tracking.

#### 6. **UI & Frontend (Flutter)**
- **Flutter**: Cross-platform UI framework for DashBot integration.
- **Riverpod** or **Provider**: For state management in Flutter.
- **Tailwind CSS**: If required in Flutter web apps (via Flutter Web integration).
- **Chart.js / Plotly**: For generating visualizations.

#### 7. **Code Integration & Test Generation**
- **Swagger/OpenAPI**: For API documentation generation.
- **Jest/Mocha**: For generating and running unit tests (via Node.js backend, if any).
- **Yeoman**: For scaffolding code templates (if necessary).

#### 8. **Other**
- **Redis**: For quick caching and session data.
- **PostgreSQL**: If relational data is needed.

