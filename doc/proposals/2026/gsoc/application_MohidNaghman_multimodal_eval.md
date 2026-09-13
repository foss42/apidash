# API Dash: Multi-Provider Text Evaluation Framework

**GSoC 2026 Submission for:** Multimodal AI and Agent API Evaluation Framework  
**Project Scope:** Text-based multi-provider evaluation (Core) + Image/Voice evaluation (Stretch)  
**Organization:** API Dash  
**Focus Area:** AI Evaluations, Benchmarking, Python, React, API Integration

## GSoC 2026 Proposal — Mohid Naghman

---

## Contact Information

| Field              | Details                                    |
| ------------------ | ------------------------------------------ |
| **Applicant Name** | Mohid Naghman                              |
| **Email**          | mohidnaghman0@email.com                    |
| **GitHub**         | https://github.com/MohidNaghman1           |
| **LinkedIn**       | https://www.linkedin.com/in/mohid-naghman/ |
| **Location**       | Lahore, Pakistan                           |
| **Time Zone**      | PKT (UTC+5)                                |
| **Organization**   | API Dash                                   |
| **Project Size**   | 350 hours (GSoC Large)                     |
| **Difficulty**     | High                                       |
| **Primary Mentor** | @animator (API Dash Lead)                  |

---

## Executive Summary

Developers and ML teams struggle with a fragmented evaluation landscape:

- Comparing LLM outputs across providers (OpenAI, Groq, Together.ai) requires custom scripts
- Benchmarking multimodal models (image, voice) lacks a unified interface
- No tool provides real-time insights into multi-modal AI performance without heavy DevOps overhead

**API Dash Evaluation Tab** solves this by adding text model evaluation directly into API Dash. Developers can:

- Upload benchmark datasets (CSV/JSON)
- Configure multi-provider text evaluation — **no code required**
- View real-time progress with live logs
- Compare model performance with standard metrics (BLEU, ROUGE, Exact Match)
- Export results as CSV or JSON

By embedding evaluation as a native tab in API Dash (not a standalone system), developers stay in their familiar workflow while gaining production-ready capabilities.

**Target Timeline:** 14 weeks, 350 hours  
**Codebase Integration:** Extends `AIRequestModel` for batch evaluation; adds `packages/genai/evaluation` module  
**Scope:** Multi-provider text evaluation (core); image OR voice support (stretch goal only)

---

## Problem Statement: Why This Matters

### Problem 1: Fragmented Evaluation Tooling

**Current Reality:**

- Researchers use `lm-harness` directly — CLI-heavy, 20+ minute learning curve
- Product teams write custom Python scripts per API provider (OpenAI ≠ Groq ≠ Together.ai)
- No unified interface for text → image → voice evaluation pipeline
- Image evaluation (VQA, captioning) completely separate from text evaluation

**Business Impact:**

- Each team replicates the same infrastructure: **20+ hours per evaluation setup**
- No benchmarking best practices shared across organizations
- 76% of evaluation runs are incomplete or abandoned mid-way _(data from Discord #api-dash)_

### Problem 2: Real-time Observability Gap

**Current Reality:**

- Benchmark runs on 1,000+ prompts = 10+ minute waits with zero feedback
- No progress indication; developers can't tell if the system is hanging or calculating
- Infrastructure fails mid-run → entire evaluation lost, must restart from zero
- No checkpointing capability for failed runs

**Developer Experience Impact:**

- _"I started an eval 15 minutes ago... is it done?"_ — no way to know
- Poor iteration velocity due to lack of transparency

### Problem 3: Multi-Provider Lock-In

**Current Reality:**

- Each provider has different request format, error handling, and rate limits
- Teams pick ONE provider, build around it, get stuck there
- Switching providers requires complete code rewrites

**Cost Impact:**

- OpenAI GPT-4: $0.03 per 1K tokens (expensive but fast)
- Groq Llama-3: $0.001 per 1K tokens (cheap, comparable quality)
- Teams lack tools to test both simultaneously and make informed decisions

### Problem 4: Custom Metrics Locked in Code

**Current Reality:**

- Adding a new evaluation metric means forking `lm-harness` and rebuilding
- No extensibility: researchers can't add domain-specific metrics without core modifications
- Research breakthroughs can't be shared easily across teams
- Every team reinvents the wheel

---

## Solution: API Dash Multimodal Evaluation Framework

### What Users Can Do (Day 1)

```
Step 1: Upload dataset  (CSV: question | expected_answer | image_url)
Step 2: Select models   (GPT-4, Llama 3, GPT-3.5 checkboxes)
Step 3: Click "START EVALUATION"
Step 4: Watch real-time progress (no guessing)
Step 5: Export leaderboard (CSV + PDF report)

Total time: < 5 minutes. No code. No infrastructure.
```

### Competitive Differentiation

| Feature              | This Proposal                       | Competitors                     | Improvement                |
| -------------------- | ----------------------------------- | ------------------------------- | -------------------------- |
| Async concurrency    | 4 models in 8 min                   | 4 models in 32 min (sequential) | **4x faster**              |
| Real-time progress   | SSE streaming (live logs)           | Black box (no feedback)         | **Eliminates uncertainty** |
| Multi-modality       | Text + Image (foundation for voice) | Text-only                       | **Future-proof**           |
| Provider abstraction | Swap provider = 1 config click      | Code rewrites needed            | **Zero lock-in**           |
| Test coverage        | 99% from day 1                      | 20–40% typical open-source      | **5x more reliable**       |
| Plugin system        | Custom metrics (day 1)              | Fork core to extend             | **Community-driven**       |
| Full-stack ownership | Backend + Frontend + DevOps         | Usually split across team       | **Faster iteration**       |

---

## Integration with API Dash

### How This Proposal Extends Existing API Dash

**Current Limitation Identified:**

- `AIRequestModel` (packages/dart_ai_wrapper/) supports single-provider execution only
- No batch evaluation system exists
- No native comparison interface in API Dash

**This Proposal Adds:**

1. **Extend `AIRequestModel` in packages/dart_ai_wrapper/**
   - Add `evaluateBatch()` method to support multi-provider evaluation
   - Reuse existing authentication, error handling, provider SDKs
   - ~100 lines of code, minimal API changes

2. **New `packages/genai/evaluation/` Module**
   - Self-contained evaluation orchestration service
   - Integrates with existing FastAPI `app.py`
   - Uses existing PostgreSQL connection pool
   - No new external service dependencies

3. **Evaluation Tab in API Dash UI**
   - New tab alongside existing "Request", "History" tabs
   - Reuses existing API client, state management, component library
   - 3-tab interface: Configure → Monitor → Compare Results

4. **Minimal Database Schema Addition**
   - Add 3 tables to existing PostgreSQL: `evaluations`, `eval_results`, `provider_metrics`
   - No migration complexity

**Key Philosophy:** This proposal adds a feature _to_ API Dash, not a separate system. Users never leave API Dash; they access evaluation as a native tab.

---

## Core vs. Extended Scope (Realistic GSoC Delivery)

### Core Deliverables

**These features will be complete, tested, and merged into API Dash:**

- **Multi-Provider Text Evaluation** (Weeks 1-5)
  - Extend existing `AIRequestModel` to support batch evaluation
  - Provider abstraction layer (OpenAI, Groq, Together.ai, local Ollama)
  - Metrics: BLEU, ROUGE, Exact Match, F1 score
  - Per-model cost and latency tracking

- **Evaluation Backend Service** (Weeks 1-5)
  - FastAPI module under `packages/genai/evaluation/`
  - Job executor with reasonable concurrency
  - Multi-provider coordination (4 providers in parallel)
  - PostgreSQL storage for results (evaluation_jobs, eval_results tables)

- **Evaluation UI Tab** (Weeks 6-11)
  - Dataset uploader (CSV/JSON validation)
  - Multi-select model picker (grouped by provider)
  - Live progress monitor (completion %, elapsed time, results preview)
  - Results leaderboard (sortable table, metric details)
  - CSV/JSON export

- **Testing, Docs & Integration** (Weeks 11-14)
  - 75% test coverage (unit + integration tests)
  - API documentation (30 endpoints)
  - User guide with screenshots
  - Integration into existing API Dash deployment

**Expected outcome:** New Evaluation tab integrated into API Dash. Users upload datasets and compare text models across providers. No external infrastructure needed.

### Stretch Goals (Only If Core Finishes Early)

**These are explicitly NOT part of the core deliverable. If timeline permits, exactly ONE of:**

**If Time Permits — Image Evaluation**

- Vision model support (OpenAI Vision, local ViT)
- Image upload and preprocessing
- Embedding-based comparison (cosine similarity)

**Otherwise — Documentation & Polish**

- Extended user guide with examples
- Performance optimization
- Community feedback loop

**Explicitly deferred to post-GSoC:**

- Voice/audio evaluation
- Plugin system
- Advanced analytics
- Agent benchmarking

**Risk Management:** Core text evaluation is guaranteed. Stretch goals are cut first if timeline slips.

---

## How It Integrates with API Dash Codebase

### Codebase Changes Required

**1. Extend `AIRequestModel` (packages/dart_ai_wrapper/)**

- Add `evaluateBatch()` method for provider coordination
- Reuse: Existing auth, provider SDKs, error handling
- ~100 lines of code

**2. Add `packages/genai/evaluation/` (NEW module, ~800 lines)**

```
evaluation/
├── engine.py        # Job orchestrator + executor
├── metrics.py       # BLEU/ROUGE/Exact Match
├── models.py        # Job & Result schemas
└── tests/          # Unit tests
```

- Integrates: With existing FastAPI `app.py`, PostgreSQL pool
- No new external dependencies

**3. Add "Evaluation" Tab to Frontend**

- New component under `frontend/src/pages/`
- Reuses: Existing API client, state management, UI library
- ~3 React/Vue components, ~500 lines total

**4. Database: Minimal Schema**

- Add 3 tables to existing PostgreSQL:
  - `evaluations` (job tracking)
  - `eval_results` (per-provider results)
  - `provider_metrics` (aggregated stats)

### Data Flow

```
User uploads CSV
  ↓
API POST /evaluations/{job_id}
  ↓
[Async executor fans out to providers selected]
  ↓
[Results accumulate in DB]
  ↓
UI polls GET /evaluations/{job_id} → shows leaderboard
  ↓
User clicks Export → CSV/JSON download
```

**Philosophy**: Reuse existing infrastructure; add only essential new code.

---

## Enhanced Metrics & Evaluation Support

### Text Evaluation

- **Accuracy**: Exact match, fuzzy match
- **Quality**: BLEU, ROUGE-L, METEOR
- **Semantic**: Cosine similarity (embedding-based)
- **Performance**: Latency, Time-to-First-Token (TTFT), total cost

### Image Evaluation (Vision Models)

- **Input**: Image URLs, base64-encoded images
- **Models**: GPT-4V, Gemini Pro Vision, Claude Vision
- **Metrics**: BLEU (captioning), VQA accuracy, cost per image
- **Validation**: Image format support, URL accessibility

### Audio Evaluation (Speech Models)

- **Input**: Audio URLs, local file paths
- **Models**: Whisper API, Azure Speech-to-Text, Google Speech-to-Text
- **Metrics**: Word Error Rate (WER), Character Error Rate (CER), latency
- **Validation**: Audio format support, preprocessing (normalization, resampling)

### Agent Evaluation (Multi-Turn Workflows)

- **Trace Logging**: Record all intermediate tool calls + reasoning steps
- **Step Validation**: Verify agent took expected steps to reach final output
- **Cost Tracking**: Break down cost by tool call and final response
- **Success Criteria**: Define pass/fail at each step, not just final answer

---

This project will integrate into API Dash as:

- **Evaluation Module:** Reusable backend service that can power API testing workflows
- **New Dashboard Tab:** "Model Benchmarking" tab in API Dash UI
- **Extensible Plugin System:** Community can contribute custom metrics without forking
- **API Endpoints:** Integration points for teams building on top of API Dash

By focusing on the core text evaluation engine first, we ensure production stability while keeping doors open for multimodal expansion in future releases.

---

## System Architecture

### Three-Layer Design

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│     React 18 + TypeScript + Zustand State Management       │
│  ├── Tab 1: Benchmark Configuration  (drag-drop UI)        │
│  ├── Tab 2: Real-time Monitor        (live logs, ETA)      │
│  └── Tab 3: Results Dashboard        (leaderboard, export) │
└─────────────────────┬───────────────────────────────────────┘
                      ↕ REST API + Server-Sent Events
┌─────────────────────────────────────────────────────────────┐
│                   APPLICATION LAYER                         │
│          FastAPI (Async Python) + Provider SDKs            │
│  ├── Benchmark Discovery  (lm-harness + lighteval tasks)   │
│  ├── Evaluation Orchestrator  (concurrent execution)       │
│  ├── Provider Abstraction  (OpenAI/Groq/Together/Local)    │
│  ├── Metrics Engine  (BLEU, ROUGE, plugins)                │
│  ├── SSE Streaming  (real-time progress events)            │
│  └── Cost Calculator  (per-API expense tracking)           │
└─────────────────────┬───────────────────────────────────────┘
                      ↕ File I/O + SQL queries
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│             SQLite (metadata) + Local Storage              │
│  ├── Evaluation History  (job metadata, configs, results)  │
│  ├── Cached Datasets     (CSVs, images, benchmarks)        │
│  ├── Results Archive     (metrics, latencies, cost)        │
│  └── User Preferences    (saved models, frequent configs)  │
└─────────────────────┬───────────────────────────────────────┘
                      ↕ Subprocess + library imports
┌─────────────────────────────────────────────────────────────┐
│               BENCHMARK INTEGRATION LAYER                   │
│           lm-harness (subprocess) + lighteval (library)    │
│  ├── lm-harness: CLI-based evaluation (50+ standard tasks) │
│  └── lighteval:  Library-based custom metrics              │
└─────────────────────────────────────────────────────────────┘
```

### Why This Architecture Wins

**Scalability:**

- Async concurrency → handle 100+ concurrent evaluations
- SSE streaming → no polling needed (saves ~90% backend CPU)
- SQLite + WAL mode → zero operational overhead, safe concurrent writes

**Reliability:**

- Job persistence → network failure doesn't lose evaluation data
- Retry logic → transient API errors handled automatically
- Circuit breakers → prevent cascading failures if a provider goes down

**Extensibility:**

- Plugin system → custom metrics without touching core code
- Provider abstraction → add new providers (Claude, Cohere) in under 1 hour
- Webhook support (future) → integrate with existing pipelines

---

## Phase-by-Phase Implementation Plan (15 Weeks, Core Scope ~25-30 hours/week)

### Phase 1: Backend Core & Text Evaluation (Weeks 1–5 | 85 hours)

**Focused on:** Text evaluation end-to-end. Multimodal deferred to Phase 2. Agent support in Phase 2.

#### Week 1 — FastAPI Scaffold & Simple Database (18 hours)

**Backend Setup:**

- FastAPI project structure with Poetry, async error handlers
- PostgreSQL schema (8 core tables: evaluations, results, metrics, providers, jobs, logs, cache, users)
- SQLAlchemy ORM + Alembic migrations
- Simple API key authentication (no OAuth, RBAC initially)
- Docker Compose dev environment (Python, PostgreSQL, optional Redis)

**Why simplified:** Focus on getting the API running fast. Auth can be extended post-MVP.

**Checkpoint:** `FastAPI localhost:8000` responds; PostgreSQL working; Docker Compose runs ✓

#### Week 2 — Benchmark Integration & Provider Abstraction (18 hours)

**Benchmark Integration Strategy:**

- **lm-harness** (subprocess wrapper): Launch as separate process; capture stdout for task definitions; index 50+ standard benchmarks (gsm8k, arc, hellaswag, etc.)
- **lighteval** (library calls): Import as Python package; call task functions directly; faster iteration than subprocess
- **Hybrid approach**: Use whichever is available; graceful fallback if one fails
- **Benchmark discovery**: Parse task configs → index name, description, input format → expose via `GET /api/benchmarks?search=arc`
- **Custom benchmark upload**: User provides CSV with input/reference columns; system Creates temporary benchmark task

**Multi-Provider Support:**

- **Provider Abstraction Layer**: Create base `ProviderClient` class with `evaluate(prompt, model, **kwargs)` method
- **Implementations**:
  - OpenAI handler (GPT-4, GPT-3.5-Turbo) — streaming support for TTFT measurement
  - Groq handler (Llama-3, fast inference) — for latency comparison testing
  - Together.ai handler (open-source models) — batch inference capability
  - Local Ollama (self-hosted) — for cost-free offline testing
- **Unified format**: All providers respond with `{text: str, tokens: int, latency_ms: float, cost_usd: float}`
- **Concurrency**: Dispatch requests to 4 providers simultaneously using `asyncio.gather()`

**Testing:**

- Unit test each provider mock (HTTP stubs)
- Integration test: 5 prompts → verify lm-harness discovers 50+ tasks
- Latency test: Confirm concurrent provider calls <5s for 5 requests

**Checkpoint:** `GET /api/benchmarks` returns 50+ tasks; can run eval with any provider; concurrent fan-out working ✓

#### Week 3 — Text Metrics Engine (16 hours)

**Metrics Implementation:**

- BLEU (SacreBLEU, per-sample + aggregate)
- ROUGE (all variants)
- Exact Match + Fuzzy Match
- Metrics aggregator (mean, std, percentiles)

**No advanced features yet:**

- BERTScore, METEOR deferred to extended scope
- Plugin system deferred

**Checkpoint:** 10 prompts → OpenAI → BLEU/ROUGE computed correctly ✓

#### Week 4 — SSE Streaming & Job Management (17 hours)

**Real-Time Streaming:**

- SSE endpoint `/api/evaluations/{id}/stream`
- Job manager (create, poll, cancel)
- Event serialization (progress, logs)
- Structured logging (JSON format)

**Testing & Monitoring:**

- Unit tests (75% coverage — realistic target)
- Health check endpoint
- Basic Prometheus metrics
- API documentation (OpenAPI/Swagger)

**Checkpoint:** Live SSE stream verified via curl; tests passing ✓

#### Week 5 — Cost Tracking, Load Testing & Integration (16 hours)

**Cost & Performance:**

- Token counting (accurate usage tracking)
- Cost calculator per provider
- Latency profiling
- Load test: 100 prompts × 4 models concurrently in <10 minutes

**Integration & Documentation:**

- Integration tests (upload dataset → eval → export CSV)
- End-to-end workflow documented
- Backend API fully documented (45 endpoints)
- Dev guide for contributors

**Checkpoint:** Load test passes; 75% coverage achieved; full API documented ✓

**Phase 1 Success Criteria:**

- Text evaluation working across 4 providers
- Cost accurate to the penny
- 75% test coverage (not 99% — unrealistic)
- SSE streaming production-ready
- Simple, clean codebase easy for others to extend

---

### Phase 2: Frontend Core UI (Weeks 6–9 | 95 hours)

#### Week 6 — React Scaffold + Configuration Tab (22 hours)

**Frontend Setup:**

- Vite scaffold (React 18, TypeScript, TailwindCSS, shadcn/ui)
- Zustand state management
- API client (axios + SSE listener)
- Simple authentication UI (API key input only)

**Configuration Tab:**

- Benchmark selector (searchable, 50+ options)
- Dataset uploader (CSV drag-drop)
- Model multi-selector (checkboxes)
- Parameter configurator (temperature, max_tokens)
- START button

**Checkpoint:** Config form fully functional, POSTs to `/api/evaluations` ✓

#### Week 7 — Execution Monitor (24 hours)

**Real-Time Monitoring:**

- Progress bar (0–100%, live updates)
- Live log viewer (color-coded, auto-scrolling)
- ETA display
- Per-model progress tracking
- Pause/Cancel buttons
- Network status indicator

**Visual Polish:**

- Responsive design (mobile-friendly)
- Dark mode toggle
- Smooth animations

**Checkpoint:** Live eval visible in real-time; <500ms update lag ✓

#### Week 8 — Results Dashboard (28 hours)

**Results Presentation:**

- Leaderboard (models ranked by metric)
- Interactive charts (Recharts):
  - Quality vs. Latency scatter
  - Cost comparison bar chart
  - Performance radar chart
- Metric tables (per-sample + aggregates)

**Export Functionality:**

- CSV export (all metrics)
- JSON export
- Simple PDF report (tables + basic chart)
- Share-link (read-only public URLs)

**Checkpoint:** All exports working; charts render correctly ✓

#### Week 9 — Polish, Testing & Accessibility (21 hours)

**Quality Assurance:**

- Component unit tests (Vitest, 75% coverage)
- Accessibility audit (WCAG 2.1 AA basics)
- Responsive testing (mobile, tablet, desktop)
- Lighthouse performance audit (>85 target)

**Documentation:**

- User guide with screenshots
- FAQ page
- API client examples

**Checkpoint:** 75% test coverage; Lighthouse >85; accessible ✓

**Phase 2 Success Criteria:**

- New user can configure eval in <3 minutes
- Real-time streaming with no lag
- All results exportable in 3 formats
- Mobile-responsive
- 75% frontend test coverage

---

### Phase 2B: Multimodal & Agent Support _(Stretch Goals, Weeks 10–13 | 60 hours)_

**⚠️ Conditional Scope:** Only if Phase 1 + Phase 2 finish early (by end of Week 9). If timeline slips, skip to Phase 3 production.

#### Week 10 — Image Evaluation Support (18 hours)

**Vision Model Integration:**

- OpenAI Vision API integration
- Hugging Face ViT (Vision Transformer) local option
- Image upload + scaling for model input
- Embedding extraction (cosine similarity evaluation)
- Dataset format: URI or base64 in CSV

**Frontend Support:**

- Image preview before eval
- Gallery view for results
- Similarity score visualization

**Testing:**

- Unit tests (image scaling, embedding extraction)
- Integration test with 10 sample images

**Checkpoint:** OpenAI Vision returning embeddings; cosine sim scores accurate ✓

#### Week 11 — Audio Evaluation Support (18 hours)

**Audio Model Integration:**

- Groq Whisper API (fast transcription)
- OpenAI Whisper API as fallback
- Audio file upload/streaming
- ASR evaluation (WER against reference transcripts)

**Frontend Support:**

- Audio player UI
- Transcription display
- WER score display

**Testing:**

- Unit tests (audio file handling, WER calculation)
- Integration test with 5 audio samples

**Checkpoint:** Audio transcription working; WER scores calculated ✓

#### Week 12 — Agent (Tool-Call) Evaluation (18 hours)

**Tool-Call Inspection:**

- Structured logging of agent actions
- Tool-call validation (was right tool called?)
- State machine tracking (agent flow validation)
- Trace replay UI (help debug agent behavior)

**Integration with Backend:**

- New DB table: `agent_traces` (action, tool, args, result)
- Agent session management (attach eval_id to agent run)

**Frontend Support:**

- Trace viewer (timeline of tool calls)
- Step inspector (see args/results)
- Success/failure markers

**Testing:**

- Unit tests (trace validation)
- Integration test with 3 simple agent runs

**Checkpoint:** Tool-call traces logged correctly; trace viewer functional ✓

#### Week 13 — Multimodal Integration & Polish (6 hours)

**Cross-Modality Polish:**

- Result aggregation (text + image + audio + agent in one export)
- UI consistency across modalities
- Performance tuning for fan-out queries
- Documentation for multimodal workflows

**Checkpoint:** Multimodal eval can blend providers in single session ✓

**Phase 2B Success Criteria (If Completed):**

- Image evaluation working for 2+ providers
- Audio evaluation working for 2+ providers
- Agent tool-call traces accurate and queryable
- Multimodal results exportable together
- Feature documented in README + API docs

---

### Phase 3: Production Launch & Hardening (Week 14 | 50 hours)

#### Week 14 — Final Testing, CI/CD & Launch (50 hours)

**Core Production Readiness (35 hours):**

- E2E tests (Playwright: full workflows)
- Load test: 500 concurrent requests
- Security audit (SQL injection, XSS, key handling)
- CI/CD pipeline (GitHub Actions: test + build + deploy)
- Docker & Docker Compose setup
- Render deployment (PostgreSQL + web service)
- Sentry error monitoring + health checks
- Database backup verification

**Documentation & Launch (15 hours):**

- Complete README + quick start guide
- API documentation (45+ endpoints)
- CONTRIBUTING guide for community
- CHANGELOG + deployment guide
- Blog post announcement
- GitHub release notes
- Discord/community launch

**Checkpoint:** Live at `api-dash-eval.render.com`; stable for 24h+; docs published ✓

**Phase 3 Success Criteria:**

- 78% overall test coverage
- Zero critical security issues
- Production stable + monitoring active
- Full documentation published
- Community ready to engage
- All users can self-serve (no manual setup required)

---

## Post-GSoC Roadmap (Future Community Phases)

These features are intentionally deferred to post-GSoC community-driven development:

**Phase 4: Advanced Tooling (Future)**

- Plugin system (custom evaluation functions)
- Advanced benchmarks (HELM, OpenCompass)
- Multi-tenant RBAC
- OAuth authentication

## Technology Stack

### Backend

| Component       | Technology                              | Rationale                                               |
| --------------- | --------------------------------------- | ------------------------------------------------------- |
| Framework       | FastAPI                                 | Async-native, SSE support, auto-OpenAPI docs            |
| Runtime         | Python 3.11+                            | ML ecosystem, benchmark tool compatibility              |
| Async           | asyncio + concurrent.futures            | Parallel model evaluation                               |
| Database        | PostgreSQL 15 (with connection pooling) | Scalable, ACID-compliant, handles large result sets     |
| Caching         | Redis                                   | High-performance caching for benchmarks and results     |
| Streaming       | Server-Sent Events (SSE)                | Simpler than WebSocket, perfect for unidirectional logs |
| Benchmark Tools | lm-harness, lighteval                   | Industry-standard, actively maintained                  |
| Provider SDKs   | openai, groq, together                  | Official libraries for API calls                        |
| Metrics         | nltk, rouge_score, bert-score           | Standard NLP metric libraries                           |
| Storage         | S3 (images/voice) + Local filesystem    | Scalable cloud storage ready                            |
| Migrations      | Alembic                                 | Version-controlled schema changes                       |

### Frontend

| Component        | Technology                     | Rationale                                    |
| ---------------- | ------------------------------ | -------------------------------------------- |
| Framework        | React 18+                      | Component-based, performance, huge ecosystem |
| Language         | TypeScript                     | Compile-time type safety                     |
| State Management | Zustand                        | 90% less boilerplate than Redux, 3KB bundle  |
| UI Components    | shadcn/ui + Tailwind CSS       | Production-ready, accessible, themeable      |
| Charts           | Recharts                       | React-native, responsive charting            |
| HTTP Client      | axios + SSE client             | Promise-based + event stream support         |
| Build Tool       | Vite                           | Fast HMR, small bundle                       |
| Testing          | Vitest + React Testing Library | Fast, React-focused                          |

### Architecture Decision: Frontend Technology Choice

**Why React (Web) Instead of Flutter (Native)?**

This proposal uses **web-based React/Zustand** rather than Flutter-native, but the architecture is intentionally backend-agnostic to support both:

- **Web-first MVP advantage**: Flutter's Dart Isolates are excellent for concurrent evaluation, but require Dart expertise. React allows leveraging existing JavaScript ecosystem.
- **Backend-optional design**: The core evaluation engine runs on FastAPI/Python. Text evaluation can execute entirely serverless/async in the UI if needed; multimodal naturally async to backend.
- **Community alignment**: API Dash's primary community uses TypeScript/React; proposal integrates as web tab within the existing ecosystem. A pure-Flutter fork would benefit desktop users post-launch.
- **Future path**: Phase 2B (multimodal/agents) showcases complex backend orchestration; Phase 4 (post-GSoC) can include native Flutter evaluation client if community interest exists (Dart/lm-harness is mature).

**Reality Check**: Amogha Karanth's competing proposal goes pure Dart/Flutter ("zero external dependencies for core text eval"). This is valid and arguably bettter architecturally, but requires Dart/Flutter fluency. Mohid's React choice trades architecturally-preferred for **pragmatically-deliverable-by-deadline**.

### Infrastructure

| Component              | Technology                  | Rationale                                |
| ---------------------- | --------------------------- | ---------------------------------------- |
| Containerization       | Docker (multi-stage)        | Reproducible deployment, <700MB image    |
| CI/CD                  | GitHub Actions              | Native GitHub integration, free tier     |
| Database Service       | Render PostgreSQL / Railway | Managed database hosting                 |
| Cache Service          | Redis Cloud / Upstash       | Managed Redis without ops overhead       |
| Deployment             | Render / Railway            | Easy deployment, free tier available     |
| Monitoring             | Prometheus + Grafana        | Production-grade monitoring and alerting |
| Error Tracking         | Sentry                      | Real-time error tracking and debugging   |
| Performance Monitoring | Built-in APM                | Response time profiling and optimization |

### PostgreSQL vs. SQLite for This Project

PostgreSQL is chosen for this large 350-hour project because:

- **Concurrent connections:** Handles 100+ simultaneous evaluations with connection pooling
- **Advanced querying:** Complex analytical queries for results comparison and trends
- **JSONB support:** Native JSON storage for flexible result schemas
- **Full-text search:** Search across evaluation results and logs
- **Scalability:** Can migrate to managed cloud services (Render, Railway, AWS RDS)
- **Horizontal scaling:** Read replicas for high-traffic analytics queries

SQLite would struggle with concurrent modifications and high-volume queries. PostgreSQL with connection pooling provides reliable concurrent access.

---

## 14-Week Intensive Delivery Schedule (350 hours - Competitive & Realistic)

| Week      | Phase   | Key Milestone                      | Verification                           | Est. Hours |
| --------- | ------- | ---------------------------------- | -------------------------------------- | ---------- |
| 1         | 1       | FastAPI + PostgreSQL scaffold      | `localhost:8000`; DB working           | 18         |
| 2         | 1       | Benchmark integration + providers  | 50+ benchmarks; 4 providers working    | 18         |
| 3         | 1       | Text metrics engine                | BLEU/ROUGE computed correctly          | 16         |
| 4         | 1       | SSE streaming + job manager        | Live stream via curl; tests passing    | 17         |
| 5         | 1       | Cost tracking + integration tests  | Load test: 100 items × 4 models <10min | 16         |
| 6         | 2       | React scaffold + config UI         | Config form POSTs to backend           | 22         |
| 7         | 2       | Execution monitor                  | Live progress bar; <500ms lag          | 24         |
| 8         | 2       | Results dashboard + exports        | All exports (CSV/JSON/PDF) work        | 28         |
| 9         | 2       | Polish + accessibility + testing   | 75% coverage; Lighthouse >85; mobile   | 21         |
| 10        | 3       | Integration testing + optimization | E2E tests pass; 1K concurrent requests | 18         |
| 11        | 3       | Security audit + documentation     | 0 critical issues; all docs published  | 16         |
| 12        | 3       | CI/CD pipeline + Docker            | Push to main → auto-tests → build      | 18         |
| 13        | 3       | Deployment + monitoring            | Live at api-dash-eval.render.com       | 18         |
| 14        | 3       | Documentation + launch prep        | All docs complete; ready to announce   | 15         |
| 15        | 3       | Final testing + community launch   | 48h monitoring; community engaged      | 15         |
| **Total** | **All** | **Text Eval Platform Live**        | **Core scope delivered; stable**       | **350**    |

**Stretch Goals (if time permits):** Image evaluation (Week 16+), plugin system, advanced analytics.

---

## Success Metrics (Realistic, Text-Focused)

| Metric                  | Target                       | How We Verify                                    |
| ----------------------- | ---------------------------- | ------------------------------------------------ |
| API Response Time (p99) | <300ms                       | Load test with 100 concurrent requests           |
| Text Eval Accuracy      | Matches reference BLEU/ROUGE | Compare vs. standard NLP libraries               |
| Multi-Provider Support  | 4 providers working          | Integration test: OpenAI, Groq, Together, Ollama |
| Test Coverage           | 75% (realistic for GSoC)     | Coverage report in CI/CD                         |
| UI Responsiveness       | Dashboard loads in <2s       | Lighthouse or manual timing                      |
| Dataset Upload          | Accepts CSV + JSON formats   | 5+ test files of various sizes                   |
| Export Functionality    | CSV + JSON working           | File integrity checks on exports                 |
| Documentation           | Covers all major features    | README + API docs + user guide                   |
| User Walkthrough        | New user evaluates in <5min  | Manual QA test                                   |
| Security                | Zero critical/high vulns     | Manual + automated scanning                      |

**What's NOT a success metric:**

- 99% test coverage (unrealistic for GSoC)
- Image/voice/agent support (in stretch goals, not core)
- Production-grade SLA (this is academic work)
- 10K+ concurrent users (targeting small team workflows)

**Stretch Goal Metrics** (only if completed):

- Image eval: 2+ vision model providers working
- Voice eval: ASR transcription from 1+ provider

**What defines success:** Developers can drop in a CSV, click "Evaluate", and see which model is best. No code required. Clear results.

---

## Why I'm Uniquely Qualified

### Relevant Production Experience

**1. LLM Integration & Multi-Provider Systems**
Built AETERNA (Autonomous Alpha Engine) — a distributed event-driven architecture using RabbitMQ, Redis, PostgreSQL, and Celery for AI-powered crypto intelligence. Designed the evaluation pipeline for multi-source LLM scoring and alert routing. This directly applies to Weeks 1-5 (provider orchestration, async job handling, real-time event streaming).

**2. FastAPI + Async Backend Architecture**
Built production FastAPI backends for AI-Powered Content Platform and CareerGPT. Experience with async/await, WebSocket handling, and real-time streaming. Deployed on Render with GitHub Actions CI/CD. Comfortable with the exact tech stack needed for this proposal.

**3. React Dashboards + Real-Time UI**
Built multiple React 18 frontends (CareerGPT dashboard, content platform UI) with Zustand state management and real-time updates. Understand responsive design and user experience for evaluation workflows.

**4. Testing & Deployment**
All projects use pytest, Vitest, Docker, and GitHub Actions CI/CD. Familiar with achieving 75-80% test coverage on production code. Have successfully deployed multiple systems to Render.

**5. Multi-Agent AI Systems**
Built CareerGPT using LangGraph with dynamic routing across specialized agents. Understand complex AI orchestration, RAG pipelines (ERP RAG Assistant), and LLM integration workflows.

**Why this matters for this proposal:** I've built the exact components needed (FastAPI backend, React UI, async job processing, provider coordination). This isn't theoretical — I've shipped similar systems on tight timelines. The proposal is about integrating proven patterns, not inventing new technology.

---

## Risk Mitigation (GSoC-Focused)

| Risk                               | Probability | Impact | Mitigation                                         | Contingency                                         |
| ---------------------------------- | ----------- | ------ | -------------------------------------------------- | --------------------------------------------------- |
| Scope creep during development     | 40%         | High   | Stick to Core vs Extended breakdown; cut stretch   | Drop stretch goals immediately if delays accumulate |
| LLM API rate limits hit            | 25%         | Medium | Request quota increase Week 1; Ollama fallback     | Test with Ollama locally; reduce concurrent models  |
| lm-harness integration issues      | 15%         | Medium | Spike in Week 1; build subprocess wrapper early    | Fall back to lighteval + custom benchmarks          |
| Frontend complexity underestimated | 30%         | Medium | Prototype SSE client in Week 6 independently       | Skip PDF export; keep CSV + JSON only               |
| Database performance at scale      | 10%         | Low    | Load test in Week 5 with realistic data            | Add Redis caching; upgrade to Render premium plan   |
| Deployment issues                  | 5%          | Low    | Test Docker locally in Week 12; have Railway ready | Switch to Railway if Render fails                   |
| Personal time constraints          | 10%         | High   | Daily standup tracking; escalate early to mentor   | Request 1-week extension; hand off documentation    |

**Contingency Budget:** 15-20% of timeline (≈25-30 hours) reserved for unknowns.

**Key Principle:** **Core scope is guaranteed. Stretch goals are optional.** If we hit Week 10 and have slippage, we immediately cut image evaluation, plugins, and voice support — keeping text evaluation + UI rock-solid.

---

## Example Workflows

### Workflow 1: Compare 3 LLM Providers

```
1. Alice (ML Manager) logs into api-dash-eval.render.com
2. Clicks "+ New Evaluation"
3. Selects benchmark: "GLUE-RTE" (50 samples)
4. Selects models: [GPT-4, Llama-3-70B, GPT-3.5-Turbo]
5. Sets temperature: 0.1 (deterministic)
6. Clicks START

[Dashboard shows live progress — no black box waiting]
[5 minutes later...]

Results:
| Model         | BLEU | ROUGE | Latency | Cost    |
|---------------|------|-------|---------|---------|
| GPT-4         | 92.3 | 85.1  | 120ms   | $0.032  |
| Llama-3-70B   | 88.1 | 81.8  | 45ms    | $0.001  |
| GPT-3.5-Turbo | 85.2 | 78.9  | 60ms    | $0.001  |

Insight: "Llama-3 is 50% cheaper and nearly as good. Ship it."
Exports PDF for stakeholder meeting.

Time saved vs. building this manually: ~20 hours
```

### Workflow 2: Add a Custom Domain Metric

```python
# Bob uploads this plugin via the web UI:

def evaluate_code_correctness(generated, reference):
    """Custom metric: does generated code produce same output as reference?"""
    try:
        exec(generated)
        exec(reference)
        return {"pass": True, "score": 1.0}
    except:
        return {"pass": False, "score": 0.0}
```

```
1. Upload plugin via web UI
2. Select it in evaluation config
3. Run evaluation
4. Results include new "code_correctness" metric alongside BLEU/ROUGE

Time saved vs. forking lm-harness: ~8 hours
```

---

## Code Structure

```
api-dash-eval/
├── backend/
│   ├── main.py                      # FastAPI app entry
│   ├── config.py                    # Settings, env, paths
│   ├── dependencies.py              # DI: database, logger
│   ├── api/
│   │   ├── benchmarks.py            # GET /api/benchmarks
│   │   ├── evaluations.py           # POST, GET /api/evaluations
│   │   ├── results.py               # GET /api/results/{id}
│   │   ├── datasets.py              # POST /api/datasets (upload)
│   │   └── models.py                # GET /api/models (providers)
│   ├── core/
│   │   ├── benchmark_runner.py      # lm-harness orchestration
│   │   ├── multimodal_adapter.py    # Text / image / voice adapters
│   │   ├── provider_orchestrator.py # OpenAI / Groq / etc. handlers
│   │   ├── metrics_engine.py        # BLEU, ROUGE compute
│   │   ├── plugin_system.py         # Custom metric plugins
│   │   └── sse_streaming.py         # Event streaming
│   ├── models/
│   │   ├── database.py              # SQLAlchemy ORM
│   │   ├── schemas.py               # Pydantic models
│   │   └── enums.py                 # EvalStatus, constants
│   ├── utils/
│   │   ├── logger.py
│   │   ├── cost_calculator.py
│   │   └── retry_logic.py
│   └── tests/
│       ├── test_benchmarks.py
│       ├── test_providers.py
│       ├── test_metrics.py
│       ├── test_streaming.py
│       ├── integration_tests.py
│       └── conftest.py
├── frontend/
│   ├── src/
│   │   ├── pages/
│   │   │   └── DashboardPage.tsx    # Main 3-tab interface
│   │   ├── components/
│   │   │   ├── BenchmarkSelector.tsx
│   │   │   ├── DatasetUploader.tsx
│   │   │   ├── ModelConfigurator.tsx
│   │   │   ├── ExecutionMonitor.tsx
│   │   │   ├── ProgressBar.tsx
│   │   │   ├── LiveLogViewer.tsx
│   │   │   ├── ResultsLeaderboard.tsx
│   │   │   ├── ComparisonCharts.tsx
│   │   │   └── ExportButton.tsx
│   │   ├── hooks/
│   │   │   ├── useEvaluations.ts
│   │   │   └── useSSE.ts
│   │   ├── stores/
│   │   │   └── evaluationStore.ts   # Zustand state
│   │   └── types/
│   │       └── index.ts
│   ├── vite.config.ts
│   └── package.json
├── docker/
│   ├── Dockerfile                   # Multi-stage build
│   └── docker-compose.yml
├── .github/
│   └── workflows/
│       ├── test.yml
│       ├── build.yml
│       └── deploy.yml
├── docs/
│   ├── README.md
│   ├── USER_GUIDE.md
│   ├── API.md
│   ├── ARCHITECTURE.md
│   └── PLUGINS.md
└── requirements.txt
```

---

## Post-GSoC Commitment

### Months 1–3: Stabilization (Summer Post-GSoC)

- Monitor live instance for bugs (24h response time on issues)
- Gather feedback from early adopters (Discord community)
- Security updates and provider integration patches
- Performance optimization based on real-world usage patterns
- Active support via GitHub issues and Discord
- First monthly office hours and community meetup

### Months 4–6: Expansion & Advanced Features

- **Agent Evaluation:** Extend framework for autonomous AI agent benchmarking
- **Advanced Analytics:** Trend detection, A/B test comparison, outlier quality flagging
- **Distributed Evaluation:** Scale to 100K+ concurrent jobs on Kubernetes (optional)
- **LLM Judge Integration:** Use LLM-as-scorer for subjective quality metrics
- **Community Plugin Marketplace:** Curated repository of community-contributed metrics

### Months 6+ & Beyond: Community-Driven Growth

- Monthly Discord office hours (every other Thursday 10am UTC)
- Mentor 5+ new contributors (pair programming sessions)
- Blog series: _"Production Patterns in FastAPI"_, _"Building LLM Evaluation Pipelines"_, _"Open Source Sustainability"_
- Conference talk submissions (NeurIPS, PyData, PyCon)
- Integration partnerships (Weights & Biases, Hugging Face Hub)
- Roadmap co-governance with community input (GitHub Discussions)

**Long-term Vision (12+ months):** API Dash Evaluation Framework becomes the de-facto standard for AI model benchmarking in the open-source ecosystem — powering 5000+ teams, with 200+ community-contributed metrics, and partnerships with major LLM providers for native integration.

---

## Communication Plan

### Weekly Sync (Friday 22:00 UTC / 3:00 AM PKT Saturday)

- **5 min:** Live demo — show what was built this week (always have 2 working features minimum)
- **15 min:** Discuss blockers and design decisions
- **7 min:** Preview next week's tasks and dependencies
- **3 min:** Action items, follow-ups, and any upstream feedback

### Daily Async Updates

- Slack status: on track / slight delay / blocker (daily end-of-day message)
- GitHub commits: Structured commit messages with references to issues/milestones
- PR reviews within 24 hours
- Issue responses within 12 hours (during active development weeks)

---


### Midterm Deliverables

By the midterm evaluation (Week 8 - End of Phase 2), the following will be **completed and working**:

- **Dataset Ingestion:** CSV/JSON upload functional, validation working
- **Multi-Provider Text Evaluation:** Pipeline operational for OpenAI, Groq, Together.ai, Ollama
- **Core Metrics:** BLEU, ROUGE-L, Exact Match, F1 score all computed correctly
- **Execution Interface:** Fully functional CLI or minimal web UI for evaluation runs
- **Results Storage:** PostgreSQL schema in place, results persisting correctly
- **Real-Time Streaming:** SSE or polling mechanism for live progress updates
- **Testing:** 75% code coverage on backend, no critical bugs
- **Documentation:** API endpoints documented, user guide with examples

**Mentor Assessment Focus:** Is the core evaluation pipeline production-ready? Can a new user realistically run an evaluation end-to-end?

### Final Evaluation (Week 15 - End of Project)

**Expected Status:**

- All 3 phases complete
- Core scope fully delivered
- Production deployment verified

**Deliverables for Review:**

- Text-based multi-provider evaluation platform
- React dashboard (3 tabs: config, monitor, results)
- CSV/JSON/PDF export working
- Real production instance at `api-dash-eval.render.com`
- 75-80% test coverage
- Complete documentation
- CI/CD pipeline automated

**Pass Criteria:** All core features working, live & stable, well-documented, extendable

### If Scope Slips

**Priority Order (Drop bottom items first):**

1. Text evaluation + multi-provider (non-negotiable)
2. Real-time UI + results dashboard
3. PDF export (CSV/JSON kept)
4. Advanced analytics (historical trends)
5. Stretch goals (image/voice/plugins)

**Contingency Plan:** If Week 10-12 shows slippage, reduce frontend polish and focus on stable core delivery.

---

## Escalation Path

| Issue Type      | Response Time | Channel           |
| --------------- | ------------- | ----------------- |
| Quick question  | <1 hour       | Slack             |
| Design decision | 24 hours      | GitHub Discussion |
| Blocker         | Same day      | Discord           |
| Critical bug    | Immediate     | Slack + Discord   |

---

## Final Statement

This proposal is a realistic, well-scoped 14-week plan to bring multi-provider text evaluation directly into API Dash. Core scope is text evaluation (guaranteed); image/voice are optional stretch goals. Every phase has weekly checkpoints and contingency plans for scope creep.

**Why you should fund this:** I've shipped LLM evaluation systems at scale, integrated complex async backends, and deployed to production. I understand the technical challenges and have proven I can deliver working code within tight timelines. I will ship core text evaluation on time, fully tested, and documented for the community to extend.

---

**Applicant:** Mohid Naghman  
**GitHub:** https://github.com/MohidNaghman1  
**LinkedIn:** https://www.linkedin.com/in/mohid-naghman/  
**Email:** mohid.naghman@email.com  
**Date:** March 28, 2026
