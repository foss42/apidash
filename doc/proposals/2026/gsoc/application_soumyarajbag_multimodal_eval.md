# GSoC 2026 — Multimodal AI & Agent API Eval Framework

---

## About

| | |
|---|---|
| **Full Name** | Soumyaraj Bag |
| **Public Email** | soumyarajbag@gmail.com |
| **Phone** | +91-8337045160 |
| **Discord** | [soumyarajbag](https://discord.com/soumyarajbag) |
| **GitHub** | https://github.com/soumyarajbag |
| **LinkedIn** | https://www.linkedin.com/in/soumyarajbag |
| **Time Zone** | IST (UTC+5:30) |
| **Resume** | https://drive.google.com/file/d/1TYmE47lWNoCBs9zo4r-3rACDsvfiBLTw/view |

---

## University Info

| | |
|---|---|
| **University** | [Maulana Abul Kalam Azad University of Technology] |
| **Program** | [B.Tech in Computer Science and Engineering] |
| **College** | [RCC Institute of Information Technology] |
| **Year** | [Fourth Year] |
| **Expected Graduation** | [2026] |

---

## Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before? Attach repo links or relevant PRs.**

I have made four contributions directly to the APIDash codebase in preparation for this proposal:

- **PR #1588** — https://github.com/foss42/apidash/pull/1588
  Fixed a critical Anthropic API spec violation in `packages/genai/lib/interface/model_providers/anthropic.dart`. The system prompt was being placed as `{"role": "system", "content": ...}` inside the `messages` array, which violates the Anthropic Messages API spec — the system prompt must be a top-level `"system"` field. This caused all Anthropic requests with a system prompt to silently produce wrong responses. I corrected the placement and added a `"Generate"` fallback for empty prompts to match OpenAI's behaviour. I also added comprehensive unit tests for the Anthropic, OpenAI, and Ollama provider adapters from scratch (+406 lines across three new test files) since none existed before.

- **PR #1590** — https://github.com/foss42/apidash/pull/1590
  Added a `ResponseEvaluator` utility to the `better_networking` package — a typed evaluation layer that returns `List<EvalResult>` instead of void logging. It covers five assertion types: status code match, max latency threshold, required JSON key presence, body substring check, and content-type header validation. Shipped with 25 test cases covering individual assertions, edge cases, and multi-assertion combinations. This utility is a direct building block for any response validation workflow in the eval framework.

- **Issue #1591** — https://github.com/foss42/apidash/issues/1591
  Identified that `packages/genai/lib/utils/ai_request_utils.dart` imports `package:flutter/foundation.dart` solely to use `debugPrint`, creating a hard Flutter SDK dependency across the entire `genai` package. This blocks the package from being used in pure Dart CLI or headless server contexts entirely — `dart pub get` fails without the Flutter SDK present. Filed the issue with a concrete fix path (replace `debugPrint` with `dart:developer`'s `log()`), referencing the identical fix that was already applied to `better_networking` in issue #1360.

- **Issue #1592** — https://github.com/foss42/apidash/issues/1592
  Found and documented two compounding bugs in Anthropic's SSE streaming parser. First, the text extraction path was `x['text']` when Anthropic's actual event structure nests it as `x['delta']['text']`, causing every token to return null. Second, the parser processed every SSE data line regardless of event type, meaning `message_start`, `ping`, and `content_block_start` events were all fed into the text extractor unnecessarily. Documented both bugs with Anthropic's actual SSE wire format and the precise fix required for each.

**2. What is your one project/achievement you are most proud of? Why?**

**Techtrix 2026 — Official Tech Fest Platform** (https://github.com/soumyarajbag/techtrix-2026)

If I had to point to one project that reflects my growth as a developer, it's Techtrix 2026 — the production-grade platform I designed, architected, and led for my college's annual technical festival, which served **3,000+ users** and handled real money transactions without a single critical failure.

What I built:
- **Full event ecosystem** — browse, register, and manage team-based competitions with real-time state via Zustand
- **Live payment integration** — end-to-end Razorpay flow: server-side order generation + cryptographic webhook signature verification
- **Auth & profiles** — Supabase Auth with secure server-side sessions (`@supabase/ssr`), registration tracking per user
- **Team management** — create teams, invite members, coordinate across events — all reflected live in the UI
- **AI-powered search** — Google AI SDK + Pinecone vector search for contextual RAG-based event discovery (one of the first RAG uses in our college's event history)
- **Performance & SEO** — Next.js 16 SSR-first, custom metadata, sitemap, robots.txt, PWA manifest
- **Code quality** — strict TypeScript across the entire codebase, Husky pre-commit hooks, ESLint + Prettier enforced for all contributors

This wasn't a toy project. Real registrations, real payments, real deadlines. I made architectural decisions that mattered — choosing Supabase over a custom backend to keep velocity high, structuring the codebase so multiple contributors could work without stepping on each other. Seeing 3,000+ people use something I shipped is the benchmark I hold all my work to.

**3. What kind of problems or challenges motivate you the most?**

What consistently pulls me in is the gap between what a tool could do for developers and what it currently forces them to do themselves. At Trumio, working on the AI Interviewer Agent, evaluating whether a response was actually good meant ad hoc scripts and manual comparison — there was no standardised interface. At smallcase, microservice observability was a first-class concern and you always knew when something broke. That contrast stuck with me: AI APIs are increasingly the most critical layer in a product, yet they remain the least observable and hardest to evaluate systematically.

That tension is exactly what this idea addresses — and it is why I built the POC before writing this proposal. A well-designed evaluation framework removes that friction permanently, not just for one project but for every developer who reaches for APIDash when building with AI. Shipping infrastructure that other developers quietly depend on, without ever having to think about the underlying complexity, is what I find most meaningful to work on.

**4. Will you be working on GSoC full-time? If not, what else will you be doing concurrently?**

- **35–40 hrs/week** commitment during the coding period
- **No concurrent internships** or academic coursework during GSoC
- **No planned vacations** during the GSoC period
- **One known constraint** — final semester exams, Jun 29 – Jul 7, 2026; exam days may require a full-day leave, and I have planned Week 6 deliverables to account for this so no critical milestones fall during that window
- Outside that window, **full-time availability** with no other personal, academic, or professional commitments

**5. Do you mind regularly syncing up with the project mentors?**

- **35–40 hrs/week** dedicated to GSoC — no concurrent internships or academic commitments during the coding period
- **Daytime IST (UTC+5:30)** primary hours — overlaps with European mornings and US evenings, making real-time calls practical
- **No planned vacations** during the GSoC period
- **Proactive async communication** by default — updates, blockers, and progress shared between syncs, not just during them
- Already engaged in `#1226` discussion — familiar with the codebase and mentor expectations before coding starts

**6. What interests you the most about API Dash?**

- **Serious tool with a clean architecture** — APIDash isn't just a UI wrapper; the `genai` and `better_networking` packages are thoughtfully separated, well-scoped, and genuinely pleasant to read. Contributing to them felt like working with a codebase that has standards.
- **At the intersection of API testing and AI** — Most API clients stop at request/response. APIDash is already pushing into multimodal AI providers, which is exactly the layer where evaluation infrastructure is missing and most needed.
- **Active, receptive community** — The maintainers engage seriously with issues and PRs. Discussion #1226 already has substantive back-and-forth, and my own contributions (PR #1588, PR #1590) received real review — not just rubber stamps.
- **Real impact potential** — The eval framework I'm proposing isn't an isolated side feature; it's a direct extension of what APIDash already does. Every developer who uses APIDash to test AI APIs is a natural user of this eval layer.

**7. Can you mention some areas where the project can be improved?**

- **Flutter SDK dependency in the genai package** — The `genai` package has an unnecessary hard dependency on the Flutter SDK, which prevents it from being used in pure Dart CLI or headless server contexts. The same problem was already resolved for `better_networking` (see [Issue #1360](https://github.com/foss42/apidash/issues/1360)), so the fix path is well-established. Filed as [Issue #1591](https://github.com/foss42/apidash/issues/1591).

- **Anthropic provider spec violations** — The Anthropic provider had two independent issues: the system prompt was being sent in the wrong position in the request body (violating the Anthropic Messages API spec), and the SSE streaming parser was reading from an incorrect path in the event data, causing every streamed token to return null. Fixed in [PR #1588](https://github.com/foss42/apidash/pull/1588); streaming bug documented in [Issue #1592](https://github.com/foss42/apidash/issues/1592).

- **Silent exception swallowing in the agentic engine** — When the agent retry loop encounters an exception, the error is constructed into a string but never actually logged or surfaced. Agent failures disappear silently, making it very difficult to debug why an agent run did not complete.

- **AI request body handling is unimplemented in better_networking** — The networking layer has an explicit unresolved TODO for handling the body of AI-type requests, currently returning nothing. This means any tooling that inspects, replays, or logs AI request bodies gets incomplete data. Related to the response evaluation utility added in [PR #1590](https://github.com/foss42/apidash/pull/1590).

- **No timeout on streaming responses** — Streaming responses have no timeout configured, so a stalled server connection will hang the client indefinitely with no recovery path. Every other request type in the same service has timeout handling; streaming is the one gap.

- **Outdated and incomplete model registry** — The model list is missing several widely-used recent models across all providers, and no entry carries capability metadata such as whether a model supports vision, function calling, or audio. This means the UI cannot warn users when they configure a capability that the selected model does not support.

- **No multi-provider dispatch in the request model** — The current request model is designed around a single provider per request. Comparing the same prompt across multiple providers requires manually duplicating and issuing requests outside the framework, with no built-in support for fan-out or result aggregation.

**8. Have you interacted with and helped the API Dash community? (GitHub/Discord links)**

- PR #1588: https://github.com/foss42/apidash/pull/1588
- PR #1590: https://github.com/foss42/apidash/pull/1590
- Issue #1591: https://github.com/foss42/apidash/issues/1591
- Issue #1592: https://github.com/foss42/apidash/issues/1592

---

## Project Proposal

### 1. Title
**APIDash Eval Studio — Multimodal AI & Agent API Evaluation Framework**

---

### 2. Abstract

**The Problem**

API Dash today is exceptional at testing a single request against a single provider. But developers building AI-powered products need answers at dataset scale and across providers: *Does GPT-4o or Claude 3.5 Sonnet score better on my summarization dataset? What is the word error rate gap between Whisper and Gemini on my audio test set? Does my agent reliably call the right tools in the right sequence?* Answering any of these today requires manually stitching together datasets, API calls, metric libraries, and result storage — none of which exists inside API Dash.

**What APIDash Eval Is**

APIDash Eval is a fully integrated evaluation layer for API Dash — a FastAPI backend paired with a React/TypeScript companion UI that lets developers run multi-provider, multimodal evaluation runs against custom or HuggingFace datasets, stream live progress, and compare results across runs without writing a single line of evaluation code.

A complete working prototype is already live at https://apidash-eval-poc.vercel.app/ (source: https://github.com/soumyarajbag/apidash-eval). The GSoC work is about hardening, integrating, and extending this into the APIDash ecosystem.

**What the POC Established**

Building the POC surfaced the non-obvious architectural decisions that make this framework correct and usable:

Every provider — OpenAI, Anthropic, Google, HuggingFace — is implemented behind a single abstract adapter interface that normalises all responses into a unified schema carrying output text, latency, token counts, finish reason, and error state. This makes cross-provider metric computation identical regardless of which provider produced the response, and adding a new provider is a matter of implementing four methods without touching the eval pipeline.

The metric engine uses a registry pattern: metrics are keyed by name and dispatched to modality-specific scorers at runtime. Text metrics (BLEU, ROUGE-1/2/L, F1, exact match, BERTScore), voice metrics (WER, CER, word accuracy), and image metrics (image-text relevance) are all registered under the same interface. BERTScore is lazily imported so PyTorch does not load at server startup — a real-world concern for deployment on constrained platforms. Aggregate statistics (avg, min, max per metric) are computed automatically across the full dataset run.

Real-time progress delivery is handled by a pub/sub SSE stream manager: each run gets a `run_id`, and the frontend subscribes to a typed event stream that carries log lines, progress fractions, per-sample metrics, and a terminal completion signal. A heartbeat fires every 15 seconds to keep connections alive through Render and Vercel proxy timeouts. Multiple browser tabs can subscribe to the same run stream concurrently.

For agent evaluation, the POC records the full execution trace per task — every think step, every tool call with its input and output, every model reasoning excerpt — and scores it on tool-call accuracy (exact match on function name and arguments), task completion, step efficiency, and output correctness against an expected answer. The agent tool definitions map directly to real external API endpoints, so evaluating an agent that calls a live weather API or search service is first-class.

The benchmark runner wraps lm-harness and lighteval as managed async subprocesses. Task selection, few-shot count, sample limits, and provider routing are all configurable from the UI. Subprocess output is captured line-by-line and forwarded to the same SSE stream, so benchmark runs feel identical to custom dataset runs from the frontend's perspective.

**Future Roadmap Beyond GSoC**

Once the core framework is stable, the natural extensions are: an LLM-as-judge scoring mode for free-form responses where reference-based metrics fall short; prompt A/B testing that runs the same dataset against multiple templates and compares metric distributions; a custom metric plugin system so teams can register their own domain-specific scorers; and a cost-quality Pareto view that surfaces which provider gives the best score per dollar across runs.

---

### 3. Detailed Description

#### 3.1 Problem Statement

API Dash today excels at testing a single request against a single provider. But developers building AI-powered products need answers at dataset scale and across providers: which provider scores better on a given task, how an agent behaves across a benchmark, what the word error rate gap looks like between voice APIs. None of this infrastructure exists inside APIDash today, and solving it without a dedicated framework requires stitching together multiple disconnected tools by hand.

---

#### 3.2 Pre-GSoC Preparation & Prototype Highlights

Rather than proposing the idea at a conceptual level, the pre-GSoC period was spent building a complete working prototype — deployed at https://apidash-eval-poc.vercel.app/ (source: https://github.com/soumyarajbag/apidash-eval).

**Backend (FastAPI)**

| File | Status | Lines |
|------|--------|-------|
| `app/providers/base.py` | Implemented | 132 |
| `app/providers/openai_adapter.py` | Implemented | 299 |
| `app/providers/anthropic_adapter.py` | Implemented | 265 |
| `app/providers/google_adapter.py` | Implemented | 252 |
| `app/providers/huggingface_adapter.py` | Implemented | 185 |
| `app/providers/registry.py` | Implemented | 78 |
| `app/evaluation/engine.py` | Implemented | 160 |
| `app/evaluation/metrics/text_metrics.py` | Implemented | 118 |
| `app/evaluation/metrics/voice_metrics.py` | Implemented | 90 |
| `app/evaluation/metrics/image_metrics.py` | Implemented | 107 |
| `app/evaluation/metrics/agent_metrics.py` | Implemented | 152 |
| `app/core/streaming.py` | Implemented | 110 |
| `app/services/eval_service.py` | Implemented | 244 |
| `app/services/agent_evaluator.py` | Implemented | 220 |
| `app/services/benchmark_runner.py` | Implemented | 315 |
| `app/services/dataset_service.py` | Implemented | 323 |
| `app/models/schemas.py` | Implemented | 350 |
| `app/main.py` | Implemented | 114 |

**Frontend (React + TypeScript)**

| File | Status | Lines |
|------|--------|-------|
| `pages/Eval/EvalPage.tsx` | Implemented | 416 |
| `pages/AgentEval/AgentEvalPage.tsx` | Implemented | 337 |
| `pages/Datasets/DatasetsPage.tsx` | Implemented | 249 |
| `pages/Benchmarks/BenchmarksPage.tsx` | Implemented | 242 |
| `pages/Results/ResultsPage.tsx` | Implemented | 159 |
| `pages/Dashboard/DashboardPage.tsx` | Implemented | 166 |
| `hooks/useSSEStream.ts` | Implemented | 75 |
| `api/client.ts` | Implemented | 104 |

---

#### 3.3 Proposed Architecture

APIDash Eval is built as a companion service to APIDash — a Python backend paired with a React/TypeScript frontend that together deliver the three capabilities described in the idea.

The **backend** (FastAPI) is the evaluation engine. It manages datasets, dispatches requests to AI provider APIs, computes metrics, runs benchmark tools, and stores results. It is also responsible for streaming live progress back to the browser in real time so users never stare at a blank screen waiting for a long eval run to finish.

The **frontend** (React/TypeScript) is the configuration and results layer. It gives users a clean interface to upload or connect datasets, configure which providers and models to test, pick the metrics they care about, watch runs progress live, and compare results across multiple runs side by side.

The **provider adapter layer** sits between the two. Every AI provider — OpenAI, Anthropic, Google, HuggingFace — is implemented behind a single unified interface that normalises all responses into a common format. This means the rest of the system never needs to know which provider it is talking to: the metrics engine, the agent evaluator, and the benchmark runner all work the same way regardless of which API is under evaluation.

The **metrics engine** is a registry of named scorers organised by modality. Text evaluation uses BLEU, ROUGE, F1, and BERTScore. Voice evaluation uses word error rate and character error rate. Image evaluation uses CLIP-based image-text relevance. Agent evaluation scores tool-call accuracy, task completion, and step efficiency. New metrics can be added to the registry without touching any other part of the system.

The **benchmark runner** integrates with lm-harness and lighteval by managing them as background processes. The user selects a task and model from the UI; the backend launches the benchmark tool, captures its output line by line, and streams it live to the frontend — exactly the same streaming experience as a custom dataset run.

| Idea Requirement | APIDash Eval Subsystem |
|---|---|
| Run AI benchmarks via lm-harness / lighteval | Benchmark Runner — background process manager with live log streaming |
| UI to configure requests, datasets, parameters, view results | React/TypeScript frontend — Dataset Manager, Eval Config, Results Dashboard |
| Evaluate text / image / voice / agent via API | Provider Adapter layer + Metrics Engine + Agent Evaluator |

**End-to-End Data Flow**

```
┌─────────────────────────────────────────────────────────────┐
│                        FRONTEND (React/TS)                  │
│   Upload Dataset  │  Configure Run  │  Select Metrics       │
└─────────────────────────────┬───────────────────────────────┘
                              │  POST /api/v1/eval/runs
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     EVAL SERVICE (FastAPI)                  │
│           Spawns background task, assigns run_id            │
└──────────┬──────────────────┬──────────────────┬────────────┘
           │                  │                  │
           ▼                  ▼                  ▼
┌──────────────┐   ┌─────────────────┐   ┌──────────────────┐
│   Dataset    │   │    Provider     │   │    Benchmark     │
│   Service    │   │    Adapters     │   │    Runner        │
│              │   │                 │   │                  │
│ Load rows    │   │ OpenAI          │   │ lm-harness       │
│ from file /  │   │ Anthropic       │   │ lighteval        │
│ HuggingFace  │   │ Google          │   │ (subprocess)     │
└──────┬───────┘   │ HuggingFace     │   └────────┬─────────┘
       │           └────────┬────────┘            │
       │ rows               │ responses           │ stdout
       └──────────┬─────────┘                     │
                  ▼                               │
┌─────────────────────────────┐                   │
│      EVALUATION ENGINE      │                   │
│                             │                   │
│  Text  → BLEU, ROUGE, F1    │                   │
│  Voice → WER, CER           │                   │
│  Image → CLIP similarity    │                   │
│  Agent → tool accuracy,     │                   │
│          step efficiency    │                   │
└─────────────┬───────────────┘                   │
              │ per-sample scores                 │
              ▼                                   ▼
┌─────────────────────────────────────────────────────────────┐
│                    STREAM MANAGER (SSE)                     │
│         Publishes LOG / PROGRESS / METRIC / COMPLETE        │
└─────────────────────────────┬───────────────────────────────┘
                              │  GET /eval/runs/{id}/stream
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        FRONTEND (React/TS)                  │
│    Live log terminal  │  Progress bar  │  Per-sample view   │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      RESULTS DASHBOARD                      │
│   Aggregate metrics  │  Cross-run comparison  │  Export     │
└─────────────────────────────────────────────────────────────┘
```

---

#### 3.4 Files Already Implemented (POC → GSoC Refinement)

**`app/providers/base.py`** — `AIProviderAdapter` abstract base class with `text_completion`, `image_understanding`, `voice_transcription`, `agent_completion`, and `ProviderResponse` unified response schema.
_To add:_ retry logic with exponential backoff, per-provider rate limiting, request cost estimation.

**`app/providers/{openai,anthropic,google,huggingface}_adapter.py`** — Concrete provider implementations for all four major providers across text, image, and voice modalities.
_To add:_ image modality for Anthropic Vision, audio transcription for Google Gemini, structured output support for OpenAI.

**`app/evaluation/engine.py`** — Registry-pattern metric dispatcher. Metrics are keyed by name and routed to modality-specific scorers at runtime. Computes per-sample and aggregate (avg/min/max) statistics.
_To add:_ custom metric plugin registration, LLM-as-judge integration hook.

**`app/evaluation/metrics/text_metrics.py`** — BLEU (sacrebleu), ROUGE-1/2/L (rouge-score), F1, exact match, contains match, BERTScore (lazy-loaded).
_To add:_ METEOR, semantic similarity via sentence-transformers.

**`app/evaluation/metrics/voice_metrics.py`** — WER, CER, word accuracy via jiwer.
_To add:_ speaker diarization accuracy metric.

**`app/evaluation/metrics/image_metrics.py`** — Image-text relevance via CLIP (lazy-loaded).
_To add:_ SSIM, PSNR for image generation evaluation.

**`app/evaluation/metrics/agent_metrics.py`** — Tool-call accuracy (exact match on function name + args), task completion rate, step efficiency, output correctness.
_To add:_ tool-call order accuracy, partial credit scoring for near-correct tool calls.

**`app/core/streaming.py`** — `StreamManager` pub/sub SSE layer. Each run gets a `run_id`; the frontend subscribes to a typed event stream (`LOG`, `PROGRESS`, `METRIC`, `ERROR`, `COMPLETE`). Heartbeat fires every 15 seconds to keep connections alive through proxy timeouts.
_To add:_ stream persistence so late-joining clients can replay missed events.

**`app/services/eval_service.py`** — Orchestrates batch evaluation as a background task: loads dataset rows, dispatches provider calls concurrently (configurable concurrency limit), scores per sample, publishes SSE events, stores aggregate results.
_To add:_ checkpoint/resume for large runs, cancellation support.

**`app/services/agent_evaluator.py`** — Runs agent tool-call loops, records every step (think / tool_call / response), scores against expected tool sequences.
_To add:_ multi-agent orchestration evaluation, timeout handling per step.

**`app/services/benchmark_runner.py`** — Wraps `lm-harness` and `lighteval` as managed async subprocesses. Subprocess stdout is captured line-by-line and forwarded to the SSE stream in real time.
_To add:_ lighteval task auto-discovery, custom task registration support.

**`app/services/dataset_service.py`** — Handles CSV, JSON, JSONL uploads; HuggingFace Hub dataset pull; dataset preview with column schema inference.
_To add:_ Parquet support, dataset validation against expected schema.

**`app/models/schemas.py`** — Full Pydantic schema coverage: `EvalRunCreate`, `EvalRunResponse`, `EvalSampleResultResponse`, `AgentEvalRunCreate`, `AgentTaskResultResponse`, `BenchmarkRunCreate`, `BenchmarkRunResponse`.
_To add:_ schema versioning for result export compatibility.

---

#### 3.5 New Files to be Added

**`app/evaluation/metrics/custom_metrics.py`**
Plugin registration system allowing users to define and register custom Python scoring functions under a named key, which are then available in the `EvaluationEngine` registry.

**`app/evaluation/llm_judge.py`**
LLM-as-judge scoring mode — uses a configurable judge model (GPT-4o or Claude) to score free-form responses against criteria, for cases where reference-based metrics are insufficient.

**`tests/test_providers.py`** — Unit tests for each provider adapter: correct request formatting, response parsing, error handling, latency measurement.

**`tests/test_evaluation_engine.py`** — Metric correctness tests for all registered metrics across all modalities, including edge cases (empty strings, identical inputs, unicode).

**`tests/test_eval_service.py`** — Integration tests for end-to-end batch eval runs against a mocked provider.

**`tests/test_benchmark_runner.py`** — Tests for subprocess management, SSE event forwarding, and timeout handling.

**`tests/test_agent_evaluator.py`** — Agent loop tests: tool-call tracing correctness, accuracy scoring, max-step enforcement.

**`examples/eval-text-summarization/`** — Demonstrates batch text eval: CSV dataset, two providers, ROUGE + BERTScore metrics, results dashboard.

**`examples/eval-agent-toolcall/`** — Demonstrates agent eval: tool definitions pointing to a mock API, task list with expected tool sequences, accuracy scoring.

---

#### 3.6 How APIDash Eval Integrates with APIDash

APIDash Eval runs as a companion service alongside the existing APIDash desktop app. Integration is via REST — APIDash desktop can call `POST /api/v1/eval/runs` directly, making evaluation a native APIDash action without any changes to Flutter or Dart code. The eval service is shipped as a Docker image so it can be run locally alongside APIDash or deployed independently.

The REST API is designed so a user can select a collection from APIDash, point it at a dataset, choose metrics, and start a run — all from within the APIDash UI. The eval service handles everything from that point: dispatching to providers, computing metrics, streaming progress, and storing results.

---

#### 3.7 Tests to be Added

| Test File | Covers |
|---|---|
| `tests/test_providers.py` | Provider adapter request formatting, response parsing, error handling |
| `tests/test_evaluation_engine.py` | Metric correctness across all modalities, edge cases |
| `tests/test_eval_service.py` | End-to-end batch eval with mocked provider |
| `tests/test_benchmark_runner.py` | Subprocess management, SSE forwarding, timeout handling |
| `tests/test_agent_evaluator.py` | Tool-call tracing, accuracy scoring, max-step enforcement |
| `tests/test_dataset_service.py` | CSV/JSON/JSONL parsing, HuggingFace Hub pull, schema inference |

---

#### 3.8 Reference Implementations

**`lm-evaluation-harness` (EleutherAI)**
Primary reference for benchmark task structure, few-shot configuration, and model-API routing. The `BenchmarkRunner` in APIDash Eval wraps this as a managed subprocess.

**`lighteval` (HuggingFace)**
Secondary benchmark runner reference. Task discovery and result parsing patterns are modeled after its CLI interface.

**`html-bundler-webpack-plugin` by webdiscus**
Reference for how provider-agnostic pipelines handle input normalization and output rewriting — informed the multimodal input normalization layer design across OpenAI, Anthropic, and Google.

---

#### 3.9 Key Design Decisions

- **Companion service, not a Flutter reimplementation** — Python is the right runtime for evaluation workloads (metric libraries, ML dependencies, subprocess management). APIDash desktop integrates via REST, not by reimplementing the engine in Dart.
- **Provider adapters as an ABC** — forces a consistent interface, makes adding a provider a bounded task, and allows the eval pipeline to be provider-agnostic.
- **Registry-pattern metrics** — new metrics are added by registering a callable under a name; no branching in the eval service itself.
- **Lazy imports for heavy dependencies** — BERTScore and CLIP import PyTorch only when actually called, keeping startup fast and the Docker image footprint reasonable.
- **SSE over WebSockets** — unidirectional server-push is sufficient for progress streaming; SSE has simpler reconnect semantics and works through standard HTTP proxies without configuration.
- **Background tasks over a job queue** — `asyncio` background tasks are sufficient for the expected concurrency; Redis/Celery would add operational complexity without meaningful benefit at this scale.

---

### 4. Proof of Concept — APIDash Eval Studio

**APIDash Eval Studio** is a fully working pre-GSoC prototype of the proposed framework, already deployed at https://apidash-eval-poc.vercel.app/ (source: https://github.com/soumyarajbag/apidash-eval).

The following demonstrates the end-to-end functionality already working in APIDash Eval Studio:

**Configuration**
```
Provider: openai (gpt-4o-mini)
Dataset:  custom CSV — input column: "prompt", expected column: "reference"
Metrics:  bleu, rouge, f1, exact_match
Modality: text
```

**Feature Validation**

| Component | Input | Output |
|---|---|---|
| Dataset Manager | CSV file upload | Parsed schema, row preview, stored dataset ID |
| Eval Playground (single) | Prompt + provider/model | Response, latency, per-metric scores |
| Batch Eval | Dataset ID + config | Run ID, SSE stream with per-sample progress |
| SSE Stream | `run_id` | Live LOG / PROGRESS / METRIC events in terminal UI |
| Agent Evaluator | Task + tool definitions | Full step trace, tool-call accuracy, task completion score |
| Benchmark Runner | lm-harness task name + model | Subprocess SSE stream, parsed results stored |
| Results Dashboard | Run IDs | Side-by-side metric comparison, per-sample drilldown, CSV export |

---

### 5. Weekly Timeline: A week-wise timeline of activities

| Week | Start | End | Tasks |
|------|-------|-----|-------|
| **Community Bonding** | May 1 | May 26 | • Review POC with mentors and finalise deliverable scope<br>• Agree on REST API schema and supported metrics per modality<br>• Set up CI pipeline (GitHub Actions) for backend and frontend<br>• Configure Docker Compose for local development<br>• Write integration design document with API contracts<br>• Deep-dive into lm-harness and lighteval CLI interfaces and task discovery |
| **Week 1** | May 27 | Jun 2 | **Backend Core — Dataset Service & Provider Foundation**<br>• Finalise MongoDB schemas for datasets, eval runs, and results<br>• Dataset ingestion: CSV, JSON, JSONL parsing with column schema inference<br>• HuggingFace Hub dataset pull via the datasets library<br>• Dataset preview endpoint with row sampling and pagination<br>• Provider adapter base class with unified response schema (output, latency, tokens, error)<br>• OpenAI and Anthropic text adapters with retry logic and rate limit handling<br>• Provider registry with API key validation |
| **Week 2** | Jun 3 | Jun 9 | **Batch Eval Engine & Text Metrics**<br>• Batch eval service: concurrent row dispatch with configurable concurrency limit<br>• Eval run lifecycle management: pending → running → completed / failed<br>• Text metrics: BLEU, ROUGE-1/2/L, F1, exact match, contains match<br>• BERTScore with lazy PyTorch import to keep startup fast<br>• Per-sample result storage: input, expected, actual output, metrics, latency<br>• Aggregate metric computation (avg / min / max) across full dataset<br>• Google and HuggingFace text adapters |
| **Week 3** | Jun 10 | Jun 16 | **SSE Streaming & Multimodal Support**<br>• StreamManager: pub/sub SSE with per-run async queues<br>• Typed event protocol: LOG, PROGRESS, METRIC, ERROR, COMPLETE<br>• Heartbeat every 15 seconds to prevent proxy timeouts<br>• Stream persistence so late-joining clients can replay missed events<br>• Image modality: OpenAI Vision and Gemini Vision adapters<br>• Voice modality: Whisper and Gemini audio transcription adapters<br>• Multimodal input normalisation layer (base64 / URL across providers)<br>• Voice metrics: WER, CER via jiwer — Image metrics: CLIP relevance (lazy-loaded) |
| **Week 4** | Jun 17 | Jun 23 | **Agent Evaluator & Benchmark Runner** ✦ Mid-term checkpoint<br>• Agent evaluator: tool-call loop recording every think / tool_call / response step<br>• Tool definition schema mapped to real external API endpoints<br>• Agent scoring: tool-call accuracy, task completion rate, step efficiency<br>• Agent eval API endpoint with SSE streaming per run<br>• Benchmark runner: lm-harness async subprocess wrapper with stdout line capture<br>• lighteval subprocess wrapper with task auto-discovery<br>• Benchmark results parsing and structured storage<br>• Mid-term deliverable: text + image + voice eval + agent eval + benchmark runner all functional |
| **Week 5** | Jun 24 | Jun 30 | **Frontend — Dataset Manager & Eval Configuration**<br>• Dataset Manager: upload CSV/JSON/JSONL, preview rows, HuggingFace Hub pull, delete<br>• Eval Config panel: provider dropdown, model selector, modality toggle<br>• Request parameter controls: temperature, max tokens, system prompt<br>• Metric selector with per-modality checkboxes<br>• Single eval playground: one-shot request with live response and per-metric scores<br>• API key management in settings page |
| **Week 6** | Jul 1 | Jul 7 | **Frontend — Batch Eval UI & Results Dashboard**<br>• Batch eval UI: dataset picker + config → start run flow<br>• SSE log terminal with live scrolling output<br>• Progress bar showing samples completed out of total<br>• Run history list with status badges, provider, modality, and timestamps<br>• Per-sample results view: input, expected output, actual output, per-metric breakdown<br>• Results Dashboard: aggregate metrics display and side-by-side cross-run comparison<br>• CSV and JSON export of full run results |
| **Week 7** | Jul 8 | Jul 14 | **Frontend — Agent Eval & Benchmark UI**<br>• Agent Eval UI: tool definition builder, task list with expected tool sequences, run button<br>• Step trace viewer: expandable timeline of think / tool_call / response steps per task<br>• Agent results view: tool-call accuracy, task completion score, step count<br>• Benchmark Runner UI: task name input, few-shot count, model picker, start run<br>• Benchmark live terminal with real-time subprocess output<br>• Parsed benchmark results display with per-task scores |
| **Week 8** | Jul 15 | Jul 21 | **Testing, Documentation & Final Submission**<br>• Provider unit tests: request formatting, response parsing, error handling per adapter<br>• Metric correctness tests across all modalities with edge cases<br>• Eval service integration tests against mocked providers<br>• Agent evaluator tests: tracing correctness, accuracy scoring, step limit enforcement<br>• Dataset service tests: all formats, HuggingFace pull, schema inference<br>• Docker Compose and deployment documentation<br>• README with quickstart, configuration reference, and example walkthroughs<br>• Final mentor review and GSoC portal submission |

**Stretch goals** (if ahead of schedule):
- LLM-as-judge scoring mode for free-form responses
- Custom metric plugin system for user-defined scorers
- Prompt A/B testing across multiple system prompts on the same dataset

---

### 6. Why Me

- **Working POC before the proposal** — Built and deployed a complete prototype before writing this: https://apidash-eval-poc.vercel.app/ (source: https://github.com/soumyarajbag/apidash-eval). Hard architectural problems are already solved — async multi-provider execution, registry-pattern metrics, pub/sub SSE streaming, agent step tracing, lm-harness/lighteval subprocess management. The GSoC period is about hardening and productionising what already works.

- **Deep APIDash contributions** — Four direct contributions rooted in reading the source: [PR #1588](https://github.com/foss42/apidash/pull/1588) (Anthropic spec fix), [PR #1590](https://github.com/foss42/apidash/pull/1590) (typed response evaluator, 25 tests), [Issue #1591](https://github.com/foss42/apidash/issues/1591) (Flutter SDK dep blocking headless use), [Issue #1592](https://github.com/foss42/apidash/issues/1592) (SSE streaming null token bug).

- **Full-stack production experience** — Python/FastAPI backends, React/TypeScript frontends, MongoDB/PostgreSQL. Shipped Techtrix 2026 (3,000+ users, live payments, zero critical failures). Professional internships:
  - **smallcase** — Backend SWE Intern. Contributed backend integrations across Foundation Unit microservices, focused on scalable service architecture. Stack: Node.js, Express.js, Go, MongoDB, REST APIs.
  - **Trumio Inc., San Jose CA** — SWE Intern (May 2024 – Nov 2025). Built major features across the platform: Organization Admin Portal frontend, Flexternship (full-stack project-based hiring), AI Interviewer Agent enhancements with job automation, and User Simulation (interactive feature-testing playground). Stack: React.js, Next.js, TypeScript, Redux, MongoDB, PostgreSQL, Python, FastAPI.

- **Multi-org open source track record** — webpack core: [PR #20735](https://github.com/webpack/webpack/pull/20735) (HTML entry POC). webpack-doc-kit: [PR #61](https://github.com/webpack/webpack-doc-kit/pull/61), [PR #62](https://github.com/webpack/webpack-doc-kit/pull/62), [PR #63](https://github.com/webpack/webpack-doc-kit/pull/63), [Issue #64](https://github.com/webpack/webpack-doc-kit/issues/64). RCCIIT org: 79+ merged PRs across six repos, served as maintainer. GDG Kolkata: built DevFest 2024 frontend (3,000+ attendees).

- **Full-time availability** — 35–40 hrs/week, no concurrent commitments, proactive communicator.
