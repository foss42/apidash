# AI Eval Framework — POC

**Author:** Mohamed Salah  
**Project:** Google Summer of Code — End-to-End AI & Agent API Evaluation Framework  
**Date:** March 2026

---

## What Is This?

A working proof-of-concept for a **general-purpose AI model evaluation framework**. It lets users upload any dataset, run it against any LLM provider, and measure the quality of responses using configurable metrics — all through a web UI.

This POC validates the core evaluation loop described in the [full GSoC idea document](idea_doc_gsoc_microservices.md) by implementing two microservices (Eval Engine + Dataset Service) and a Streamlit frontend, fully containerized with Docker.

---

## Architecture

```
┌─────────────────────┐
│   Streamlit UI      │  ← Browser UI on :8501
│   (ui-streamlit/)   │
└────┬───────────┬────┘
     │ REST      │ REST
     ▼           ▼
┌─────────┐  ┌──────────────┐
│ Dataset │  │ Eval Engine  │
│ Service │  │   :8001      │
│  :8004  │  │              │
└─────────┘  └──────────────┘
```

All three services run as Docker containers orchestrated by `docker-compose.yml`.

---

## What Was Built

### 1. Eval Engine (`:8001`)

The core service. Accepts an experiment configuration, fetches dataset rows, sends each row to an LLM adapter, computes metrics, and stores results.

**Endpoints implemented:**

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/experiments` | Create and run a new evaluation experiment |
| GET | `/experiments/{id}` | Get experiment status and progress |
| GET | `/experiments/{id}/results` | Get full per-sample results |
| POST | `/experiments/{id}/cancel` | Cancel a running experiment |
| GET | `/adapters` | List all registered model adapters |
| GET | `/metrics` | List all available evaluation metrics |
| GET | `/health` | Service health check |

**Model adapters:**

| Adapter | Provider | Models | Notes |
|---------|----------|--------|-------|
| `mock` | None | mock-model | Returns reversed input text; for testing the pipeline |
| `groq` | Groq Cloud | llama-3.3-70b-versatile, llama-3.1-8b-instant, gemma2-9b-it, mixtral-8x7b-32768 | Free tier, 1K req/day limit |
| `openai` | OpenAI | gpt-4, gpt-4-turbo, gpt-3.5-turbo | Requires `OPENAI_API_KEY` |

**Evaluation metrics:**

| Metric | Description |
|--------|-------------|
| `exact_match` | 1.0 if predicted == expected (exact string match) |
| `contains_match` | 1.0 if expected appears anywhere in the prediction (case-insensitive) |
| `case_insensitive_match` | 1.0 if predicted == expected ignoring case |
| `bleu_score` | Unigram BLEU with brevity penalty (word overlap score, 0–1) |

### 2. Dataset Service (`:8004`)

Handles file upload, parsing, validation, and serving dataset rows to the Eval Engine.

**Endpoints implemented:**

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/datasets/upload` | Upload a CSV or JSONL file |
| GET | `/datasets` | List all uploaded datasets |
| GET | `/datasets/{id}` | Get dataset metadata |
| GET | `/datasets/{id}/sample` | Preview first N rows |
| GET | `/datasets/{id}/rows` | Return all rows (used by Eval Engine) |
| GET | `/datasets/{id}/stream` | Stream all rows |
| DELETE | `/datasets/{id}` | Delete a dataset |
| GET | `/health` | Service health check |

**Supported formats:** CSV, JSONL, NDJSON

**Expected columns:** `input` (required), `expected_output` (optional)

### 3. Streamlit UI (`:8501`)

A three-tab web interface:

- **Datasets** — Upload files, browse existing datasets, preview rows
- **Run Experiment** — Select dataset, adapter, model, and metrics; run with live progress bar
- **Results** — View aggregate metrics, per-sample scores, download results as CSV

---

## Dataset Format

The framework is **task-agnostic**. Any CSV/JSONL with an `input` column works. The `expected_output` column is needed for scoring.

**Examples of valid datasets:**

| Use Case | input | expected_output |
|----------|-------|-----------------|
| QA | "What is the capital of France?" | "Paris" |
| Classification | "Classify: `<script>alert(1)</script>`" | "XSS" |
| Sentiment | "This movie was terrible" | "negative" |
| Translation | "Translate to French: Hello" | "Bonjour" |

Two sample datasets are included:

- `sample_data/qa_sample.csv` — 10 general knowledge QA pairs
- `sample_data/security_payloads_sample.csv` — 42 security payload classification tasks (XSS, SQL Injection, Command Injection, etc.)

---

## How to Run

### Prerequisites

- Docker and Docker Compose installed
- A Groq API key (free at https://console.groq.com/keys) or OpenAI API key

### Steps

1. **Set your API key** in `.env`:

```
GROQ_API_KEY=gsk_your_key_here
```

2. **Start everything:**

```bash
cd ai-eval-framework
docker compose up -d
```

3. **Open the UI:** http://localhost:8501

4. **Upload a dataset** → **Run an experiment** → **View results**

### Management Commands

```bash
docker compose up -d          # Start all services
docker compose down           # Stop all services
docker compose restart        # Restart after .env changes
docker compose logs -f        # View live logs
docker compose build          # Rebuild after code changes
```

---

## File Structure

```
ai-eval-framework/
├── .env                                  # API keys
├── .dockerignore
├── docker-compose.yml                    # Run all 3 services
├── README.md                             # This file
├── sample_data/
│   ├── qa_sample.csv                     # 10-row QA dataset
│   └── security_payloads_sample.csv      # 42-row security classification dataset
├── services/
│   ├── dataset-service/
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   └── app/
│   │       ├── main.py                   # FastAPI app
│   │       └── routers/
│   │           └── datasets.py           # Upload, list, serve datasets
│   └── eval-engine/
│       ├── Dockerfile
│       ├── requirements.txt
│       └── app/
│           ├── main.py                   # FastAPI app
│           ├── storage.py                # In-memory experiment/result store
│           ├── adapters/
│           │   ├── base.py               # Adapter interface
│           │   ├── mock.py               # Deterministic test adapter
│           │   ├── groq_adapter.py       # Groq Cloud (Llama, Gemma, Mixtral)
│           │   ├── openai_adapter.py     # OpenAI (GPT-4, GPT-3.5)
│           │   └── registry.py           # Adapter registry
│           ├── engine/
│           │   └── runner.py             # Core evaluation loop
│           ├── metrics/
│           │   ├── text.py               # exact_match, contains_match, bleu_score
│           │   └── registry.py           # Metric registry
│           └── routers/
│               ├── experiments.py        # Experiment CRUD + run
│               ├── adapters.py           # List adapters
│               └── metrics.py            # List metrics
└── ui-streamlit/
    ├── Dockerfile
    ├── requirements.txt
    └── app.py                            # Streamlit UI (3 tabs)
```

---

## What This POC Demonstrates

1. **Microservices separation** — Dataset Service and Eval Engine are independent services communicating over REST, each with its own Dockerfile and port
2. **Pluggable adapter pattern** — Adding a new LLM provider is one file + one registry entry; the framework doesn't care which model answers
3. **Pluggable metrics** — Adding a new metric is one function + one registry entry; users pick which metrics to apply per experiment
4. **Task-agnostic design** — The framework doesn't know what the data is about; it works for QA, classification, translation, security analysis, or any other task
5. **Live progress tracking** — The UI polls experiment status and shows a real-time progress bar
6. **Containerized deployment** — One `docker compose up -d` starts everything


