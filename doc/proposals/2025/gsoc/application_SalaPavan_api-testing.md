### About 

1. Sala Pavan Sai Teja Kishore
2. Email : pavankishore2203@gmail.com
3. Phone : +91 6303141184
4. Discord handle : spavansaitejakishore
5. GitHub profile link : https://github.com/SPavanKishore/
6. LinkedIn : https://www.linkedin.com/in/s-pavan-kishore-b19383218
7. Time zone : IST(+5.30)
8. Resume : https://drive.google.com/file/d/1HQM_FNaDH_2td2YWuJtbo5JnINmG4ngw/view?usp=sharing

### University Info

1. Indian Institute of Technology (IIT) Tirupati
2. Computer Science and Engineering
3. 2020-2024

### Motivation & Past Experience

Short answers to the following questions (Add relevant links wherever you can):
1. Have you worked on or contributed to a FOSS project before? 
  No, I haven't worked on FOSS project before, I am waiting to contribute.
2. What is your one project/achievement that you are most proud of? Why?
  One of my energetic projects is BlueVa, which is building logic using code-blocks provided, designed canvas to allow user make logic, 
  its like Java game for beginners to explore, so after completing canvas, this tool will generate code for logic and will show errors if any.
  This project is like teaching a language, so this project made me teach and understand what and how I did things.
3. What kind of problems or challenges motivate you the most to solve them?
  Puzzles are most motivating challenges, cause they dont have straight solution, they give space to think and analyse and every analysis will contribute to solutionn somehow.
  So such puzzles in development are optimization, scalability, real-time analysis. So these kind of challenges will try to solve.
4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?
  I will be working completely on GSoC and open-source contribution.
5. Do you mind regularly syncing up with the project mentors?
  If project needs regular-syncups then it is good to have them.
6. What interests you the most about API Dash?
  I worked on APIs recently, so now this API Dash will make to go in more deeper thoughts about api and api-testing.
7. Can you mention some areas where the project can be improved?
  AI-driven api-testing and making suggestions for possible improvements for endpoints.

### Project Proposal Information

1. Proposal Title : AI-Powered API Testing and Tool Integration
2. Abstract: 
  Integrating APIs with AI agent frameworks like crewAI, smolagent, pydantic-ai, or langgraph 
  requires manual conversion of API endpoints into tool definitions-another time-intensive process.
  This project aims to automate and enhance these workflows using Large Language Models (LLMs), making
  API testing and integration smarter, faster, and developer-friendly

3. Detailed Description  
To build an AI agent that:
    -Automates API testing using prompts.
    -Converts APIs (OpenAPI specs or raw documentation) into structured tool definitions for testing
    -Benchmarks and evaluates LLMs for optimal performance in test generation and tool creation
    -Integrates with agent frameworks like crewAI, smolagent, pydantic-ai, and langgraph as mentioned

4. Weekly Timeline: 

Week 1-2: Research & Planning
- Finalize target frameworks and API formats
- Research best-fit LLMs 
- Define API testing criteria and tool definition schemas
-  Tasks :
    -  Define problem scope (API types, test goals, output formats)
    -  Choose baseline LLMs (e.g., GPT-4, Claude, Mixtral, Mistral-Instruct, etc.)
    -  Study integration specs of crewAI, smolagent, pydantic-ai, langgraph
    -  Define evaluation metrics (accuracy, coverage, latency, cost)
    - Set up project repo, issue tracker, CI/CD for deployments
    -  Prepare API collection (Swagger/OpenAPI/REST/GraphQL)
-  Deliverables:
    -  Project blueprint & API collection
    -  Defined output schema for tool definitions & test cases
    -  Initial prompt templates
      
Week 3-4: API Parsing & Tool Generation Module
- Build parsers for OpenAPI and Swagger 
- Generate tool definitions for popular agent frameworks
-  Tasks:
    -  Create OpenAPI parser using Python (pydantic, openapi-spec-validator)
    -  Add feedback for parsing raw text descriptions
    -  Make prompt templates for converting API specs to: pydantic-ai function signatures,crewAI tools,Langgraph nodes
    -  Validate tool formats via auto-regression tests
    -  Build minimal CLI: python generate_tools.py --api_spec sample.json
-  Deliverables:
    -  API parser module (OpenAPI, raw docs)
    -  Initial prompt-to-tool-definition pipeline
    -  Sample tool outputs across 3 agent frameworks

Week 5-6: API Testing Engine
- Accept natural language test scenarios 
- Generate test cases 
- Execute tests and validate responses
-  Tasks:
    -  Create NL2TestCase prompt templates (e.g., "Test login with invalid password")
    -  Use LLM to:
        -  Parse prompt into method + params
        -  Generate edge cases and parameter variations
    -  Implement the executor (requests/httpx) to call endpoints
    -  Implement LLM-based validator:
        -  Match response schema
        -  Check for expected fields/values
        -  Score for correctness and performance
    -  Add basic metrics: latency, response size, status codes
-  Deliverables:
    -  test_runner.py with support for JSON/REST APIs
    -  LLM prompt templates for test generation
    -  Sample outputs and test logs

Week 7-8: Agent Framework Integration
- Wrap test functions for agent compatibility
- Build CLI and optional Flutter web frontend
-  Tasks:
    -  Wrap test modules and tool definitions for:
        -  crewAI agents with roles (tester, validator, reporter)
        -  smolagent function chains
        -  pydantic-ai function registry
    -  Create orchestrator:
        -  Accept test goals in natural language
        -  Select relevant APIs/tools
        -  Chain test generation → execution → validation
    -  Provide CLI: agent test_sample_api.yaml "<sample prompt>"
-  Deliverables:
    -  Agent orchestration modules
    -  CLI interface for testing flows
    -  Compatibility will be tested across 3 frameworks

Week 9: Benchmarking & Evaluation
- Create a benchmark dataset
- Compare LLMs for performance and cost on identical tasks
-  Tasks:
    -  Collect 10–20 APIs (public and varied: weather, books, finance, auth, etc.)
    -  Write 30–50 natural language test prompts and expected outcomes
    -  Create test matrix:
        -  API, prompt, model used, output, validation score
    -  Run tests on: GPT-4, Claude, Mixtral/Mistral-Instruct, Command R+
    -  Log the results with latency, tokens (if API-based)
-  Deliverables:
    -  benchmark.jsonl with labeled prompts, inputs,outputs
    -  Evaluation script + scoring logic
    -  LLM comparison table (charts if needed)


Week 10: Finalize
- Documentation and demo
-  Tasks:
    -  Add Logging-retries in test ececutor
    -  try new prompt versions
    -  Failure recovery for bad input
    -  Write Dev and user documentation
    -  Prepare Integration guide for frameworks used
    -  Make demo APIs and walkthroughs(if nay)
-  Deliverables:
    -  Final CLI
    -  Build lightweight web UI (Streamlit/Flet/Flutter Web)
    -  Packaged tools by Python-module or docker image
    -  Documentation and guide


This timeline has significant flexibility to add or modify tasks.

#Tools
- Languages: Python, Dart (for optional Flutter frontend)
- Frameworks: crewAI, smolagent, pydantic-ai, langgraph (as mentioned)
- LLMs: GPT-4, Claude
- Libraries: LangChain, FastAPI, httpx
- Others : Docker, Git, Jupyter, pytest



