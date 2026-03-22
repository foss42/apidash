### About

1. Full Name: Mariam Khokhoberidze
2. Contact info: mariamkhokhiashvili5@gmail.com
3. Discord handle: khox
4. GitHub profile link: https://github.com/MariamKhoKh
5. LinkedIn: https://www.linkedin.com/in/mariam-k-053585273/
6. Time zone: GMT+4 (Kutaisi, Georgia)
7. Resume: https://drive.google.com/file/d/1z8SWz3uM6YiGbJQhMvNI5gmWJD7w7e6Q/view?usp=sharing

---

### University Info

1. University name: Kutaisi International University
2. Program: Bachelor of Science in Computer Science
3. Year: 4th year
4. Expected graduation date: June 2026

---

### Motivation & Past Experience

1. **FOSS Contributions:**
   I've been contributing to API Dash recently. I found a bug where 
   typing `1e309` in an AI model config field (like max_tokens) 
   crashed the app silently — no error shown to the user, just a 
   console exception. I traced it to `model_config_value.dart` and 
   reported it as issue #1264. I submitted a fix in PR #1265, got 
   reviewer feedback, and learned an important lesson — only fix 
   exactly what the issue describes, nothing more. I'll apply that 
   going forward.
    - Issue: https://github.com/foss42/apidash/issues/1264
    - PR: https://github.com/foss42/apidash/pull/1265

2. **Projects I'm proud of:**

   **Multi-LLM Debate System** — Four LLMs collaborate on problems 
   with roles (solver/judge) assigned by confidence score. Solvers 
   review and defend each other's answers before a judge picks the 
   winner. Built entirely from scratch using multiple provider APIs.

   **Online Media Monitoring** — Scrapes social and online media, 
   runs sentiment analysis and relevance checks, presents results 
   via visual charts in a GUI. Full pipeline from data collection 
   to presentation.

   **TV Media Monitoring** — Same concept but for broadcast content. 
   Transcribes TV shows via STT, runs speaker diarization and 
   sentiment analysis, visualizes results. Taught me a lot about 
   chaining AI models in a real production pipeline.

3. **What kind of problems motivate me:**
   I want to build things that make people's lives easier and less 
   frustrating. For example, if a developer wastes an hour debugging something 
   that a better tool would have caught in seconds, that's a problem 
   worth solving.

4. **Full-time commitment:**
   Yes, full-time. I'm a student and will organize my schedule 
   around GSoC during the coding period.

5. **Mentor syncs:**
   No problem at all. I'm active on the project Discord and happy 
   to sync regularly with mentors.

6. **What interests me about API Dash:**
   I've built projects where I'm calling OpenAI, Gemini, and 
   Anthropic in the same pipeline. Switching between them, handling 
   their different formats, comparing their outputs — it's messier 
   than it should be. API Dash is trying to fix that, and I think 
   there's a real gap in the multimodal evaluation space that this 
   project is well positioned to fill.

7. **Areas for improvement:**
   After exploring the codebase directly, I found three concrete gaps:

   - **No multi-provider comparison** — `AIRequestModel` holds a 
     single `modelApiProvider` and there's no orchestration layer 
     to fan out the same prompt to multiple providers simultaneously.
     (`packages/genai/lib/models/ai_request_model.dart`)

   - **No benchmark runner** — searched across the entire repo, 
     no implementation of benchmark execution, dataset evaluation, 
     or result comparison exists.

   - **No multimodal support in AI requests** — every provider 
     builds text-only payloads. `AIRequestModel` only has 
     `systemPrompt` and `userPrompt` string fields. No image or 
     audio input exists in any provider implementation.
     (`packages/genai/lib/interface/model_providers/`)

---

### Project Proposal Information

1. **Proposal Title:**
   Multimodal AI and Agent API Eval Framework for API Dash

2. **Abstract:**
   AI models are increasingly used across text, image, and voice 
   modalities, but developers have no straightforward way to evaluate 
   how these models perform across varied real-world inputs. Current 
   tools either require deep ML expertise to set up, or only test one 
   modality at a time. This project adds a complete evaluation 
   framework to API Dash — letting developers configure AI API 
   requests, run them against custom or standard datasets, and view 
   results in a clean UI — without leaving their existing workflow.

3. **Detailed Description:**

   ### The Problem
   Evaluating AI models today is fragmented. Tools like 
   lm-evaluation-harness and lighteval are powerful but CLI-heavy 
   and hard to integrate into a developer's daily API testing 
   workflow. There's no tool that lets a developer send the same 
   prompt to GPT-4, Gemini, and Claude and see results side by side 
   in a simple UI. This gap is worse for multimodal inputs — 
   evaluating image or audio API responses has almost no accessible 
   tooling at all.

   After reading the codebase, I confirmed these gaps exist directly 
   in API Dash today:
   - `AIRequestModel` supports only one provider at a time with 
     no fan-out capability
   - No benchmark runner exists anywhere in the repo
   - All provider implementations are text-only with no image 
     or audio field support

   ### Proposed Solution

   I will build an end-to-end eval framework with three components:

   **1. Benchmark Runner UI (React/TypeScript)**
   - Select AI provider and model
   - Upload custom datasets (CSV/JSON) or select standard benchmarks
   - Configure request parameters
   - Run evaluations and monitor progress in real time

   **2. Evaluation Backend (Python)**
   - Accepts eval job configurations from the UI
   - Integrates with lm-evaluation-harness and lighteval
   - Supports custom dataset evaluation with configurable metrics
     (exact match, BLEU, semantic similarity)
   - Handles text, image, and audio modalities
   - Exposes results via REST API

   **3. Results Dashboard**
   - Per-sample results: input / expected output / actual output
   - Aggregate metrics per model and provider
   - Side-by-side comparison across providers
   - Export as CSV or JSON

   ### Multimodal Support
   For image evaluation — send image inputs to vision-capable 
   models (GPT-4V, Gemini Vision) and evaluate text responses 
   against expected outputs.
   For audio — send audio inputs to speech models and evaluate 
   transcription accuracy or response quality.

   ### Agent Evaluation
   Define multi-step workflows, run them end to end via API, and 
   evaluate whether the agent reached the correct final output.

4. **Weekly Timeline:**

   **Community Bonding Period**
   - Study lm-evaluation-harness and lighteval APIs
   - Review API Dash AI request codebase thoroughly
   - Finalize architecture with mentors
   - Define dataset formats and metrics to support

   **Week 1-2 (Hours 1-50): Backend Foundation**
   - Set up Python backend project structure
   - Design REST API schema for eval jobs
   - Implement basic eval job runner — single prompt, 
     single provider, returns result
   - Write tests for core runner logic

   **Week 3-4 (Hours 51-100): Dataset Support & Metrics**
   - Implement custom dataset ingestion (CSV, JSON)
   - Implement core metrics: exact match, BLEU, 
     semantic similarity
   - Integrate lm-evaluation-harness for standard benchmarks
   - Write tests for dataset parsing and metrics

   **Week 5-6 (Hours 101-150): React UI — Configuration**
   - Set up React/TypeScript frontend
   - Build provider and model selection UI
   - Build dataset upload and configuration interface
   - Build request parameter panel
   - Connect UI to backend eval API

   **Week 7-8 (Hours 151-200): Results Dashboard**
   - Build per-sample results view
   - Build aggregate metrics display
   - Build side-by-side provider comparison view
   - Add export to CSV/JSON

   **Week 9-10 (Hours 201-250): Multimodal Support**
   - Add image input support for vision models
   - Add audio input support for speech models
   - Update UI for multimodal input configuration
   - Test across at least 2 providers per modality

   **Week 11-12 (Hours 251-300): Agent Evaluation**
   - Design agent evaluation model
   - Implement multi-step agent workflow runner via API
   - Add agent eval results to dashboard
   - Write integration tests

   **Week 13 (Hours 301-325): Integration & Polish**
   - Connect eval framework to API Dash collections
   - Polish UI based on testing and mentor feedback
   - Handle edge cases and error states

   **Week 14 (Hours 326-350): Documentation & Submission**
   - Write user and developer documentation
   - Record demo video
   - Final testing, bug fixes, GSoC submission
