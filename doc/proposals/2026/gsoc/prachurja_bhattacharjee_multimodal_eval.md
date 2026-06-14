# GSoC 2026 Proposal — Multimodal AI and Agent API Eval Framework

**Organization:** API Dash (foss42/apidash)  
**Contributor:** Prachurja Bhattacharjee  
**Email:** prachurjabhattacharjee99@gmail.com  
**GitHub:** [github.com/Prachurja](https://github.com/prachurja99)  
**LinkedIn:** [linkedin.com/in/prachurja-bhattacharjee](www.linkedin.com/in/prachurja-bhattacharjee-94568b281)  
**Location:** Dhaka, Bangladesh (UTC+6)  
**University:** BRAC University — BSc in Computer Science and Engineering  
**CGPA:** 3.87 / 4.00 (Merit Scholarship Recipient)  
**Expected Graduation:** January 2026  
**Project Size:** 90 hours (Small)  

---

## Table of Contents

1. [Abstract](#abstract)
2. [The Problem](#the-problem)
3. [Proposed Solution](#proposed-solution)
4. [Technical Architecture](#technical-architecture)
5. [Implementation Plan](#implementation-plan)
6. [Week-by-Week Timeline](#week-by-week-timeline)
7. [About Me](#about-me)
8. [Relevant Projects](#relevant-projects)
9. [Why I Am the Right Contributor](#why-i-am-the-right-contributor)
10. [Availability and Commitments](#availability-and-commitments)
11. [Post-GSoC Plans](#post-gsoc-plans)

---

## Abstract

API Dash is a powerful open-source API client used by developers to create, test, and inspect API requests. As AI APIs become central to modern development workflows, developers increasingly need to evaluate AI model outputs systematically — not just send a single request and read a single response, but run structured evaluations across datasets, compare providers, score outputs with standard metrics, and visualize results clearly.

Currently, API Dash has no dedicated framework for this. Developers must piece together external Python scripts, spreadsheets, and manual inspection workflows. This project closes that gap by building a first-class **Multimodal AI and Agent API Eval Framework** directly inside API Dash — covering text, image, and audio modalities, supporting standard benchmarking tools, enabling multi-provider comparison, and presenting results in an intuitive dashboard.

The outcome will be a production-quality evaluation layer that makes API Dash the tool of choice for developers working seriously with AI APIs.

---

## The Problem

Developers working with AI APIs today face three compounding problems:

**1. No structured evaluation workflow.** Sending one request and eyeballing the response is not evaluation. Real evaluation requires running a model against a dataset, aggregating scores, and comparing outputs — but no existing API client makes this easy.

**2. Multimodal APIs are not supported by evaluation tools.** Modern AI APIs accept text, images, and audio together. Evaluation frameworks like lm-harness were built for text-only models. There is no tool that handles multimodal API evaluation with a clean UI.

**3. Provider comparison is manual and slow.** Developers who want to compare GPT-4o, Gemini, and Claude on the same task must write custom scripts, manage API keys in multiple places, and manually collate results. This friction slows down the critical decision of which AI provider to use.

API Dash is already the tool developers use to interact with APIs. It is the right place to solve all three problems.

---

## Proposed Solution

I propose building the Multimodal AI and Agent API Eval Framework as a new, self-contained module inside API Dash with three layers:

**Layer 1 — Evaluation Configuration UI** (React + TypeScript)  
A dedicated Eval tab where developers configure evaluation runs: upload datasets, set model parameters, select metrics, and choose providers to compare.

**Layer 2 — Evaluation Engine** (Python)  
A backend engine that executes evaluation runs, computes metrics (BLEU, ROUGE-L, BERTScore, Exact Match, WER, SSIM, CLIP Score), integrates with lm-harness and lighteval for standard benchmarks, and handles multimodal inputs.

**Layer 3 — Results Dashboard** (React + Recharts)  
A results visualization panel showing score summaries, provider leaderboards, response diffs, run history, and export options (CSV, PDF).

---

## Technical Architecture

```
┌─────────────────────────────────────────────────────┐
│                   API Dash Frontend                  │
│                                                     │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────┐ │
│  │  Eval Config │  │ Results View │  │  Run Hist. │ │
│  │  (React/TS)  │  │  (Recharts)  │  │  (SQLite)  │ │
│  └──────┬──────┘  └──────┬───────┘  └─────┬──────┘ │
│         │                │                │         │
└─────────┼────────────────┼────────────────┼─────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────┐
│               Python Evaluation Engine               │
│                                                     │
│  ┌────────────┐  ┌────────────┐  ┌───────────────┐  │
│  │  Text Eval  │  │ Multimodal │  │  Benchmark    │  │
│  │  BLEU/ROUGE │  │ SSIM/CLIP  │  │  lm-harness   │  │
│  │  BERTScore  │  │  WER/CER   │  │  lighteval    │  │
│  └────────────┘  └────────────┘  └───────────────┘  │
└──────────────────────────┬──────────────────────────┘
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │  OpenAI  │    │  Gemini  │    │ Anthropic│
    │   API    │    │   API    │    │   API    │
    └──────────┘    └──────────┘    └──────────┘
```

### Dataset Support
- CSV and JSONL file upload
- Hugging Face datasets (via `datasets` library)
- Custom user-defined prompt-response pairs

### Metric Coverage

| Modality | Metrics |
|----------|---------|
| Text | BLEU, ROUGE-L, BERTScore, Exact Match, F1 |
| Audio | WER (Word Error Rate), CER (Character Error Rate) |
| Image | SSIM, CLIP Score |
| Agent | Tool call accuracy, step success rate, final answer correctness |

### Tech Stack

| Component | Technology |
|-----------|-----------|
| Frontend UI | React, TypeScript (existing API Dash codebase) |
| Eval Engine | Python (FastAPI microservice) |
| Benchmarks | lm-harness, lighteval |
| Visualization | Recharts |
| Storage | SQLite (eval history), local filesystem (datasets) |
| Multimodal | Pillow, librosa, sentence-transformers, openai-clip |

---

## Implementation Plan

### Phase 1 — Foundation (Weeks 1–4)

**Goal:** Working single-model text evaluation pipeline end-to-end.

- Set up the Python evaluation engine as a FastAPI microservice
- Implement text metrics: BLEU, ROUGE-L, BERTScore, Exact Match, F1
- Build the Eval tab UI skeleton in React/TypeScript:
  - Dataset upload panel (CSV, JSONL)
  - Single-request eval configuration form
  - Basic results table
- Connect frontend to Python engine via REST
- Write unit tests for metric computation and UI components

**Deliverable:** A user can upload a CSV dataset, run it against a single text AI API, and see BLEU/ROUGE scores in the UI.

### Phase 2 — Multimodal and Multi-Provider (Weeks 5–9)

**Goal:** Full multimodal support and provider comparison mode.

- Extend the engine to handle image inputs (Pillow, CLIP)
- Extend the engine to handle audio inputs (librosa, WER/CER)
- Test against multimodal APIs: GPT-4o Vision, Gemini Vision
- Build provider comparison mode: run same dataset across multiple AI providers simultaneously
- Build side-by-side response diff viewer in the UI
- Add async batch processing so large eval runs do not block the UI

**Deliverable:** A user can run the same image+text prompt across GPT-4o and Gemini Vision simultaneously and see a side-by-side score comparison.

### Phase 3 — Benchmarks, Dashboard, Export (Weeks 10–13)

**Goal:** Production-quality results dashboard, benchmark integration, and export.

- Integrate lm-harness and lighteval for standard AI benchmarks
- Build score leaderboard and chart dashboard using Recharts
- Implement run history panel backed by SQLite
- Add export to CSV and PDF
- Write comprehensive documentation and a usage guide
- Performance optimization, edge case handling, final testing

**Deliverable:** A fully functional eval framework that any developer can use out of the box.

---

## Week-by-Week Timeline

| Week | Deliverable |
|------|-------------|
| 1 | Community bonding: deep dive into API Dash codebase, set up dev environment, identify integration points, make 1–2 small PRs to get familiar with the contribution workflow |
| 2 | Design eval module architecture with mentor input. Finalize API contracts between frontend and Python engine |
| 3 | Build Eval tab UI skeleton: dataset upload panel, configuration form. Write UI unit tests |
| 4 | Build Python evaluation engine: BLEU, ROUGE-L, BERTScore, Exact Match, F1. Connect to frontend via REST. Integration tests |
| 5 | Midterm checkpoint: working text eval pipeline end-to-end. Submit midterm evaluation report |
| 6 | Multimodal image support: extend UI and engine for image+text inputs. SSIM and CLIP score implementation |
| 7 | Test multimodal pipeline against GPT-4o Vision and Gemini Vision APIs. Fix issues and edge cases |
| 8 | Audio input support: WER and CER metrics via librosa. Test against speech and audio APIs |
| 9 | Provider comparison mode: simultaneous multi-provider eval runs. Side-by-side diff viewer |
| 10 | lm-harness and lighteval integration. Standard benchmark runner UI |
| 11 | Score leaderboard dashboard using Recharts. Run history panel backed by SQLite |
| 12 | CSV and PDF export. Performance optimization. Comprehensive documentation |
| 13 | Buffer week: mentor feedback, bug fixes, UI polish, final tests, submission report and demo video |

---

## About Me

I am a final-year Computer Science and Engineering student at BRAC University, Bangladesh (CGPA 3.87/4.00, Merit Scholarship Recipient, expected graduation January 2026). I am a full-stack and AI/ML engineer with hands-on experience building production-grade applications, training and evaluating deep learning models, and integrating LLM APIs into real systems.

My technical stack maps directly to API Dash's needs:

- **Languages:** Python, JavaScript, TypeScript, Java, C
- **Backend:** Node.js, Express.js, Django, Flask, REST APIs, FastAPI, Socket.IO
- **Frontend:** React.js, TypeScript, Recharts, TailwindCSS, Vite
- **AI/ML:** PyTorch, TensorFlow, Keras, Scikit-learn, Whisper, Wav2Vec 2.0, ALBERT, Groq LLM, sentence-transformers
- **Data:** Pandas, NumPy, Matplotlib
- **Tools:** Git, GitHub, CUDA, Vercel, Render, MongoDB Atlas

---

## Relevant Projects

### Brain Tumor MRI Segmentation and Classification
*PyTorch, Python, Deep Learning*

Implemented U-Net, Attention U-Net, and a Multi-Task Joint Model in PyTorch on the BRATS 2025 dataset. Achieved 99.10% classification accuracy across 4 tumor types, 0.8731 Dice coefficient and 0.7843 IoU for segmentation, and 62% faster training via joint training. This project required designing and running rigorous evaluation pipelines across multiple model architectures — exactly the kind of systematic model comparison this project will enable for AI APIs.

### Real-Time Closed Captioning for Bengali Multimedia
*Whisper, Wav2Vec 2.0 (XLSR), Python*

Built a low-latency Bengali speech-to-text system with VAD-based chunking and noise suppression. Evaluated the system using WER and CER metrics across multiple model checkpoints. This is the direct technical foundation for the audio evaluation component of this project — I have already implemented WER/CER pipelines from scratch and understand their edge cases deeply.

### Disaster Tweet Classification
*ALBERT, Bi-LSTM, Bi-GRU, RNN, Python*

Trained and compared four NLP architectures (RNN, Bi-LSTM, Bi-GRU, ALBERT) for binary disaster tweet classification. ALBERT achieved 82% accuracy. Personally implemented the Bi-LSTM and GRU pipelines and led data preprocessing and model evaluation. This project demonstrates my ability to run structured model comparison experiments — the core purpose of this eval framework.

### Smart Student Tracker — AI-Powered Academic Platform
*Groq LLM, Scikit-learn, React, Node.js, PostgreSQL, MongoDB*

Built a full-stack platform with dual database architecture, JWT authentication, role-based access across three dashboards, a Scikit-learn ML microservice for real-time academic risk assessment, and a context-aware Groq LLM chatbot. Deployed across Vercel, Render, and Neon PostgreSQL. This demonstrates my ability to build and integrate AI/ML backends with full-stack React/Node frontends — the same architecture this project uses.

### SpendSmart — AI-Powered Expense Tracker
*Groq LLM, Recharts, React, Node.js, MongoDB*

Built a full-stack MERN application with Groq LLM integration for natural language expense categorization and interactive data visualizations using Recharts. Recharts is the same library API Dash uses for its dashboards — I am already productive with it and know its API well.

---

## Why I Am the Right Contributor

Three things make my profile uniquely suited to this project:

**I have already built AI evaluation pipelines.** My Bengali speech recognition project required implementing WER/CER from scratch, evaluating multiple checkpoints, and comparing model outputs systematically. My brain tumor project required comparing U-Net, Attention U-Net, and joint models on Dice, IoU, and accuracy metrics. I do not need to learn what evaluation means — I need to build the tooling that makes it easier for everyone else.

**I can work across the entire API Dash tech stack without ramp-up.** I have shipped production applications in React, TypeScript, Node.js, and Python. I have integrated Groq LLM, Scikit-learn, and Recharts in real projects. API Dash's tech stack is my everyday stack.

**I have done this kind of cross-modality metric work before.** Audio (WER/CER via Whisper), image (Dice/IoU for segmentation masks), text (accuracy, F1 for classification) — I have computed evaluation metrics across all three modalities in separate projects. This project brings them together into one framework, which is the engineering challenge I am most excited to tackle.

---

## Availability and Commitments

I have no other internship, job, or academic commitments during the GSoC coding period. My expected graduation is January 2026, so the program timeline aligns perfectly with my schedule.

- Available hours per week: 35–40 hours
- Time zone: Bangladesh Standard Time (UTC+6)
- I will attend the weekly mentor connect sessions without exception
- I will respond to Discord messages within 24 hours
- I will submit weekly progress updates proactively and raise blockers early rather than silently
- I have read and agree to the API Dash AI Usage Policy

---

## Post-GSoC Plans

The Multimodal AI Eval Framework is a feature that will grow with the AI API landscape. After GSoC, I plan to remain an active contributor — adding support for new modalities (video), new benchmark integrations, new AI providers, and improvements based on community feedback. I see this as a long-term contribution to API Dash rather than a bounded summer project.

---

*Thank you for the opportunity to apply. I have spent time understanding API Dash's codebase, reading past GSoC proposals, and thinking carefully about how to build this feature in a way that feels native to the project. I am ready to start immediately and committed to delivering something the community will use.*

**Prachurja Bhattacharjee**  
prachurjabhattacharjee99@gmail.com
