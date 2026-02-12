### Initial Idea Submission

**Full Name:** Keerthi Pradyun
**University name:** University of Hyderabad
**Program you are enrolled in (Degree & Major/Minor):** Integrated M.Tech in CSE Major
**Year:** 3rd
**Expected graduation date:** June 2028

**Project Title:** Git Support, Visual Workflow Builder & Collection Dashboard
**Relevant issues:** * [Issue #502: Git Integration](https://github.com/foss42/apidash/issues/502)
* [Issue #120: Drag & Drop UI API workflow builder](https://github.com/foss42/apidash/issues/120)

### Idea description:

My approach focuses on evolving API Dash from a tool for individual requests into a comprehensive environment for **Team Collaboration** and **Automated Workflows**. The implementation will be divided into three integrated modules:

#### 1. Git Integration (Collaboration)
To enable version control, I will implement a layer that maps API Dash collections to a local directory structure. 
* **Implementation:** Instead of one large state file, collections will be saved as individual JSON files. I will use a Dart-native Git wrapper to allow users to `Commit` changes, `Push/Pull` from remote repositories, and view `Diffs` directly within a new "Version Control" view in the app.
* **State Management:** I will utilize **Riverpod** to track file-system changes and ensure the UI reflects the current Git branch and "dirty" (unsaved) status in real-time.

#### 2. Visual Workflow Builder (Automation)
I will build a drag-and-drop canvas to allow users to chain multiple API requests.
* **Node-Link UI:** Using the `vyuh_node_flow` package (suggested in community discussions), I will create "Nodes" representing API requests and "Edges" representing data flow. This allows for passing variables (e.g., an auth token from a login response) into the headers of subsequent requests.
* **Agentic AI:** I will implement a "Smart Prompt" feature. Users can describe a sequence in plain English, and an AI agent will generate the corresponding node graph by mapping the prompt to the existing collection schema.

#### 3. Collection Dashboard (Observability)
A central dashboard will provide high-level insights into the health of API collections.
* **Analytics:** I will use `fl_chart` to visualize execution history, success/failure rates, and latency trends over time. 
* **Automated Reporting:** I will implement a Webhook system that sends automated execution reports to platforms like Slack or Discord, facilitating better observability for API lifecycles and CI/CD pipelines.
