### Initial Idea Submission

**Full Name:** Himanshi Chainani

**University name:** N/A (Working Professional)

**Program you are enrolled in (Degree & Major/Minor):** B.Tech, Computer Science (Graduated)

**Year:** Working Professional (1+ year at HPE)

**Expected graduation date:** N/A (Already graduated)

**Project Title:** Multimodal AI and Agent API Eval Framework

**Relevant issues:** [#1226](https://github.com/foss42/apidash/issues/1226)

### Idea Description

#### The Problem

Evaluating AI models today is fragmented. Existing tools like lm-evaluation-harness and lighteval are text-only and CLI-driven. There is no unified platform where a user can configure an AI API, point it at a benchmark or custom dataset, run evaluations across text, image, voice, and agent modalities, and visually compare results - all from a single UI. Switching providers (OpenAI -> Anthropic -> HuggingFace) requires rewriting evaluation code. Comparing results is a manual spreadsheet exercise.

#### Proposed Solution

I propose building an end-to-end evaluation framework with a **FastAPI backend** and **React/TypeScript frontend** that addresses all of the above.

**Backend (Python + FastAPI):**

- **Provider Abstraction Layer** - A `BaseProvider` interface that every provider adapter (OpenAI, Anthropic, HuggingFace, custom REST) implements. Common methods: `generate_text`, `generate_image`, `speech_to_text`, `agent_execute`, etc. All return a standardized `ProviderResult` with output, latency, tokens, and cost. Swapping providers requires only a config change, not code changes.

- **Evaluator Modules** - One evaluator class per modality:
  - Text - BLEU, ROUGE-L, F1, Exact Match (implemented from scratch, no external metric libraries)
  - Image - Classification accuracy, caption BLEU/ROUGE, generation success
  - Voice - WER and CER via Levenshtein edit distance
  - Agent - Tool selection accuracy, argument accuracy, task completion, answer F1

- **Benchmark Wrappers** - Integration with lm-evaluation-harness (MMLU, HellaSwag, ARC, GSM8K, etc.) and lighteval (TruthfulQA, BoolQ), with a simulated mode for demos/CI when these tools aren't installed.

- **Custom Dataset Loader** - Support for user-uploaded JSONL, CSV, and JSON datasets with auto-detection of field names.

- **Eval Engine & Task Runner** - Central orchestrator that routes evaluations to the correct evaluator or benchmark wrapper. Asyncio-based task runner with concurrent execution, progress tracking, and cancellation.

- **Storage** - SQLite (aiosqlite) for all metadata. Designed for easy migration to PostgreSQL.

- **API Routes** - Five groups: `/providers`, `/datasets`, `/benchmarks`, `/evaluations`, `/results` with CRUD, comparison, and export endpoints.

**Frontend (React + TypeScript + Vite + TailwindCSS + Recharts):**

- Six pages: Dashboard, Providers, Datasets, Benchmarks, Evaluations, Results
- Provider registration with connection testing
- Dataset upload with preview
- Evaluation configuration, launch, and live progress tracking
- Results comparison with bar/radar charts and metric rankings
- Export as JSON/CSV

**Deployment:** Docker Compose for one-command startup of backend + frontend.

#### Timeline (350 hours, 18–20 hrs/week)

| Phase | Period | Deliverable |
|-------|--------|-------------|
| Community Bonding | May 1 – May 26 | Finalize architecture with mentors, design DB schema, set up CI |
| Weeks 1–3 | May 26 – June 16 | Core backend: provider adapters, evaluator modules, benchmark wrappers, SQLite schema, unit tests |
| Weeks 4–6 | June 16 – July 7 | Full frontend: all 6 pages connected to backend, real-time progress, export |
| **Mid-term** | **July 7** | **End-to-end demo: register provider → upload dataset → run eval → view results** |
| Weeks 7–8 | July 7 – July 21 | Comparison charts, error handling, integration/E2E tests |
| Weeks 9–10 | July 21 – Aug 4 | Docker setup, security hardening, documentation |
| Buffer | Aug 4 – Aug 25 | Cleanup, mentor feedback, final demo |

#### About Me

I am a beginner open source contributor working as a software engineer at HPE (Hewlett Packard Enterprise) for more than a year. I have built an embedding/transformer model benchmarking framework that evaluates models across classification, clustering, similarity search, and sustainability/energy metrics - which is directly relevant to this project's evaluation focus. I also build FastAPI microservices, work with AI/ML pipelines, and have experience with React and Docker. I am comfortable managing my time alongside my job and can dedicate 20–25 hours per week (evenings and weekends).

