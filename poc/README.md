# Multimodal AI API Evaluation Framework — POC

A multimodal-first evaluation framework that sends images, audio, and video to multiple AI providers (OpenAI, Anthropic, Gemini, Ollama), scores responses with modality-appropriate metrics, and streams real-time comparison results to a React dashboard.

## Features

- **Multi-provider comparison** — same inputs sent to all selected providers simultaneously
- **Real-time streaming** — SSE-powered live progress during evaluations
- **Multimodal datasets** — text, image (understanding + generation), audio (STT + TTS), video
- **Request parameter control** — temperature, max\_tokens, system\_prompt forwarded per provider
- **lm-eval benchmarks** — run arc\_easy, hellaswag, etc. against local Ollama models (optional)
- **Local model priority** — Ollama as first-class provider (LLaVA for vision, Whisper for audio)
- **Cost tracking** — per-provider token counts and estimated USD
- **Job history** — SQLite-persisted results with re-run capability
- **Zero-config setup** — `pip install` + `pnpm install`, no Docker or Redis required

---

## Prerequisites

| Requirement | Version | Purpose |
|-------------|---------|---------|
| Python | 3.11+ | Backend runtime |
| [uv](https://docs.astral.sh/uv/getting-started/installation/) | latest | Python package manager |
| Node.js | 20+ | Frontend build |
| [pnpm](https://pnpm.io/installation) | latest | Node package manager |
| [Ollama](https://ollama.com) | latest | Local model serving (optional) |

Install `uv`: `pip install uv` or follow the [uv docs](https://docs.astral.sh/uv/getting-started/installation/).

---

## Backend Setup

```bash
cd poc/backend

# Install dependencies
uv sync

# Copy and configure environment variables
cp .env.example .env
```

Edit `.env` and add your API keys (see [API Key Configuration](#api-key-configuration)).

```bash
# Start the backend (port 8000)
uv run uvicorn main:app --reload --port 8000
```

The API is available at `http://localhost:8000`. Interactive docs at `http://localhost:8000/docs`.

---

## Frontend Setup

```bash
cd poc/frontend

# Install dependencies
pnpm install

# Start the dev server (port 5173)
pnpm dev
```

Open `http://localhost:5173` in your browser.

---

## API Key Configuration

Edit `poc/backend/.env`:

```env
OPENAI_API_KEY=sk-...           # Required for OpenAI GPT / DALL-E / Whisper
ANTHROPIC_API_KEY=sk-ant-...    # Required for Anthropic Claude
GOOGLE_API_KEY=AIza...          # Required for Google Gemini
OLLAMA_BASE_URL=http://localhost:11434  # Ollama local server (default)
```

Providers without a configured key are marked unavailable but the app still starts.

---

## Optional: lm-eval (Benchmarks tab)

To use the Benchmarks tab, install lm-eval in the backend environment:

```bash
cd poc/backend
uv sync
uv pip install lm-eval
```

`transformers` is also required for tokenizer-backed Ollama benchmark runs. It is included in
`backend/requirements.txt`; if your environment predates that change, run `uv sync` again.

Without it, the Benchmarks tab shows an install prompt but everything else works normally.

---

## Sample Eval Walkthrough

### Text Evaluation

1. Pull a small local model: `ollama pull qwen2.5:0.5b`
2. Open `http://localhost:5173`
3. Click **Upload Dataset** → select `poc/sample_data/datasets/text_eval.csv`
4. In **Configure Evaluation**: set Modality → Text, add Ollama provider
5. (Optional) Adjust Temperature slider or add a System Prompt
6. Click **Start Evaluation** — watch live progress stream in
7. Results page shows side-by-side provider responses with exact\_match / BLEU scores

### Image Evaluation

1. Pull a vision model: `ollama pull moondream` or `ollama pull llava-phi3`
2. Upload `poc/sample_data/datasets/image_eval.csv`
3. Set Modality → Image Understanding, add Ollama + a cloud provider
4. Run — responses describe each uploaded image

### Audio Evaluation (Speech-to-Text)

1. Upload `poc/sample_data/datasets/audio_eval.csv`
2. Set Modality → Speech-to-Text, select Whisper (tiny or base)
3. Run — WER and CER scores compare transcripts to expected text

### lm-eval Benchmark

1. Ensure Ollama is running with a model: `ollama pull qwen2.5:0.5b`
2. Navigate to the **Benchmarks** tab
3. Select task `arc_easy`, model `qwen2.5:0.5b`
4. Click **Run Benchmark** — lm-eval stdout streams live; accuracy score appears on completion

---

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/providers` | List registered providers with health status |
| POST | `/api/datasets` | Upload dataset (multipart) |
| GET | `/api/datasets` | List uploaded datasets |
| POST | `/api/eval` | Start evaluation job |
| GET | `/api/eval/{id}/stream` | SSE progress stream |
| GET | `/api/jobs` | List past evaluation jobs |
| GET | `/api/jobs/{id}` | Job details + results + eval\_config |
| POST | `/api/jobs/{id}/rerun` | Re-run a past job |
| POST | `/api/benchmarks` | Start lm-eval benchmark run |
| GET | `/api/benchmarks/{id}/stream` | SSE log stream for benchmark |
| GET | `/api/benchmarks` | List past benchmark runs |

---

## Demo

> _Screenshot / GIF placeholder — will be added after recording a short demo._

The POC demonstrates:
1. Image understanding eval: moondream vs llava-phi3 on nature photos
2. Audio STT eval: Whisper tiny vs Whisper base on speech samples
3. Text eval: qwen2.5:0.5b vs smollm2:360m with temperature control
4. lm-eval benchmark: arc\_easy accuracy score streaming in real time

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      React Dashboard (Vite)                      │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐ ┌────────────────┐   │
│  │EvalConfig│ │FileUpload│ │LiveProgress│ │BenchmarkRunner │   │
│  │ +params  │ │          │ │   (SSE)    │ │    (SSE)       │   │
│  └────┬─────┘ └────┬─────┘ └─────┬──────┘ └───────┬────────┘   │
│       └────────────┴─────────────┴────────────────┘            │
│                          REST + SSE                              │
└──────────────────────────────────────────────────────────────────┘
                               │
┌──────────────────────────────┼──────────────────────────────────┐
│                   FastAPI Backend                                 │
│  ┌───────────┐ ┌──────────┐ ┌──────────┐ ┌───────────────────┐ │
│  │ Evaluators│ │ Metrics  │ │Benchmarks│ │  Provider Registry │ │
│  │text/image │ │BLEU/WER/ │ │ runner   │ │OpenAI│Anthropic   │ │
│  │audio/video│ │LLM-judge │ │ (lm-eval)│ │Gemini│Ollama      │ │
│  └─────┬─────┘ └────┬─────┘ └─────┬────┘ └──────┬────────────┘ │
│        └────────────┴─────────────┴──────────────┘             │
│                          │                                       │
│  ┌───────────────────────┴────────────────────┐                 │
│  │          SQLite (aiosqlite)                 │                 │
│  │  datasets │ jobs │ job_results │ benchmark_ │                 │
│  │  items    │      │ job_events  │ runs       │                 │
│  └────────────────────────────────────────────┘                 │
└──────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
poc/
├── backend/
│   ├── main.py              # FastAPI app entry point
│   ├── config.py            # Settings (pydantic-settings)
│   ├── providers/           # Provider adapters — OpenAI, Anthropic, Gemini, Ollama, Whisper
│   ├── evaluators/          # Per-modality evaluation logic
│   ├── metrics/             # Scoring plugins (text similarity, WER/CER, LLM-judge, cost)
│   ├── benchmarks/          # lm-eval subprocess runner (optional)
│   ├── datasets/            # Dataset loading and validation
│   ├── jobs/                # Job execution, persistence, models
│   ├── streaming/           # SSE event helpers
│   ├── storage/             # Artifact filesystem storage
│   └── api/                 # FastAPI route handlers
├── frontend/
│   └── src/
│       ├── components/      # EvalConfig, BenchmarkRunner, ResultsTable, …
│       ├── hooks/           # useSSE, useApi custom hooks
│       ├── pages/           # EvalPage, BenchmarksPage, ResultsPage, HistoryPage
│       └── types/           # TypeScript type definitions
├── sample_data/             # Demo datasets, images, audio, video
└── README.md                # This file
```

## Dependencies

**Backend**: FastAPI, openai, anthropic, google-generativeai, httpx, aiosqlite, sse-starlette, faster-whisper, jiwer, opencv-python-headless, Pillow

**Frontend**: React 18, Vite, Tailwind CSS v4, recharts, react-dropzone

**Optional**: lm-eval (for Benchmarks tab), ollama (for local models)
