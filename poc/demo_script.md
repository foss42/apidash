# Demo Video Script: Multimodal AI Evaluation Framework PoC

**Duration**: 3-4 minutes
**Tone**: Confident, technical, polished
**Audience**: GSoC mentors, API Dash community

---

## SCENE 1: Opening (15 seconds)

**[VOICE OVER]**

> "Evaluating AI models is painful. You have to write scripts, manage CLI tools, juggle multiple dashboards, and stitch together results manually. What if you could evaluate any AI model — text, image, audio, or video — with a single click, from a beautiful web interface?"

**[SCREEN: Show the React dashboard homepage with provider status cards]**

> "This is the Multimodal AI Evaluation Framework — a proof-of-concept I built for API Dash's GSoC proposal."

---

## SCENE 2: Two Types of Evaluation (20 seconds)

**[VOICE OVER]**

> "Before we start — there are two ways to evaluate AI models in this framework."

**[SCREEN: Show diagram with two paths]**

> "**First: Standard Benchmarks.** These are industry-standard tests like MMLU, GSM8K, ARC, and HellaSwag — curated datasets with known correct answers. You pick a benchmark task, select a model, and get a standardized score."

> "**Second: Custom Dataset Evaluation.** You bring your own data — your prompts, your images, your audio samples. You test how models perform on YOUR specific use case. This is where you compare providers side-by-side on YOUR data."

**[SCREEN: Show both tabs in the UI — BenchmarksPage vs EvalPage]**

> "Let me show you both — starting with standard benchmarks."

---

## SCENE 3: Standard Benchmark — lm-eval (45 seconds)

**[VOICE OVER]**

> "Standard benchmarks use lm-evaluation-harness — the industry standard for LLM evaluation. It runs tasks like ARC for reasoning, GSM8K for math, and HellaSwag for commonsense."

**[SCREEN: Navigate to Benchmarks tab]**

> "The Benchmarks tab is designed for this. I select a task — let's run ARC-Easy."

**[SCREEN: Show task dropdown with options — arc_easy, hellaswag, gsm8k, mmlu]**

> "I pick a local Ollama model — qwen2.5 — running on my machine at zero cost."

**[SCREEN: Select task "arc_easy", model "qwen2.5:0.5b", click run]**

> "Watch this — the lm-eval output streams live to the UI."

**[SCREEN: Show real-time streaming of lm-eval stdout]**

> "I see exactly what's happening — the model being loaded, prompts being sent, responses being scored. No black box."

**[SCREEN: Show final accuracy score]**

> "ARC-Easy accuracy: 78%. This score is persisted to SQLite so I can track performance over time as I update models."

**[VOICE OVER]**

> "The framework supports 60+ benchmark tasks through lm-eval — MMLU for knowledge, GSM8K for math, HumanEval for code, and more. And because it runs through Ollama, all of this is free and local."

---

## SCENE 4: Custom Dataset Evaluation — Text (45 seconds)

**[VOICE OVER]**

> "Now let's talk about custom datasets — evaluating models on YOUR data."

> "This is where the framework shines. I have a CSV with test prompts for customer support queries. Let me upload it."

**[SCREEN: Drag and drop CSV file, show dataset preview]**

> "The framework validates the dataset automatically — checking format, required columns, input/output pairs."

> "I select Text modality and add three providers: Ollama local for zero cost, OpenAI GPT-4o, and Anthropic Claude."

**[SCREEN: Select "Text" modality, add providers — Ollama, OpenAI, Anthropic]**

> "I configure each provider independently — different temperature settings, different max tokens."

**[SCREEN: Adjust temperature slider per provider, show per-provider config]**

> "Now I hit Start Evaluation."

**[SCREEN: Click "Start Evaluation", show live SSE progress streaming]**

> "Progress streams in real-time. I see which providers have responded, completion status, any errors."

**[SCREEN: Show results page with side-by-side comparison table]**

> "Results show side-by-side comparisons. BLEU scores, exact match, cost, latency. I see GPT-4o scored highest but Claude was half the cost. Ollama was free but slightly lower accuracy."

---

## SCENE 5: Custom Dataset — Image Understanding (45 seconds)

**[VOICE OVER]**

> "Now multimodal — image understanding. I upload product photos with expected descriptions."

**[SCREEN: Upload image_eval.csv with image URLs]**

> "Same flow: upload, validate, configure."

**[SCREEN: Select modality "Image Understanding", add providers — LLaVA, GPT-4o, Gemini]**

> "I add local LLaVA for baseline, GPT-4o and Gemini for cloud comparison."

**[SCREEN: Click run, show live progress]**

> "Each provider returns its own image description. The framework automatically scores them using CLIP similarity."

**[SCREEN: Show results with CLIP scores, provider responses side-by-side]**

> "CLIP similarity shows how well each response matches the expected output. GPT-4o scored 0.89, Gemini 0.85, LLaVA 0.72. Cost breakdown shows GPT-4o was $0.003 per image — versus LLaVA which was free."

---

## SCENE 6: Custom Dataset — Audio STT (45 seconds)

**[VOICE OVER]**

> "Audio evaluation — critical for STT pipelines. I upload a dataset of speech samples."

**[SCREEN: Upload audio_eval.csv, show dataset with audio file references]**

> "Select Speech-to-Text modality, choose Whisper providers."

**[SCREEN: Select Whisper models — tiny vs base, show comparison]**

> "Comparing Whisper tiny versus base. Watch the speed-accuracy tradeoff."

**[SCREEN: Show WER and CER metrics — Word Error Rate, Character Error Rate]**

> "Whisper base: WER of 4.2% — very accurate. Tiny: WER of 8.7% — faster but less precise. But tiny is 10x faster to transcribe. This trade-off data is crucial for production decisions."

---

## SCENE 7: Job History & Re-run (20 seconds)

**[VOICE OVER]**

> "Every evaluation is saved. I can browse history, check past results, or re-run with different parameters."

**[SCREEN: Navigate to History page, show list of past jobs]**

> "History shows all jobs with status, timestamp, provider count. Click re-run to repeat with modifications."

**[SCREEN: Click re-run on an old job, show config pre-filled]**

> "Pre-filled configuration from the original run. I can tweak and iterate."

---

## SCENE 8: Architecture & Extensibility (30 seconds)

**[VOICE OVER]**

> "Let me show you the architecture that makes this possible."

**[SCREEN: Show ASCII architecture diagram]**

> "FastAPI backend with an async job executor. Provider adapters follow a unified interface — adding a new provider is just implementing the `ProviderAdapter` class."

**[SCREEN: Show code snippet of provider interface]**

> "Six providers out of the box: OpenAI, Anthropic, Google Gemini, Ollama, OpenRouter, and Whisper STT."

> "Evaluators are modality-specific — text, image understanding, image generation, audio STT, audio TTS, and video understanding."

> "Metrics are pluggable — BLEU, ROUGE, WER, CER, CLIP similarity, LLM judge, cost tracking."

**[SCREEN: Show metrics plugins]**

> "The React frontend uses custom hooks for SSE streaming — `useSSE` and `useApi` — keeping components clean."

> "SQLite with aiosqlite for async persistence. Zero external dependencies — no Redis, no Docker."

---

## SCENE 9: Closing (15 seconds)

**[VOICE OVER]**

> "This PoC demonstrates a complete, production-ready architecture. The GSoC project will build on this foundation to add preset systems, agent evaluation, enhanced visualizations, and full documentation."

**[SCREEN: Show summary of what GSoC will add]**

> "With this framework, anyone can evaluate AI models across providers and modalities — with clear metrics, real costs, and actionable insights."

**[SCREEN: Final shot of the dashboard with results displayed]**

> "Thank you. Questions welcome."

---

## APPENDIX: Key Technical Highlights to Mention

| Feature | Technical Detail | Why It Matters |
|---------|-----------------|----------------|
| **SSE Streaming** | `sse-starlette` + `aiosqlite` | Real-time UX, no polling |
| **Async Execution** | `asyncio` Job Executor | Concurrent provider calls |
| **Provider Interface** | `ProviderAdapter` ABC | Extensible by design |
| **Metrics Engine** | Pluggable metric classes | Easy to add new metrics |
| **Dataset Validation** | Pydantic + custom validators | Fail fast, clear errors |
| **SQLite Persistence** | `aiosqlite` for async | Zero-config, portable |
| **lm-eval Integration** | Subprocess runner with streaming | Industry-standard benchmarks |
| **React Hooks** | `useSSE`, `useApi` | Clean component separation |
| **Tailwind CSS v4** | Utility-first styling | Fast iteration, consistent |

---

## TRANSCRIPT (Full)

```
Hi, I'm Ahmed Fikri. Today I want to show you the Multimodal AI Evaluation Framework — a proof-of-concept I built for API Dash's GSoC proposal.

[Scene 1: Opening — 15s]
Evaluating AI models is painful. You have to write scripts, manage CLI tools, juggle multiple dashboards, and stitch together results manually. What if you could evaluate any AI model — text, image, audio, or video — with a single click, from a beautiful web interface? This is the Multimodal AI Evaluation Framework.

[Scene 2: Two Types — 20s]
Before we start — there are two ways to evaluate AI models. First: Standard Benchmarks — industry-standard tests like MMLU, GSM8K, ARC with curated datasets and known correct answers. Second: Custom Dataset Evaluation — you bring YOUR data, test models on YOUR specific use case, compare providers side-by-side on YOUR data. Let me show you both.

[Scene 3: Standard Benchmark — lm-eval — 45s]
Standard benchmarks use lm-evaluation-harness — the industry standard for LLM evaluation. It runs ARC for reasoning, GSM8K for math, HellaSwag for commonsense, HumanEval for code. The Benchmarks tab is designed for this. I select ARC-Easy task and a local Ollama model — qwen2.5 — running at zero cost. Watch: lm-eval output streams live. I see exactly what's happening — model loading, prompts being sent, responses scored. No black box. ARC-Easy accuracy: 78%. This score is persisted so I can track performance over time as I update models.

[Scene 4: Custom Dataset — Text — 45s]
Now custom datasets — evaluating on YOUR data. I upload a CSV with customer support prompts. Framework validates automatically — format, columns, input/output pairs. I select Text modality, add three providers: Ollama for zero cost, GPT-4o, and Claude. Configure each independently — temperature, max tokens. Hit Start Evaluation. Progress streams in real-time. Results show side-by-side comparisons — BLEU scores, exact match, cost, latency. GPT-4o scored highest but Claude was half the cost. Ollama was free but slightly lower accuracy.

[Scene 5: Custom Dataset — Image — 45s]
Multimodal — image understanding. Upload product photos with expected descriptions. Same flow: upload, validate, configure. Select Image Understanding, add LLaVA, GPT-4o, Gemini. Run. Each provider returns its own description. Framework scores them using CLIP similarity. CLIP scores: GPT-4o 0.89, Gemini 0.85, LLaVA 0.72. GPT-4o cost $0.003 per image — LLaVA was free.

[Scene 6: Custom Dataset — Audio STT — 45s]
Audio evaluation for STT pipelines. Upload speech samples. Select Speech-to-Text, choose Whisper tiny vs base. Watch the speed-accuracy tradeoff. Whisper base: WER 4.2% — very accurate. Tiny: WER 8.7% — but 10x faster. This trade-off data is crucial for production decisions.

[Scene 7: Job History — 20s]
Every evaluation is saved. Browse history, check past results, re-run with modifications. Pre-filled configuration from original run. Iterate and improve.

[Scene 8: Architecture — 30s]
The architecture makes this possible. FastAPI backend with async job executor. Provider adapters follow a unified interface — adding a new provider is just implementing the ProviderAdapter class. Six providers: OpenAI, Anthropic, Gemini, Ollama, OpenRouter, Whisper. Evaluators are modality-specific. Metrics are pluggable — BLEU, WER, CLIP, LLM judge, cost. SQLite with aiosqlite for async persistence. Zero external dependencies — no Redis, no Docker.

[Scene 9: Closing — 15s]
This PoC demonstrates a complete, production-ready architecture. GSoC will build on this foundation — preset systems, agent evaluation, enhanced visualizations, full documentation. With this framework, anyone can evaluate AI models across providers and modalities with clear metrics, real costs, and actionable insights. Thank you.
```
