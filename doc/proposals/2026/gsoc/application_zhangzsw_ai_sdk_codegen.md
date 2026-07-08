### About

1. **Full Name**: Zhang Zsw
2. **Contact info (public email)**: babbnejn@gmail.com
3. **Discord handle in our server (mandatory)**: Whdbjq111
4. **GitHub profile link**: https://github.com/wxxz123
5. **Time zone**: UTC+8 (Beijing Time)


### University Info

1. **University name**: Zhengzhou University 
2. **Program you are enrolled in**: Bachelor of Engineering in Cyber Security
3. **Year**: Sophomore (2nd Year)
4. **Expected graduation date**: June 2028

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**
   While this will be my first time formally applying to a large-scale FOSS organization like API Dash through Google Summer of Code, I possess a solid foundation in Java and frontend development. Recently, I have deeply engaged with the open-source community by studying and actively developing open-source RAG (Retrieval-Augmented Generation) frameworks on GitHub (detailed below).

2. **What is your one project/achievement that you are most proud of? Why?**
   My proudest achievement is an open-source Medical RAG Knowledge Base system tailored for pharmaceutical consultation. Starting with zero foundational background in AI/RAG, I self-taught the necessary core concepts, cloned a baseline open-source project, and completely rewrote its architecture to integrate domain-specific medical data. Open-sourcing it on GitHub not only reinforced my programming abilities but also gave me a profound, hands-on understanding of the entire RAG pipeline—from vectorizing queries to chaining LLM prompts and retrieving accurate medical records.This is the link:https://github.com/wxxz123/MedGraphRAG

3. **What kind of problems or challenges motivate you the most to solve them?**
   I am deeply motivated by "Developer Experience (DX)" friction. During my journey of learning AI and developing the Medical RAG system, I constantly encountered a frustrating loop: I would use API testing tools to fine-tune my LLM prompts and API parameters, but then I had to mentally (and painfully) translate those raw JSON/HTTP configurations into Python `LangChain` classes or `openai` SDK method calls. The lack of a tool that seamlessly bridges "API testing" and "AI SDK implementation" drove my interest in optimizing exactly this workflow for API Dash.

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**
   I am fully committed to completing this GSoC project. Regarding the timeline (late May to late August):
   - **Late June**: I will have my university final exams.
   - **July**: Occasional school scheduled social practice activities.
   - **August**: Official university summer vacation.
   Although the schedule has overlaps, I am highly disciplined. I plan to front-load my research and heavy codebase exploration in May/early June, maintain steady commits during exams, and compensate by dedicating intensive, full-time hours (40+ hours/week) during August to ensure the project is delivered flawlessly.

5. **Do you mind regularly syncing up with the project mentors?**
   Not at all. I value async communication and will provide highly structured, bi-weekly progress reports. I am always open to feedback via Discord and GitHub PR reviews.

6. **What interests you the most about API Dash?**
   The architecture of the `lib/codegen` module is brilliant. The way it cleanly decouples the complex Flutter UI from the pure string-manipulation logic of code generation allows developers to contribute massive value (supporting new languages/frameworks) without needing to rewrite core routing or state management logic.

7. **Can you mention some areas where the project can be improved?**
   Currently, API Dash generates raw HTTP code (e.g., Python `requests`, Dart `http`). However, the modern developer landscape has heavily pivoted towards AI Agents. When testing an OpenAI endpoint, giving a user the raw HTTP `POST` code is sub-optimal because they will inevitably need to rewrite it using `LangChain` or official SDKs (which handle retries, typing, and streaming natively). API Dash lacks this "AI Developer-first" export pipeline.

8. **Have you interacted with and helped API Dash community?**
   Yes! I am actively engaging with the codebase and have successfully submitted **PR #1479 (Fix Select Model button fallback text)**: https://github.com/foss42/apidash/pull/1479 
   This PR was a profound learning experience. Initially, I patched a UI bug where Dart's `??` operator failed to handle empty strings `""` for model fallbacks. Shortly after, the project's automated Copilot reviewer flagged a subtle strict Null-Safety risk (`String?` vs `String`) and suggested adding regression tests. Instead of ignoring it, I actively collaborated with the automated review system: I iterated the PR by enforcing exact strict null-casting (`aiRequestModel!.model!`) and independently wrote comprehensive **Automated Widget Tests** (`ai_model_selector_button_test.dart`) covering null, empty, and valid string states. This hands-on process proved my ability to quickly adapt to API Dash's rigorous testing standards and CI/CD workflows.


### Project Proposal Information

#### 1. Proposal Title
**Empowering API Dash with AI Developer Tools: Code Generation Suite for LangChain, OpenAI SDK, and Prompt Testing**

#### 2. Abstract
As the AI ecosystem expands, developers increasingly rely on API clients to test LLM endpoints and Prompts before integrating them into applications. Currently, translating these tested API payloads back into framework-specific code (like LangChain or OpenAI SDK) is a manual, error-prone process. This proposal aims to extend the API Dash `lib/codegen` system to natively support generating production-ready code snippets for the **Python/Node.js OpenAI Official SDKs** and **Python LangChain**, while introducing an automated **Function Calling Schema Generator** to simplify AI Agent development.

#### 3. Problem Statement & Motivation
When an AI developer tests an endpoint like `api.openai.com/v1/chat/completions` in API Dash, the current CodeGen feature outputs raw HTTP requests (e.g., Python `requests.post()`). 
However, in reality, AI developers rarely use raw HTTP requests in production. They use:
1. `openai` (Official Python/Node.js SDK)
2. `LangChain` / `LlamaIndex` (High-level orchestration frameworks)

Furthermore, constructing the complex JSON Schema for LLM Function Calling (`tools`) is notoriously tedious. Developers lack a visual tool to quickly draft an API request and instantly export its corresponding OpenAI Function standard JSON Schema wrapper. This proposal bridges the gap between API configuration and AI code execution.

#### 4. Proposed Solution & Architecture
This project focuses on executing a "Blue Ocean" feature that targets the `lib/codegen` module. Given my solid Java fundamentals and deep understanding of RAG data structures, I am uniquely positioned to execute these string manipulations and logic mappings flawlessly for API Dash.

**Deliverables (Scoped for a 175-hour Medium Project):**
1. **OpenAI SDK Generators**: Python and Node.js code generators for native `client.chat.completions.create` syntax.
2. **LangChain Code Generator**: Python implementation that maps JSON payloads into `ChatOpenAI` and `PromptTemplate` chains.
3. **Function Calling Schema Exporter**: A specialized utility that parses an API Dash `RequestModel` (URL, params, body) and exports a valid JSON Schema draft-07 object compatible with OpenAI's `tools` standard.

**Technical Implementation Details:**
* **Model Layer (`lib/consts.dart`)**: Introduce new `CodegenLanguage` enums (`pythonOpenAI`, `nodeJsOpenAI`, `pythonLangChain`, `jsonSchema`).
* **Generation Layer (`lib/codegen/`)**: 
  - Create `python/openai.dart`, utilizing the established Jinja template (`package:jinja`) pattern.
  - Implement robust JSON parsing (`dart:convert`) to extract `messages`, `model`, and `temperature` from the `HttpRequestModel.body` to map into the SDK's strong typing format.
* **Testing Layer (`test/codegen/`)**: Write comprehensive unit tests strictly following existing patterns (e.g., testing against `requestModelGet1`, `requestModelPost1`).

#### 5. Weekly Timeline (175 Hours)

* **Community Bonding (May)**: 
  - Finalize Jinja template specifications with mentors. 
  - Discuss the specific UI integration points for the Function Calling JSON exporter.

* **Week 1-2**: *Core OpenAI Integration*
  - Implement `PythonOpenAICodeGen`.
  - Handle edge cases (missing API keys from headers, missing system prompts).
  - Draft corresponding unit tests.

* **Week 3-4**: *Exam Period & Node.js Expansion*
  - Balance university final exams with slightly lighter coding tasks.
  - Implement `NodeJsOpenAICodeGen` (TypeScript syntax compatibility).
  - Maintain communication with mentors to ensure code quality isn't compromised during exams.

* **Week 5-6**: *LangChain Integration & Social Practice*
  - Translate API Dash JSON payloads into LangChain `HumanMessage` / `SystemMessage` arrays.
  - Implement `PythonLangChainCodeGen`.

* **Week 7-9**: *The Schema Generator (Intensive Block)*
  - Fully leverage summer vacation for the most logical-heavy task.
  - Parse `HttpRequestModel` query parameters and Form/JSON bodies.
  - Generate OpenAI-compliant Function Calling JSON strings from standard API configurations.

* **Week 10-12**: *Testing, UI Polish & Documentation*
  - Achieve 95%+ test coverage (`flutter test`) for the 4 newly added generators.
  - Update `adding_codegen.md` and user-facing documentation to showcase the new AI Developer Suite feature.
  - Final PR reviews and project wrap-up.
