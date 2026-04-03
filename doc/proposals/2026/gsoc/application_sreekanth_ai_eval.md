GSoC 2026 Proposal
Multimodal AI and Agent API Evaluation Framework
Project: API Dash
About
Full Name: Peddu Sreekanth Reddy
Email: peddusreekanthreddy@gmail.com
Phone: +91 7386783406
Discord: peddusreekanthreddy_35424
GitHub: github.com/peddusreekanthreddy7
LinkedIn: Sreekanth Reddy Peddu
Time Zone: IST — Indian Standard Time (UTC+5:30)
Resume: View Resume (Google Drive PDF)

University Info
University: Indian Institute of Information Technology Design and Manufacturing (IIITDM), Kurnool
Degree & Major: B.Tech 
Year: 2nd Year (Currently)
Expected Graduation: 2028

Motivation & Past Experience
1. Have you worked on or contributed to a FOSS project before?
Honestly, I have not contributed to any FOSS project yet. I came across API Dash only about two weeks ago and right now I am in the middle of my semester exams. So I have not had the time to raise any PRs. But after April 15th, I will have around 3 months of holidays and I plan to start actively contributing from there.
2. What is your one project/achievement that you are most proud of? Why?
The project I am most proud of is an AI-powered answer script correction system I built. The idea was simple instead of teachers manually checking answer sheets, the app automatically evaluates student responses and gives scores with feedback. I trained AI models as the backend and built the full application around it. It was a real problem I noticed in the Indian education system, these app is using one of my professor to correct the assignments and building something that could actually solve it felt very meaningful to me. That experience also gave me hands-on understanding of how LLM outputs need to be evaluated  which directly connects to what I want to do in this GSoC project.
3. What kind of problems or challenges motivate you the most?
I get most excited by problems where something is working, but I do not fully understand why. That gap pushes me to dig deeper. I like challenges that need both logical thinking and creativity. For me the best problems are ones where I have to read code I did not write, understand the full picture, and then build something on top of it. That is exactly how I feel about API Dash  the codebase is well structured, and I want to extend it in a meaningful way.
4. Will you be working on GSoC full-time?
Not completely full-time during May, since I still have a few exams. But starting from mid-April, I will have roughly 3 months of college holidays. During that time, I will dedicate most of my hours to GSoC. I am also working on my startup on the side  building AI powered apps and websites. That experience with AI models and backend systems is actually very relevant to this project.
5. Do you mind regularly syncing up with the project mentors?
Not at all  I actually enjoy it. I have had a few mentor interactions in the past and I like the back-andforth of discussing ideas and getting feedback. I could not stay consistent recently because of exams, but from April 15 onwards I will be fully available for regular syncups. I am looking forward to learning from the mentors and sharing my progress.
6. What interests you the most about API Dash?
What really caught my attention is that API Dash is not just a regular API client  it already has a solid foundation for AI and agent-based workflows. While reading through the codebase, I found the agenticservices module very interesting. The way it handles multi-step AI workflows using an agent caller system is well thought out. I realized I do not need to build from scratch I can extend this existing system to support evaluation workflows, like running model queries across a dataset and collecting results automatically.  I also noticed how RequestModel and environment variables are used to dynamically construct API requests. That gave me the idea that dataset inputs can be treated like dynamic variables, so batch evaluation can happen without touching the core request logic.  The LLMcomparator feature also stood out. It already supports side-by-side model comparison, and I think it is a great base to turn into a full evaluation dashboard by adding batch execution and proper metrics.  Overall, I like that all the right building blocks are already there agent workflows, dynamic request handling, comparison UI and my project can connect them into something bigger.
7. Can you mention some areas where the project can be improved?
A few areas I think could be improved:
•	Handling large API responses more efficiently right now, big payloads can slow things down.
•	Adding scripting support so users can write small pre/post processing scripts for requests, similar to Postman.
•	Real-time protocol support like WebSocket or SSE is which are common in modern AI APIs.
•	Better AI transparency showing token usage, latency, and model metadata more clearly.
•	Workspace sync the ability to sync collections across devices or share with a team.
•	Improved test automation making it easier to write and run automated API tests inside the tool.
I feel these improvements matter because modern developers work with large data realtime APIs, and AI systems. If the tool becomes slow or hard to use for those cases, it limits its usefulness. Also features like scripting and sync are already expected in tools like Postman, so adding them would make API Dash much more practical for realworld projects.

Project Proposal Information
1. Proposal Title
Multimodal AI and Agent API Evaluation Framework for API Dash
2. Abstract
Right now, there are many AI models available OpenAI, Gemini, Claude, and more. Developers often struggle to figure out which model actually works best for their specific use case before committing to one.
I faced this exact problem personally. While building my startup app, I needed to pick an AI model. I did not have a proper way to compare them, so I just went ahead and purchased the Gemini API. Later, I realized it was not the best fit for my use case and felt I had wasted money and time.
That experience made me think there should be a simple way to test multiple models on real data before choosing one. When I came across this GSoC idea in API Dash, it felt like the exact solution to that problem.
This project will build an AI and Agent Evaluation Framework inside API Dash. It will let developers upload their own datasets, run batch evaluations across different AI models, compare results side by side, and measure performance using metrics like accuracy, latency, and token usage. The goal is to help developers make better, more informed decisions before choosing or paying for any AI API.
3. Detailed Description
Overview
Most AI model evaluation tools today are command line based (like language model evaluation tool) and not easy to use during normal development. This project brings evaluation directly into API Dash through a simple UI based workflow, so developers can test models without leaving the tool they already use.
What I Will Build
The framework has three main parts:
Dataset Configuration
•	We have to Upload datasets in CSV or JSON format
•	After that Map dataset columns to API inputs (eg question means prompt, answer means expected output)
•	Before running just check dataset preview
Batch Execution Engine
•	It will Automatically generate and send multiple API requests from a dataset
•	Show live progress how many requests are done, how many are failed
•	Don’t send too many requests together to avoid limits
•	It will Retry failed requests automatically
•	It will Support for text, image and also audio inputs
Evaluation Dasboard
•	Compare model outputs to expected answers
•	Show how correct the results are, how fast responses come, and how much cost is used
•	It will Support both simple checks (exact match) and AI based evaluation (LLM-as-judge)
•	Export results to standard formats compatible with tools like language model evaluation tool
How I Will Build It
UI & State Management
•	I will Create a new feature module following existing API Dash structure
•	By Using River pod for state management, so it matches the current codebase
•	It will Show real time progress during batch requests
•	And Store results locally so user can check later
Dataset Handling
•	Read and handle uploaded CSV and JSON files properly
•	Use the existing variable system to pass dataset values into API requests
•	No need to change the main request system dataset values will work like normal variables only 
Batch Execution
•	Build a queue-based system to send requests in batches
•	Control max parallel requests to respect rate limits
•	If request fails, wait and try again
Evaluation Engine
•	Check if the output exactly matches the expected answer for simple cases
•	basic rules to verify structured outputs
•	Use the existing agent system in API Dash to evaluate responses using AI
•	Send model output to another AI and get a score automatically 
Export Support
•	Export results in JSON or CSV format
•	Export results in a format that works with tools like lm-eval-harness and lighteval
Why This Fits API Dash
While exploring the codebase, I could see that API Dash already has all the right building blocks  agentic services for multi step agent workflows, RequestModel for dynamic request construction, and LLm comparator for side-by-side output comparison. My project does not reinvent any of these  it extends them into a complete evaluation system. That is why I think this project is a natural fit for the codebase rather than a bolt-on feature.
4. Weekly Timeline
Phase	Week	What I will work on	Deliverable
Community Bonding	Pre	Read the full codebase Discuss UI and architecture with mentors.
Finalize evaluation flow and data model. Set up dev environment in my laptop.	Plan confirmed with mentors
Phase 1 — Dataset Handling & Basic Setup (Weeks 1–3)
Setup & UI	Week 1	I will create the new evaluation module and design the basic UI structure (dataset upload screen and results on the dashboard) set up Rive pod state	Working UI skeleton
	Week 2	And I will Load CSV/JSON data it will show preview, and manage errors	Dataset loads successfully
	Week 3	After that Create mapping UI to connect dataset columns to API inputs and test it with sample data	Dataset connected to API request
Phase 2 — Batch Execution Engine (Weeks 4–6)
Batch Engine	Week 4	Then Build the batch request engine generate and send requests from dataset rows and it will show live progress	Batch runs end to end
	Week 5	And also Control how many requests run at a time and retry if any request fails.	Stable batch execution
	Week 6	User can upload a dataset, map inputs, and run batch API calls with live progress tracking.	Multimodal input working
Midterm Goal: User can upload a dataset, map inputs, and run batch API calls with live progress tracking.
Phase 3 — Evaluation System (Weeks 7–9)
Evaluation	Week 7	Then Building basic evaluation exact match the  field comparison that  show pass/fail per row	Pass/fail per row visible
	Week 8	Implement AI as judge evaluation using the existing agent system. Score responses automatically.	AI judge scoring working
	Week 9	Build export functionality JSON, CSV output compatible with lm eval harness(AI model evaluation tool) format.	Export file ready
Phase 4 — Dashboard & Final Polish (Weeks 10–12)
Polish & Submit	Week 10	Build results dashboard to show accuracy, speed, and usage, and allow checking each result to user	Dashboard live
	Week 11	i will Test with large datasets fix performance issues, and improve user experience	Stable on large data
	Week 12	Final testing, write documentation, clean up code, and prepare for GSoC submission.	Ready to submit
Final Goal: A complete, usable AI evaluation framework fully integrated into API Dash no external tools needed.


Thank you for reading my proposal. I look forward to contributing to API Dash!
