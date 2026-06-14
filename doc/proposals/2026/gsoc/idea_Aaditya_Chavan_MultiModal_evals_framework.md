Full Name: Aaditya Umesh Chavan
University: University of Mumbai (Atharva College of Engineering, Malad)
Program: B.E. Computer Engineering
Year: 1st Year
Expected Graduation: 2029
Project Title: Multimodal AI and Agent API Eval Framework
Relevant Issues: #1226

Experience :I have hands-on experience with LangChain, LangGraph, RAG pipelines,OpenAI Agent SDK, and MCP integration,Fastapi,Docker,SQLalchemy.I also contributed to the foss42/api repo (Issue #83), fixing error handling across country endpoints using FastAPI.

Personal Projects:1. Autonomous Multi-Agent Coding System ,i am working on this project where main motive is multi agents team built app(for ex.todo list app) with help of mcp server tools,in e2b sandboxes for safer execution.The main feature of my project is high multi orchestration of agents by which agents run parallel and also sequentially when needed.

### Idea Description

**Lets focus on pain points and give solution for such points and hence construct this project with first principle.**

## Why Evaluations?

--> The llm can hallucinate ,fail,partially fail in process of doing user's desire task.
TO MONITOR LLM'S CAPACITIES,BEHAVIOUR AND ACTIONS ,it is important while doing task .we can improve desire pipeline accordingly and Hence ,we achieve logical progress at every step

## How we can "MONITOR LLM'S CAPACITIES,BEHAVIOUR AND ACTIONS"?

--> we can do this by using evals framework and tools to view llm's behaviour and characteristics

## What is missing in project idea (#1226) to achieve goal of "MONITOR LLM'S CAPACITIES,BEHAVIOUR AND ACTIONS" in best way ?

--> 1.Both Model Benchmarking and Model Evaluations should be done instead of just Model Evaluations.
2.Also with evals of  local llm and online api based llm calling ,we should add AI apps,AI Sites,etc  based evaluation for real user system.

## Domain Splits

--> The System domain should be in Offline and Online

 1.Offline Domain

```
    (1).Uses Fix and pre-downloaded datasets.
    (2).This will be get handled by lm-harness/lighteval integration.
    (3).This very good for testing/experimenting ai products locally before deployment.
```

 2.Online domain

```
    (1).Live api calls to external AI services (Openai,Anthropic,Gemini) (This can also be handle by Offline domain ,here specified due to more flexibility.)
    (2).Live Multi Modal AI apps,AI websites,AI products,etc i.e Custom API
    (3).User provide Custom Datasets
    (4).Result evaluated in real time 
```

## System Architecture

--> Different AI System needs Specialized approach **Evals Strategies**. (especially for live AI products).One set of framework compressed with multiple tests sets like Lighteval , lm-harness will be overwhelming and expensive too. 

  **model evaluation must match the system**, For Example:

```
    -RAG (different approach) 
    -Agents(different approach)
    -MCP Systems , etc(different approach)
```

For Example — RAG Systems: 

```
    -Firstly we should use specialized model Evaluation method like **Ragas**.
    -for evals of whole system will be Overwhelming without much requirements.
    -here we can just evals  similar outputed chunks ,also evals pretrained llm for answering user query through chunks.
    -And on System design/architect  requirements we can increment Evals to whole System to monitor  system's each step 
```

**We should  design this project by getting inspired by Evaluations Pyramid (which is inspired by SWE Test Pyramid )**

For Multi Modal AI based products(live chatbot app,etc) we should use separate tests for live Evals:

```
    -lm-harness,Lighteval such framework are not mean for real time ai products evals. 
    -Prompt Foo framework can be used to check whether the user is ordering ai to do malicious activities through prompt or request i.e for Safety & jailbreak testing.
    -MMLU Pro Benchmark for Accuracy benchmarking.
    -And many other tests which will solve problem/gaps without making system complicated.
    -llm-as-judge for evaluating neatly.
    -Human-in-loop for human verificatin to put trust on future outputs.
```

Scoring Mechanism (3 Ingredients of Evals)
Evaluation framework will follow:

```
    • Task - the prompt/request which will be get evaluated
    • Dataset - real-world test cases (standard or custom)
    • Scorer - LLM-as-judge / BLEU / ROUGE / Ragas metrics,CLIP score,WER using Whisper transcription,etc (for multimodal purpose).
    -llm-as-judge for evaluating .
    -Human-in-loop for human verificatin to put trust on future outputs.
```

## Multimodal Evaluation Featurmmes:

```
    The framework will support evaluation across all multimodality :
    Text  → There will be include of evaluate response accuracy, relevance, 
            hallucination detection,etc

    Image → This involves evaluate prompt-image alignment, 
            image quality, caption accuracy,etc

    Voice → This include evaluate transcription accuracy, 
            speech quality, response correctness,etc
```

The framework will expose evaluation results via a React/TypeScript UI where users can configure requests, upload datasets, and visualize results in real-time using SSE streaming.



------




The path for viewing PoC:
URL:  https://github.com/aditya047-stack/MultiModal_Eval_Project_PoC-






