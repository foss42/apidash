### About

1. Full Name: Abdelrahman Alkerdawy
2. Contact info: abdelrahman@kerdawy.dev
3. Discord handle in our server (mandatory): kerdawy
4. Home page (if any): N/A
5. Blog (if any): N/A
6. GitHub profile links: https://github.com/KERDAWY-2 (active) | https://github.com/Kerdawy-1 (older projects)
7. LinkedIn: https://www.linkedin.com/in/abdelrahman-alkerdawy
8. Time zone: Africa/Cairo (UTC+2, EET)
9. Link to a resume: https://www.linkedin.com/in/abdelrahman-alkerdawy

### University Info

1. University name: Zewail City of Science and Technology
2. Program you are enrolled in: B.Sc. in Communication and Information Engineering
3. Year: 3rd year
4. Expected graduation date: June 2027

### Motivation & Past Experience

1. **Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

   Most of my work has been personal projects that I have kept public on GitHub. I have two accounts: an older one (https://github.com/Kerdawy-1) where most of my earlier projects live, and a newer one (https://github.com/KERDAWY-2) where I keep more recent work.

   On Kerdawy-1, the most relevant ones are a deep learning food classification model built from scratch in PyTorch across 101 categories (Machine_Learning_Project--Food-101), and a Python/MySQL inventory management system with a GUI (GUI-Goods_Manager_Program---Python-MySQL). There is also a C++ OOP project where I implemented a simplified version of Microsoft Paint.

   On Kerdawy-2, I have a real-time video streaming server I built for an IoT project (Horse_Feeder) using Python, Flask, asyncio, and WebSockets, where an ESP32-CAM streams frames to a browser through a relay server I wrote.

   I recently forked API Dash and started getting familiar with the codebase. My first contributions to the project are the comment on Issue #1269 and this proposal PR.

2. **What is your one project/achievement that you are most proud of? Why?**

   My graduation project. I am building an infrastructure defect detection system using CNNs and YOLO for the computer vision side, with a Flutter frontend and a Python/FastAPI backend. The reason I am proud of it is that it is not just an academic exercise — it is something that actually works end to end: a mobile app captures images, sends them to the backend, the model runs inference, and the result comes back in near real time. Seeing all those pieces connect was a big moment for me. It also pushed me to properly learn deployment and async API design, which I had only touched on before.

3. **What kind of problems or challenges motivate you the most to solve them?**

   I am most drawn to problems where you have to connect multiple systems together and make them feel seamless. Whether it is getting a Flutter app to talk to a Python ML backend, or designing an API that handles streaming responses cleanly — the integration layer is where things get interesting. I also enjoy debugging non-obvious issues, the kind where you have to actually understand what is happening under the hood rather than just Googling the error.

4. **Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**

   I will be going into my 4th year during the GSoC period. I will have some university commitments, but the summer semester is lighter than the rest of the year, and I am planning to treat GSoC as my main focus. I am comfortable committing 30-35 hours a week to it.

5. **Do you mind regularly syncing up with the project mentors?**

   Not at all — I actually prefer it. I find regular check-ins help me stay on track and catch wrong assumptions early before I have spent too much time going in the wrong direction.

6. **What interests you the most about API Dash?**

   Honestly, what caught my attention first was that it is built in Flutter — a stack I actively work with. But the more I looked into it, the more I appreciated the direction the project is heading: treating AI APIs as first-class citizens and building proper tooling around them. Most tools in this space either ignore AI-specific workflows or bolt them on as an afterthought. API Dash is actually thinking about it from the ground up, which makes it a much more interesting project to contribute to.

7. **Can you mention some areas where the project can be improved?**

   The biggest gap I see right now is evaluation. You can send requests to AI APIs and see the responses, but there is no way to run a dataset through a model, compare results across providers, or measure anything quantitatively. That is the core of what I want to build. Beyond that, I think better streaming support for long-running AI requests and a cleaner way to manage API keys per environment would both make day-to-day use smoother.

8. **Have you interacted with and helped the API Dash community? (GitHub/Discord links)**

   - Posted an introduction on Discussion #1048 (GSoC Application Guide): https://github.com/foss42/apidash/discussions/1048
   - Commented on Issue #1269 (Revamp Model Selector dialog): https://github.com/foss42/apidash/issues/1269
   - Commented on Discussion #1226 (Idea #2 — Multimodal AI and Agent API Eval Framework) with technical architecture notes: https://github.com/foss42/apidash/discussions/1226
   - Commented on Issue #1180 (AI-powered smart request suggestions) proposing a SuggestRequestTool implementation approach: https://github.com/foss42/apidash/issues/1180
   - Sent an introduction in the #gsoc-foss-apidash Discord channel (handle: kerdawy)
   - This proposal PR is the most substantive contribution so far.

### Project Proposal Information

1. **Proposal Title:** Multimodal AI and Agent API Eval Framework

2. **Abstract:**

   Right now, API Dash is great for sending requests and inspecting responses — but when it comes to AI APIs, that is only half the story. Developers building AI-powered features need to run their prompts against real datasets, compare model outputs, and measure quality in a repeatable way. None of that is possible today without stitching together a bunch of separate tools.

   This project will change that. I want to build a proper evaluation framework directly inside API Dash — one that lets you load a dataset, fire it at any supported AI provider, and see the results with aggregate metrics, all from the same interface you already use to test your APIs.

3. **Detailed Description:**

   **The Problem**

   When you are building something that calls a multimodal AI API — say, an image captioning endpoint or a voice transcription service — at some point you need to answer: is this model actually performing well on my data? Today the only options are to write your own eval scripts from scratch, or use heavy external platforms that were not built with API testing in mind. There is no lightweight, developer-friendly eval tool that lives inside an API client.

   **What I Will Build**

   The framework has four main pieces:

   **a) Dataset Manager** A simple UI to upload test datasets in CSV, JSON, or JSONL format. Each row represents one test case: an input (text, image URL, or audio file path) and an expected output. The data model integrates cleanly with the existing API Dash workspace.

   **b) Eval Request Configuration** An extension of the existing AI request panel. Once you have a dataset, you can bind its fields to request parameters — so instead of sending one request manually, you are sending the whole dataset through. You can also pick multiple providers to run the same eval against side by side.

   **c) Eval Runner** A lightweight Python service (FastAPI) that handles the actual execution. It batches the requests, manages concurrency, streams progress back to the Flutter client, and stores results locally. I will design it to be compatible with the interfaces used by lm-harness and lighteval so that existing benchmark configs can be reused.

   **d) Results View** A results table that shows each test case with its input, expected output, actual output, and pass/fail. Aggregate metrics (accuracy, BLEU, ROUGE, exact match) displayed at the top. Export to CSV or JSON.

   For agent APIs, I also want to add basic tool-call chain inspection — so you can see not just the final answer but the intermediate steps the agent took, and validate those against expected tool call sequences.

   **Tech Stack**

   - Flutter/Dart for all UI components
   - Python (FastAPI + asyncio) for the eval runner service
   - lm-harness / lighteval for benchmark integration
   - Local SQLite for storing eval run history

4. **Weekly Timeline:**

   **Community Bonding (Weeks 1-2)** Deep dive into the codebase, specifically the AI request execution flow and DashBot. Set up local dev environment, run all tests. Study lm-harness and lighteval APIs. Finalize architecture with mentors and get early feedback.

   **Weeks 3-4** Design and implement the Dataset Manager: data models, file parsing for CSV/JSON/JSONL, and the basic Dart UI (list view, upload, preview).

   **Weeks 5-6** Build the Eval Request Configuration UI. Extend the AI request panel to support dataset binding and field mapping. Handle text and image input types first.

   **Weeks 7-8** Implement the Python eval runner service. Batch execution logic, concurrency handling, progress streaming to Flutter client via Server-Sent Events or WebSocket.

   **Weeks 9-10** Build the Results view: per-example table, aggregate metrics, export functionality. Wire everything end to end and test with real providers (OpenAI, Gemini).

   **Weeks 11-12** Add audio input support. Begin agent eval support: tool-call chain display and validation.

   **Week 13** Bug fixes, UI polish, write documentation and tests for the critical paths.

   **Week 14** Code freeze, final review with mentors, submit.
