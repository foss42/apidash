### About

1. Full Name:Aaditya Umesh Chavan
2. Contact info (public email):chavan.aditya047@gmail.com
3. Discord handle in our server (mandatory):auc369
4. Home page (if any):-
5. Blog (if any):-
6. GitHub profile link:https://github.com/aditya047-stack
7. Twitter, LinkedIn, other socials:www.linkedin.com/in/aditya-chavan-a695a22a2
8. Time zone:IST (UTC+5:30)
9. Link to a resume (PDF, publicly accessible via link and not behind any login-wall):

### University Info

1. University name:University of Mumbai
2. Program you are enrolled in (Degree & Major/Minor):B.E Computer Engineering
3. Year:1st Year
4. Expected graduation date:Aug 2026



### Motivation & Past Experience



1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?
   ---> Yes,i have wholeheartedly contributed to FOSS project
   i have contributed to foss/api repo
   #84,#86,#88 are issues that i have raised in foss/api repo and try to fixed and raised PR for this .






2. What is your one project/achievement that you are most proud of? Why?
   ---> My project "Gamma Agents".I am very proud of this project.This project aims to build autonomously software apps using multi agents orchestration and it handles from writing to deployment of apps.
   Mini Description of my project:
   1.Firstly agents makes contract and then write on based on it.
   2.Various needed MCP tools are used like for safety i used e2b sandox where agent can write and run the code
   3.It is high level multi orchestration of agents where it include both sequential and parallelism in workflow.
   
   
   
      
   why??   
   --> It was my first project that i build independently without watching any tutorial .
   I was just searching ,gathering information,experimenting,looking for right tools.
   This part consumed my time but i got feel that what is real programming .For the first time i feel the real programming where i can selfly paused my pace and experiment things, learn extra things instead of just caught by tutorial timestamps
   It took many months to build this project also there is even more to add taste to this project.
   This projects opens my new way of learning framework.





3. What kind of problems or challenges motivate you the most to solve them?
   
   ---> Curiosity and critical thinking about system excites me alot.I am curious of how will system will look like to end user and how can i make it better for experience.



4. Will you be working on GSoC full-time? In case not, what will you be studying 
   
   ---> I will not be able to work fully on GSoC project .As i am college student i have lectures ,assignments,Exams,etc.But I have plan scheduled were i manage both GSoC Project and college work .I will truly put consistent efforts on GSoC Projects.


5. Do you mind regularly syncing up with the project mentors?
   
   ---> I am comfortable communicating with mentors regularly,through meetings,messages,gmail,etc
   I already have accounts on discord,whatsapp,gmail,slack,linkedin.
   I will acknowledge for any feedback,information,etc from mentor related to GSoC project. 


6. What interests you the most about API Dash?
   I think one of my favourite part is API Collection .
   It is very design and built.
   The type of APIs in collection are sufficient in testing our program.
   Hence it helps us to run our program.


7. Can you mention some areas where the project can be improved?
   ---> I think UI and UX could be better.
   I think the product should be good from major sides.
   Hence ,i don't think it is very hard or impossible to increase overall UI and UX by implementing best designs
   Also the logo of API Dash could be best with more perfect design and colour ,looks modifying.
   Slowly, new features should be added to keep up with running updated technology.
   -Also the new feature related to AI and AI products are coming we have to add feature related to evaluating such AI API and their products



##Proposal Title:
Multimodal AI and Agent API Eval Framework


#Abstract:

In today’s era ,there are many AI System for augmentation and automation workflows are build which are lifting most important .But Using AI System is like maintaining and working with black box where you just crossed fingers and just hope for best result .By this we didn’t get know where AI System failed or at what step the cost is high,etc

So by taking account this problem ,this project involves making AI System work in transparent ,where we can see behaviour of agents at each steps

Detail Description

**The Black Box Problem**

Imagine you hire a team to build your most expensive mansion, but you can only see the final result ,also there is no visibility into what was built, how, or at what cost. If it's get wrong, you will have no idea which decision caused the failure. You simply try again and simply hope for a better outcome.

Community Problem:

•       Score fragmentation: There are different sources that report different benchmark scores for the same model.

•       Benchmark incompatibility: Standard LLM benchmarks are really not designed for agentic evaluation like such complex system.

•       No single source of truth: Benchmarks are scattered across GitHub repos and leaderboards

•       No live product evaluation: Tools like lm-harness , lighteval were not designed for real-time AI product testing which truly need system level evaluations

  * Solution for this is recently launched product of Hugging Face i.e Evaleeval . we can integrate

this in project for ease of users

**Real Industry Failures (Without Eval)**

•       Imagine you order Gemini to play your favourite songs but due to some problems Gemini played the wrong song.

•       News came out that NYC chatbot advised users to break the law-a real incident

•       This was shocking news where Claude Code deleted a user's database — a real incident

These are not edge cases. They are predictable failures that eval frameworks are designed to catch before production.

The proposed Solution:

A 3-layers of  evaluation framework built on first principles, where each layer addresses a specific class of failure.

|   |   |   |
|---|---|---|
|**Layer**|**What it does**|**Tools Used**|
|Layer 1- Model Brain Eval|The model is benchmark before using in desire systems. To verify if it can handle your specific domain (tool calling, JSON schema, coding, etc.)|lm-harness, LightEval, HF Jobs, local GPU|
|Layer 2- Agent Eval|Here we monitor every step of agentic workflows and agents itself. Track tool calls, costs, failures, security violations, reward hacking, and long-horizon tasks.|LangFuse, OpenTelemetry, LangSmith, custom harness|
|Layer 3 - Live Product Eval|Evaluating multimodal AI products in real time.This for Test safety, accuracy, image/voice correctness, and human trust signals.|PromptFoo, LLM-as-judge, RAGAS, CLIP, Whisper, Human-in-loop|

Suggestion:

For evaluating it is better to use -Local cluster or GPU,HF jobs,cloud compute.It is not good to use model evaluations on Inference model because you are benchmarking the provider and not the actual model.

Layers detail descriptions

Layer-1: **Model Benchmarking (Offline)**

**-here we use predownloaded datasets from Hugging faces store or from any other services**

**-We use lm-harness or lighteval as framework to evaluate model.**

**-Here by not fully relying on third party model benchmarking we can use custom metrics,custom datasets,custom subsets,splits,etc**

**Layer 2: Agent Evaluation**

Sequence of Actions — Tracking & Observability

-Every tool call ,functional calls ,and environment interaction is decision part.If we track only final output we lose entire reasoning pipeline.

- We instrument each step with **OpenTelemetry spans** — vendor neutral and framework agnostic. LangFuse consumes these spans as the observability backend.

- **Why OTel over LangSmith-only?** LangSmith is powerful but locked to LangChain. If a user's agent is built on AutoGen, CrewAI, or a custom framework, LangSmith gives nothing. OTel works regardless of which agent framework is underneath. Swapping the observability backend later requires zero changes to instrumentation code.

- Agent Decision

      ↓

OTel Span (tool_name, input, output, timestamp)

      ↓

LangFuse Collector

      ↓

Step-by-step trace dashboard

**Efficiency Metrics — Cost & Latency Per Step**

**-Knowing only the final cost is not enough to understand and improvement of the system.**

**-A 50-step agents system, burns 70% of tokens alone on step 6 ,this is** **architectural problem.**

**-But you will never catch such internal system faults with alone of final output bills.**

**-** **We capture per-step: token count, cost, latency, and step count-** **attached directly to each OTel span.**

**-This means ,by this user can pinpoint and debug ,exactly budget draining step or bottleneck step.**

**Security — Harmful Action Detection**

**-Agents have access to many tools.**

**-SO there is possibility that Agents can call wrong tool call,** **making unauthorized API calls or doing this things like reward** **hacking.**

**- solve this with a rule engine that runs after every step:**

 **-** **Did the agent call a tool outside its allowed list? → flag as security violation.**

 **-** **Did the agent attempt a destructive action on a resource it shouldn't touch ? → block and log.**

**We choose rule based engine as first gate for better safety and only allows action which are authorized to Agents.**

**Failure Analysis — Pinpointing Exactly What Broke**

**The Agents fails,the question isn’t did it fail,its about why it fails or simply which step caused it to do so.**

**We combine two mechanisms:**

**- LLM-as-judge handles the viewing what has been wrong .Wrong tool calls,** **malformed JSON output,** **schema mismatch.**

 **-This gives automatic failure report that points to exact step and not just final score.**

**Long-Horizon Support — Agents That Run For Hours**

**Most eval frameworks assume system’s runs complete in seconds or In minutes.But in real life the Agents runs for hours and even days**

**Two problems arise:**

 **-If system crashes at Agents 40th step starting from 1st is unusable for evaluating whole system.**

 **-A live dashboard freezes after 200-step run is also unusable.**

**We stream results through SSE for continuous updates dashboard.**

MultiModal part will contains below things:

 The following things will be there:

-Text: response accuracy, relevance, hallucination detection

-Image: prompt-image alignment, caption accuracy (CLIP score)

 -Voice: transcription accuracy, speech quality (WER via Whisper)

-Safety: jailbreak and prompt injection testing via PromptFoo

-Accuracy: LLM-as-judge for automated scoring

-Trust: Human-in-loop verification for high-stakes outputs

**Scoring Mechanism (3 Ingredients)**

•       Task: here ,there will be the prompt or request being evaluated.

•       Dataset: So we can test the model via on standard benchmarks or custom user-provided test cases.

•       Scorer: We give score with help LLM-as-judge / BLEU / ROUGE / RAGAS / CLIP / WER depending on modality .

# System Architecture

The framework will split into two domains i.e Offline and Online due to different capability and ease .

Offline Domain:This domain includes testing of offline and online simple Api call models.Also it will be best for ideal for pre-deployment testing .It will has internal working mechanism  based on Fixed datasets, lm-harness/LightEval integration.

Online Domain: here ,we will handle Live Api calls of Agents which are integrated in system. We can use here personal datasets as per desired system. 

The React/TypeScript UI exposes all evaluation results in real time — users can configure requests, upload custom datasets, and visualize results with full step-by-step traceability.

**Timeline**

|**Week**|**Dates**|**Focus**|
|---|---|---|
|**Bonding**|Apr 28–May 25|Repo setup, mentor sync, finalize architecture, read codebase|
|**W1**|May 26–Jun 1|Project scaffold, FastAPI eval router, base models/schemas|
|**W2**|Jun 2–Jun 8|Layer 1 — lm-harness integration, dataset loading|
|**W3**|Jun 9–Jun 15|Layer 1 — LightEval integration, custom metrics/datasets|
|**W4**|Jun 16–Jun 22|Layer 1 polish, tests, docs, API endpoints finalized|
|**W5**|Jun 23–Jun 29|Layer 2 — OTel spans scaffold, LangFuse setup|
|**W6**|Jun 30–Jul 6|Layer 2 — per-step cost/latency/token tracking|
|**W7**|~Jul 7–14|**Submit eval** — Layer 1 complete + Layer 2 core working|
|**W8**|Jul 14–Jul 20|Layer 2 — rule engine (security), LLM-as-judge failure analysis|
|**W9**|Jul 21–Jul 27|Layer 2 — SSE streaming, checkpoint/resume for long-horizon|
|**W10**|Jul 28–Aug 3|Layer 3 — PromptFoo safety, LLM-as-judge scoring|
|**W11**|Aug 4–Aug 10|Layer 3 — CLIP (image), Whisper (voice/WER) integration|
|**W12**|Aug 11–Aug 17|React/TS dashboard, visualize traces + scores|
|**W13**|Aug 18–Aug 23|Buffer — bug fixes, final docs, PR cleanup, demo|






