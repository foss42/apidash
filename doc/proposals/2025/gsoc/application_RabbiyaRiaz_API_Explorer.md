
### GSoC Proposal: API Explorer for API Dash

#### About

**Full Name:**  
  Rabbiya Riaz

**Contact Info:**  
  - **Email:** rabbiyariaz2@gmail.com

**Discord Handle:**  
  rabbiya0453

**GitHub Profile Link:**  
  [https://github.com/rabbiyariaz](https://github.com/rabbiyariaz)

**LinkedIn:**  
  [https://www.linkedin.com/in/rabbiya-riaz-4b700224a/](https://www.linkedin.com/in/rabbiya-riaz-4b700224a/)

**Time Zone:**  
  GMT+5 (Asia/Karachi)

**Link to Resume:**  
  [https://drive.google.com/file/d/1c8MOBYc3hm6UuFkiyQTkK5A-CNzMvLqX/view](https://drive.google.com/file/d/1c8MOBYc3hm6UuFkiyQTkK5A-CNzMvLqX/view)

#### University Info

**University Name:**  
  National University of Sciences and Technology (NUST)

**Program Enrolled:**  
  BS Computer Science

**Year:**  
  3rd Year

**Expected Graduation Date:**  
  June 2026

#### Motivation & Past Experience

**Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?**  
  No, I have not contributed to a FOSS project before. However, I am eager to start contributing to the API Dash open-source project and build my experience in the process.

**What is your one project/achievement that you are most proud of? Why?**  
  The achievement I’m most proud of is my dedicated progress through Dr. Angela Yu’s “100 Days of Code: The Complete Python Pro Bootcamp” course on Udemy, where I built a variety of real-world projects that significantly honed my technical and problem-solving skills. I worked through the majority of the curriculum, developing tools like:  
  - A Spotify playlist automation system (using Selenium and Spotipy to track Billboard’s top songs)  
  - A flight deal finder (integrating Amadeus and Sheety APIs)  
  - A weather reporting application (via OpenWeather API)  
  - A price tracker that sends email alerts when prices drop  
  
  This accomplishment is meaningful because it demonstrates consistency and perseverance, deepened my Python expertise, and taught me critical API integration and automation workflows—turning abstract ideas into functional tools.

**What kind of problems or challenges motivate you the most to solve them?**  
  I am most motivated by challenges that require critical thinking and the ability to break down complex problems into manageable parts. I enjoy focusing on one problem at a time to devise creative and effective solutions.

**Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?**  
  According to the GSoC 2025 timeline, the coding period begins on June 2. My semester is expected to end around that time, which will allow me to commit full-time to GSoC during my summer vacation.

**Do you mind regularly syncing up with the project mentors?**  
  Not at all. I believe that regular and clear communication is essential for the success of any project, and I am committed to syncing up with the project mentors on a regular basis.

**What interests you the most about API Dash?**  
  I have hands-on experience working with APIs and appreciate the clarity of well-formatted API requests. API Dash stands out because it offers a clean, simple interface that makes it easy for users to understand and work with APIs. Additionally, my experience in web scraping has sparked my interest in automation, and I see API Dash as a great opportunity to further enhance my skills in API management and automation.

**Can you mention some areas where the project can be improved?**  

   **Advanced Navigation and Filtering:** Develop a sidebar filter with checkboxes for predefined categories (e.g., AI, Finance, Weather, Social Media) and a dynamic search bar that auto-suggests API names or keywords. This ensures users can pinpoint the API they need with minimal effort.  

   **Streamlined GitHub Workflow:** Enhance the contribution process by integrating GitHub’s API to fetch real-time pull request statuses and comments. For example, a “Contributions” tab on the dashboard could show pending PRs, automated test results from GitHub Actions, and a summary of reviewer comments.

#### Project Proposal Information

##### Proposal Title

**Automated API Explorer and Template Generator for Enhanced API Dash Integration**

##### Abstract

This project proposes to build an automated API Explorer integrated into API Dash to streamline the discovery, testing, and integration of public APIs. The solution will provide a centralized library where users can browse and search a curated set of popular public APIs initially manually added (5–10 APIs), including popular AI APIs from sources like *awesome-generative-ai-apis*. These APIs, organized into predefined categories (based on a subset of categories from *awesome-open-source-flutter-apps*), will come with pre-configured request templates that include authentication placeholders, sample payloads, and expected responses.

In parallel, a backend automation pipeline will be developed to periodically parse API documentation (OpenAPI, HTML, and Markdown formats), auto-tag them using rule-based techniques, enrich the data with metadata, and generate standardized templates. Community feedback via ratings, reviews, and GitHub contributions will ensure that the library remains accurate and up-to-date. This system is designed to reduce manual API configuration, improve onboarding time, and boost testing efficiency.

##### Detailed Description

###### Problem Statement

Developers often face significant delays and errors when manually setting up API tests. Public APIs are documented in a variety of formats, which forces developers to repeatedly interpret and configure each endpoint, resulting in duplicated efforts, increased cognitive load, and inconsistent testing setups. There is no unified system that automatically extracts, categorizes, and standardizes API configurations for one-click import into testing environments.

###### Proposed Solution

The proposed solution consists of three integrated components:

---

###### A. Front-End API Explorer

**Objective:**  
Build a responsive, user-friendly dashboard within API Dash that allows users to easily discover, browse, and import public API endpoints into their testing workspaces.

**Key Features and Design Considerations:**

**Manual Curation (Initial Phase):**
  Start by manually adding 5–10 popular public APIs, including high-demand AI APIs (from *awesome-generative-ai-apis*).
  **Example APIs:** OpenWeatherMap for weather data, Twitter API for social media interactions, and a few AI-related endpoints.

**Data Structure & API Template Specification:**
   **API data** will be stored in a standardized JSON format.
    Each API template will include:
     **Basic Fields:**
      - API Name (e.g., “Twitter API – Post a Tweet”)
      - Category (Predefined: e.g., Social Media, AI, Finance, Weather)
      - Endpoint URL & HTTP Method (e.g., POST `https://api.twitter.com/2/tweets`)
     **Authentication:**  
      Type (e.g., Bearer Token) with a placeholder.
     **Payload & Response Examples:**  
      Sample payload and expected response formats.
     **Metadata:**  
      Descriptions, version info, usage tips, and any constraints.

 **UI Design:**
   **Dashboard Layout:**  
    Card-based grid display with API cards.
   **Search & Filter:**  
    Ability to filter APIs by predefined categories (subset from *awesome-open-source-flutter-apps*), HTTP method, and other attributes.
   **Detailed View:**  
    Clicking on a card opens a detailed page with all API template information.
   **Import Functionality:**  
    A one-click “Import” button that sends the template (via a POST request) to API Dash’s backend endpoint (e.g., `/workspace/import`), injecting the API configuration into the user's workspace.

---

###### B. Backend Automation Pipeline

**Objective:**  
Develop a backend service to automate API data extraction, enrichment, categorization, and template generation.

**Modules & Implementation:**

 **Parsing Module:**
   **OpenAPI Parsing:**  
    Use libraries like `swagger-parser` or `redocly` to extract API details from OpenAPI documents (.json or .yaml).
   **HTML/Markdown Parsing:**  
    Utilize BeautifulSoup (for HTML) and Markdown parsers.  
    Leverage NLP techniques using Hugging Face Transformers (e.g., BERT) to detect key sections (e.g., "Endpoints," "Authentication") in unstructured documentation.

 **Auto-Tagging & Data Enrichment:**
   **Rule-Based Engine:**  
    Apply a rules engine (e.g., Python's `rule-engine`) to infer defaults (e.g., `limit=10` for pagination) and enrich data with usage tips.
   **Predefined Categories:**  
    APIs will be auto-tagged to a subset of predefined categories (drawn from *awesome-open-source-flutter-apps*), such as AI, Finance, Weather, and Social Media.

 **Template Generator:**  
  Generate final JSON templates that encapsulate all the parsed and enriched data.  
  Ensure the output conforms to the standardized schema for easy import into API Dash.

 **Error Handling & Logging:**  
  Log parsing errors and enrichment failures using Elasticsearch.  
  Implement retry logic (via Celery) for recoverable errors, with a maximum of three attempts.

 **Pipeline Scheduling:**  
  The pipeline will run periodically (once a week) or on-demand when new APIs are added, ensuring the API library remains up-to-date.


###### C. Community Feedback and Version Control

**Objective:**  
Facilitate community curation of the API library through ratings, reviews, and contributions.

**Implementation Details:**

 **User Feedback System:**  
  Allow users to submit ratings (1–5 stars) and written reviews for each API template.  
  Store feedback in PostgreSQL with an appropriate schema and enforce rate limiting (e.g., max 5 reviews per user per hour).

 **Contribution Workflow via GitHub:**  
  Host the API template library in a public GitHub repository.  
  Enable users to propose updates or add new templates via pull requests.  
  Utilize GitHub Actions for CI/CD to validate JSON schema compliance and run unit tests on new submissions.  
  Manual reviews by maintainers to ensure security and quality.  
  **Change Tracking:**  
  Maintain version history with changelogs for each API template.

---

#### 4. Weekly Timeline (Aligned with GSoC)

##### Community Bonding Period (May 8 – June 1)

 **Onboarding & Planning:**
  - Familiarize with API Dash’s codebase and contribution guidelines.
  - Research high-demand public APIs (e.g., GitHub, OpenWeather, Stripe, popular AI APIs).
  - Define and validate the JSON schema for API templates.
  - Design initial wireframes for the API Explorer dashboard.
  - Engage with mentors and the community to refine architectural decisions.

##### Coding Phase Begins (June 2)

###### Weeks 1–4 (June 2 – July 1)  
**Milestone:** MVP Frontend and Initial Dataset Complete

- Develop the API Explorer dashboard UI using React and Material-UI.
- Implement card-based display, search, and filtering features.
- Manually add 5–10 curated APIs across predefined categories (e.g., AI, Finance, Weather, Social Media).
- Build the "Import" functionality to allow one-click insertion into the workspace.
- Finalize and test the initial JSON schema for API templates.

###### Weeks 5–7 (July 2 – July 18)  
**Milestone:** Backend Pipeline Prototype + Midterm Evaluation

- Implement the OpenAPI parser using `swagger-parser`.
- Develop the HTML/Markdown scraper using BeautifulSoup and NLP models (e.g., BERT).
- Create the rule-based engine for auto-tagging and data enrichment.
- Set up PostgreSQL tables for storing enriched API data.
- Integrate the backend pipeline with the front-end to display generated templates.
- Prepare a demo for the midterm evaluation, showcasing the complete flow from parsing to importing.

###### Weeks 8–10 (July 19 – August 25)  
**Milestone:** Automation Expansion and Community Features

- Finalize the template generator to produce standardized JSON API templates.
- Implement the “Import” API endpoint to push templates into the testing environment.
- Integrate Redis caching for frequently accessed API templates.
- Develop the user feedback (ratings and reviews) system.
- Enable GitHub-based contributions with CI/CD via GitHub Actions.
- Optimize and polish both the backend and frontend components.
- Conduct usability testing with real users to gather feedback.

##### Final Week (August 26 – September 1)

- Conduct a full QA cycle including integration tests, unit tests, and UX validation.
- Finalize comprehensive documentation covering the template schema, contribution processes, and developer setup.
- Submit final code deliverables, evaluation report, and prepare a presentation for final evaluation.

##### Post-Submission (Optional Extensions)

- Monitor community PRs and integrate additional API templates.
- Extend parser support to additional formats (e.g., GraphQL).
- Explore machine learning-based classification for undocumented APIs.
- Further optimize performance and scalability based on user feedback.

