## Instructions

- Create a fork of API Dash.
- In the folder [doc/proposals/2026/gsoc](https://github.com/foss42/apidash/tree/main/doc/proposals/2026/gsoc) create a file named `application_Naorem_Singh_Multimodal_AI_Eval.md`

The file should contain the following:

```
### About

1. Full Name - **Naorem Nganthoiba Singh**
2. Contact info (public email) - **necrospre@gmail.com**
3. Discord handle in our server (mandatory) - **necroman3355**
4. Home page (if any) - **N/A**
5. Blog (if any) - **N/A**
6. GitHub profile link - https://github.com/naormeit
7. Twitter, LinkedIn, other socials - https://linkedin.com/in/naoremnganthoiba
8. Time zone - **IST (UTC+5:30)**
9. Link to a resume - https://drive.google.com/file/d/1U-QtYFZmKjeJLq0TO7kxQ_5SVd3CSEsM/view?usp=sharing 

### University Info

1. University name - **Alliance University**
2. Program you are enrolled in (Degree & Major/Minor) - B.Tech in Software Product Engineering 
3. Year - 2nd Year (2024 - 28)
4. Expected graduation date - 10th May 2028

### Motivation & Past Experience

1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

Ans - **Yes, I am actively contributing to the Git open-source project as part of my GSoC 2026 application process. My primary contribution involved a technical refactor of builtin/repo.c to decouple the command from the the_repository global variable. This task was critical for Git’s long-term goal of reducing global state and moving toward a "multi-repo ready" architecture. Through this, I learned to navigate a massive legacy C codebase, follow strict community coding standards, and pivot my technical approach based on maintainer feedback.**

PR/Gist: https://gist.github.com/naormeit/a17b2159768043b31f695d0411349e24

2. What is your one project/achievement that you are most proud of? Why?

Ans - **I am most proud of developing Aether AI, a multi-model AI orchestration platform. The core challenge was building a system that could "fan-out" prompts to multiple LLMs (GPT-4, Gemini, Claude) and reconcile their outputs into a single high-confidence answer. I am proud of this because it required solving real-world "AI-First" problems: managing cross-model latency, handling varying API response formats, and implementing a logic layer to detect hallucinations. This project transitioned me from an AI consumer to an AI systems researcher, which is the exact expertise I want to bring to API Dash.**

3. What kind of problems or challenges motivate you the most to solve them?

Ans - **I am most motivated by "Interoperability and Efficiency" challenges. I enjoy building tools that sit between complex low-level systems and high-level user needs. For example, in my robotics work with ParkHub, the challenge was making vision-integrated robotics communicate seamlessly with a full-stack parking management system. I thrive when I am tasked with taking fragmented data (like raw AI API responses) and turning them into structured, actionable insights (like benchmarking metrics). Problems that require architectural refactoring to improve long-term maintainability—such as moving away from global states or optimizing async streams—are what I find most rewarding.**

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

Ans - **Yes, I will be dedicating 40+ hours per week to GSoC as my primary priority. My university schedule for the summer is clear, allowing me to treat this project with the same professional rigor as a full-time engineering role. I have planned my 12-week timeline to account for deep coding phases and thorough testing cycles, ensuring that the Multimodal Eval Framework is not just functional, but production-ready by the end of the term.**

5. Do you mind regularly syncing up with the project mentors?

Ans - **I don’t just "not mind" it—I actively encourage it. As a Software Product Engineer, I understand that regular sync-ups are vital for aligning technical decisions with the project’s long-term roadmap. I am comfortable with asynchronous communication on Discord and GitHub, but I also value 1:1 meetings to discuss complex architectural hurdles. I believe that early and frequent feedback prevents "code drift" and ensures that the final product meets the high standards of the API Dash community.**

6. What interests you the most about API Dash?

Ans - **What fascinates me most is API Dash’s unique position as a Flutter-native, AI-integrated API client. Most traditional API clients are struggling to adapt to the "Agentic" era, but API Dash is building for it from the ground up. The project's focus on Model Context Protocol (MCP) and its drive toward becoming a primary tool for AI communication layers align perfectly with my career goals. I want to contribute to a tool that isn't just a Postman alternative, but a foundational part of the new AI development stack.**

7. Can you mention some areas where the project can be improved?
Ans - **While API Dash is excellent for standard REST testing, there is significant room to improve the "Developer Experience (DX) for AI Engineers". Currently, comparing the outputs of different multimodal models requires manual, repetitive effort. The project could be improved by:

- Implementing Automated Cost-Per-Token estimation to help developers choose the most economical models for their use cases.

- Enhancing Async/Streaming visualization to track Time to First Token (TTFT), which is a critical metric for real-time AI applications.

- Standardizing the evaluation harness so that benchmarks are reproducible across different teams.**

8. Have you interacted with and helped API Dash community?

Ans - **I have initiated interaction by joining the Idea Discussion #1226 on GitHub, where I shared my technical interest in the Multimodal Eval track. I have also been active on the Discord server, engaging with the documentation and guides to ensure my proposal aligns with the community’s architectural vision. Moving forward, I plan to contribute by reviewing PRs in the apidash_core package and helping new contributors navigate the AI integration logic.**

### Project Proposal Information

1. Proposal Title

## Multimodal AI and Agent API Evaluation Framework for API Dash

2. Abstract: A brief summary about the problem that you will be tackling & how.

## The rapid evolution of LLMs has created a "measurement gap" where developers lack standardized, real-time tools to compare multimodal model performance. Currently, testing Vision, Audio, and Text APIs across different providers (Google, OpenAI, Anthropic) requires fragmented, manual efforts. This project will implement an end-to-end evaluation framework within API Dash to automate benchmarking. By building a "Request Multiplier" and a real-time metrics dashboard, this framework will provide objective data on latency (TTFT), token efficiency, and API costs, enabling developers to build more reliable AI-driven applications.

3. Detailed Description

## As a Software Product Engineer who has built Aether AI (a multi-model orchestration platform), I understand that the primary challenge in AI integration is consistency and cost-management. My implementation will focus on three core pillars:

- Architectural Decoupling & Benchmarking: I will implement an intuitive interface to run industry-standard AI benchmarks (such as lm-harness or lighteval) directly within the API Dash environment.

- The "Fan-Out" Dispatcher: I will design a backend logic in Dart/Flutter that allows a single prompt to be simultaneously dispatched to multiple model endpoints. This will allow for side-by-side visual comparisons of how different models (e.g., Gemini 1.5 Pro vs. GPT-4o) interpret the same multimodal input (Image/Audio/Text).

- High-Fidelity Observability:

    - Time to First Token (TTFT): Using Flutter Streams, I will capture and display real-time latency metrics to measure model responsiveness, which is critical for agentic workflows.

    - Cost & Token Analytics: I will build an automated "Cost Estimator" that calculates the USD cost of a request based on current provider pricing and token usage, helping developers optimize their AI spending.

- Agentic Quality Grading: I propose using a "Judge LLM" architecture where a high-capability model can automatically grade the quality of outputs from other models based on user-defined rubrics.

4. Weekly Timeline: A week-wise timeline of activities that you would undertake.

## Weekly Timeline (350 Hours - Large Project)

Week 1: System Architecture

## - Define data contracts for evaluation results.

## - Set up MultiRequestProvider using Riverpod for state management.

Weeks 2-3: Request Multiplier

## - Develop the UI and backend logic to select multiple models.

## - Implement simultaneous "fan-out" API calls.

Weeks 4-5: Streaming Metrics

## - Integrate Flutter Streams to capture real-time responses.

## - Implement tracking for TTFT (Time to First Token) and total latency.

Week 6: Cost Engine

## - Build a dynamic service to calculate USD costs per 1,000 tokens for OpenAI, Google, and Anthropic.

## - Midterm Deliverable: Evaluation Dashboard

## - A functional comparison view showing side-by-side text model outputs with live performance metrics.

Weeks 7-8: Multimodal Inputs

## - Extend the framework to support Image (Vision) and Audio file uploads for the evaluation suite.

Weeks 9-10: Benchmark Harness

## - Integrate external libraries (like lm-harness) to allow users to run standard datasets (e.g., MMLU) directly.

Week 11: Agentic Grading

## - Implement a "Judge LLM" feature that uses a high-capability model to automatically score the quality of other outputs.

Week 12: Cleanup & Documentation

## - Final bug fixes and UI performance optimization.

## - Complete developer documentation for the new framework.

```

- Feel free to add images by adding it to the `images` folder inside [doc/proposals/2026/gsoc](https://github.com/foss42/apidash/tree/main/doc/proposals/2026/gsoc) and linking it to your doc.
- Finally, send your application as a PR for review.
