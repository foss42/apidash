# GSoC 2026 API Dash Proposal

# API EXPLORER for API Dash

###    **Personal Details:**

Full Name	: 	BALASUBRAMANIAM L  
Email		: 	 balasubramaniam12007@gmail.com  
Discord	: 	.balasubramaniam  
GitHub	: 	[Balasubramaniam](https://github.com/BalaSubramaniam12007)  
LinkedIn	:	[Balasubramaniam](http://www.linkedin.com/in/balasubramaniam2007)  
Twitter	: 	[Balasubramaniam](https://x.com/BALASUBRAMAN1AM)  
Resume	:	https://example.com/resume_balasubramaniam.pdf  
Time zone	: 	GMT+5:30

## **University Info:**

University name	:	Saveetha University, Chennai  
Institution name	:	Saveetha Engineering College  
Degree & Major	:	Bachelor of Technology  
Year			:	2nd Year  
Graduation		:	2028

## **Motivation & Past Experience** 

### **1\. What interests you the most about API Dash?**

API Dash stood out to me as a lightweight, developer-focused tool. Over the past year, contributing across multiple parts of the codebase has given me a deep understanding of how the app is structured and where it can grow. What interests me most now is building something substantial like the API Explorer that adds real discovery value for developers. The community has been consistently supportive, which makes it the right place to do meaningful GSoC work.

### **2\. Have you worked on or contributed to a FOSS project before?**

Yes, I have contributed to API Dash and other open-source projects previously.

#### API Dash

1. Tab Bar ([PR \#676](https://github.com/foss42/apidash/pull/676) ): Implemented the tab bar to display a list of API requests as interactive tabs, supporting selection, closing, and reordering  
2. Global Status Bar ([PR \#665](https://github.com/foss42/apidash/pull/665)) — Implemented a centralized status bar to display failed requests, warnings, and validation errors, improving overall error visibility.

#### ESP-Website

1. Fix IndexError in StatisticsQueryForm ([PR \#4340](https://github.com/learning-unlimited/ESP-Website/pull/4340)) — Added validation checks to handle empty datasets, preventing runtime crashes.  
2. Technical Walkthrough README ([PR \#4587](https://github.com/learning-unlimited/ESP-Website/pull/4587)) — Created a module-level README covering architecture, routing, and onboarding for new contributors.

   Other Meaningful Contributions

[*PR \#643*](https://github.com/foss42/apidash/pull/643) *· [PR \#661](https://github.com/foss42/apidash/pull/661)  · [PR \#676](https://github.com/foss42/apidash/pull/676) · [PR \#829](https://github.com/foss42/apidash/pull/829) · [PR \#4505](https://github.com/learning-unlimited/ESP-Website/pull/4505) · [PR \#4698](https://github.com/learning-unlimited/ESP-Website/pull/4698) · [PR \#4701](https://github.com/learning-unlimited/ESP-Website/pull/4701) · [PR \#5101](https://github.com/learning-unlimited/ESP-Website/pull/5101)*

**3\. Will you be working on GSoC full-time?**  
I will not have any exams or other commitments during the entire coding period, allowing me to dedicate my full focus entirely to the project.

### **4\. Do you mind regularly syncing up with the project mentors?**

I will communicate with mentors through calls or chats for task updates and suggestions while remaining self-reliant between check-ins.

# Project Title: API EXPLORER

## **Abstract:**

The proposal focuses on enhancing the API Dash user experience by creating a comprehensive API Explorer. The project will integrate a curated library of popular, publicly available APIs, simplifying the process for developers to discover, test, and import API endpoints into their workspaces. An automated CI/CD pipeline will be developed to parse OpenAPI specification files, enrich and auto-tag the extracted data, and produce standardized JSON templates. This system aims to pre-configure authentication details, sample payloads, and expected responses, significantly reducing the manual setup time for developers. Additionally, the platform will feature a modern user interface that organizes APIs by domain, such as AI, finance, and social media, while supporting direct imports into testing environments and encouraging community contributions. Ultimately, this solution is designed to reduce onboarding time and enhance efficiency, positioning API Dash as a valuable tool for API exploration and integration.

#### **Concrete goals by the end of GSoC:**

* ≥ 50 public APIs indexed at launch spanning 6+ categories  
* Parser handles OpenAPI 2.0, 3.0.x, and 3.1.x  
* ≥ 95% of generated templates pass API Dash RequestModel validation  
* Full import-to-workspace flow is working on all supported API Dash platforms  
* Automated daily sync with change detection; no manual template maintenance required after launch

## **Detailed Description:**

This project focuses on building a complete ecosystem for discovering and consuming public OPENAPIs within API Dash, powered by an automated pipeline and static delivery model.

### **1\. Source Registry and Ingestion Strategy**

Maintainer-managed registry.json files contain the definitions for OpenAPI specification sources, including their name, category, and source URL.

New sources are added by maintainers via the input.json file. This action triggers the Ingestion Workflow, which populates registry.json with flat key-value entries and defines batch assignments in batch.json.

A batch is a list of API IDs to check the version. This system processes one batch per execution. This approach maintains operational stability for API versioning updates and prevents GitHub Action rate limiting.

Ingestion is managed through two specialized GitHub Actions workflows:

* **Workflow 1:** Source Ingestion. Triggered by modifications to input.json, this workflow detects new sources, organizes them into batches, and updates registry.json.  
* **Workflow 2:** Daily Versioning Sync. A single batch from batch.json is processed daily to monitor for API version updates.

### **2\. Sync and Versioning Workflow**

During daily sync, each source is checked using HTTP metadata (ETag / Last-Modified).

* If unchanged → skip  
* If changed → fetch spec → compute hash → confirm actual change → trigger pipeline

This ensures only meaningful updates trigger regeneration and avoid unnecessary processing.

### **3\. Template Generation Pipeline (Parsing → Enrichment → Template Generation → Validation)**

The pipeline converts OpenAPI specifications into API Dash-compatible request templates.

Parsing & Extraction

* Parse OpenAPI YAML/JSON files  
* Extract endpoints, methods, request bodies, headers, and authentication schemes.

Mapping to API Dash Request Model

* Convert OpenAPI structures into API Dash request format  
* Handle edge cases:  
* Path parameters retained as placeholders in URL  
* Multiple content types resolved to a default (JSON)  
* Security schemes mapped to API Dash authentication models

Data Enrichment

* Use category defined in registry (AI, finance, weather, etc.)  
* Add minimal metadata (description, version info)

Template Generation

* Generate structured JSON templates compatible with API Dash  
* Organize outputs into versioned directories

Validation and Security Checks

* Validate structure against API Dash request model   
* Detect and remove hardcoded secrets (API keys, tokens)  
* Allow only placeholder-based authentication (e.g., {{API\_KEY}})

### **4\. Storage and Distribution**

Generated templates are stored in a separate GitHub repository as the source of truth

* Organized by API and its version  
* Global index and per-API index are generated

jsDelivr serves this templates repository as a CDN layer over GitHub.

* Immutable versioned files are cached efficiently.  
* The latest data is accessed through index references  
* Additionally, pointer \+ purge strategy enables near-instant cache updates

This provides fast global delivery, avoids GitHub rate limits, and eliminates the need for backend infrastructure.

**5\. Index-Based Data Access**  
The system introduces two index files that are used as navigation layers.

* The global index provides the list of APIs and categories so the client can render the API Explorer immediately.  
* The per-API index provides the list of endpoints for a selected API.

This allows the client to:

* Load minimal metadata initially  
* Fetch only required templates on demand  
* Avoid scanning or downloading unnecessary files

### **6\. Client (API Dash Consumption)**

The client interacts directly with jsDelivr.

* On startup, it fetches the global index to display the list of APIs  
* On API selection, it fetches the per-API index for that API’s latest version  
* On endpoint selection, it fetches the corresponding template file and loads it into API Dash

This enables lazy loading and keeps the client lightweight with no backend dependency.

### **7\. Sync and Versioning Management**

Versioning is handled at the API level.

* Workflow 2 generates new template versions upon detecting changes.  
* Previous versions are preserved and never overwritten  
* Versions are identified by timestamps (e.g., YYYY-MM-DD) or Version ID(e.g., V1, V2), a standard to be confirmed during the community bonding period  
* It also ensures reproducibility, as users can access any previously generated version.

Batch-based sync ensures updates are processed gradually, preventing overload and maintaining stability.

## **Implementing Essential Features (Project Deliverables)**

### **1\. Repo Structure**

How I will implement it

* API Dash Application →  Main repository   
* Generated Templates \+ Indexes → Separate repository (public)

Template Repository Structure:

```text
api-explorer/
├── api_templates/                 Production JSON served via CDN
│   ├── current.json               Points to the latest commit SHA
│   ├── global_index.json          Global API and category catalog
│   └── apis/
│       └── {api_id}/
│           ├── index.json         API metadata and versions
│           └── {version}/         Versioned endpoint collections
│               └── templates.json
├── pipeline/                      Generation engine
│   └── lib/
│       ├── parser.dart
│       └── generator.dart
└── registry/                      Build and state management
    ├── registry.json              Source of truth for API sources
    ├── batch.json                 Batch grouping and rotation state
    ├── hashes.json                Change detection state
    └── input.json                 Temporary input for new sources
```

Why this approach

* Clear separation of concerns  
* Predictable paths for client fetch  
* Versioned data is immutable and CDN-friendly

### **2\. Source Registry**

How I will implement it

* Maintain registry.json as a flat key-value dictionary in the template repo  
* Each key is the source ID; the value contains name, openapi\_url, and category  
* Workflow 1 writes new entries from input.json; maintainers never edit registry.json directly  
* Validate new entries before they enter sync

Why this approach

* Keeps source onboarding maintainer-driven  
* Gives one source of truth for all registered APIs  
* A flat key-value structure makes lookups, merges, and batch assignment straightforward.

Sample  Flat key-value:

```json
{
  "openai": {
    "name": "OpenAI API",
    "openapi_url": "https://.../openapi.json",
    "category": "ai"
  }
}
```

### **3\. Discovery and Sync Workflows**

How I will implement it

* Use two GitHub Actions workflows  
* Ingestion workflow triggers on input.json changes; writes new sources into registry.json and assigns them to batches   
* Daily workflow processes only one batch per run  
* Batch membership is stored separately and rotated over time  
* `input.json` is reset to `{}` after ingestion.

Why this approach

* Separates onboarding from synchronization  
* Event-driven trigger runs only when sources are actually added  
* Controls GitHub Action daily rate-limit pressure

### **4\. Source Specification Change Detection**

How I will implement it

* Check ETag and Last-Modified first  
* If metadata suggests a change, fetch the spec  
* Compute a hash on the fetched content  
* Compare with the stored hash in hashes.json for that source  
* Trigger regeneration only when the hash changes

Why this approach

* Skips unchanged sources early  
* Avoids unnecessary regeneration  
* Keeps sync efficient without a backend state service

### **5\. Parsing and Mapping**

How I will implement it

* Parse OpenAPI YAML/JSON files  
* Extract endpoints, methods, request bodies, headers, and authentication schemes  
* Map OpenAPI into API Dash request models  
* Keep path parameters as placeholders in the URL  
* Map security schemes into API Dash auth models  
* Add minimal enrichment, such as a description  
* Generate API Dash-compatible templates from the mapped model

### **6\. Validation and Security Checks**

How I will implement it

* Validate required request fields after generation  
* Check that template paths referenced by indexes exist  
* Reject malformed JSON  
* Detect hardcoded secrets or unsafe values  
* Allow only placeholder-based secrets like {{API\_KEY}}  
* Run a post-generation structure check against the API Dash request model

Why this approach

* Prevents broken templates from being published  
* Reduces manual review burden  
* Protects against accidental secret leakage

### **7\. Template Storage and Version Management**

How I will implement it

* Store generated output in a separate template repository  
* Organize files by API and its version  
* Preserve older versions without overwriting them  
* Regenerate into a new version folder whenever a source changes

### **8\. Index Generation**

How I will implement it

* Generate a global index for API discovery  
* Generate a per-API index for endpoint listing  
* Keep both index files lightweight and navigation-focused

Why this approach

* Let the client load only what it needs  
* Avoids scanning all template files  
* Supports API-level browsing with minimal fetch cost

### **9\. CDN Delivery and Client Fetch Flow**

How I will implement it

* Serve template repo via jsDelivr  
* Base URL (branch):

```text
https://cdn.jsdelivr.net/gh/<org>/<repo>@main/api_templates/
```

* Pointer (latest commit):

```text
GET https://cdn.jsdelivr.net/gh/<org>/<repo>@main/api_templates/current.json -> 
{ "sha": "<commit-sha>", "updatedAt": "..." }
```

* Immutable fetch using SHA: once the client has the SHA, all asset fetches are SHA-pinned; jsDelivr caches these permanently at every edge node, so no request ever hits GitHub origin
* Global index fetched on app load:

```text
GET https://cdn.jsdelivr.net/gh/<org>/<repo>@<sha>/api_templates/global_index.json
```

* Per-API index fetched lazily when the user opens an API:

```text
https://cdn.jsdelivr.net/gh/<org>/<repo>@<sha>/api_templates/apis/<api-id>/<version>/index.json
```

* Template file fetched lazily when the user selects an endpoint:

```text
https://cdn.jsdelivr.net/gh/<org>/<repo>@<sha>/api_templates/apis/<api-id>/<version>/templates/<endpoint>.json
```

* After each publish, CI/CD immediately purges the pointer file:

```text
GET https://purge.jsdelivr.net/gh/<org>/<repo>@main/api_templates/current.json
```

* So the next client fetch gets the new SHA within seconds.

Why this approach

* Immutable URLs → perfect CDN caching  
* Pointer \+ purge → near-instant updates   
* No backend needed; GitHub \+ CDN acts as a delivery layer  
* Client performs minimal, ordered fetches (lazy loading)

### **10\. UI Explorer and Import Flow**

* Explorer List View with API cards, search bar, and category filters  
* Category chips derived from the global index  
* Client-side filtering based on search and category  
* API Detail View with two-pane layout (endpoint list \+ template preview)  
* Endpoint list with HTTP method badges  
* Template preview showing URL, headers, params, and body  
* Import button for single endpoint and Import All option  
* Imported templates mapped into the API Dash RequestModel and redirected to the Requests tab

### **API EXPLORER Design :**

**Click here to check the UI prototype:  [Figma Link](https://www.figma.com/design/QIvRRUuZJbau67cAOWI55k/apidash-ui?node-id=0-1&t=Nf5Zs7YJvaPyk191-1)**

## **Weekly Timeline (12 Weeks)**

### **Community Bonding Period**

* Discuss the project scope, architecture, and boundaries with mentors  

* Discuss the project scope, architecture, and boundaries with mentors  
* Finalize template structure, metadata fields, and naming conventions  
* Confirm registry format, batching strategy, and versioning approach

### **Week 1: Project Setup & Repository Structure**

* Set up the main API Dash repo and separate template repo  
* Define registry.json, batch.json, global index, and per-API folder structure  
* Prepare base GitHub Actions workflow files

*Deliverable: Both repositories structured; registry and batch logic ready*

### **Week 2: Pipeline Parser**

* Parse OpenAPI YAML and JSON specification files  
* Extract endpoints, HTTP methods, headers, request bodies, and authentication schemes.  
* Handle $ref resolution and schema composition; add explicit handling for the cases where the package fails (catch \+ log)  
* Detect OpenAPI version (2.0 vs 3.0.x vs 3.1.x) and apply version-specific extraction logic  
* Test the parser against 3–5 real-world API specifications

*Deliverable: Parser correctly extracts raw endpoint data from OpenAPI specs*

### **Week 3: Mapping and Template Generation**

* Handle path parameters, request body variants, and authentication schemes  
* Map the parsed OpenAPI data into the API Dash request model  
* Map security schemes into API Dash authentication models  
* Handle allOf (merge), oneOf/anyOf (pick first concrete schema, log warning)  
* Add minimal enrichment: category, description, and version info

*Deliverable: API Dash-compatible templates generated from OpenAPI specs*

####   

#### 

#### **Week 4: Validation and Security Checks**

* Add validation for required fields and structure  
* Reject malformed JSON and broken references  
* Implement placeholder-based secrets instead of hardcoded values

*Deliverable: validated and secure template output*

#### **Week 5: Index Generation and Versioned Storage**

* Generate the global index and per-API index files  
* Organize generated output into versioned folders per API  
* Preserve older versions without overwriting them

*Deliverable: Global and per-API indexes generated; versioned storage working*

#### **Week 6: Automation with GitHub Actions**

* Set up the input.json-triggered source ingestion workflow  
* Set up the daily sync workflow with batching  
* Add ETag / Last-Modified checks and hash-based change detection

*Deliverable: automated pipeline for source sync and template generation*

*Mid Evaluation: Working pipeline with a validated, versioned template output published to the template repository.*

#### **Week 7: CDN Setup and Data Delivery**

* Connect the template repository to jsDelivr  
* Implement the current.json pointer and purge flow  
* Confirm correct fetching of the global index, API index, and template files.  
* Confirm lazy loading works end-to-end from CDN inside API Dash

*Deliverable: CDN-based delivery confirmed working end-to-end*

#### **Week 8: Explorer List View**

* Build the Explorer list view with API cards, category chips, and a search bar.  
* Load API cards from the global index via the CDN  
* Implement client-side filtering by API name and category

#### *Deliverable: Working Explorer list view with search and category filters*

#### **Week 9: API Detail View & Import Flow**

* Build the API detail view with the endpoint list and template preview  
* Implement single-endpoint import and Import All, mapping templates into API Dash RequestModel  
* Implement the import flow from Explorer into the API Dash request model

*Deliverable: browse and import flow working end-to-end*

#### **Week 10: Edge Cases & Mentor Feedback**

* Handle empty states, loading indicators, and fetch error scenarios  
* Cover edge cases: APIs with no endpoints, missing fields, and large endpoint lists  
* Refine client-side search and filter behavior  
* Incorporate community and mentor feedback on the UI

*Deliverable: UI stable with edge cases handled*

#### **Week 11: Testing and Integration**

* Write unit tests for parsing, generation, and validation  
* Add widget and integration tests for the UI and import flow  
* Run end-to-end checks across the pipeline, CDN, and client

*Deliverable: Tested and stable system behavior*

#### **Week 12: Optimization, Documentation, and Final Review**

* Analyze performance and quality to ensure features work smoothly.  
* Final review with mentors.  
* Prepare technical documentation and contribution documentation.

*Deliverable: Prepare documentation for final evaluation*  
   
*Final Evaluation*		

### **Future Enhancements**

1. Deeper oneOf/anyOf handling — generate variant templates for all concrete schemas in a union type, not just the first

2. Community API submissions — a structured PR template and CI validator that lets external contributors propose new APIs to input.json with automated spec validation before maintainer review

3. Non-OpenAPI source ingestion — a parser for API reference pages that lack OpenAPI specs (scraping \+ LLM-assisted extraction)

4. GitHub Actions matrix builds — parallelize batch processing across matrix jobs once the registry exceeds 100 APIs
