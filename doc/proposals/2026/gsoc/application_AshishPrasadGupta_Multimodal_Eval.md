### About

1. **Full Name:** Ashish Prasad Gupta
2. **Contact info:** ashishgupta.op195@gmail.com
3. **Discord handle:** aashish_op
4. **GitHub profile:** [https://github.com/Aashish-Op](https://github.com/Aashish-Op)
5. **LinkedIn:** [https://www.linkedin.com/in/ashishgupta1279/](https://linkedin.com/in/ashish-gupta)
6. **Time zone:** IST (UTC+5:30)
7. **Resume:** https://drive.google.com/file/d/1ihhFu35EBKY4hHYq7JY2Mvtepbn0_Qnu/view?usp=sharing

### University Info

1. **University name:** Lovely Professional University, Punjab, India
2. **Program:** B.Tech Computer Science and Engineering
3. **Year:** 2nd Year (2024–2028)
4. **Expected graduation date:** 2028
---

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**

Yes. I forked the API Dash repository and spent significant time studying the codebase to understand its AI-request architecture before writing this proposal. During that exploration, I identified three structural gaps that are directly relevant to the multimodal evaluation project:

First, `AIRequestModel` in `packages/genai/lib/models/ai_request_model.dart` only carries `systemPrompt` and `userPrompt` as plain `String` fields — there is no provision for image payloads, audio references, or structured multimodal content blocks. Second, every provider implementation under `packages/genai/lib/interface/model_providers/` (Gemini, OpenAI, Anthropic, Ollama, Azure OpenAI) constructs text-only request bodies. For example, `gemini.dart` builds a `contents` array containing a single `{"text": aiRequestModel.userPrompt}` part — no `inlineData` or `fileData` fields for images or audio. Similarly, `openai.dart` and `anthropic.dart` set the `"content"` field to a plain string instead of the array-of-blocks format that their vision APIs require. Third, a full-text search across the entire repository confirms that no benchmark runner, evaluation engine, or dataset management system exists anywhere in the codebase.

I have also been actively participating in GitHub discussions and Discord conversations related to this GSoC idea.

**2. What is your one project/achievement that you are most proud of? Why?**

The project I am most proud of is **MedConnect**, a Gemini-powered emergency medical AI assistant that I designed, built, and shipped in approximately 50 hours during a hackathon. The system earned the **Google DeepMind Prize**, but the award matters less to me than the engineering lessons it forced.

The core challenge was this: in a medical emergency, a generic LLM will confidently generate first-aid advice that is factually dangerous. A chatbot that tells a seizure victim's companion to "put something in their mouth" could cause a jaw fracture. The problem is not model capability — it is evaluation and grounding.

MedConnect solved this with a three-stage architecture. First, I built a **Retrieval-Augmented Generation (RAG) pipeline** backed by a curated medical knowledge base. User queries were embedded using sentence-transformers, and the top-k relevant medical documents were retrieved via cosine similarity from a vector store. This ensured the model's responses were grounded in verified medical protocols rather than parametric guesses. Second, I **fine-tuned the Gemini model** on emergency-specific Q&A pairs to improve its instruction-following behavior for triage scenarios — reducing the tendency to hedge with generic disclaimers when a user needs immediate, actionable guidance. Third, the system included a **real-time alert pipeline** that could notify emergency contacts with location data if the triage assessment exceeded a severity threshold.

Building MedConnect taught me something that directly shapes this proposal: the hardest part of an AI system is not making it generate answers — it is knowing whether those answers are trustworthy. Evaluation is not a feature you bolt on after launch. It is the engineering discipline that separates a dangerous prototype from a deployable system. The RAG architecture, the embedding pipeline, and the evaluation methodology I built for MedConnect directly inspire the Dataset Augmentor module proposed in this project.

**3. What kind of problems or challenges motivate you the most?**

I am motivated by the gap between building AI systems and being able to *trust* them. In a medical emergency, a model that hallucinates is not just wrong — it is dangerous. Building MedConnect taught me that evaluation is not optional; it is the difference between a demo and a deployed system.

This conviction is also shaped by my work on a **Real-Time Bus Tracking System** built for the Smart India Hackathon, where I orchestrated live geolocation data streams and built a frontend that had to stay consistent while underlying data was continuously changing. That experience maps cleanly to the SSE-based evaluation progress streaming proposed here — evaluation telemetry is fundamentally a real-time data flow problem, and I have solved real-time data flow problems under production constraints.

Additionally, as **Operations Lead for the AWS Cloud Club** at my university, I have been responsible for cloud infrastructure, deployment pipelines, and team coordination. This background directly informs the cloud-native deployment option I propose as a stretch goal — I am not speculating about AWS architectures, I work with them operationally. My work as a **Community Admin at Physics Wallah**, where I managed Discord bots serving 90,000+ users, further proved my ability to build and maintain production-scale infrastructure that real people depend on.

**4. Will you be working on GSoC full-time?**

Yes, full-time. I am a Second -year student, which means my summer is completely unencumbered by internships, thesis work, or advanced coursework. I will commit 40+ hours per week to this project. I also plan to use the Community Bonding period to complete structured Flutter/Dart learning so that I am productive in the API Dash codebase from the first day of coding.

**5. Do you mind regularly syncing up with the project mentors?**

Enthusiastically, yes. I strongly prefer frequent mentor interaction for a project of this scope because architecture decisions made in Week 1 compound through every subsequent week. I am comfortable with async-first communication via Discord and GitHub, supplemented by weekly video calls for design reviews and milestone check-ins.

**6. What interests you the most about API Dash?**

API Dash is the only tool in this space that thinks about AI-native workflows from scratch rather than bolting AI features onto a traditional REST client. It already supports AI requests, SSE streaming, and multimedia response inspection. The MCP support. The Flutter-native cross-platform performance. The vision of being the "IDE for AI engineers" rather than "Postman with an AI tab." That ambition is what excites me — this project is an opportunity to help API Dash evolve from a tool that *calls* AI APIs into a serious engineering workbench for *evaluating* AI systems.

**7. Can you mention some areas where the project can be improved?**

Yes. Through my codebase exploration, I identified three concrete, file-level gaps:

- **No multimodal input types:** `AIRequestModel` (`packages/genai/lib/models/ai_request_model.dart`) only has `systemPrompt` and `userPrompt` as `String` fields. There is no way to attach images, audio, or structured content blocks to an AI request.
- **Text-only provider payloads:** Every provider in `packages/genai/lib/interface/model_providers/` — including `gemini.dart`, `openai.dart`, and `anthropic.dart` — constructs request bodies with plain text content only. Gemini's `parts` array contains only `{"text": ...}`, never `{"inlineData": ...}`. OpenAI's `content` field is a string, not the array-of-blocks format required by GPT-4V.
- **No evaluation infrastructure:** A search across the entire repository returns zero results for any benchmark runner, evaluation engine, dataset manager, or metrics computation module. No eval framework of any kind exists.

**8. Have you interacted with and helped the API Dash community?**

Yes. I have been active in the GitHub repository and Discord server, studying the codebase and engaging in discussions around the multimodal evaluation GSoC idea. Specific interactions: [Insert GitHub issue/PR links and Discord messages]. I intend to continue contributing during the Community Bonding period and beyond.

---

### Project Proposal Information

**1. Proposal Title**

**Multimodal AI and Agent API Eval Framework for API Dash**

**2. Abstract**

There is a measurement gap at the center of AI engineering today. Developers can send requests to GPT-4V, Gemini Vision, or Whisper through API Dash, but they have no systematic way to answer the question that actually matters: *how good are the responses?* A developer building a medical triage app cannot know if their vision model correctly identifies injuries without testing it against a curated dataset. A team deploying a customer service agent cannot measure whether it calls the right tools in the right order without step-level tracing.

I propose a three-layer evaluation framework — Unit (single-request), Integration (dataset-level batch), and System (end-to-end agent workflow) — integrated directly into API Dash. The framework introduces five interlocking components: a Dataset Manager with a novel RAG-augmented synthetic test case generator, an Eval Configuration Panel for multi-provider orchestration, a FastAPI-based Eval Runner with SSE progress streaming, a Results Dashboard with side-by-side provider comparison, and a first-of-its-kind Dataset Augmentor that generates diverse evaluation datasets from as few as five seed examples. The system supports text, image, voice, and agent modalities, computes industry-standard metrics (BLEU, ROUGE, CLIP score, WER, LLM-as-judge), and optionally deploys to AWS for team-scale usage. By the end of GSoC, API Dash will be the only developer tool that lets you build, test, and *measure* AI systems in one place.

**3. Detailed Description**

#### The Problem

In March 2024, New York City's AI chatbot — built on a major foundation model — advised business owners to break federal and local laws, including telling landlords they could discriminate against tenants based on source of income. The model had never been systematically evaluated against the domain's regulatory constraints. The cost of that missing evaluation was not a poor benchmark score; it was real legal liability and public trust erosion.

This is not an isolated case. Consider a developer building an emergency triage application — a scenario I lived through while building MedConnect. A vision model that misidentifies a burn severity grade does not produce a "wrong answer." It produces a dangerous treatment recommendation. Without systematic evaluation against a labeled dataset of injury images, the developer is deploying on faith, not evidence. Or consider the recent wave of AI coding agents: Anthropic's Claude Code was reported to have deleted a user's production database when given an ambiguous instruction. With proper agent evaluation — validating tool-call sequences against expected trajectories before deployment — that failure was entirely predictable and preventable.

The root cause is the same in every case: the gap between *calling* an AI API and *measuring* what it actually does. Today, that gap looks like this in API Dash's own codebase:

- `AIRequestModel` in `packages/genai/lib/models/ai_request_model.dart` carries only `systemPrompt` and `userPrompt` string fields. There is no structure for multimodal content — no image payloads, no audio references, no content blocks.
- Every provider implementation in `packages/genai/lib/interface/model_providers/` — Gemini, OpenAI, Anthropic, Ollama, Azure OpenAI — builds text-only request bodies. The Gemini provider constructs a `parts` array with a single `{"text": ...}` entry; it never uses `inlineData` or `fileData` for images. The OpenAI provider sends `content` as a plain string, not the array-of-blocks format that GPT-4V requires.
- No benchmark runner, evaluation engine, or dataset management module exists anywhere in the repository.

API Dash already understands AI requests, SSE streaming, and multimedia responses. What is missing is the measurement layer — the ability to not just *send* a request, but to send a *thousand* requests against a labeled dataset and quantify whether the responses are good enough to ship. This proposal builds that missing layer.

#### The Three-Layer Evaluation Pyramid

The framework is structured as an evaluation pyramid with three distinct layers, each building on the one below:

**Layer 1 — Unit Evaluation (Single Request).** Evaluates a single model response against a single expected output. Metrics: accuracy, latency, Time to First Token (TTFT), token count, cost estimate. This is the atom of the evaluation system.

**Layer 2 — Integration Evaluation (Dataset-Level Batch).** Runs an entire dataset against one or multiple providers in parallel, computing aggregate metrics. Metrics: mean accuracy, BLEU, ROUGE-L, semantic similarity, average latency, total cost, cost per correct answer. This layer includes the novel RAG-augmented dataset generation capability. Users can provide as few as 5–10 seed examples, and the system generates 50–100 diverse synthetic test cases — dramatically reducing the barrier to systematic evaluation.

**Layer 3 — System Evaluation (Agent Workflow).** Evaluates end-to-end agent workflows with step-level tracing. Tracks tool call sequences, validates them against expected trajectories, measures per-step latency and cost, and uses LLM-as-judge for reasoning quality assessment. Instrumented via OpenTelemetry spans — I chose OpenTelemetry over LangSmith because OTel is framework-agnostic. If a user's agent runs on AutoGen instead of LangChain, LangSmith gives nothing. OpenTelemetry works with any agent framework: LangChain, AutoGen, CrewAI, or custom implementations.

#### Architecture Overview

The framework consists of five interlocking components:

```
┌─────────────────────────────────────────────────────┐
│              Flutter/Dart UI (API Dash)             │
│  ┌──────────┐ ┌────────────┐ ┌───────────────────┐  │
│  │ Dataset  │ │   Eval     │ │     Results       │  │
│  │ Manager  │ │  Config    │ │    Dashboard      │  │
│  │ + RAG    │ │  Panel     │ │  + Comparisons    │  │
│  │ Augment  │ │            │ │  + Leaderboard    │  │
│  └────┬─────┘ └─────┬──────┘ └────────┬──────────┘  │
│       │             │                 │             │
│       └─────────────┼─────────────────┘             │
│                     │ HTTP + SSE                    │
└─────────────────────┼───────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────┐
│         FastAPI Evaluation Backend                  │
│  ┌──────────────────┴──────────────────────────┐    │
│  │           Async Eval Runner                 │    │
│  │  asyncio orchestration · batch processing   │    │
│  │  checkpoint/resume · SSE event streaming    │    │
│  └──────┬──────────┬──────────┬────────────────┘    │
│         │          │          │                     │
│    ┌────┴───┐ ┌────┴───┐ ┌────┴───────┐             │
│    │  Text  │ │ Vision │ │   Agent    │             │
│    │ Metrics│ │ Metrics│ │  Tracer    │             │
│    │BLEU,   │ │ CLIP,  │ │OTel spans, │             │
│    │ROUGE,  │ │Caption │ │Tool-call   │             │
│    │SemSim  │ │BLEU    │ │validation  │             │
│    └────────┘ └────────┘ └────────────┘             │
│         │          │          │                     │
│    ┌────┴──────────┴──────────┴────────────┐        │
│    │  lm-evaluation-harness · lighteval    │        │
│    │  (standard benchmark integration)     │        │
│    └───────────────────────────────────────┘        │
│                                                     │
│    ┌────────────────────────────────────────┐       │
│    │  Storage: SQLite (local) / S3+RDS      │       │
│    └────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────┘
```

**Component 1: Dataset Manager.** Supports file upload of CSV, JSON, and JSONL datasets with drag-and-drop in the Flutter UI. Each dataset row contains an input (text, image URL, or audio file path), an expected output, optional metadata tags, and a modality label. Datasets are stored locally in SQLite via Hive for offline access and fast querying. The Dataset Manager integrates with the existing API Dash collection workspace so that users can manage evaluation datasets alongside their API collections.

**Component 2: Eval Configuration Panel.** Extends the existing AI request panel in API Dash with evaluation-specific controls. Users bind dataset fields to request parameters via a visual field-mapping UI, select multiple providers to compare (e.g., GPT-4V + Gemini Vision + Claude Vision running the same image classification dataset simultaneously), and configure execution parameters: max concurrency, per-request timeout, retry policy, and a cost budget cap that halts evaluation if spend exceeds a threshold. Pre-built templates for common evaluation types — classification accuracy, caption quality, transcription WER, agent task completion — reduce setup time for standard workflows.

**Component 3: Eval Runner (FastAPI Backend).** The execution engine is a FastAPI service with an async orchestration core. It supports three deployment modes: local (runs on the developer's laptop), networked (deployed on a team server), and cloud (AWS Lambda for small evaluations, AWS ECS/Fargate for large benchmark runs). Progress is streamed to the Flutter client via Server-Sent Events — the same architecture I implemented in my Real-Time Bus Tracking System, where live geolocation data was streamed to a frontend that had to remain responsive under continuous state changes. Each request in an evaluation run is tracked with: latency, TTFT, token count, cost estimate, and the raw response. For long-running evaluations (100+ samples), the runner supports checkpoint/resume so that a network interruption does not require restarting from scratch. The runner integrates with `lm-evaluation-harness` and `lighteval` for standard benchmarks (MMLU, HellaSwag, ARC, TruthfulQA, etc.), exposing them through API Dash's UI instead of requiring CLI invocation.

**Component 4: Results Dashboard.** Provides three views: (1) a per-sample table showing input, expected output, actual output, score, latency, and cost for every evaluation row; (2) an aggregate metrics panel with accuracy, BLEU, ROUGE-L, semantic similarity, average latency, and total cost; and (3) a side-by-side provider comparison with linked scrolling so users can directly compare how GPT-4V and Gemini Vision responded to the same image. A model leaderboard view ranks providers by any selected metric. Historical run comparison lets users track model performance over time. Export options include CSV, JSON, and formatted PDF reports.

**Component 5 (Novel): RAG-Augmented Dataset Augmentor.** This is the feature that no other evaluation framework offers, and it is directly inspired by the RAG pipeline I built for MedConnect. The workflow: a user uploads 5–10 seed QA pairs (e.g., five examples of medical triage questions with expected answers). The system embeds each seed example using sentence-transformers, then calls an LLM with a structured generation prompt that includes the seed examples as few-shot demonstrations and instructs the model to generate diverse variations — varying phrasing, complexity, edge cases, and domain coverage. Generated examples are deduplicated via cosine similarity against both the seed set and previously generated examples, ensuring diversity. The user reviews and approves the generated batch in the Flutter UI before it is committed to the dataset store. This reduces the barrier to systematic evaluation from "spend days hand-crafting a dataset" to "provide five examples and get a hundred."

#### Multimodal Evaluation Support

**Text evaluation** computes BLEU, ROUGE-L, exact match, and semantic similarity via sentence-transformers embeddings. For open-ended responses where string metrics are insufficient, an LLM-as-judge mode sends the (input, expected, actual) triple to a designated judge model that scores on a configurable rubric.

**Image (Vision) evaluation** supports sending images to vision APIs (GPT-4V, Gemini Vision, Claude Vision) as either base64-encoded payloads or URL references. Metrics include CLIP score for prompt-image alignment measurement — the standard multimodal ML metric for quantifying how well an image matches a text description — and caption BLEU/ROUGE for comparing generated captions against reference captions. Object detection accuracy metrics are available for classification-style vision tasks.

**Voice/Audio evaluation** integrates with Whisper for speech-to-text transcription, computing Word Error Rate (WER) and Character Error Rate (CER) — the industry-standard metrics for ASR evaluation. Audio files can be sent to Gemini Audio API or Whisper API for evaluation. No other competing proposal includes proper WER/CER computation with Whisper integration for voice evaluation.

**Agent evaluation** instruments tool call sequences via OpenTelemetry spans, providing step-level tracing with per-step latency, cost, and argument capture. The evaluator compares actual tool call sequences against expected trajectories, flagging deviations. An LLM-as-judge component scores reasoning quality at each step. A timeline visualization in the Flutter UI shows the full agent execution trace with expandable step details.

#### Cloud-Native Deployment Option

Given my operational experience as AWS Cloud Club Operations Lead, I propose an optional cloud deployment mode — not as the default, but as a stretch goal for teams that need shared evaluation infrastructure:

- The FastAPI backend is containerized with Docker and deployable via Docker Compose for local use or AWS ECS/Fargate for team-scale usage.
- Datasets and evaluation results are stored in AWS S3 for durability and sharing across team members.
- An AWS Lambda variant provides serverless execution for small evaluations without maintaining a persistent server.
- AWS RDS (PostgreSQL) replaces SQLite for shared evaluation history, enabling team-wide leaderboards and run comparison.

This is explicitly optional and additive — the local-first SQLite-backed architecture is the default. But production teams evaluating models at scale need cloud-native infrastructure, and I have the operational background to deliver it rather than just propose it.

#### SSE Streaming Architecture

The evaluation runner streams typed events to the Flutter client via Server-Sent Events. I chose SSE over WebSockets because evaluation telemetry is fundamentally unidirectional and append-only — the server emits progress updates, the client consumes them. SSE provides simpler reconnection semantics, works over standard HTTP (no upgrade negotiation), and aligns with API Dash's existing streaming patterns. This is an architecture I have hands-on experience with from building the Real-Time Bus Tracking System, where live location data was streamed to a frontend under continuous state change.

Typed SSE event categories: `run.started`, `run.progress` (with percentage and current sample index), `run.metric` (individual metric as computed), `run.log` (human-readable status), `run.warning`, `run.error`, `run.completed`. This typed event model allows the Flutter UI to render specific UI components per event type rather than parsing raw text.

#### Technical Stack

| Component | Technology | Rationale |
|---|---|---|
| UI | Flutter/Dart | Native cross-platform performance, existing API Dash codebase |
| Backend | Python FastAPI + asyncio | Async eval execution, lm-harness/lighteval compatibility |
| Progress streaming | Server-Sent Events (SSE) | Unidirectional, HTTP-native, proven in my real-time systems work |
| Benchmark integration | lm-evaluation-harness, lighteval | Industry-standard, extensive benchmark library |
| Text metrics | BLEU, ROUGE, sentence-transformers | Standard NLP evaluation metrics |
| Image metrics | CLIP score | Standard multimodal alignment measurement |
| Voice metrics | Whisper (WER/CER) | Best-in-class ASR for transcription evaluation |
| Agent tracing | OpenTelemetry | Framework-agnostic — works with LangChain, AutoGen, CrewAI, custom |
| Storage | SQLite + Hive (local) / AWS S3 + RDS (cloud) | Progressive complexity, local-first default |
| Dataset augmentation | RAG + LLM generation | Novel synthetic test case generation, inspired by MedConnect |
| Containerization | Docker + Docker Compose | One-command local setup, cloud-deployable |

**4. Weekly Timeline (350 hours — Large Project)**

| Week | Dates | Focus | Deliverables |
|---|---|---|---|
| **Community Bonding** | Apr 28 – May 25 | Deep codebase study of `packages/genai`, AI request execution flow, DashBot integration. Set up local dev environment and run all existing tests. Study lm-evaluation-harness and lighteval APIs. Complete Flutter/Dart learning. Finalize architecture with mentors. Submit PRs for small bugs found during exploration. | Architecture specification doc approved by mentors. Dev environment fully operational. |
| **Week 1** | May 26 – Jun 1 | FastAPI project scaffold: proper project structure, database models (SQLite via SQLAlchemy async), core data models (EvalJob, EvalResult, Dataset, ProviderConfig), basic CRUD endpoints. | Running backend with health check endpoint, database migrations. |
| **Week 2** | Jun 2 – Jun 8 | Flutter eval feature folder structure. Riverpod providers for eval state management. Basic Dataset Manager UI wireframe. Backend-Flutter HTTP client integration. | Flutter skeleton screen connected to backend. |
| **Week 3** | Jun 9 – Jun 15 | Dataset file parsing: CSV, JSON, JSONL with validation and row-level preview. Flutter Dataset Manager UI: upload, preview table, field mapping interface, modality tagging. | Working dataset upload → preview → save flow. |
| **Week 4** | Jun 16 – Jun 22 | RAG-augmented Dataset Augmentor: seed embedding pipeline (sentence-transformers), structured LLM generation prompt, cosine similarity deduplication, batch approval UI. | Text-modality seed-to-synthetic dataset generation working end-to-end. |
| **Week 5** | Jun 23 – Jun 29 | Async eval execution engine: asyncio orchestration, batch processing with configurable concurrency, per-request tracking (latency, TTFT, token count, cost estimate). | Eval runner executing text evaluations with per-request metrics. |
| **Week 6** | Jun 30 – Jul 6 | SSE progress streaming: typed event model, FastAPI SSE endpoint, Flutter SSE client consuming live progress. Checkpoint/resume mechanism for long evaluations. | End-to-end text eval with real-time progress streaming and checkpoint support. |
| **Midterm** | ~Jul 7 | **Midterm demo:** Register a dataset → configure eval → run against 2+ providers → watch real-time progress → view results. lm-harness integration for MMLU benchmark. Basic results table in Flutter. | Full text evaluation pipeline working end-to-end with live streaming and benchmark support. |
| **Week 7** | Jul 7 – Jul 13 | Implement text metrics: BLEU, ROUGE-L, exact match, semantic similarity (sentence-transformers). LLM-as-judge integration for qualitative scoring. | Complete text metrics suite with LLM-as-judge. |
| **Week 8** | Jul 14 – Jul 20 | Flutter Results Dashboard: per-sample table, aggregate metrics panel, provider comparison side-by-side view with linked scrolling, model leaderboard. Export to CSV/JSON. | Full results dashboard with comparison and export. |
| **Week 9** | Jul 21 – Jul 27 | Image evaluation: base64/URL payload handling, CLIP score computation, caption BLEU/ROUGE. Vision API integration (GPT-4V, Gemini Vision, Claude Vision). Flutter image upload and preview in eval configuration. | Working image evaluation with CLIP score and vision API support. |
| **Week 10** | Jul 28 – Aug 3 | Voice evaluation: Whisper integration for WER/CER computation, audio file handling, Gemini Audio API integration. Flutter audio upload UI. | Working audio evaluation with WER/CER metrics. |
| **Week 11** | Aug 4 – Aug 10 | Agent evaluation: OpenTelemetry span instrumentation, tool call sequence validation, step-level cost/latency breakdown. Flutter agent trace timeline visualization. | Agent eval with step-level trace dashboard. |
| **Week 12** | Aug 11 – Aug 17 | Docker + Docker Compose for one-command local setup. Optional AWS deployment documentation (ECS/Fargate + S3). Performance optimization, UI polish, error handling, edge cases. | Dockerized deployment, performance-validated. |
| **Week 13** | Aug 18 – Aug 25 | User documentation (running evals, interpreting results), developer documentation (adding metrics, adding providers). Video demo. Final PR cleanup and review. GSoC final submission. | Complete documentation, demo video, final PRs submitted. |

---

### Commitment

I will work on this project full-time at 40+ hours per week for the entire coding period. As a first-year student with no competing summer commitments, this is my primary engineering focus. I am available for daily asynchronous communication via Discord and GitHub, and weekly synchronous video calls with mentors. I have already begun learning Flutter/Dart and will be fully productive in the API Dash codebase by the start of the coding period.

This project is personally meaningful to me. Building MedConnect showed me that the difference between a demo and a deployed AI system is not the model — it is the measurement. I want to help API Dash give every developer the tools to make that measurement, across every modality, at scale.
