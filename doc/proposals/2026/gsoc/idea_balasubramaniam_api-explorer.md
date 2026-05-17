### Initial Idea Submission

**Full Name:** BALASUBRAMANIAM L  
**University name:** SAVEETHA ENGINEERING COLLEGE  
**Program you are enrolled in (Degree & Major/Minor):** B.Tech, AIML  
**Year:** 2nd Year  
**Expected graduation date:** 2028

**Project Title:** API Explorer
**Relevant Issues:** [https://github.com/foss42/apidash/issues/619](https://github.com/foss42/apidash/issues/619)

---
## Idea Description

### Problem

This project is designed to enhance the API Dash user experience by integrating a curated library of popular and publicly available APIs. This feature allows users to discover, browse, search, and directly import API endpoints into their workspace for seamless testing and exploration. Developers can access pre-configured API request templates, complete with authentication details, sample payloads, and expected responses. This eliminates the need to manually set up API requests, reducing onboarding time and improving efficiency. APIs spanning various domains—such as AI, finance, weather, and social media—are organized into categories, making it easy for users to find relevant services. You are required to develop the entire process backend in the form of an automation pipeline which parses OpenAPI/HTML files, auto-tag it to relevant category, enrich the data, create templates. You can also add features such as user ratings, reviews, and community contributions (via GitHub) to ensure accurate and up-to-date resources


### What I'm Building

API Dash currently has no way for users to discover and import pre-built API requests. I want to add a curated template library — a collection of ready-to-use request templates for popular APIs like OpenAI, Stripe, GitHub, and weather services — that users can browse and import directly into their workspace.

I'm planning to create a `registry.yaml` file that lists every source the pipeline should pull from. Each entry is one of four types:

- **`github_repo`** — a GitHub repo (e.g. `openai/openai-openapi`) that publishes an official OpenAPI spec
- **`raw_url`** — a direct link to a hosted `swagger.json` or spec file
- **`aggregator_feed`** — APIs.guru publishes a machine-readable index of ~2,000 public APIs; one fetch gives a lot of coverage
- **`community_pr`** — a contributor trigger the pipeline and open for PR.

```yaml
# registry.yaml
sources:
  - id: openai
    type: github_repo        # fetched via GitHub API
    url: openai/openai-openapi

  - id: stripe
    type: raw_url            # fetched directly over HTTP
    url: https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json

  - id: apis_guru
    type: aggregator_feed    # one request, hundreds of specs
    url: https://api.apis.guru/v2/list.json

  - id: weatherapi
    type: community_pr       # contributor-submitted file
    path: contrib/weatherapi.yaml
```

I'm writing a fixed set of **adapters** in Python - a small module with one job: fetch the raw spec content and hand it to the pipeline. The pipeline itself never knows whether content came from GitHub or a community PR. It just receives raw content and starts processing.


---

### Pipeline

![API Explorer Workflow](images/apiexplorer-workflow.png)

Once content is fetched, it goes through three main stages — **Parse**, **Validate**, and **Enrich** — and comes out the other end as a clean JSON template.I won't go deep into each stage here since I open the issue for discussion highlevel workflow, and the output of the pipeline is a file like `stripe.json` that contains everything API Dash needs to pre-fill a request: the method, URL, headers, sample body, and auth type.

This pipeline runs inside **GitHub Actions**, which is free and requires no server.


---

### Repository Structure

I'm planning to keep this as **two separate repositories** rather than one monolith or embedding it inside the main API Dash repo.

- **`apidash-templates-core`** — holds the pipeline code: the adapters, registry, and processing logic. This is the engine, written in Python. It runs in CI and is never shipped to the user.
- **`apidash-templates`** — holds only the output: the generated JSON template files and the `index.json` manifest. This repo is what gets deployed and served. Contributors who just want to add a new API template never need to touch the pipeline repo.

The reason I prefer this split is that it keeps concerns clean and makes hosting straightforward — the output repo can be served directly via **GitHub Pages** as an optional human-browsable UI, and via **jsDelivr CDN** as the programmatic fetch endpoint for API Dash. If both lived in one repo, jsDelivr would be mirroring pipeline code alongside template data, which is messy.

---

### `index.json`

I'm proposing a small `index.json` file that lives at the root of the output repo. API Dash fetches this single file on launch. It's lightweight (maybe a few kilobytes) and uses it to render the entire browse UI. It doesn't contain the templates themselves, just metadata pointing to them:

```json
  {
    "id": "stripe-create-charge",
    "name": "Stripe — Create Charge",
    "category": "Finance",
    "version": "1.2.0",
    "url": "cdn.jsdelivr.net/gh/apidash/templates@v1.2/finance/stripe-create-charge.json"
  }
```  

When the user clicks **Import**, API Dash uses the `url` field to fetch just that one template. Everything is lazy,nothing heavy is downloaded until the user actually asks for it.

---

### Versioning

Every successful pipeline run produces a **semantic version tag** (e.g. `v1.3.0`) on the output repo. GitHub Releases capture an immutable snapshot at each tag. jsDelivr's CDN URL includes the version, so `@v1.2` always points to exactly that build — stable and predictable.

---

### Sync — Still an Open Area

I had proposed a hash-comparison approach for sync but I agree it gets messy fast ,cross-checking hundreds or thousands of templates on every run introduces fragility. I think this is worth discussing before committing to an approach. The core question is: **how does the pipeline know what to regenerate?** I want to think through this more carefully rather than propose something that works at 10 templates but breaks at 1,000.

On the client side, API Dash checks the latest tag against its cached version on launch. If they match, nothing is downloaded. If there's a new version, only the updated `index.json` is re-fetched, and individual templates are pulled fresh on next import.

---

### Open Questions

1. **Repo structure** is the first real question. Separate repos keep things clean and make hosting straightforward, but inside the main repo is simpler to manage early on. I lean toward separate but I want to align on this before structuring anything.
2. **Python in the pipeline** feels like the right call given the available tooling, but if there's a strong preference to keep the entire project in Dart or avoid Python as a dependency, I'd like to know that now before the pipeline is built around it.
3. **Sync strategy** is genuinely unsolved. I have a rough idea of version tagging and scheduled runs, but how the client decides when to pull fresh data and how the pipeline decides what to rebuild needs more thought — and is probably the most important design decision left open.
4. **Scope of the registry** : how many sources and categories to target first .Is something I'd like to define together so the initial build has a clear, testable boundary rather than expanding indefinitely. And your thoughts on how to add/update the catalog over time.
