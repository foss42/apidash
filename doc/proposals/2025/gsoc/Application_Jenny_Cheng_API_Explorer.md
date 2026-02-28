# API Dash - GSoC 2025 Proposal

## About 

1. Full Name: Jenny(An-Chieh) Cheng
2. Contact info (email, phone, etc.): jennyc28@uci.edu
3. Discord handle: jennyyyy0954
4. GitHub profile link: https://github.com/Jennyyyy0212
5. LinkedIn: https://www.linkedin.com/in/an-chieh-cheng/
6. Time zone: Pacific Time / Los Angles (GMT-7)
7. Link to a resume: [Link](https://drive.google.com/file/d/1wN6gdueKzCLeDX9STjcd0X0T4oS76mKl/view?usp=sharing>)

## University Info

1. University name: University of California, Irvine
2. Program you are enrolled in (Degree & Major/Minor): Master in Software Engineering
3. Year: 2024
5. Expected graduation date: Dec 2025

## Motivation & Past Experience

Short answers to the following questions (Add relevant links wherever you can):
1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs? 
    
    No, but I am eager to start contributing. 
2. What is your one project/achievement that you are most proud of? Why? 

    One project I’m most proud of is a [Movie Tracking application](https://github.com/Jennyyyy0212/MovieLog) that I developed on my own. It involved APIs creation, frontend development, and database management. This project was challenging and rewarding because I had to build everything from scratch, which required me to understand and implement each part from designing the UI to creating APIs and managing database.

3. What kind of problems or challenges motivate you the most to solve them?

    Those require creative thinking, automate workflows, and improve user experience.

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

    Yes, I will work on GSoC for full-time.

5. Do you mind regularly syncing up with the project mentors?

    No, I don't mind. I am happy to sync up with the mentors and get feedback from them.

6. What interests you the most about API Dash?

    I'm interested in API Dash because of its ability to integrate API creation and testing. It serves as an open-source alternative to tools like Postman and Insomnia. Especially, it aligns with my interest in improving developer workflows by providing a clean interface and efficient API management. The test preview feature also makes it a valuable tool for developers.

7. Can you mention some areas where the project can be improved?

    - Integrate to VS code or some IDE as extension
    - Allow more custom themes or layout in UI, such as dark theme
    - Enable users to schedule or automate APIs testing (ex: daily, weekly, or after code change) instead of manually testing APIs



## Project Proposal Information

### 1.Proposal Title

API Explorer - Library for API templates

### 2.Abstract

This project aims to help the APIs creation where users easily discover, browse, search, and import popular, publicly available APIs. Developers will be able to quickly access pre-configured API templates with authentication details, sample data, and expected responses. So they don't need to manually set them up. The APIs will be organized into categories like AI, finance, weather, and social media, making it easy for users to find what they need. The backend will automate the process of parsing OpenAPI and HTML files, tagging APIs to relevant categories, enriching the data, and creating templates. Features like user ratings, reviews, and community contributions via GitHub will help keep the resources up to date and relevant.

### 3.Detailed Description
#### Problem Statement
Currently, developers using API Dash only when they have their APIs. Creating APIs or searching public APIs manually can take time and configuring requests often involves mistakes, especially for those new to the service.

#### Proposed Solution
- Parses API documentation (OpenAPI YAML, or HTML) to automatically extract key components like endpoints, authentication methods, parameters, and responses.
- Generates pre-configured API request templates (GET, POST, PUT, DELETE) with details and neccessary infomation
- Categorizes APIs based on functionality
- Provides a search and filter system to help developers quickly find APIs by category, name, or tags.
- Support user feedback features, so users can rate and comment
- Imports APIs directly into the workspace, reducing setup time and improving the workflow for developers.
- Fetch the lastest APIs periodically


### 4.Weekly Timeline
| Week | Goals/Activities                                           | Deliverables                                                    |
|------|-------------------------------------------------------------|-----------------------------------------------------------------|
| 1    | Set up project environment and repositories. Familiarize with API Dash architecture. Define project requirements and scope. Begin early design concepts for the UI/UX. | Project repository initialized. Environment and tools set up. Project scope and requirements document. Initial UI/UX design concepts. |
| 2    | Research OpenAPI and HTML parsing libraries. Choose parsing tools and libraries. Continue refining UI/UX design based on project goals. | List of tools and libraries for parsing and scraping APIs. Refined UI/UX design wireframes. |
| 3    | Begin implementing OpenAPI parsing functionality. Set up the database schema for API metadata. Finalize initial UI/UX wireframes and layout design. | Basic OpenAPI parsing for extracting endpoints, parameters. Initial database schema design for storing API info. Finalized UI/UX wireframes. |
| 4    | Complete OpenAPI parser and test with sample files. Begin categorization of APIs based on keywords. Start designing the UI components for the API Explorer interface. | OpenAPI parser code with test results. Categorization logic for APIs. Early-stage UI component designs. |
| 5    | Start implementing HTML scraper for APIs without OpenAPI. Test parser with real-world API documentation. Iterate on UI/UX design with feedback from initial API interface mockups. | HTML scraping tool for parsing API documentation. Test results from HTML scraping. UI/UX design iteration based on feedback. |
| 6    | Implement enrichment features (authentication, versioning, etc.). Develop automatic categorization based on descriptions. Continue refining UI/UX design, focusing on API explorer features. | Enrichment logic for API metadata. Automated categorization model or keyword-based system. Refined UI/UX design for API explorer features. |
| 7    | Start template generation for API requests (GET, POST). Add sample payloads and expected responses to templates. Continue refining UI components and user flow. | Template generation code for API requests. Sample request/response templates for testing. Refined UI components and user flow design. |
| 8    | Refine template generation for all API methods (PUT, DELETE). Implement authentication template generation (e.g., API keys). Finalize the UI/UX design for the entire API Explorer workflow. | Complete set of API request templates. Authentication logic integrated into templates. Finalized UI/UX design for API Explorer. |
| 9    | Begin integration of user feedback system (ratings, reviews). Test user feedback system with a sample set of APIs. Start implementing UI for user feedback and ratings. | User feedback feature integrated into API Dash. UI for user ratings and reviews. |
| 10   | Implement API search and filter functionality. Integrate categorized and enriched APIs into the workspace. Finalize the UI for the search/filter and API results display. | Search and filter system for APIs. API Explorer interface integrated with categorized APIs. Finalized UI for search and results display. |
| 11   | Finalize real-time testing features (API execution in UI). Perform end-to-end testing and debugging. Conduct user testing for UI/UX feedback. | Real-time API testing feature completed. Final bug fixes and refinements. User feedback on UI/UX design. |
| 12   | Conduct final testing and gather feedback. Prepare documentation for the project. Deploy and release API Explorer feature. Finalize UI/UX design adjustments based on testing feedback. | Final version of API Explorer feature. Complete documentation (API usage, setup, etc.). API Explorer released and deployed. Finalized UI/UX design. |



