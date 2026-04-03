# GSoC 2026 — API Explorer | foss42/apidash

---

## About

1. **Full Name:** Bhumika Nilesh Ujjainkar
2. **Contact:** bhumikanilesh1810@gmail.com
3. **Discord handle:** bhumikanilesh_47843
4. **Home page:** https://api-explorer-web.vercel.app/
5. **GitHub:** https://github.com/bhumikanilesh
6. **LinkedIn / other socials:** https://www.linkedin.com/in/bhumika-nilesh-ujjainkar/
7. **Time zone:** IST (UTC+5:30)
8. **Resume:** https://docs.google.com/document/d/1hbHxG8hqyH2AbOaVa-qkd2Ra1ddbXyei/edit?usp=sharing&ouid=111447101156064526915&rtpof=true&sd=true

---

## University Info

1. **University:** Visvesvaraya National Institute of Technology (VNIT), Nagpur
2. **Program:** B.Tech in Computer Science and Engineering
3. **Year:** 3rd Year
4. **Expected graduation:** 2026

---

## Motivation & Past Experience

**1. Have you worked on or contributed to a FOSS project before?**

Not yet in terms of merged PRs to external repos, but this proposal is itself the start of that — I built the full 7-phase pipeline POC (~3,560 lines across 8 files) specifically to contribute to API Dash, and this PR is my first open-source contribution. I've worked extensively on open-buildable personal projects (linked below) and am comfortable with GitHub-based collaboration, PR review cycles, and issue-driven development.

**2. What is your one project/achievement you are most proud of? Why?**

My **Network Traffic Monitoring & Alert System** — built in Python using Scapy to capture live packets, flag bandwidth-hogging devices, and visualize traffic in real time. I'm most proud of this one because it required understanding a real protocol (not just an API), working with raw data that doesn't come in a clean format, and turning it into something immediately useful. The pipeline I built for this GSoC proposal has the same structure: messy real-world input, normalization, useful output. The mindset transferred directly.

**3. What kind of problems motivate you most?**

Problems where the gap between "it should work" and "it actually works" is invisible — where something is failing silently and you have to build tooling to see what's happening. That's what drew me to API Dash. The moment before testing — when you're trying to construct the right request for the first time — is full of those invisible gaps. Auth format undocumented, request body schema implied not stated, parameters in the wrong place. I want to close that gap.

**4. Will you be working on GSoC full-time?**

I'll have 7–8 hours per week available for the full 12 weeks, with no exams or other commitments clashing with the GSoC timeline. My 3rd-year coursework runs in parallel but I've planned around it — the timeline below reflects realistic hours, not optimistic ones.

**5. Do you mind regularly syncing up with project mentors?**

Not at all — it's something I actively want. My first priority after selection would be a call or thread with the mentor to go through `explorer_model.dart` and confirm the exact Flutter output format before writing a single line of publisher code. I'd rather spend Week 1 asking questions than Week 6 discovering I built against the wrong schema.

**6. What interests you most about API Dash?**

The decisions it's already made well. When I built a small API Explorer prototype myself, I made a lot of wrong UX choices before arriving at things API Dash had solved from the start — the `{{PLACEHOLDER}}` environment variable syntax being the clearest example. Seeing that system, I immediately understood that the auth header generator in my pipeline needed to output exactly that format. API Dash has thought deeply about what a developer actually needs mid-request. I want to extend that thinking into the discovery layer.

**7. Areas where the project can be improved:**

- **Discovery layer** — the problem this proposal addresses. There's no way to go from "I want to try ElevenLabs" to a working importable request without leaving the app.
- **Spec coverage** — HTML and Markdown-documented APIs (many AI APIs) aren't machine-readable yet. The parser I built handles these as a fallback.
- **Search** — right now there's nothing to search. A pre-built inverted index (Phase 7 of this pipeline) enables instant keyword search without downloading all templates.
- **Community sources** — a `sources.yaml` contributor format would let the community add APIs the pipeline doesn't automatically find.

**8. Have you interacted with and helped the API Dash community?**

I've been reading through the issues, particularly #619 which defines the `PREDEFINED_CATEGORIES` list I implemented in `enricher.py`. _(Add any Discord interactions or GitHub comments you've made here — even a "I'm working on this" comment on the issue counts.)_

---

## Project Proposal Information

### 1. Proposal Title

**API Explorer — 7-Phase Data Pipeline for a Searchable API Marketplace**

---

### 2. Abstract

API Dash solves the testing problem well. What's missing is the moment _before_ testing — when a developer decides to try a new API and spends the next 30 minutes reading docs, figuring out auth headers, and burning real API quota just to get a working first request.

**API Explorer** is the fix: a searchable library of pre-configured request templates that developers can browse and import directly into API Dash — placeholders, sample payloads, and endpoint notes already set up.

This proposal is to build the data pipeline that populates this library: 7 phases that fetch, parse, enrich, validate, publish, and index 2500+ real-world APIs from apis.guru and community sources, outputting a static `marketplace/` directory that the Flutter client can fetch on demand.

> **What I've already done:** Before writing this, I built a proof-of-concept of all 7 phases (~3,560 lines across 8 files) and wrote a test suite covering the core components. The GSoC period is for hardening, running against real data at scale, and integrating properly with the API Dash codebase.

---

### 3. Detailed Description

#### The Problem

Every time a developer wants to try a new API:

- Open the docs, find the right endpoint
- Figure out the exact format — method, path params, headers, body schema
- Debug the first few attempts because the docs were incomplete or auth format wasn't obvious
- Burn real API calls just getting to the first working request

API Dash handles testing once you have a working request. Getting there still takes too long.

**What done looks like:** A developer types "voice synthesis" in API Dash, sees ElevenLabs in the results, imports it, and gets a `POST /v1/text-to-speech/{voice_id}` request with `Authorization: Bearer {{ELEVENLABS_API_KEY}}` ready to fill in. No docs, no setup, no wasted calls.

---

#### Pipeline Architecture

Seven phases running in sequence, each feeding into the next. The full run is orchestrated by `run.py`:

```
python run.py           # full pipeline (real network calls)
python run.py --demo    # full pipeline with mock data — no network, no keys
python run.py --from phase4   # resume from a specific phase
python run.py --only phase5   # run one phase only
```

| #   | File                | Responsibility                                                                                                                      |
| --- | ------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `fetcher.py`        | Download specs from apis.guru + awesome-generative-ai-apis. MD5 snapshot dedup, exponential backoff, graceful degradation.          |
| 2   | `parser.py`         | Parse OpenAPI 3.x / Swagger 2.x / HTML / Markdown → unified endpoint dict. `$ref` resolution with cycle detection, 50-endpoint cap. |
| 3   | `enricher.py`       | Three-layer categorization, `{{PLACEHOLDER}}` auth headers, content-type detection, endpoint notes.                                 |
| 4   | `publisher.py`      | Generate split `marketplace/` structure: `index.json` + `apis/{id}.json` + `categories/{cat}.json`.                                 |
| 5   | `validator.py`      | SecurityScanner, SchemaValidator, DuplicateDetector. Reject invalid templates with logged reasons.                                  |
| 6   | `deployer.py`       | Pre-deployment verification, `.nojekyll`, CORS headers, `manifest.json`.                                                            |
| 7   | `search_indexer.py` | Pre-built inverted index with quality scoring. O(1) keyword lookup — Flutter downloads once, searches locally.                      |

---

#### Phase 1 — fetcher.py

Pulls specs from apis.guru (2500+ OpenAPI/Swagger files) and the awesome-generative-ai-apis GitHub README. The `SnapshotManager` tracks each spec by both the apis.guru `updated` timestamp and an MD5 hash of the content — both are needed because timestamps can drift on the registry side without the spec actually changing:

```python
def needs_update(self, api_id: str, updated: str, spec_hash: str) -> bool:
    if api_id not in self.data:
        return True
    entry = self.data[api_id]
    if entry.get("updated") != updated:
        return True
    if entry.get("spec_hash") != spec_hash:
        return True
    return False
```

Uses `ThreadPoolExecutor` (15 workers) for concurrent downloads with exponential backoff on failures and Retry-After header handling for HTTP 429.

> **Bug caught during POC:** Demo was seeding `"abc123"` as anthropic.com's hash, so `needs_update()` always returned `True` and re-fetched it every run. Fixed by computing the actual MD5 of the mock content.

> **Known gap:** Concurrent snapshot writes need proper locking before running at scale.

---

#### Phase 2 — parser.py

Handles four input formats — all produce the same unified endpoint dict regardless of source format.

**`$ref` resolution with cycle detection.** Real specs (Stripe, Twilio) use `$ref` everywhere. Without resolving, request bodies show up as `{"$ref": "#/components/schemas/XYZ"}` — useless in a template. Circular schemas (a `Node` with a `child: $ref Node`) are caught via a resolution chain set:

```python
if ref_path in self._resolving:
    return {}  # circular — return empty, don't loop forever
self._resolving.add(ref_path)
try:
    return self._resolve_inner(ref_path, spec)
finally:
    self._resolving.discard(ref_path)  # stays reusable after each call
```

**Swagger 2.x vs OpenAPI 3.x base URL** — two completely different structures handled by separate parser classes, both outputting the same unified dict.

**50-endpoint cap** — Stripe has 400+ endpoints. `MAX_ENDPOINTS_PER_API = 50` keeps files manageable.

> **Known gap:** External file refs (`"$ref": "other-file.yaml#/..."`) return empty silently. Some real-world specs use these.

---

#### Phase 3 — enricher.py

Makes templates immediately usable on import. The `{{PLACEHOLDER}}` auth syntax matches API Dash's existing environment variable system exactly:

```python
if auth_scheme == "bearer":
    return {"Authorization": f"Bearer {{{{{placeholder_name}}}}}"}
# → {"Authorization": "Bearer {{ELEVENLABS_API_KEY}}"}
```

**Three-layer categorization** based on the `PREDEFINED_CATEGORIES` list from issue #619: apis.guru categories mapped first, keyword fallback on title + description, `"other"` as final fallback. All results validated against the predefined set before writing.

> **Bug caught during POC:** `"image"` was in the multipart/form-data trigger keywords. OpenAI's `/images/generations` takes a JSON body, not a file upload. Removed — correct triggers are `"file"`, `"upload"`, `"attachment"`.

---

#### Phase 4 — publisher.py

Generates a split file structure so Flutter only downloads what it needs:

```
marketplace/
  index.json              ← ~300KB for 2500 APIs, loaded once on startup
  apis/openai.json        ← full template, fetched only when user opens this API
  categories/voice.json   ← API list for this category, fetched on filter
  search/index.json       ← pre-built inverted index
  manifest.json           ← stats for Flutter "last updated" display
```

All 2500 full templates upfront would be 50–100MB — not viable on mobile.

`write_if_changed()` skips writes when content is identical, keeping weekly CI diffs reviewable:

```python
new_hash = hashlib.md5(new_content.encode()).hexdigest()
if filepath.exists():
    existing_hash = hashlib.md5(filepath.read_text().encode()).hexdigest()
    if existing_hash == new_hash:
        return False  # no write — GitHub Actions won't see noise commit
```

> **Important:** The `info + requests` template structure is based on reading issue #619. Confirming exact field names against `explorer_model.dart` is my first Week 1 task — if they don't match, imports fail silently.

---

#### Phase 5 — validator.py

Three-layer validation. Failures logged with reasons to `validation_report.json` — maintainers can review patterns.

**SecurityScanner** catches accidentally included real credentials. The `(?!{{)` negative lookahead excludes our own `{{PLACEHOLDER}}` format:

```python
(re.compile(r'sk-[a-zA-Z0-9]{20,}'),                         "OpenAI API key"),
(re.compile(r'AKIA[0-9A-Z]{16}'),                             "AWS access key"),
(re.compile(r'Bearer\s+(?!{{)[a-zA-Z0-9+/]{40,}={0,2}'),     "Hardcoded bearer token"),
```

**DuplicateDetector** normalizes titles before comparison so `"Stripe API v3.1"` catches as a duplicate of `"Stripe API"`.

> **Bug caught during POC:** `_update_index()` compared bare filenames (`"openai.json"`) against index entries stored as `"apis/openai.json"`. Removed templates stayed in the index. Fixed: `removed_set = {f"apis/{name}" for name in removed_filenames}`

> **Known gap:** SecurityScanner currently only scans headers. Leaked keys also appear in request bodies and URLs.

---

#### Phase 6 — deployer.py

Pre-deployment verification before the GitHub Pages commit. The one that matters most:

```python
# Without .nojekyll, GitHub Pages runs Jekyll which silently drops .json files
# making the entire marketplace unreachable from Flutter
nojekyll_path = self.marketplace_dir / ".nojekyll"
nojekyll_path.write_text("")
```

`PreDeploymentVerifier` checks that file count in `apis/` matches index entries — a mismatch means something went wrong in Phase 5.

---

#### Phase 7 — search_indexer.py

Pre-built inverted index enabling O(1) keyword lookup after a single download:

```json
{
  "terms": {
    "voice": ["elevenlabs", "lovo-ai", "playht"],
    "image": ["openai", "stability-ai"]
  },
  "apis": {
    "elevenlabs": {
      "title": "ElevenLabs API",
      "score": 87,
      "tags": ["voice", "ai"]
    }
  }
}
```

Quality scoring (0–100) ranks results by description completeness, endpoint count, auth headers present, request bodies, source reliability. Stop words filtered, terms under 3 chars dropped, max 50 terms per API.

> **Known gap:** Scoring weights are based on intuition. Whether they surface the most useful APIs first needs validation on real data.

---

#### Validation & Error Handling

The validator correctly detects and rejects templates with schema issues, duplicate entries, and security problems before anything reaches the marketplace.

**Duplicate detection:**

![Duplicate APIs rejected](images/rejected_api_duplicates.png)

**Schema validation errors:**

![Schema errors caught](images/rejected_api_schema_issue.png)

**Security issue detection:**

![Security issues flagged](images/rejected_api_security_reason.png)

**Full validation report with reasons:**

![Validation report](images/validation_report_with_reason.png)

---

#### Test Suite

Tests came from actually running the code and finding what broke. Not written after the fact.

**Parser tests (~50 tests across 8 classes)**

`TestRefResolver` — four failure modes that would corrupt templates silently: circular ref returns `{}`, external ref returns `{}`, missing ref returns `{}`, `finally: discard()` keeps resolver reusable.

`TestOpenAPIParser` — basic GET/POST, multiple methods on one path, `$ref` resolved in request body, path-level params merged with operation params, 50-endpoint cap enforced:

```python
def test_endpoint_cap_at_50(self):
    paths = {f"/ep{i}": {"get": {"summary": f"EP {i}"}} for i in range(60)}
    result = OpenAPIParser().parse(spec_with(paths))
    assert result["endpoint_count"] <= 50
```

**Enricher tests (~40 tests across 5 classes)**

`TestSecurityScanner` — the two cases that matter most:

```python
def test_placeholder_not_flagged(self):
    template = self._wrap({"Authorization": "Bearer {{OPENAI_API_KEY}}"})
    assert SecurityScanner().scan(template) == []

def test_openai_key_detected(self):
    template = self._wrap({"Authorization": "Bearer sk-abc12345678901234567890"})
    assert len(SecurityScanner().scan(template)) > 0
```

`TestDuplicateDetector` — version numbers stripped during comparison. `TestWriteIfChanged` — same content returns False, changed returns True, parent dirs created.

**Validator integration tests (6 tests)** — full validate-and-remove flow including the path prefix bug fix verified on disk.

**Deployer tests (13 tests)** — missing index fails, invalid JSON fails, file count mismatch is a warning not a hard error, all config files created.

**Search indexer tests (6 tests)** — term mapping correct, higher-scored APIs ranked first, missing index returns `"failed"` status.

**Test suite running:**

![Tests running](images/tests.png)

---

### Full Documentation & Live Demo

https://api-explorer-web.vercel.app/

---

### Link to Sample UI created in Figma

## https://github.com/user-attachments/assets/7b166a97-c079-49ed-9944-4f3e9160aa2d

## Proof of Concept

- GitHub Repository: https://github.com/bhumikanilesh/api-explorer-pipeline
- CI (GitHub Actions): https://github.com/bhumikanilesh/api-explorer-pipeline/actions

---

### 4. Weekly Timeline

12 weeks, 7–8 hours per week. Buffer built in — real pipelines at scale always find surprises.

| Week   | Focus                              | What I'm actually doing                                                                                                                     |
| ------ | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **1**  | Alignment                          | Read `explorer_model.dart`. Confirm Flutter output format with mentor. Run pipeline on 20–30 real apis.guru specs, document what breaks.    |
| **2**  | fetcher.py hardening               | Fix snapshot race condition (concurrent writes need locking). Run on 200+ real specs. Write tests for retry logic and graceful degradation. |
| **3**  | parser.py — real data              | Run against real Stripe, Twilio, GitHub specs. Fix what breaks. Add external `$ref` support. Handle non-UTF-8 encoded specs.                |
| **4**  | parser.py edge cases + enricher.py | Handle `allOf`/`oneOf`/`anyOf` from real specs. Fix category false positives. Start profiling memory.                                       |
| **5**  | publisher.py                       | Build to the confirmed Flutter format. Verify `write_if_changed()` in CI. Test index merge with deletes.                                    |
| **6**  | validator.py                       | Extend SecurityScanner to cover request bodies and URLs. Validate `_update_index()` fix on real data. Tune schema rules.                    |
| **7**  | search_indexer.py                  | Run on full 2500+ API set. Check actual index size. Tune quality scoring weights based on real results.                                     |
| **8**  | deployer.py + GitHub Actions       | Write `.github/workflows/` CI file. Test CORS with actual Flutter web fetch. End-to-end deploy test.                                        |
| **9**  | Full pipeline run                  | All 7 phases on complete apis.guru dataset. Fix failures. Profile and fix memory issues.                                                    |
| **10** | Buffer                             | Empty by design — for whatever Week 9 surfaces. Mentor review feedback. No new features.                                                    |
| **11** | Docs                               | README, `sources.yaml` contributor guide, architecture diagram, inline docstrings, how-to-add-a-source walkthrough.                         |
| **12** | Final polish + PR                  | End-to-end demo on real data. Review fixes. Open PR. GSoC final report.                                                                     |
