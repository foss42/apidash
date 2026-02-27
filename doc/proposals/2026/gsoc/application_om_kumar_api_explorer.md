# GSoC 2026 Application – API Explorer

---

## ### About

1. **Full Name**  
   Om Kumar  

2. **Contact info (public email)**  
   omku415@gmail.com  

3. **Discord handle in our server (mandatory)**  
   omku415  

4. **Home page (if any)**  
   N/A  

5. **Blog (if any)**  
   N/A  

6. **GitHub profile link**  
   https://github.com/omku415  

7. **Twitter, LinkedIn, other socials**  
   LinkedIn: https://linkedin.com/in/kumar-om45  

8. **Time zone**  
   IST (UTC +5:30)  

9. **Link to a resume (PDF, publicly accessible via link and not behind any login-wall)**  
   (I will provide a publicly accessible Google Drive PDF link here)

---

## ### University Info

1. **University name**  
   Cochin University of Science and Technology  

2. **Program you are enrolled in (Degree & Major/Minor)**  
   Bachelor of Technology in Information Technology  

3. **Year**  
   4th Year  

4. **Expected graduation date**  
   2026  

---

## ### Motivation & Past Experience

### 1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

I have not yet made an official contribution to a FOSS project. However, I have strong experience working with Git, collaborative workflows, and structured development through my internship and full-stack projects.

During my internship, I worked in a team environment using Git for version control, code reviews, and feature-based branching. I am comfortable with pull requests, resolving merge conflicts, and maintaining clean commit history.

I am currently exploring the API Dash repository and Issue #619 to understand the architecture, coding patterns, and contribution guidelines. I am actively preparing to begin contributing and aim to submit my first pull request soon.

---

### 2. What is your one project/achievement that you are most proud of? Why?

I am most proud of my full-stack project **Event Connect**, where I:

- Built REST APIs using Node.js and Express  
- Implemented JWT-based authentication and Role-Based Access Control (RBAC)  
- Designed optimized SQL queries  
- Automated email notifications  
- Deployed frontend and backend services  

This project strengthened my understanding of API lifecycle management, authentication systems, backend architecture, and database integration — all of which directly align with the API Explorer project.

---

### 3. What kind of problems or challenges motivate you the most to solve them?

I am highly motivated by:

- Backend automation challenges  
- Parsing and transforming structured data  
- API system design and optimization  
- Improving developer experience  

The API Explorer project particularly excites me because it combines automation, data processing, categorization, and scalable backend architecture into one cohesive system.

---

### 4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

Yes, I will dedicate full-time effort during the GSoC period. I will not undertake internships or part-time commitments during that time and will prioritize delivering high-quality contributions to the project.

---

### 5. Do you mind regularly syncing up with the project mentors?

Not at all. I strongly believe regular mentor sync-ups are essential for:

- Validating architectural decisions  
- Receiving continuous feedback  
- Ensuring maintainable and scalable code  
- Delivering production-ready outcomes  

I am comfortable with weekly meetings and asynchronous updates.

---

### 6. What interests you the most about API Dash?

API Dash focuses on simplifying API testing and improving developer workflows.

The API Explorer feature interests me because it:

- Reduces onboarding friction  
- Automates repetitive API setup  
- Enables easy discovery of public APIs  
- Enhances productivity for developers  

Given my background in building REST APIs and authentication systems, this project aligns perfectly with my technical interests.

---

### 7. Can you mention some areas where the project can be improved?

Potential improvements include:

- A fully automated OpenAPI ingestion pipeline  
- Intelligent API categorization  
- Metadata enrichment (authentication detection, version tracking)  
- Ratings and review mechanism for quality control  
- GitHub-based community contribution workflow  
- Automated validation for submitted APIs  

---

## ### Project Proposal Information

### 1. Proposal Title

API Explorer: Automated OpenAPI Parsing & Template Generation Pipeline

---

### 2. Abstract

The API Explorer project aims to build a fully automated backend pipeline that ingests OpenAPI and HTML documentation, parses and normalizes API endpoints, auto-tags them into relevant categories, enriches metadata, and generates ready-to-use API request templates for direct import into API Dash.

This system will significantly reduce manual configuration effort, improve onboarding experience, and establish a scalable, community-driven API discovery ecosystem.

---

### 3. Detailed Description

#### Overview

The proposed system will consist of:

1. OpenAPI/HTML ingestion module  
2. Parsing and normalization engine  
3. Auto-tagging system  
4. Metadata enrichment layer  
5. Template generator  
6. Ratings and review module  
7. GitHub-based contribution workflow  

---

#### 1. OpenAPI / HTML Parsing

- Accept OpenAPI JSON/YAML files  
- Validate schema compliance  
- Extract endpoints, HTTP methods, parameters, authentication type, and request/response examples  
- Normalize into a structured internal JSON format  

Tools:
- Python (PyYAML, jsonschema)
- Node.js for backend integration

---

#### 2. Auto-Tagging Engine

Automatically categorize APIs into domains such as:

- AI  
- Finance  
- Weather  
- Social Media  
- Dev Tools  
- E-commerce  

Initial approach:
- Keyword-based classification  
- Description and endpoint analysis  

Future enhancement:
- Lightweight NLP-based classification  

---

#### 3. Metadata Enrichment

Automatically detect and store:

- Authentication type (API key, OAuth, Bearer token)  
- Version information  
- Base URL  
- Documentation link  

Store structured API records in MongoDB or PostgreSQL for scalability.

---

#### 4. Template Generation

Automatically generate:

- Pre-filled headers  
- Sample request bodies  
- Query parameters  
- Authentication placeholders  

These templates will be directly importable into the API Dash workspace.

---

#### 5. Ratings & Reviews

- 1–5 star rating system  
- User comments  
- Flag outdated APIs  
- Basic moderation controls  

---

#### 6. GitHub Contribution Automation

- Community submits APIs via Pull Requests  
- CI validation of OpenAPI schema  
- Automated parser testing  
- Structured JSON preview generation  

---

### 4. Weekly Timeline (90 Hours)

#### Week 1
- Study API Dash architecture  
- Define database schema  
- Design ingestion pipeline  

#### Week 2
- Implement OpenAPI parser  
- Build normalization layer  
- Handle validation and edge cases  

#### Week 3
- Implement auto-tagging module  
- Add metadata enrichment  
- Integrate database storage  

#### Week 4
- Develop template generator  
- Test with multiple APIs  
- Backend integration  

#### Week 5
- Implement ratings and reviews system  
- Add moderation and validation  

#### Week 6
- GitHub workflow automation  
- Testing and bug fixes  
- Documentation and final refinements  

---

## Expected Outcome

By the end of the project:

- API Explorer backend will be fully automated  
- OpenAPI ingestion pipeline will be scalable and maintainable  
- APIs will be categorized and enriched  
- Import-ready request templates will be available  
- Community contribution workflow will be established  

---