# Idea Doc: End-to-End AI and Agent API Evaluation Framework (Microservices)
**Author:** Mohamed Salah  
**Project:** Google Summer of Code — End-to-End AI & Agent API Evaluation Framework  
**Date:** March 2026

---

## 1. Problem Statement

Evaluating modern AI models and agent systems is fragmented. Researchers manually stitch together benchmark tools (lm-harness, lighteval), hand-craft API calls, and build one-off scripts for result analysis. There is no unified, UI-driven framework that handles:

- Standard LLM benchmarks via existing tools
- Custom dataset evaluation across providers (OpenAI, Anthropic, HuggingFace, etc.)
- Multi-modal evaluation (text, image, voice)
- Agent evaluation with intermediate action tracing

This project builds that unified framework — designed as a **microservices system** so each concern scales, deploys, and fails independently.

---

## 2. Microservices Architecture Overview

```
                        
                        ┌────────────--┐
                        │  UI Backend  │  ← BFF (Backend for Frontend)
                        │   Service    │    Aggregates data for the UI
                        └──────┬───────┘
                               │ REST
                        ┌──────▼───────┐
                        │ API Gateway  │  ← Auth, routing, rate limiting
                        └──┬──┬──┬─────┘
                           │  │  │
          ┌────────────────┘  │  └─────────────────┐
          │                   │                    │
   ┌──────▼──────┐    ┌───────▼──────┐    ┌────────▼────────┐
   │   Dataset   │    │ Eval Engine  │    │  Agent Tracer   │
   │   Service   │    │   Service    │    │    Service      │
   └─────────────┘    └──────┬───────┘    └────────┬────────┘
                             │                     │
                    ┌────────▼─────────────────────▼────---─┐
                    │         Message Queue (Kafka)      
                    └────────┬──────────────────────────────┘
                             │
                    ┌────────▼────────┐
                    │   Benchmark     │
                    │ Runner Service  │  ← lm-harness, lighteval
                    └─────────────────┘

   Shared: PostgreSQL · Redis · Object Storage (S3-compatible)
```

---

## 3. Service-by-Service Design

### 3.1 API Gateway — Port 8000

Single entry point for all clients. Handles auth (API key / OAuth2), routes requests to downstream services, enforces rate limits, and aggregates errors.

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/experiments` | Create and submit a new evaluation experiment. Routes to Eval Engine. |
| GET | `/api/experiments/{id}` | Fetch the full status and results of a single experiment. |
| GET | `/api/experiments` | List all experiments for the authenticated user (filterable by status, date). |
| DELETE | `/api/experiments/{id}` | Cancel a running experiment or delete a completed one. |
| POST | `/api/datasets` | Upload a new dataset file. Routes to Dataset Service. |
| GET | `/api/datasets` | List all datasets uploaded by the authenticated user. |
| GET | `/api/benchmarks` | List all available benchmark tasks. Routes to Benchmark Runner. |
| POST | `/api/benchmarks/run` | Trigger a benchmark run for a given task and model. |
| POST | `/api/agents/trace` | Submit an agent for evaluation. Routes to Agent Tracer. |
| GET | `/api/agents/trace/{id}` | Retrieve a completed agent trace and its metrics. |
| POST | `/api/auth/token` | Issue an API token (API key or OAuth2 flow). |
| GET | `/health` | Gateway health check. Returns status of all downstream services. |

---

### 3.2 Eval Engine — Port 8001

Core runner. Loads datasets, dispatches async requests to AI provider adapters, computes metrics, and stores results.

**Kafka topics — publishes:** `eval.completed`, `eval.progress`  
**Kafka topics — consumes:** `benchmark.result`

| Method | Endpoint | Description |
|---|---|---|
| POST | `/experiments` | Start a new evaluation run. Loads dataset, dispatches provider requests, computes metrics, and stores results. |
| GET | `/experiments/{id}` | Return the current state of an experiment (pending / running / completed) with partial results if still in progress. |
| GET | `/experiments/{id}/results` | Return the full result set for a completed experiment, including per-sample scores and aggregate metrics. |
| POST | `/experiments/{id}/cancel` | Stop a running experiment. Ongoing API calls are aborted. |
| GET | `/experiments/{id}/cost-estimate` | Return a token-count and cost estimate before the experiment runs. |
| GET | `/adapters` | List all registered model adapters (OpenAI, Anthropic, HuggingFace, Custom Agent) and their supported parameters. |
| GET | `/metrics` | List all available evaluation metrics (exact match, BLEU, ROUGE, SBERT, CLIP, WER) with their applicable modalities. |
| GET | `/health` | Service health and Redis / PostgreSQL connectivity status. |

---

### 3.3 Benchmark Runner — Port 8002

Wraps lm-harness and lighteval so standard benchmarks run through the system without modification. Intentionally isolated because lm-harness is CPU/memory heavy and scales independently.

**Kafka topics — consumes:** `benchmark.run`  
**Kafka topics — publishes:** `benchmark.result`

| Method | Endpoint | Description |
|---|---|---|
| GET | `/tasks` | List all available benchmark tasks across lm-harness and lighteval, plus any custom YAML tasks. |
| GET | `/tasks/{name}` | Return metadata for a single task — description, sample count, expected metrics, and data source. |
| POST | `/runs` | Queue a new benchmark run for a given task and model adapter. Publishes a job to the `benchmark.run` Kafka topic. |
| GET | `/runs/{id}` | Return the status and results of a benchmark run, with scores per subtask. |
| GET | `/runs/{id}/logs` | Stream the raw stdout/stderr of the underlying lm-harness or lighteval process for debugging. |
| POST | `/tasks/custom` | Register a new custom benchmark task by uploading a YAML config file. |
| GET | `/health` | Service health and Kafka consumer status. |

---

### 3.4 Agent Tracer — Port 8003

Evaluates tool-calling and multi-step agents. Calls the agent endpoint, intercepts each tool call and LLM response turn, logs the full trace, and computes agent-specific metrics.

**Kafka topics — publishes:** `agent.trace.completed`

| Method | Endpoint | Description |
|---|---|---|
| POST | `/traces` | Submit an agent endpoint and a task. The service calls the agent, intercepts each step, and records the full execution trace. |
| GET | `/traces/{id}` | Return a completed trace — all steps, tool calls, LLM responses, final answer, and computed metrics. |
| GET | `/traces` | List all traces with filters by agent endpoint, success status, or date range. |
| GET | `/traces/{id}/steps` | Return only the intermediate steps of a trace — for debugging agent reasoning without the full metric payload. |
| GET | `/traces/{id}/metrics` | Return just the computed agent metrics — task success, steps taken, tool accuracy, hallucinated actions, latency. |
| POST | `/traces/batch` | Submit multiple agent tasks in a single batch. Each task gets an independent trace and metric computation. |
| GET | `/health` | Service health and Kafka producer status. |

**Agent metrics computed:**
| Metric | Description |
|---|---|
| Task success rate | Did the agent complete the goal? |
| Steps to completion | Fewer = better |
| Tool accuracy | Correct tool called with valid args? |
| Hallucinated actions | Non-existent or malformed tool calls |
| Latency | Total wall-clock trace time |

---

### 3.5 Dataset Service — Port 8004

Handles dataset upload, validation, storage in MinIO, and streaming to the Eval Engine during active runs.

**Supported formats:** CSV, JSONL, HuggingFace Hub  
**Column mapping:** `input`, `expected_output`, `context`, `image` (path/base64), `audio` (path/base64)

| Method | Endpoint | Description |
|---|---|---|
| POST | `/datasets/upload` | Upload a CSV or JSONL file. Validates structure, stores in MinIO, returns a `dataset_id`. |
| POST | `/datasets/import` | Import a dataset from HuggingFace Hub by name and split (e.g. `squad/validation`). |
| GET | `/datasets` | List all datasets owned by the user with metadata (row count, columns, modality, upload date). |
| GET | `/datasets/{id}` | Return full metadata for a single dataset including schema and detected modality. |
| GET | `/datasets/{id}/sample` | Return a small preview of N rows. Used by the UI before the user launches a run. |
| GET | `/datasets/{id}/stream` | Stream dataset rows to the Eval Engine in batches during an active experiment. |
| POST | `/datasets/{id}/validate` | Validate a column mapping config — checks that required fields exist and are non-empty. |
| DELETE | `/datasets/{id}` | Permanently delete a dataset and its stored file from MinIO. |
| GET | `/health` | Service health and MinIO connectivity status. |

---

### 3.6 UI Backend (BFF) — Port 8005

Backend for Frontend. Aggregates data from multiple services into UI-ready responses and relays real-time Kafka events to the browser over WebSocket.

| Method | Endpoint | Description |
|---|---|---|
| GET | `/dashboard/experiments` | Return a combined experiment list with status, dataset name, model, and top-level metrics — aggregated from Eval Engine and Dataset Service in one call. |
| GET | `/dashboard/experiments/{id}` | Return a fully assembled detail view — config, dataset info, results, and linked agent traces — ready for the results page. |
| GET | `/dashboard/compare` | Return a side-by-side comparison of two or more experiments. Accepts a list of experiment IDs and returns aligned metrics. |
| GET | `/dashboard/providers` | Return all supported model providers and available models, pulled from the Eval Engine adapter registry. |
| GET | `/dashboard/cost-estimate` | Return a cost and token-count estimate for a proposed experiment config before submission. |
| WS | `/ws/experiments/{id}/progress` | WebSocket. Relays real-time `eval.progress` Kafka events to the browser — sample count, current score, estimated time remaining. |
| WS | `/ws/benchmarks/{id}/progress` | WebSocket. Relays `benchmark.run` progress events — current task, subtask scores as they complete. |
| GET | `/exports/experiments/{id}` | Download the full results of an experiment as a CSV or JSON file. |
| GET | `/health` | BFF health check and Kafka consumer connectivity. |

---

## 4. Shared Infrastructure

| Component | Purpose | Technology |
|---|---|---|
| Message Bus | Async job dispatch, event streaming, replayable logs | Kafka |
| Cache | Response caching, rate-limit buckets | Redis |
| Database | Experiments, results, traces, datasets metadata | PostgreSQL |
| Object Storage | Dataset files, audio/image blobs | MinIO (S3-compatible) |

---

## 5. Multi-Modal Support

| Modality | Tasks | Metrics |
|---|---|---|
| **Text** | QA, summarization, classification, translation | Exact match, BLEU, ROUGE, SBERT similarity |
| **Image** | Image captioning, Visual QA | CLIP similarity, CIDEr |
| **Voice** | Speech-to-text, voice assistants | Word Error Rate (WER), latency |

Image and audio fields are uploaded via Dataset Service and passed as base64 blobs in provider API calls.

---

## 6. Deployment

### Docker Compose (self-hosted / development)
```yaml
services:
  api-gateway:      { build: ./services/gateway,   ports: ["8000:8000"] }
  eval-engine:      { build: ./services/eval,       ports: ["8001:8001"] }
  benchmark-runner: { build: ./services/benchmark,  ports: ["8002:8002"] }
  agent-tracer:     { build: ./services/agent,      ports: ["8003:8003"] }
  dataset-service:  { build: ./services/dataset,    ports: ["8004:8004"] }
  ui-backend:       { build: ./services/ui-backend, ports: ["8005:8005"] }
  ui:               { build: ./ui,                  ports: ["3000:3000"] }
  zookeeper:        { image: confluentinc/cp-zookeeper:7.6.0,  ports: ["2181:2181"] }
  kafka:            { image: confluentinc/cp-kafka:7.6.0,       ports: ["9092:9092"] }
  redis:            { image: redis:7 }
  postgres:         { image: postgres:16 }
  minio:            { image: minio/minio }
```

### Kubernetes (production)
Each service gets its own `Deployment` + `Service` manifest. The Benchmark Runner is configured with a `HorizontalPodAutoscaler` since benchmark jobs are CPU-heavy and bursty. Kafka and PostgreSQL run as StatefulSets.

```
k8s/
 ├── gateway/         deployment.yaml, service.yaml
 ├── eval-engine/     deployment.yaml, service.yaml, hpa.yaml
 ├── benchmark/       deployment.yaml, service.yaml, hpa.yaml
 ├── agent-tracer/    deployment.yaml, service.yaml
 ├── dataset/         deployment.yaml, service.yaml
 ├── ui-backend/      deployment.yaml, service.yaml
 ├── infra/           kafka.yaml, zookeeper.yaml, redis.yaml, postgres.yaml, minio.yaml
 └── ingress.yaml
```

---

## 7. Proposed Timeline (GSoC ~12 weeks)

| Phase | Weeks | Deliverable |
|---|---|---|
| Scaffold | 1 | Repo structure, Docker Compose, shared DB schema, Kafka setup |
| Adapters + Eval Engine | 2–3 | Adapter layer (OpenAI, Anthropic, HF), Eval Engine Service end-to-end |
| Dataset Service | 4 | Upload, validation, streaming, MinIO integration |
| Benchmark Runner | 5–6 | lm-harness + lighteval bridges; MMLU / GSM8K working |
| Agent Tracer | 7–8 | Trace schema, agent metrics, CustomAgentAPIAdapter |
| Multi-Modal | 9 | Image + voice adapters, CLIP / WER metrics |
| UI + BFF | 10–11 | React UI: experiment builder, live run view, results dashboard, WebSocket progress |
| K8s + Docs | 12 | K8s manifests, full docs, ≥80% test coverage, example notebooks |

---

## 8. Open Questions for Maintainer

1. Should the Benchmark Runner spawn lm-harness via subprocess or use its Python API directly?
2. Are there specific agent benchmarks (WebArena, AgentBench, τ-bench) to prioritize?
3. Is MinIO acceptable for object storage, or is there a preferred S3-compatible solution?
4. Should inter-service auth (service-to-service JWT) be in scope for GSoC, or is internal trust assumed?

---

## 9. File Architecture

### Monorepo Root

```
ai-eval-framework/
├── services/              ← one folder per microservice
├── ui/                    ← React frontend
├── k8s/                   ← all Kubernetes manifests
├── shared/                ← shared Pydantic schemas + Kafka event types
│   ├── schemas.py         ← RequestConfig, ModelResponse, ExperimentResult …
│   └── events.py          ← Kafka topic names + event payload models
├── docker-compose.yml
├── .env.example
└── README.md
```

> `shared/` is imported by every service. `schemas.py` holds models that cross service boundaries. `events.py` holds Kafka topic names and payload shapes — both producer and consumer import from the same file so schema mismatches are caught at import time, not at runtime.

---

### API Gateway — `:8000`

```
services/gateway/
├── app/
│   ├── main.py                ← FastAPI app, mounts all routers
│   ├── routers/
│   │   ├── experiments.py     ← proxies to eval-engine
│   │   ├── datasets.py        ← proxies to dataset-service
│   │   ├── benchmarks.py      ← proxies to benchmark-runner
│   │   ├── agents.py          ← proxies to agent-tracer
│   │   └── auth.py            ← token issuance + validation
│   ├── middleware/
│   │   ├── auth.py            ← API key / JWT verification on every request
│   │   └── rate_limit.py      ← per-user rate limiting via Redis
│   └── config.py              ← downstream service URLs from env vars
├── tests/
│   └── test_routing.py
├── Dockerfile
└── requirements.txt
```

---

### Eval Engine — `:8001`

```
services/eval-engine/
├── app/
│   ├── main.py
│   ├── routers/
│   │   ├── experiments.py     ← POST/GET /experiments
│   │   ├── adapters.py        ← GET /adapters
│   │   └── metrics.py         ← GET /metrics
│   ├── adapters/              ← one file per AI provider
│   │   ├── base.py            ← BaseModelAdapter ABC
│   │   ├── openai.py
│   │   ├── anthropic.py
│   │   ├── huggingface.py
│   │   └── custom_agent.py
│   ├── engine/
│   │   ├── runner.py          ← async dispatcher, rate-limit, retries, caching
│   │   ├── dataset_client.py  ← streams rows from dataset-service
│   │   └── cost_estimator.py
│   ├── metrics/
│   │   ├── text.py            ← BLEU, ROUGE, exact match, SBERT
│   │   ├── image.py           ← CLIP similarity, CIDEr
│   │   ├── voice.py           ← WER, latency
│   │   └── registry.py        ← maps metric names → functions
│   ├── kafka/
│   │   ├── producer.py        ← publishes eval.progress, eval.completed
│   │   └── consumer.py        ← consumes benchmark.result
│   ├── db/
│   │   ├── models.py          ← SQLAlchemy Experiment, Result models
│   │   └── crud.py
│   └── config.py
├── tests/
│   ├── test_adapters.py
│   ├── test_runner.py
│   └── test_metrics.py
├── Dockerfile
└── requirements.txt
```

---

### Benchmark Runner — `:8002`

```
services/benchmark-runner/
├── app/
│   ├── main.py
│   ├── routers/
│   │   ├── tasks.py           ← GET /tasks, GET /tasks/{name}
│   │   └── runs.py            ← POST /runs, GET /runs/{id}, GET /runs/{id}/logs
│   ├── bridges/               ← wraps external benchmark tools
│   │   ├── base.py            ← BenchmarkBridge ABC
│   │   ├── lm_harness.py      ← wraps lm-harness CLI / Python API
│   │   └── lighteval.py       ← wraps lighteval
│   ├── tasks/                 ← YAML task definitions (mounted as a k8s volume)
│   │   ├── mmlu.yaml
│   │   ├── gsm8k.yaml
│   │   └── truthfulqa.yaml
│   ├── kafka/
│   │   ├── consumer.py        ← consumes benchmark.run
│   │   └── producer.py        ← publishes benchmark.result
│   ├── db/
│   │   ├── models.py          ← BenchmarkRun model
│   │   └── crud.py
│   └── config.py
├── tests/
│   ├── test_lm_harness_bridge.py
│   └── test_lighteval_bridge.py
├── Dockerfile
└── requirements.txt
```

---

### Agent Tracer — `:8003`

```
services/agent-tracer/
├── app/
│   ├── main.py
│   ├── routers/
│   │   └── traces.py          ← all /traces endpoints
│   ├── tracer/
│   │   ├── runner.py          ← calls agent endpoint, intercepts each step
│   │   ├── interceptor.py     ← captures tool calls + LLM responses mid-trace
│   │   └── metrics.py         ← task success, tool accuracy, hallucination detection
│   ├── kafka/
│   │   └── producer.py        ← publishes agent.trace.completed
│   ├── db/
│   │   ├── models.py          ← Trace, TraceStep models
│   │   └── crud.py
│   └── config.py
├── tests/
│   ├── test_tracer_runner.py
│   └── test_metrics.py
├── Dockerfile
└── requirements.txt
```

---

### Dataset Service — `:8004`

```
services/dataset-service/
├── app/
│   ├── main.py
│   ├── routers/
│   │   └── datasets.py        ← all /datasets endpoints
│   ├── storage/
│   │   └── minio_client.py    ← upload, download, delete from MinIO
│   ├── parsers/
│   │   ├── csv_parser.py
│   │   ├── jsonl_parser.py
│   │   └── huggingface_loader.py  ← pulls from HuggingFace Hub
│   ├── validators/
│   │   └── schema_validator.py    ← checks column mapping, non-empty fields
│   ├── db/
│   │   ├── models.py          ← Dataset metadata model
│   │   └── crud.py
│   └── config.py
├── tests/
│   ├── test_parsers.py
│   └── test_validators.py
├── Dockerfile
└── requirements.txt
```

---

### UI Backend (BFF) — `:8005`

```
services/ui-backend/
├── app/
│   ├── main.py
│   ├── routers/
│   │   ├── dashboard.py       ← all /dashboard/* REST endpoints
│   │   ├── websocket.py       ← /ws/experiments/{id} and /ws/benchmarks/{id}
│   │   └── exports.py         ← CSV / JSON download endpoints
│   ├── aggregators/           ← calls multiple services, merges responses
│   │   ├── experiment_aggregator.py  ← merges eval + dataset + trace data
│   │   └── compare_aggregator.py     ← aligns metrics across experiments
│   ├── kafka/
│   │   └── consumer.py        ← reads eval.progress → forwards to WebSocket
│   ├── clients/               ← typed HTTP clients for each upstream service
│   │   ├── eval_client.py
│   │   ├── dataset_client.py
│   │   ├── benchmark_client.py
│   │   └── agent_client.py
│   └── config.py
├── tests/
│   ├── test_aggregators.py
│   └── test_websocket.py
├── Dockerfile
└── requirements.txt
```

---

### React UI — `:3000`

```
ui/
├── src/
│   ├── pages/
│   │   ├── ExperimentBuilder.tsx  ← configure provider, dataset, metrics
│   │   ├── LiveRun.tsx            ← progress bar, streaming results
│   │   ├── Results.tsx            ← scores, failure cases, charts
│   │   └── Compare.tsx            ← side-by-side model comparison
│   ├── components/                ← reusable UI components
│   ├── hooks/
│   │   └── useExperimentSocket.ts ← manages WebSocket connection
│   ├── api/                       ← typed fetch wrappers for every BFF endpoint
│   └── main.tsx
├── Dockerfile
├── package.json
└── vite.config.ts
```

---

## 10. Summary

This design decomposes the framework into **6 independent microservices**, each with a clear single responsibility. The Benchmark Runner is isolated because lm-harness is CPU-heavy. The Agent Tracer is isolated because agent evaluation has a fundamentally different execution model from standard inference. The Dataset Service is isolated because dataset I/O is I/O-bound and benefits from independent scaling.

Services communicate synchronously over REST for request/response flows and asynchronously over **Kafka** for long-running jobs (benchmark runs, large eval batches). Kafka's log-based model is a deliberate choice over a traditional message queue — it allows event replay for debugging failed runs, reprocessing results with updated metrics, and auditing the full history of an experiment without re-running it. This makes the system resilient and observable: a slow benchmark run does not block the UI or eval engine, and no progress event is ever lost.
