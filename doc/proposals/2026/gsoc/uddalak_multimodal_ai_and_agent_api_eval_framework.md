# GSoC 2026 Application — Multimodal AI and Agent API Eval Framework

---

### About

1. **Full Name**: Uddalak Mukhopadhyay
2. **Contact Info**: uddalakmukhopadhyay@gmail.com
3. **Discord Handle**: uddalak_mukhopadhyay *(on API Dash Discord server)*
4. **Home Page**: https://uddalakmukhopadhyay.netlify.app/
5. **Blog**: N/A
6. **GitHub Profile**: https://github.com/uddalak2005
7. **Socials**:
   - LinkedIn: https://www.linkedin.com/in/uddalak-mukhopadhyay/
   - Twitter/X: https://x.com/UddalakMukherji
8. **Time Zone**: IST (UTC+5:30)
9. **Resume**: https://drive.google.com/file/d/1LmujCGXBezi0QUxghL1wCe1xZvvBdPJf/view?usp=sharing *(publicly accessible)*

---

### University Info

1. **University Name**: Siksha 'O' Anusandhan University (SOA University), Bhubaneswar
2. **Program**: B.Tech in Computer Science and Engineering
3. **Year**: 3rd Year
4. **Expected Graduation Date**: May 2027

---

### Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

I have not made formal open-source contributions yet, but GSoC 2026 with API Dash is my deliberate first step into the FOSS ecosystem. My experience building production-grade systems at internships and hackathons has prepared me well for collaborative open-source development. I am actively setting up the API Dash codebase locally and plan to raise my first PR on an existing issue before the proposal deadline.

**2. What is your one project/achievement that you are most proud of? Why?**

My proudest project is **AgroSure** — an AI-powered fintech platform for agricultural insurance and risk management. The project combined machine learning for crop risk prediction, a React-based dashboard for farmers, and a Node.js/Express backend for real-time data processing. It was built under intense hackathon pressure (32 hours, offline) and won **1st Runners Up at Hexafalls**. It was also recognized as a Finalist at **Smart India Hackathon (SIH) 2024**. What made it special was that it was not just a prototype — it addressed a real gap in how smallholder farmers access structured financial risk tools. The end-to-end system design, the AI integration, and the stakeholder impact all came together in a way I was genuinely proud of.

**3. What kind of problems or challenges motivate you the most?**

I am most motivated by problems at the intersection of AI and developer tooling — where building the right infrastructure enables an entire ecosystem of people to do better work. The challenge of making AI evaluation accessible, reproducible, and multimodal is exactly this kind of problem. Right now, running evals on LLMs requires significant expertise and setup. If API Dash can make this as simple as clicking "run" with a nice UI, it genuinely changes how developers test and trust AI APIs. That scale of impact motivates me deeply.

**4. Will you be working on GSoC full-time?**

Yes, I will be working on GSoC full-time during the summer period. My university schedule allows for this, and I have no conflicting internship or academic commitments planned for the GSoC coding period. I am fully committed to dedicating 40+ hours per week to this project.

**5. Do you mind regularly syncing up with the project mentors?**

Not at all — I actively welcome it. Regular syncs, code reviews, and feedback loops are how I learn and improve fastest. I am comfortable with weekly video calls, async updates on Discord, and sharing WIP code for early review. I understand that mentors invest significant time in GSoC students, and I intend to make that investment worthwhile.

**6. What interests you most about API Dash?**

Two things stand out. First, API Dash is one of the very few developer tools that is genuinely cross-platform, AI-native, and built with a modern stack — it is not just another Postman clone. Second, the GSoC 2026 theme around MCP testing and multimodal AI eval is exactly where the industry is heading. Working in the Agentic AI department at Samsung, I see firsthand how much friction developers face when trying to evaluate and trust AI APIs in production — there is simply no great tooling for this today. API Dash is positioned to own that space, and I want to help build it.

**7. Areas where the project can be improved:**

- **Eval Framework Gap**: There is currently no easy way for a developer to point API Dash at an AI API, upload a dataset, and get structured eval results back. This is the core gap this project addresses.
- **Agent API Testing**: Multi-turn, tool-calling agent APIs cannot currently be tested or evaluated in any meaningful way within API Dash.
- **Multimodal Response Visualization**: Image and audio model responses are previewed but not evaluated — there is no scoring, comparison, or benchmark layer.
- **Dataset Management**: No built-in support for uploading or managing eval datasets (JSONL, CSV, benchmark formats like MMLU or HellaSwag).

**8. Community Interaction with API Dash:**

I have joined the API Dash Discord server (handle: `uddalak_mukhopadhyay`) and introduced myself in the #gsoc-foss-apidash channel. I am currently setting up the project locally and exploring open issues to make my first contribution. I will link my PR here once submitted.

---

### Project Proposal Information

---

#### 1. Proposal Title

**Multimodal AI and Agent API Eval Framework for API Dash**

---

#### 2. Abstract

As AI APIs — spanning text, image, voice, and agentic systems — become the primary integration surface for modern applications, developers urgently need a way to evaluate them: systematically, reproducibly, and without deep ML expertise. Today, running LLM benchmarks (like lm-evaluation-harness or lighteval) requires complex local setup, and there is no unified UI that bridges benchmark runners, custom datasets, and multimodal AI APIs.

This project proposes to build an end-to-end **Multimodal AI and Agent API Eval Framework** inside API Dash. The framework will consist of: (1) a React/TypeScript frontend for configuring eval requests, uploading datasets, and visualizing results; (2) a Python FastAPI backend that integrates with standard eval libraries and orchestrates API calls; and (3) first-class support for text, image, voice, and agent-based AI API evaluation — all accessible through API Dash's existing beautiful UI paradigm.

---

#### 3. Detailed Description

##### 3.1 Problem Statement

The AI API ecosystem has fragmented evaluation tooling:
- **lm-evaluation-harness** (EleutherAI) and **lighteval** (HuggingFace) are powerful but CLI-only and require significant setup.
- There is no unified UI to configure, run, and compare evals across multiple AI providers (OpenAI, Anthropic, Gemini, open-source models via HuggingFace).
- Multimodal models (image captioning, speech-to-text, vision QA) have almost no standardized eval tooling accessible to the average developer.
- Agent API evaluation (tool use, multi-turn reasoning, task completion) is an open problem with no good tooling at all.

API Dash already handles API request construction and response visualization beautifully. The missing layer is evaluation — the ability to ask "how well does this AI API actually perform on my task?"

##### 3.2 Proposed Architecture

The system will follow a clean 3-layer architecture:

<img width="1640" height="1340" alt="image" src="https://github.com/user-attachments/assets/4ec45620-5b19-4003-814e-46bf1eefa6d7" />


**Frontend (React/TypeScript):**
- Eval configuration panel: select AI provider, model, endpoint, auth
- Dataset manager: upload JSONL/CSV, select from built-in benchmarks (MMLU, HellaSwag, TruthfulQA, etc.)
- Modality selector: Text, Image (vision QA), Audio (ASR), Agent (tool-use tasks)
- Results dashboard: accuracy, latency, cost per token, side-by-side comparison across providers
- Export results as JSON/CSV for reproducibility

**Backend (Python FastAPI):**
- Provider adapters for OpenAI, Anthropic, Google Gemini, HuggingFace Inference API, Ollama (local)
- Integration with `lm-evaluation-harness` for standard LLM text benchmarks
- Integration with `lighteval` for HuggingFace-native model eval
- Custom eval runner for multimodal tasks (image, audio)
- Agent eval engine: multi-turn conversation management, tool call parsing, task completion scoring — drawing directly from my hands-on experience building multi-agent systems at Samsung using LangChain and AutoGen
- Async task queue (using `asyncio` / `Celery`) for long-running eval jobs
  <img width="1900" height="1534" alt="image" src="https://github.com/user-attachments/assets/381315ec-b5e4-4e11-b515-e058b2f4696e" />


##### 3.3 Feature Breakdown

**Phase 1 — Core Text Eval (Weeks 1–5)**
- FastAPI backend scaffold with provider adapters (OpenAI, Anthropic, Gemini)
- React frontend: basic eval config UI, dataset upload (JSONL/CSV)
- Integration with lm-evaluation-harness for standard benchmarks
- Results dashboard: accuracy, pass@k, latency metrics

**Phase 2 — Multimodal Eval (Weeks 6–9)**
- Image model eval: vision QA tasks (VQA v2, MMMU), captioning (COCO)
- Audio model eval: ASR accuracy (WER/CER), speech classification tasks
- Provider adapters extended for multimodal endpoints (GPT-4o, Gemini Vision, Whisper)
- UI updated with modality-specific result visualizations (image previews, audio waveforms)

**Phase 3 — Agent API Eval (Weeks 10–13)**
- Agent eval engine: multi-turn conversation runner, tool call interception
- Task benchmarks: tool use accuracy, task completion rate, context retention
- Support for OpenAI function calling format and Anthropic tool use format
- Leaderboard-style comparison across agent configurations

**Phase 4 — Polish, Docs & Testing (Week 14)**
- End-to-end test suite (pytest for backend, Vitest/Playwright for frontend)
- Documentation: user guide, API reference, architecture notes
- Final PR and mentor review

  <img width="1880" height="1234" alt="image" src="https://github.com/user-attachments/assets/9c6d807e-0264-4d82-bc3d-5c22febdde44" />


##### 3.4 Key Technical Decisions

- **FastAPI over Flask**: async-native, modern type hints, automatic OpenAPI docs — aligns with API Dash's philosophy of good developer UX.
- **Provider Adapter Pattern**: each AI provider is a separate adapter implementing a common interface, making it easy to add new providers without touching the core.
- **JSONL as canonical dataset format**: matches lm-evaluation-harness and lighteval conventions, enabling direct use of community benchmarks.
- **React + Recharts for visualization**: consistent with existing web tooling preferences and produces beautiful charts without heavy dependencies.
- **GPU access for eval**: As noted by the org, GPU access will be provided for projects requiring it — this will be used for running open-source model evals via HuggingFace.

---

#### 4. Project Stucture

```
multimodal-eval-framework/
│
├── frontend/                          # React / TypeScript
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── components/
│   │   │   ├── EvalConfigPanel/
│   │   │   │   ├── EvalConfigPanel.tsx
│   │   │   │   ├── ProviderSelector.tsx
│   │   │   │   ├── ModelSelector.tsx
│   │   │   │   └── ModalityToggle.tsx
│   │   │   ├── DatasetManager/
│   │   │   │   ├── DatasetManager.tsx
│   │   │   │   ├── FileUploader.tsx
│   │   │   │   └── BenchmarkPicker.tsx
│   │   │   ├── ResultsDashboard/
│   │   │   │   ├── ResultsDashboard.tsx
│   │   │   │   ├── MetricsChart.tsx
│   │   │   │   ├── ComparisonTable.tsx
│   │   │   │   └── ExportButton.tsx
│   │   │   └── AgentLeaderboard/
│   │   │       ├── AgentLeaderboard.tsx
│   │   │       └── LeaderboardRow.tsx
│   │   ├── hooks/
│   │   │   ├── useEvalRunner.ts
│   │   │   ├── useDataset.ts
│   │   │   └── useResults.ts
│   │   ├── services/
│   │   │   ├── api.ts                 # Axios client to FastAPI backend
│   │   │   └── evalService.ts
│   │   ├── types/
│   │   │   ├── eval.types.ts
│   │   │   ├── provider.types.ts
│   │   │   └── dataset.types.ts
│   │   ├── App.tsx
│   │   └── main.tsx
│   ├── package.json
│   ├── tsconfig.json
│   └── vite.config.ts
│
├── backend/                           # Python / FastAPI
│   ├── app/
│   │   ├── main.py                    # FastAPI app entry point
│   │   ├── config.py                  # Settings, env vars
│   │   │
│   │   ├── routers/
│   │   │   ├── eval.py                # POST /eval/run, GET /eval/status
│   │   │   ├── datasets.py            # POST /datasets/upload
│   │   │   └── results.py             # GET /results/{eval_id}
│   │   │
│   │   ├── core/
│   │   │   ├── orchestrator.py        # EvalOrchestrator — routes & aggregates
│   │   │   ├── metrics.py             # accuracy, WER, BLEU, pass@k, etc.
│   │   │   └── task_queue.py          # Celery async task definitions
│   │   │
│   │   ├── adapters/
│   │   │   ├── base.py                # BaseProviderAdapter (ABC)
│   │   │   ├── openai_adapter.py      # GPT-4o, Whisper, DALL·E
│   │   │   ├── anthropic_adapter.py   # Claude 3.5, tool use
│   │   │   ├── gemini_adapter.py      # Gemini 1.5 Pro, Vision
│   │   │   └── huggingface_adapter.py # HF Inference API + lighteval
│   │   │
│   │   ├── runners/
│   │   │   ├── text_runner.py         # lm-eval-harness integration
│   │   │   ├── image_runner.py        # VQA, captioning (VQA v2, COCO)
│   │   │   ├── audio_runner.py        # ASR — WER/CER computation
│   │   │   └── agent_runner.py        # Multi-turn, tool call interception
│   │   │
│   │   ├── models/
│   │   │   ├── eval_request.py        # Pydantic request schemas
│   │   │   ├── eval_response.py       # Unified EvalResponse schema
│   │   │   └── dataset.py             # Dataset record model
│   │   │
│   │   └── utils/
│   │       ├── dataset_parser.py      # JSONL / CSV ingest & validation
│   │       ├── audio_utils.py         # Base64 encode/decode audio
│   │       └── image_utils.py         # Base64 encode/decode images
│   │
│   ├── tests/
│   │   ├── test_adapters/
│   │   │   ├── test_openai_adapter.py
│   │   │   ├── test_anthropic_adapter.py
│   │   │   └── test_gemini_adapter.py
│   │   ├── test_runners/
│   │   │   ├── test_text_runner.py
│   │   │   ├── test_image_runner.py
│   │   │   ├── test_audio_runner.py
│   │   │   └── test_agent_runner.py
│   │   └── test_core/
│   │       ├── test_orchestrator.py
│   │       └── test_metrics.py
│   │
│   ├── requirements.txt
│   ├── Dockerfile
│   └── celeryconfig.py
│
├── datasets/                          # Sample eval datasets
│   ├── sample_text.jsonl              # MMLU-style Q&A
│   ├── sample_agent.jsonl             # Tool-use task examples
│   └── README.md                      # Dataset format guide
│
├── docs/
│   ├── architecture.md
│   ├── user_guide.md
│   └── adding_a_provider.md          # How to extend with new adapter
│
├── docker-compose.yml                 # Frontend + Backend + Redis (Celery)
├── .env.example                       # API keys template
├── .gitignore
└── README.md
```

##### 4.1 Sample Provider Adapter Pattern
```python
from abc import ABC, abstractmethod
from typing import Any, Dict, List
import asyncio

class AIProviderAdapter(ABC):
    """Abstract interface for standardized AI API interaction."""
    
    @abstractmethod
    async def generate_response(self, prompt: str, schema: Dict = None) -> Dict[str, Any]:
        pass

class OpenAIAdapter(AIProviderAdapter):
    def __init__(self, api_key: str, model: str = "gpt-4o"):
        self.model = model
        # Internal client initialization here

    async def generate_response(self, prompt: str, schema: Dict = None) -> Dict[str, Any]:
        # Logic for tool-calling/structured output goes here
        # This demonstrates handling non-deterministic JSON outputs
        pass

class EvalOrchestrator:
    """Asynchronous runner to probe multiple providers concurrently."""
    async def run_benchmark(self, providers: List[AIProviderAdapter], dataset: List[str]):
        tasks = [p.generate_response(prompt) for p in providers for prompt in dataset]
        return await asyncio.gather(*tasks)
```

##### 4.2 Agentic Trajectory Validator
```typescript
// Frontend logic for visualizing Agent Tool-Call sequences
interface ToolCallTrace {
  step: number;
  toolName: string;
  arguments: Record<string, any>;
  isCorrectSchema: boolean;
}

export const validateAgentTrajectory = (
  actualTrace: ToolCallTrace[],
  goldStandard: string[] // Expected sequence of tool names
): number => {
  const correctSteps = actualTrace.filter(
    (trace, index) => trace.toolName === goldStandard[index] && trace.isCorrectSchema
  );
  
  // Return a "Trajectory Fidelity Score" (0.0 - 1.0)
  return correctSteps.length / goldStandard.length;
};
```

##### 4.3 Multimodal Heuristic: Word Error Rate (WER)
```python
import numpy as np

def calculate_wer(reference: str, hypothesis: str) -> float:
    """
    Computes Word Error Rate using dynamic programming.
    Demonstrates knowledge of ASR/Speech-to-Text evaluation.
    """
    r = reference.split()
    h = hypothesis.split()
    d = np.zeros((len(r) + 1) * (len(h) + 1), dtype=np.uint16)
    d = d.reshape((len(r) + 1, len(h) + 1))
    
    for i in range(len(r) + 1):
        for j in range(len(h) + 1):
            if i == 0: d[0][j] = j
            elif j == 0: d[i][0] = i
    
    for i in range(1, len(r) + 1):
        for j in range(1, len(h) + 1):
            if r[i-1] == h[j-1]:
                d[i][j] = d[i-1][j-1]
            else:
                substitution = d[i-1][j-1] + 1
                insertion = d[i][j-1] + 1
                deletion = d[i-1][j] + 1
                d[i][j] = min(substitution, insertion, deletion)
                
    return d[len(r)][len(h)] / len(r)
```


#### 5. Weekly Timeline

| Week | Dates (Approx.) | Deliverables |
|------|-----------------|-------------|
| **1** | May 27 – Jun 2 | Project setup, FastAPI scaffold, provider adapter interface defined. OpenAI & Anthropic text adapters working. Unit tests for adapters. |
| **2** | Jun 3 – Jun 9 | Dataset ingestion pipeline: JSONL/CSV upload, validation, storage. Basic React eval config UI (provider, model, dataset selector). |
| **3** | Jun 10 – Jun 16 | lm-evaluation-harness integration: run standard benchmarks (MMLU, HellaSwag) via API. Results returned to backend. |
| **4** | Jun 17 – Jun 23 | Results dashboard v1: accuracy, latency, cost metrics. Recharts visualizations. Export to JSON/CSV. |
| **5** | Jun 24 – Jun 30 | Gemini & HuggingFace Inference API adapters. Midpoint review with mentors. Bug fixes from Phase 1. |
| **6** | Jul 1 – Jul 7 | Image eval foundation: VQA dataset support, GPT-4o Vision & Gemini Vision adapters for image tasks. |
| **7** | Jul 8 – Jul 14 | Image eval metrics: accuracy, BLEU/CIDEr for captioning. UI: image preview in results, modality toggle. |
| **8** | Jul 15 – Jul 21 | Audio eval: Whisper & speech API adapters. WER/CER metric computation. Audio waveform visualization in UI. |
| **9** | Jul 22 – Jul 28 | Multimodal results dashboard: side-by-side provider comparison for image/audio. lighteval integration for HuggingFace models. |
| **10** | Jul 29 – Aug 4 | Agent eval engine: multi-turn conversation runner, tool call interception and logging. |
| **11** | Aug 5 – Aug 11 | Agent benchmarks: tool use accuracy, task completion rate. OpenAI function calling + Anthropic tool use format support. |
| **12** | Aug 12 – Aug 18 | Agent leaderboard UI: compare agent configs. Context retention scoring. Async task queue for long-running eval jobs. |
| **13** | Aug 19 – Aug 25 | End-to-end integration testing. Pytest suite for backend. Playwright tests for frontend flows. Performance profiling. |
| **14** | Aug 26 – Sep 1 | Documentation (user guide, API reference, architecture doc). Final PR. Buffer for mentor feedback and revisions. |

**Total: ~350 hours over 14 weeks (~25 hours/week, with intensive weeks reaching 35+ hours)**

---

#### 5. Why Me?

My background maps directly onto every layer of this project:

- **Agentic AI (Samsung Research)**: Working directly with LangChain, AutoGen, and LLM APIs to design and construct multi-agent systems, I am currently a Research Intern in the Agentic AI department at **Samsung Electronics**. This is directly related because the agent evaluation engine I'm suggesting is based on the same patterns I use on a daily basis at Samsung.
- **Python + AI/ML**: YOLOv8 pipelines (82% mAP on medical imaging) are being built during a research internship at the Indian Statistical Institute. familiar with the concepts of ML evaluation, TensorFlow, and PyTorch.
- **React + TypeScript + Node.js**: A1 Future Technologies' AI & Backend Intern developed Express REST APIs and integrated backend machine learning services. several full-stack hackathon initiatives.
- **API design & integration**: Extensive experience building and consuming REST APIs across hackathon projects and internship work.
- **Fast learner under pressure**: 1st Runners Up at two timed hackathons (30hr MLH, 32hr offline), SIH Finalist — I deliver under tight constraints.

---
**P.S.**  
I’m an incoming Summer Intern at Dell Technologies, where I’ll be working in the Agentic AI domain.  
Excited to share that I also cracked an MNC interview in the same field!
---

*I look forward to contributing to API Dash and making this eval framework a tool that the entire developer community can rely on. Please feel free to reach out on Discord (uddalak_mukhopadhyay) or email (uddalakmukhopadhyay@gmail.com) for any questions.*
