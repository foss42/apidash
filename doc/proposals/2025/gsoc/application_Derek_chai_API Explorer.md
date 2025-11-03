## Instructions

- Create a fork of API Dash.
- In the folder [doc/proposals/2025/gsoc](https://github.com/foss42/apidash/tree/main/doc/proposals/2025/gsoc) create a file named `application_<your name>_<short project name>.md`

The file should contain the follow:

```
### About 

Derek Chai
derekchai2006@gmail.com, 346-370-6304
.chaitime
https://github.com/Derek-Chai
www.linkedin.com/in/derek-chai-ab18472b3
Central Time Zone(CST)
https://drive.google.com/file/d/18OLk38k-P9VikzWxOC9_EosojU73XMEx/view?usp=sharing

### University Info

University of Texas at Dallas
Bachelor of Science in Computer Science
Third Year(Junior) 
May 2027

### Motivation & Past Experience

Short answers to the following questions (Add relevant links wherever you can):
1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs? Not yet, yet I have been involved on collaborative activities involving open APIs and Git-based workflows. My My Spotify to YouTube Music Playlist Transfer Tool shows that I can use third-party APIs (Spotify Web API and YouTube Music API) and deal with open integrations, like FOSS projects.
2. What is your one project/achievement that you are most proud of? Why? The Pom and Honey POS System is my most notable project and it is a Java and SQL-based web-based project which uses AWS to deploy the restaurant management system. I managed a team of five based on Agile practices, developed an inventory tracking and payroll management feature using Relational database in PostgreSQL. It taught me about leadership, database design, and scalable backend development all useful in making a contribution to API Dash.
3. What kind of problems or challenges motivate you the most to solve them? I love to solve the problems, which are a combination of automation, efficiency, and utility. Such projects as API Dash, that simplify API interactions and testing, are also attractive to me, as they cut friction on the side of the developer and make the workflow more efficient - where I can directly bring my background of working with backends and API integration.
4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project? Yes, I intend to work full time at the GSoC period. My school day will not interfere much with my academic term and I will be more than willing to concentrate on the contributions to project.
5. Do you mind regularly syncing up with the project mentors? Not by any means - in fact, I would rather have regular check-ins so as to synchronize purposes and receive feedback. I have worked remotely as a member of a team on my Outlier AI job and have been able to use communication to improve the performance of a model and debugging production code.
6. What interests you the most about API Dash? I’m drawn to API Dash’s goal of making API exploration intuitive and accessible. Most of all, the API Explorer (#619) project is intriguing as it combines discovery, categorization, and automation - all of which I have been able to work in during my API-based projects. The concept of OpenAPI/HTML files parsing and template generation automatization fits well with my experience in Python (Flask/FastAPI), Java, and SQL-based data enhancement pipelines. One thing I find especially interesting is to put in place smart tagging and enrichment logic, which will make the API library scaleable and meaningful to developer.
7. Can you mention some areas where the project can be improved? Use ML or rule-based keyword extraction to auto-classify APIs into categories (e.g., AI, weather, finance).

Enhanced Metadata Enrichment:  Parse OpenAPI specs to auto-generate request templates, sample payloads, and authentication hints.

Community Engagement: Add features like user ratings, reviews, and GitHub-based contributions to keep the library fresh and community-driven.

Search Optimization: Search Optimization: Implement advanced search filtering (by tags, response type, or authentication method).

UI Integration: Improve the front-end workflow for importing and testing APIs with React and Material-UI enhancements.

### Project Proposal Information

API Explorer Automation Pipeline for API Dash

The proposed project is expected to improve the user experience of API Dash through the incorporation of a curated collection of publicly available APIs, automated parsing, grouping, and enrichment. At the moment, users have to do endpoints testing manually, which is time-consuming. This proposal will describe the creation of a backend automation pipeline, which will be used to process OpenAPI/HTML files, auto-tag APIs based on domain (AI, finance, weather, etc.), enrich data with metadata, and create request templates pre-configured. The outcome will be searchable and interactive API library, which will allow developers to import, test, and explore the APIs in the API Dash without any complications. This project aims to develop an end-to-end backend pipeline that performs and structures the APIs automatically to be exposed to API Dash.

3. Detailed Description 
This project will aim at establishing an end-to-end automation pipeline that will simplify the mean of collection, organisation and integration of APIs into API Dash. The system would be configured to automatically scan Open API (Swagger) JSON / YAML and HTML documentation documents to extract the core information including endpoints, request and response samples, parameters and authentication information. It will then apply keyword based and metadata driven logic to classify APIs into areas such as AI, weather, finance and social media, and there is a possibility of using lightweight machine learning models to improve the tagging accuracy. The pipeline will also do data enrichment, i.e. creating ready-to-use templates, including example payloads, authentication placeholders, and structured metadata to be used in efficient indexing. In order to facilitate teamwork, the community contribution layer will be implemented by integrating with GitHub that allows submissions, reviews, and user feedback in the form of ratings and comments. The API Dash frontend will communicate via RESTful endpoints on the backend which will allow users to browse, search, and import APIs with ease and the asynchronous updates will be supported by tools such as Celery or asyncio. The project will be developed in Python (FastAPI/Flask), PostgreSQL or MongoDB, and Docker to be deployed and verified using the Pytest and Postman tools to help confirm the project's reliability. The end result is a system where API Dash users will have access to a rich, categorized library of APIs, which will save important man-hours in terms of setup, enhance discoverability, and lead to communal development of the system.

4. Weekly Timeline: Week Goal / Deliverable
Week 1: Design architecture and environment set up; API metadata storage database schema creation.
Week 2: Install OpenAPI/Swagger parser and test using a sample data set of publicly available API.
Week 3: Add parser: Add parser functionality based on scraping logic to extract endpoint entities in HTML documentation.
Week 4: Construct auto-tagging and categorization algorithms on the basis of metadata and analysis of keywords.
Week 5: Implement data enrichment and template creation component of request and response payload.
Week 6: Architecture and develop REST API endpoints to present API data to API Dash frontend.
Week 7: Shipped user feedback engine (ratings, reviews), community contribution workflow by implementing GitHub.
Week 8: Pipeline optimization, caching, and background task management (Celery/asyncio).
Week 9: Increase the scope of testing through unit and integration tests; polish on the code according to mentor feedback.
Week 10: Perform the large scale validation and performance benchmarking; resolve significant problems.
Week 11: Prepare write up, develop final project demonstration, and the deployment package.
Week 12: Final assessment and deliverables submission to the main repository; mentor assessment and final presentation.

```

- Feel free to add images by adding it to the `images` folder inside [doc/proposals/2025/gsoc](https://github.com/foss42/apidash/tree/main/doc/proposals/2025/gsoc) and linking it to your doc.
- Finally, send your application as a PR for review.
