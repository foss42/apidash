### About

1. Full Name: Suma Vyshnavy V K  
2. Contact info: vippaguntasv@gmail.com  
3. Discord handle: vyshnavy_65069  
4. Home page: N/A  
5. Blog: N/A  
6. GitHub profile: https://github.com/sumavyshnavy/  
7. LinkedIn: https://www.linkedin.com/in/suma-vyshnavy/  
8. Time zone: IST (UTC+5:30)   

---

### University Info

1. University name: Manipal Institute of Technology  
2. Program: B.Tech Electronics and Computer Engineering  
3. Year: 2nd Year  
4. Expected graduation date: 2028  

---

### Motivation & Past Experience

#### 1. Have you worked on FOSS?

I am currently in the early stages of contributing to open source and have started exploring API Dash in depth. Instead of jumping into quick fixes, I’ve been focusing on understanding how the system is structured and how different parts of the app interact.

This proposal is a result of that exploration — identifying a gap in how workflows are handled and thinking about how it can be improved in a way that aligns with the existing architecture.

---

#### 2. Project I am most proud of

One project I am most proud of is **TypePlushie**.

While building it, I realized that writing code is only one part of building a system — the bigger challenge is making it feel intuitive. I spent a lot of time thinking about how users move through the interface, where friction exists, and how small design changes can simplify interactions.

That experience directly influences how I approach this proposal — especially in designing something like a workflow system, where clarity and usability matter as much as functionality.

---

#### 3. Problems that motivate me

I am most interested in problems where tools don’t match how people actually work.

For example, API tools allow sending requests easily, but real usage is rarely just one request — it’s usually a sequence. When tools don’t support that naturally, developers end up doing manual work.

I enjoy identifying these mismatches and trying to design systems that reduce that friction.

---

#### 4. Availability

I will be working full-time on GSoC during the coding period and can dedicate consistent time each week.

---

#### 5. Mentor sync

I prefer regular syncs. It helps me validate whether I’m thinking in the right direction early, instead of building something that later needs to be reworked.

---

#### 6. Interest in API Dash

What stood out to me about API Dash is how clean and focused it is compared to many API tools.

But while using it, I noticed something:  
it handles individual requests really well, but once you try to simulate a real workflow (like login → fetch → update), you have to manually manage everything.

That gap is what led me to this idea.

---

#### 7. Areas of improvement

- No structured way to execute multi-step API workflows  
- Manual handling of dependent data (tokens, IDs, etc.)  
- Limited visibility when debugging a sequence of requests  

---

#### 8. Community interaction

I have recently started engaging with the API Dash community and plan to contribute more actively through discussions and pull requests alongside this proposal.

---

### Project Proposal Information

#### Proposal Title  
API Workflow Automation and Collaboration System  

---

#### Abstract  

Most API tools are built around sending individual requests, but real-world usage is workflow-driven.

Developers often need to execute a sequence of dependent requests, pass data between them, and debug failures across the entire flow. Currently, this process is manual and fragmented.

This project introduces a workflow-based system within API Dash that allows chaining requests, passing variables automatically, executing workflows, and visualizing results — making API testing more aligned with real developer workflows.

---

#### Detailed Description  

**Problem**

In practice, APIs are rarely used in isolation.

A simple flow like:

Login → Get token → Fetch data → Update resource  

requires:

- manually copying tokens  
- running requests one by one  
- tracking where failures occur  

This becomes inefficient and error-prone, especially when workflows grow.

---

**Proposed Solution**

The goal is to introduce workflows as a first-class concept in API Dash.

---

**1. Workflow Builder**

A visual way to define sequences of API requests.

Each step:
- represents a request  
- can extract data from previous responses  
- passes variables to the next step  

---

**2. Execution Engine**

Handles:

- sequential execution  
- variable injection (e.g., tokens, IDs)  
- stopping on failure with clear feedback  

---

**3. Execution Feedback & Dashboard**

Instead of isolated responses, developers see:

- step-by-step execution results  
- where the workflow failed  
- overall success/failure  

---

**Technical Approach**

The implementation will integrate with the existing API Dash architecture:

- Data models → `lib/models/`  
- Execution logic → `lib/services/`  
- UI components → `lib/widgets/`  

The existing request execution system will be reused, with an additional workflow layer built on top.

---

#### Weekly Timeline  

**Weeks 1–3**  
Design workflow model and implement basic execution engine  

**Weeks 4–6**  
Build workflow builder UI and variable mapping system  

**Weeks 7–8**  
Add collection versioning and improvements  

**Weeks 9–10**  
Develop dashboard and execution feedback system  

**Weeks 11–12**  
Testing, refinement, and documentation  