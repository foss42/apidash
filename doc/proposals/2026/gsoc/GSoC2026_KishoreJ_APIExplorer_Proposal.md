# Google Summer of Code 2026 — Project Proposal
## API Explorer: Curated API Library for API Dash
*An automated ingestion, enrichment & discovery pipeline for API Dash*

| Field | Detail |
|---|---|
| **Applicant** | Kishore J |
| **Email** | kishorelinganj@gmail.com |
| **GitHub** | github.com/KishoreJegan |
| **LinkedIn** | linkedin.com/in/kishorejegan |
| **Timezone** | IST (UTC +5:30) |
| **University** | Kongunadu Arts and Science College, Coimbatore |
| **Degree** | B.Sc CS with Data Analytics (Final Year) |
| **Project Size** | Medium (90 hrs) |

---

## Synopsis

Every developer who integrates a third-party API wastes time on setup that thousands of others have already done: hunting for the right endpoint URL, figuring out authentication, constructing sample payloads from scratch. This proposal introduces the API Explorer — a curated, searchable library of publicly available APIs built directly into API Dash. The core deliverable is a fully automated backend pipeline that ingests OpenAPI specifications and HTML documentation from public registries (APIs.guru, RapidAPI, GitHub) and user submissions, normalises them into a unified schema, enriches them using an LLM-assisted engine, scores them for completeness and quality, and stores them in a searchable catalog. Developers get one-click access to pre-configured request templates — complete with authentication details, sample payloads, and expected responses — reducing API onboarding from hours to seconds. The system is built for production scale: async processing via a message queue, Redis caching, Elasticsearch-backed search, community ratings and reviews, and a structured moderation pipeline with full audit logs.

---

## 1. Personal Information

| Field | Detail |
|---|---|
| **Full Name** | Kishore J |
| **Email** | kishorelinganj@gmail.com |
| **GitHub** | github.com/KishoreJegan |
| **LinkedIn** | linkedin.com/in/kishorejegan |
| **University** | Kongunadu Arts and Science College, Coimbatore – 641029, Tamil Nadu, India |
| **Degree & Year** | B.Sc Computer Science with Data Analytics — Final Year (3rd Year of 3) |
| **Expected Graduation** | May 2026 |
| **Country of Residence** | India |
| **Timezone** | IST (Asia/Kolkata) — UTC +5:30 |
| **Mentors** | Ankit Mahato (GSoC 2013) · Ashita Prasad (GDE) · Ragul Raj M (GSoC 2024) · Manas Hejmadi (GSoC 2026) |
| **Organization** | API Dash (foss42) |

---

## 2. About Me (Biographical Information)

I am Kishore J, a final-year B.Sc Computer Science with Data Analytics student at Kongunadu Arts and Science College, Coimbatore. My degree combines classical computer science fundamentals with a strong emphasis on data pipelines, analytics, and AI integration — a background that maps directly onto the technical requirements of the API Explorer project.

I am a self-driven builder. Outside of coursework I have independently built two complete, production-grade Python projects and one AI-powered Chrome extension — each of which demonstrates a specific skill this project demands. I have never contributed to a large open-source project before, but I am applying because the API Explorer is a problem I personally understand: I have wasted hours on manual API setup and I want to build the thing that eliminates that work for everyone.

### Relevant Projects — with direct mapping to this proposal

#### Project 1: AI-Powered Nifty Option Chain Analyser (Chrome Extension)

**Tech stack:** Python · Playwright · Cohere API · OpenPyXL · Excel automation

**What it does:** Uses Playwright to programmatically open the NSE Option Chain in Chrome and scrape live stock price data for positive and negative movers. Data is written to three Excel sheets: (1) a live snapshot updated every 3 minutes via a scheduled trigger, (2) a full history log for research, and (3) a 15-minute time-based analysis sheet that aggregates 5 cycles of 3-minute data to identify whether positive or negative buyers are dominant — giving the trader a concrete buy/sell conclusion without manual chart reading.

**AI chat layer:** Integrated the Cohere API as an inline chat assistant inside the extension so traders can ask market questions without switching tabs — reducing cognitive overhead during live trading.

**Relevance to API Explorer:** This project is a direct proof of the three core skills the API Explorer pipeline requires — web scraping with Playwright (the HTML Scraper stage), structured data normalisation into a defined output format (the Normalizer stage), and third-party API integration (the Enrichment Engine stage). I built all of this independently, from scratch.

#### Project 2: Local AI Agent (Terminal Chatbot)

**Tech stack:** Python · LangChain · LangGraph · DuckDuckGo Search API · Groq API · uv package manager

**What it does:** A fully local AI agent that runs in the terminal, uses LangGraph for multi-step reasoning chains, and calls DuckDuckGo search as a live data tool via LangChain's tool-calling interface. Powered by Groq API for fast inference.

**Relevance to API Explorer:** This project demonstrates that I can work with LangChain's API orchestration layer and design multi-step LLM pipelines — directly applicable to the Enrichment Engine which chains LLM calls for summarisation, tagging, and security flag detection.

#### Project 3: NLP Chatbot for Website (Google Dialogflow)

**Tech stack:** Python · Google Dialogflow · NLP intent classification · webhook integration

**What it does:** An NLP-based conversational chatbot embedded in a website that uses Dialogflow for intent recognition and a Python webhook backend to handle dynamic responses.

**Relevance to API Explorer:** Demonstrates practical experience with external API integration, webhook handling, and building systems that connect a user-facing interface to a backend processing layer — the same pattern used in the Submission Service and Notification Service.

### Academic Background

Kongunadu Arts and Science College, Coimbatore — B.Sc Computer Science with Data Analytics, 2022–2026. Relevant coursework: Data Structures & Algorithms, Database Systems, Python Programming, Data Analytics & Visualisation, Machine Learning Fundamentals, Computer Networks, Software Engineering. The Data Analytics specialisation has given me hands-on experience with structured data pipelines, quality scoring, and data normalisation — skills I will apply directly in the Completeness Scorer and Normalizer stages of this project.

### First-time GSoC Contributor — why that is not a disadvantage here

I am applying to GSoC for the first time. I want to address this directly rather than hope it goes unnoticed. What I bring instead of a contribution history is: a final-year student with no further academic commitments after May 7th, three independently built projects that directly demonstrate the required skills, and a project idea I am personally motivated by because I have experienced the problem it solves. I am available full-time for the entire GSoC period with zero competing obligations. I plan to submit a first contribution to the API Dash repository before the proposal deadline — targeting the documentation or a good-first-issue labelled item — to demonstrate that I can navigate the codebase and the contribution workflow.

---

## 3. Benefits to the Community

### For API Dash

The API Explorer is the single feature most likely to move API Dash from a power-user testing tool into a mainstream discovery platform. Postman's API Network lists over 100,000 APIs and is one of Postman's primary user acquisition channels — people come for a specific API and adopt the tool in the process. API Dash currently has no equivalent. This project closes that gap and gives the project a defensible, unique value proposition against Postman and Insomnia in the open-source space.

### For the developer community

Every developer who integrates a third-party API performs setup work that has already been done by thousands of others. The API Explorer eliminates this duplication at the ecosystem level. Because it is built on open standards (OpenAPI / OAS), stores everything in a publicly accessible catalog, and accepts community contributions via standard GitHub workflows, it produces a reusable, self-improving resource that benefits any developer — not just API Dash users.

### For open source and Google

The enrichment pipeline, unified normalisation schema, and quality scoring rubric produced by this project will all be open source and reusable by any project that needs to ingest and index API documentation. Google's sponsorship funds infrastructure that strengthens open standards (OpenAPI) and a cross-platform tool used by developers on all major operating systems.

### Measurable outcomes

- Thousands of pre-configured API templates available on first launch — zero manual setup for common APIs
- Any developer can improve an API entry via a GitHub PR — no special access required
- Long-term: a community-maintained living catalog that grows and self-corrects over time

---

## 4. Related Work

| Product | What it does | Why this project is different |
|---|---|---|
| **Postman API Network** | 100k+ API catalog, browseable inside Postman, community-maintained. | Proprietary and cloud-locked. API Dash is open source, offline-capable, and requires no account. The Explorer adds an automated enrichment pipeline that Postman does not have — listings are manually submitted there. |
| **RapidAPI Hub** | Commercial API marketplace with subscriptions and monetisation. | Built around commerce, not developer tooling. No automation pipeline. This project auto-ingests and enriches specs for higher metadata quality. |
| **SwaggerHub** | Collaborative OpenAPI design platform with a hosted spec registry. | Targets API producers (people building APIs). This project targets API consumers (developers integrating APIs). Fundamentally different use case. |
| **APIs.guru** | Open registry of 3,000+ OpenAPI specs on GitHub. | A raw data source, not a discovery tool. No search, no quality scoring, no request templates, no testing tool integration. This project uses APIs.guru as one ingestion source and adds all the missing layers. |
| **Hoppscotch Collections** | Manually curated request collections for Hoppscotch. | No automated enrichment, no quality scoring, no community ratings, no search. A flat static list — not a living pipeline. |

No existing open-source tool combines automated multi-source ingestion, LLM-assisted enrichment and quality scoring, direct import into a local API testing workspace, and community contribution via GitHub. This proposal delivers all four.

---

## 5. Understanding the Project

I have studied the API Dash repository (github.com/foss42/apidash) and the project idea in detail. My understanding of what needs to be built is as follows.

### 5.1 The backend automation pipeline

The pipeline is the core engineering challenge. Raw API documentation exists in multiple formats across the internet. The pipeline must ingest all of them, resolve inconsistencies, and produce structured, enriched, searchable catalog entries. Six stages:

- **Ingestion** — scheduled crawlers for APIs.guru and RapidAPI, webhook-triggered GitHub PR processing for community contributions, and manual upload via the Submission UI.
- **Parsing** — a format router that detects the input type (OpenAPI 2.0 YAML, OAS 3.x JSON, raw HTML documentation) and delegates to the appropriate parser module.
- **Normalisation** — maps the parsed output from all sources into one internal unified schema.
- **Enrichment** — an LLM-backed engine (using LangChain) generates summaries, detects auth type, produces request examples, auto-assigns category tags, and flags security concerns such as HTTP URLs or missing authentication.
- **Scoring** — a completeness scorer evaluates each API record against a weighted rubric. High-scoring APIs are auto-approved; low-scoring ones enter a human review queue with detailed feedback.
- **Indexing** — writes the final enriched record to PostgreSQL as the source of truth, indexes it into Elasticsearch for search, and caches hot entries in Redis.

### 5.2 The frontend discovery experience

Developers browse a categorised library, search by keyword or filter (auth type, category, quality score), read inline API documentation, and import any endpoint directly into their API Dash workspace as a pre-filled request template. Community features include star ratings, text reviews, entry flagging, and GitHub-based spec contributions.

### 5.3 Key architectural decisions

- **Why Kafka/BullMQ over a simple queue:** The pipeline has fan-out behaviour — one submitted API must trigger the parser, notifier, and audit logger simultaneously. A topic-based message queue handles this natively. BullMQ + Redis is the lighter alternative for smaller deployments.
- **Why Elasticsearch alongside PostgreSQL:** PostgreSQL full-text search degrades beyond ~100k records with combined filters. Elasticsearch is purpose-built for faceted search and supports autocomplete — a feature developers expect from a discovery tool.
- **Why LLM enrichment over rule-based tagging:** Rule-based systems fail on unusual category names, non-standard auth schemes, and sparse descriptions. LLM enrichment with cached results produces far better metadata quality at acceptable cost.
- **Why Redis for rate limiting:** In-memory per-instance counters are inaccurate in a multi-instance deployment. Redis provides a single shared counter store across all workers.

### 5.4 Codebase observations

- `lib/providers/` contains the Riverpod state management for API collection state. The Explorer UI will extend `RequestModel` and `APIType` to include a `source` field distinguishing explorer-imported vs. user-created requests.
- `lib/importer/` handles cURL and Postman collection imports. The API Explorer import-to-workspace flow will follow the same interface pattern, specifically the `APIRequestModel` structure.
- `lib/services/` contains the HTTP client. Pre-filled templates from the Explorer will populate the same model fields (method, url, headers, body) that the existing request runner already consumes — no changes to the core request execution path.
- There is no category taxonomy defined in the codebase yet. I plan to propose a standard taxonomy (AI, Finance, Weather, Maps, Social, Payments, Communication, Developer Tools, Identity, IoT, Other) as a first PR during community bonding.

---

## 6. Technical Design

### System architecture — seven layers

- **External Sources** — GitHub, APIs.guru, RapidAPI, SwaggerHub, and direct user uploads via the Submission UI.
- **Gateway & Security** — API Gateway (Kong) for routing and TLS termination. Auth Service for OAuth2 + JWT. Rate Limiter (Redis-backed sliding window). WAF with Cloudflare OWASP ruleset.
- **Core Services** — API Explorer UI, Submission Service, Discovery Engine (scheduler/crawler), Community Service (ratings/reviews), Notification Service (email/webhook/in-app).
- **Async Event Bus** — Kafka or BullMQ + Redis. Events: `api.submitted`, `api.crawled`, `api.enriched`, `api.approved`. Dead Letter Queue with exponential backoff. Cron scheduler for nightly re-crawl jobs.
- **Processing Pipeline** — six stateless worker services: OpenAPI Parser, HTML Scraper, Normalizer, Enrichment Engine, Completeness Scorer, Moderation Engine.
- **Data Layer** — PostgreSQL (canonical catalog), Elasticsearch (search index), Redis (cache + rate limits), S3/Cloudflare R2 (raw spec files and templates), Cloudflare CDN (frontend and static assets at edge).
- **Observability** — Prometheus + Grafana for metrics, OpenTelemetry + Jaeger for distributed tracing, Loki for structured logs, Sentry for error tracking.

### Technology stack

| Layer | Technology | Justification |
|---|---|---|
| **Pipeline workers** | Python 3.11+ | Primary language. Mature async ecosystem (asyncio, aiohttp); best library support for scraping and OpenAPI parsing. |
| **API layer** | Node.js + TypeScript | Consistent with existing API Dash tooling; strong typing prevents runtime schema errors. |
| **OpenAPI parsing** | swagger-parser, @apidevtools/swagger-parser | Handles $ref resolution, circular schemas, all OAS versions. Battle-tested. |
| **HTML scraping** | Playwright + Cheerio | Direct production experience with Playwright from the Nifty extension. Handles JS-rendered pages. |
| **LLM enrichment** | LangChain + Groq/Cohere API | Used both Cohere and LangChain in production projects. Chains multiple LLM calls with tool use for enrichment steps. |
| **Message queue** | Kafka / BullMQ + Redis | Kafka for scale; BullMQ as a lighter fallback. Decouples all pipeline stages. |
| **Primary database** | PostgreSQL 15 | ACID compliance, JSONB for flexible fields, versioned records. |
| **Search index** | Elasticsearch 8.x | Native faceted filters, autocomplete, relevance scoring. |
| **Cache** | Redis 7 | Sub-millisecond reads; shared counter store for rate limiting across instances. |
| **Object store** | AWS S3 / Cloudflare R2 | Raw spec files and template assets with CDN delivery. |
| **Testing** | pytest, Jest, Playwright E2E | Full test pyramid: unit → integration → end-to-end. |
| **CI/CD** | GitHub Actions | Native to the existing API Dash repo. |

### API Catalog database schema

- `apis` — id, source, name, description, base_url, auth_type, category_tags[], quality_score, status, version, created_at, updated_at
- `endpoints` — id, api_id, method, path, summary, parameters (JSONB), request_body (JSONB), responses (JSONB)
- `templates` — id, endpoint_id, name, sample_headers (JSONB), sample_body (JSONB), expected_response (JSONB)
- `reviews` — id, api_id, user_id, rating (1–5), body, created_at
- `moderation_log` — id, api_id, action, reviewer, reason, timestamp (full audit trail)

---

## 7. Deliverables

| Milestone | Period | Eval | Deliverables |
|---|---|---|---|
| **M1** | Week 1–4 | Midterm prep | REQUIRED: API Catalog PostgreSQL schema, migration scripts, versioned records, CRUD REST API. REQUIRED: OpenAPI Parser — Swagger 2.0, OAS 3.0, OAS 3.1 — with unit tests covering 30+ edge cases. REQUIRED: Category taxonomy PR to main repo. |
| **M2** | Week 5–8 | Midterm | REQUIRED: HTML Scraper (Playwright + Cheerio). REQUIRED: Normalizer. REQUIRED: Enrichment Engine (LangChain + LLM API). REQUIRED: Async pipeline with Kafka/BullMQ and scheduler. |
| **M3** | Week 9–11 | Pre-final | REQUIRED: Completeness Scorer. REQUIRED: Moderation Engine. REQUIRED: Community features (ratings, reviews, flagging). OPTIONAL: GitHub contribution flow. |
| **M4** | Week 12–13 | Final | REQUIRED: Elasticsearch search + Redis caching. REQUIRED: Full API Dash workspace integration. REQUIRED: Developer documentation and deployment guide. OPTIONAL: Prometheus + Grafana dashboard. |

---

## 8. Implementation Plan & Timeline

90 hours over 13 weeks. Exams end May 7th — available full-time from that point.

| Period | Hours | Work breakdown |
|---|---|---|
| **Community Bonding** | — | Read full API Dash codebase. Agree final schema and taxonomy with mentors. Submit first contribution PR. Set up local dev environment and GitHub project board. |
| **Week 1–2** | 14 hrs | Schema ERD finalisation, API Catalog schema, migration scripts, CRUD REST API, schema design document. |
| **Week 3–4** | 14 hrs | OpenAPI Parser — Swagger 2.0, OAS 3.0, OAS 3.1. Edge cases: missing fields, circular $ref, partial specs. Unit tests covering 30+ edge cases. |
| **Week 5** | 7 hrs | HTML Scraper (Playwright + Cheerio). Integration tests against 5 real HTML doc pages. |
| **Week 6** | 7 hrs | Normalizer — unified internal schema mapping. Auth type detection (API Key, Bearer, OAuth2, Basic, None). Property-based tests. |
| **Week 7–8** | 14 hrs | Enrichment Engine (LangChain). LLM integration, batched requests, result caching, auto-tagging, security flag detection, usage example generation. Evaluate on 50 real APIs. |
| **Week 9** | 7 hrs | Completeness Scorer, Moderation Engine, audit log. Scorer calibration against 100 manually rated APIs. |
| **Week 10** | 7 hrs | Wire all pipeline stages to Kafka/BullMQ. Dead Letter Queue. Scheduler for nightly crawl jobs. End-to-end smoke tests. |
| **Week 11** | 7 hrs | Community features — star ratings, text reviews, entry flagging, webhook handler for GitHub contribution PRs. |
| **Week 12** | 7 hrs | Elasticsearch indexing, full-text search, faceted filters, autocomplete. Redis caching for hot listings. Search relevance evaluation on 200 queries. |
| **Week 13 (buffer)** | 6 hrs | Integration testing end-to-end. Performance benchmarks (target: <200ms p99 for search). Bug fixes. Final documentation. Submit deliverables. |

---

## 9. Risks & Mitigations

| Risk | Level | Mitigation |
|---|---|---|
| LLM API rate limits or cost overruns during enrichment | HIGH | Cache all enrichment results. Batch API calls. Implement local fallback using Ollama (Mistral/LLaMA). |
| Upstream APIs change their HTML/schema structure | MED | Schema-adaptive parsers with version detection. Weekly integration tests against live endpoints. Alert on parse failure rate exceeding 5%. |
| Scope creep given the breadth of the pipeline | MED | Strict week-by-week milestones on a public GitHub project board. Community and observability features are OPTIONAL and cut-able. |
| OpenAPI spec quality from user submissions varies widely | MED | Multi-layer validation: schema validator → completeness scorer → moderation queue. Structured error messages guide users to fix specific fields. |
| Exam period overlap (exams end May 7th) | MED | Community bonding used for investigation and mentor communication. Week 1 coding begins May 8th. Week 13 is explicit buffer. |
| First-time open source contributor — workflow unfamiliarity | LOW | Submit first PR before proposal deadline. GitHub Actions CI/CD is standard and well-documented in the API Dash repo. |

---

## 10. Availability & Commitments

| Item | Detail |
|---|---|
| **Availability** | 35–40 hours per week (full-time). No further academic commitments after May 7th. |
| **Known conflicts** | Final semester examinations: approximately late April to May 7th. During this window I will limit coding and focus on investigation, codebase reading, and mentor communication. |
| **Other commitments** | None. No internship, part-time job, or competing open-source commitments during GSoC. |
| **Communication** | Weekly 30-minute video sync with mentor. Daily async updates on Discord/Slack by 6 PM IST. Weekly progress notes in the GitHub project board. Will respond to mentor messages within 4 hours during working hours. |
| **Timezone** | IST (Asia/Kolkata, UTC +5:30). Available 9 AM – 11 PM IST. |
| **Internet connectivity** | Reliable broadband at home in Coimbatore. No planned travel that would disrupt connectivity. |
| **If I fall behind** | Will notify my mentor within 24 hours and propose a revised plan. The 13th week is an explicit buffer for exactly this scenario. |

---

## 11. Post-GSoC Plans

I plan to remain an active API Dash contributor after GSoC ends. The pipeline is explicitly designed for extensibility — every stage is a stateless, independently deployable worker with a documented interface. Future contributors can add new source connectors, scoring dimensions, or enrichment steps without touching existing code.

Three specific post-GSoC contributions I have already thought through:

1. **VS Code extension** exposing the API Explorer catalog inline in the editor, powered by the REST API built during GSoC — bringing zero-setup API discovery directly into the coding environment.
2. **Fine-tuned local model** — replace the external LLM API dependency with a fine-tuned small model trained on the enriched catalog data, eliminating per-call cost and reducing enrichment latency to under 100ms.
3. **Auto-PR generation** — when an upstream API publishes a new OpenAPI version, the system automatically opens a spec-update PR in the catalog — enabling a self-maintaining, always-current library.

I have spent the last three years learning to build things that solve real problems by myself. The API Explorer is a real problem — I have experienced it myself — and I am excited to do this project. I am fully committed to delivering this, and to becoming a better developer who could contribute to open source.

---

*Thank you for considering my proposal. — Kishore J*
