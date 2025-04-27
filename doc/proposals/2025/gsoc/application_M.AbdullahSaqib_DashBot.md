# **Project Proposal**

## **DashBot: An AI Assistant to Supercharge Developer Productivity in API Dash**

* **Organization**: API Dash

* **Mentors**: *\[TBD\]*

* **Applicant**: *M. Abdullah Saqib*	

---

# **PERSONAL INFORMATION**

## **CONTACT INFORMATION**

* **Name**: *M. Abdullah Saqib*

* **Email**: *mabdullahsaqib2004@gmail.com*

* **GitHub**: [*https://github.com/mabdullahsaqib*](https://github.com/mabdullahsaqib)

* **LinkedIn**: *https://www.linkedin.com/in/mas-ai/*

* **Resume**:  [Resume-Muhammad-Abdullah-Saqib.pdf](https://drive.google.com/file/d/1YNJ5UgIgIt3YFQo-YkV7_EL3b80Ed9i3/view)

* **Website**: *https://mas-ai.netlify.app/*

* **Discord**: zuichenzuk

* **Location**: *Pakistan*

* **Timezone**: *GMT \+ 5*

## **STUDENT AFFILIATION**

* **University**: *National University of Computer and Emerging Sciences (FAST)*

* **Degree**: Bachelor’s in Computer Science

* **Expected Graduation**: 2026

## **BRIEF BIO**

I am a Computer Science undergraduate with a deep interest in building AI assistants and intelligent developer tools. Over the last year, I’ve developed multiple projects focused on AI automation and natural language interfaces for developers. I am particularly excited about agent-based workflows, LLM evaluations, and improving the day-to-day experience for developers using cutting-edge tools. The DashBot project is a perfect match for my skills and interests, and I am eager to contribute toward making it an impactful, developer-first assistant.

---

# **PROJECT DESCRIPTION**

## **ABSTRACT**

The goal of this project is to design and implement **DashBot**, a modular and intelligent AI assistant for [API Dash](https://github.com/hoppscotch/api-dash). DashBot will allow developers to automate repetitive tasks, debug API interactions, generate documentation, write test cases, and even create frontend integration code — all via natural language commands. The assistant will be powered by LLMs and built with extensibility in mind so that new capabilities can be plugged in as needed.

Each feature of DashBot will also be benchmarked across different backend LLMs to help users make informed decisions based on speed, accuracy, and cost. By the end of the project, DashBot will significantly streamline API development, testing, and integration within the API Dash environment.

---

## **BACKGROUND**

APIs are central to modern software, and developer productivity tools are evolving rapidly with the help of AI. However, despite the capabilities of LLMs, most current tools are isolated — offering code generation or documentation help in silos.

DashBot proposes to unify this experience within API Dash by enabling developers to talk to their API workspace directly, in plain English. For example:

* “Why is my request returning a 401?”

* “Generate a React component that consumes this API.”

* “Explain this response — is anything wrong with it?”

* “Create unit tests for this endpoint.”

The modular agentic design will allow DashBot to map user intents to appropriate tasks using lightweight tools and LLM backends. Moreover, since multiple LLMs can be used, benchmarking will allow the community to decide which model performs best for each feature set.

By building DashBot as a native extension to API Dash, we can offer a seamless experience for developers — right where they already work.

---

## **PROJECT PROPOSAL**

### **OVERVIEW**

DashBot will be built as a modular AI agent with the following key capabilities:

* Response Explanation and Error Debugging

* API Documentation Generation

* Test Case Generation

* Visualization of API Responses

* Frontend Integration Code (React, Flutter, etc.)

Each module will expose clean interfaces for calling LLMs, processing context, and returning results. An evaluation framework will be created alongside, to test LLM performance across each of these tasks.

### **CORE COMPONENTS**

1. **Natural Language Interface**

   * Intent detection using pattern-based parsing \+ LLM classification

   * User prompt → mapped to module or tool

2. **LLM Abstraction Layer**

   * Swappable backends: OpenAI, Gemini, local models

   * Simple config switch for API keys or local usage

3. **Feature Modules**

   * 📘 *Explain & Debug API Responses*

   * 🧪 *Generate Unit & Integration Tests*

   * 📄 *Generate API Docs from Request-Response Pairs*

   * 📊 *Visualize JSON responses into plots/tables/charts*

   * 💻 *Generate React, Flutter code snippets for API integration*

4. **Benchmarking Framework**

   * Build a standard prompt set for testing each feature

   * Evaluate LLM outputs on response quality, latency, and cost

   * Store benchmark results in JSON/Markdown tables for public sharing

---

## **TECHNOLOGIES**

* **Languages**: Python, TypeScript, Dart (Flutter)

* **Frontend Frameworks**: React, Flutter

* **AI & LLM Tools**: OpenAI API, HuggingFace Transformers, Google Gemini

* **Data Handling**: JSON, Markdown

* **Testing & Evaluation**: PromptEval, custom scripts, CLI tools

* **Dev Tools**: Git, VS Code, REST clients, WebSocket APIs

---

## **TIMELINE**

| Period | Milestone |
| ----- | ----- |
| **Community Bonding** | Deep dive into API Dash internals, gather prompt patterns, meet mentors |
| **Week 1–2** | Set up project scaffolding, LLM abstraction, and base command routing |
| **Week 3–4** | Implement “Explain & Debug” and “Generate Docs” modules |
| **Week 5–6** | Add test generation and visualization support |
| **Week 7–8** | Add frontend code generation module (React, Flutter) |
| **Week 9–10** | Build and run benchmark suite for all modules across 2–3 LLMs |
| **Week 11–12** | Final polish, bug fixing, write usage & setup docs, prepare for release |

---

## **COMMITMENT**

* I will be fully committed throughout the GSoC timeline: **June 2 – August 25, 2025**

* I have no other academic or personal commitments during this period

* I will be available to contribute \~30 hours/week or more as required

* Communication will be regular via GitHub Issues, Discord, and async updates

---

## **POST-GSOC PLANS**

After GSoC, I’m excited to continue contributing to API Dash and improving DashBot. Some of the areas I’d love to explore post-GSoC include:

* Making DashBot pluggable with external APIs (e.g., Postman collections)

* Improving benchmark scoring with automated grading

* Bringing community contributions to fine-tune prompt libraries

DashBot has the potential to become a go-to assistant for every developer working with APIs — I’d be proud to help it grow beyond GSoC.

---

