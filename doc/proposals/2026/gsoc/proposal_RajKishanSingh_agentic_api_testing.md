Full name : Raj Kishan Singh
Contact info : 
1. email : rajkishan221b@gmail.com
2. linkedin : www.linkedin.com/in/rajkishan-singh-942509333
3. Discord Handle in the server : notasura_
4. Github profile link : https://github.com/Super-Hacker1

Time Zone : Kolkata/Asia (IST)

University info :
1. Name : Kalinga Institute of Industrial Technology
2. Program : Bachelors in Technology - Computer Science
3. First year student
4. Expected graduation year : 2029

## AGENTIC API TESTING AND DOCUMENTATION

### ABSTRACT : 
APIDash currently does not provide any structured way to perform API quality assurance or maintain its documentation. It only handles individual request–response cycles. Additionally, testing a collection containing a large number of APIs is time‑consuming and can become inconsistent when multiple people are working on it. And since to be human is to err, APIs are always prone to human mistakes.

We have seen cases where a small error led to a global catastrophe.  
The [2020 Twitter account hijacking](https://en.wikipedia.org/wiki/2020_Twitter_account_hijacking) and the [Peloton API leak](https://salt.security/blog/the-peloton-api-security-incident-what-happened-and-how-you-can-protect-yourself) are just two examples among many.

Beyond testing, proper API documentation is consistently one of the most neglected parts of the development workflow. Developers often write documentation once and forget to update it when the API changes.  
This leads to people like me—who are trying to learn and implement those APIs—following outdated documentation and scratching their heads wondering why the APIs are not returning the expected responses.


------------------
### Feature Implementation: 

The feature will be applied as pipeline:

Observe the API response → Assert + Extract from the response → Chain into next call → Document automatically (Open API 3.1 spec) → AI assists at every step

### Details on the stages:
#### Stage 1 — Selectors : 
There will be **selectors** that will point at parts of an API response using JSONPath, regex, header name, body size, or status code. 
The selectors will serve two purposes simultaneously: 
1. To evaluate assertion rules to validate the response is correct and mark it Pass/Fail.
2. To extract the values required for 2nd stage.

```
Input: A response + A selector rule 
Output: A value 

Example: Response: { "data": { "token": "abc123" } } Selector: JSONPath → $.data.token Output: "abc123"
```

#### Stage 2 — Chaining : 
The values extracted in Stage 1 are saved as scoped runtime variables using the existing `{{VAR}}` syntax APIDash already supports. 
There will be **Workflow Engine** that will inject these variables into subsequent API calls — URL, headers, and body.
It will enable multi-step flows like login → authenticated call → paginated fetch to run automatically without any manual copy-paste. 

Each group supports AND logic (all rules must pass) and OR logic (at least one rule must pass).

There will **assertion groups** that will check at each step for failed assertions. A failed assertion will abort the chain immediately instead of continuing downstream. Each group supports AND logic (all rules must pass) and OR logic (at least one rule must pass).


```
Input: A collection of requests + Chain config + Assertion groups 
Output: A complete run result with pass/fail per step

Workflow Engine
│
├── runs requests sequentially
│
├── calls Selectors   ← for extraction
│     └── "find $.data.token in this response"
│
├── calls Selectors   ← for assertion evaluation
│     └── "does $.data.token EXIST in this response?"
│
├── uses the results to decide:
│     → pass → proceed to next step
│     → fail → skip / abort / continue
│
├── injects extracted variables into next request
│
└── records everything in Run History
```
#### Stage 3 — Continuously Evolving Spec : 
Every response observed during a chain run will be automatically fed into the spec system. 
Each new response will be merged into an accumulated schema that grows more accurate with every run by:
- Adding newly discovered fields that were absent in previous runs.
- Marking fields as nullable when a null value is observed for the first time.
- Marking fields as optional when they are absent in some runs but present in others.
- Embedding real example values taken directly from the most recent actual response.

The end result after several runs will be a valid OpenAPI 3.1 document(SPEC Doc) in YAML or JSON format. It will reflect what the API actually does. A spec gap detector will flag any endpoint present in the collection that have not yet contributed a response and will prompt the developer to run those so that the coverage is complete. The document can be exported and used directly in tools like Swagger UI.

### Example
**Run 1** — Collection runs for the first time:

``` json
json
POST /users → { "id": 1, "name": "Raj", "email": "raj@gmail.com" }
```
``` json
Spec learns:  id (integer), name (string), email (string)
```

**Run 2** — Collection runs for the 2nd time, this time a user with an avatar:

```json
POST /users → { "id": 2, "name": "Jay", "email": "jay@gmail.com", "avatar": "https://..." }
```
``` json
Spec learns:  avatar exists! Adds avatar (string) to schema
```

**Run 3** — Collection runs for the third time, a user with no avatar set:

json

```json
POST /users → { "id": 3, "name": "Arjun", "email": "arjun@gmail.com", "avatar": null }
```
``` json
Spec learns:  avatar can be null! Marks avatar as nullable: true
```

**After 5 runs** — The spec now accurately reflects reality:

yaml

```yaml
properties:
  id:
    type: integer
    example: 3
  name:
    type: string
    example: "Raj"
  email:
    type: string
    example: "Raj@gmail.com"
  avatar:
    type: string
    nullable: true
    example: "https://cdn.example.com/avatars/raj.jpg"
```

Voila! The spec built itself from real data.

#### Stage 4 — AI Assist : 
There will be an Agentic AI Layer that will be present across all three stages as an intelligent assistant. It will be used to propose assertion suites from observed responses to avoid writing them manually, explaining failures in plain English with concrete fix suggestions. 
It can also be used to build entire chain configurations from a natural language description of the workflow, and enriches the generated spec with human-readable descriptions and inferred security schemes.

###### The Overview of the AI Assist Flow: 

```
┌─────────────────────────────────────────────┐
│           APIDash AI Assist Layer           │
├─────────────────────────────────────────────┤
│                                             │
│  Natural Language Input → Intent Parser     │
│          ↓                                  │
│  Agent Planner (decomposes into steps)      │
│          ↓                                  │
│  Tool Executor                              │
│  ├── Selector                               │
│  ├── Chaining (Runner + Assertions)         │
│  └── Spec Generator.                        │
│          ↓                                  │
│  Result Interpreter → Plain English Output  │
│                                             │
└─────────────────────────────────────────────┘
```

There will be 3 sub parts of AI Assist which let me explain using example: 

#### Part 1 : Assertion Generation
``` json
// Example Response

HTTP/1.1 200 OK
Content-Type: application/json
Response time: 245ms

{
  "data": {
    "id": 42,
    "email": "raj@gmail.com",
    "token": "eyJhbGci..."
  },
  "meta": {
    "total": 1
  }
}
```

The AI looks at the response and proposes the following:
```
- status == 200
- body.data.id EXISTS
- body.data.email matches regex [email format]
- body.meta.total is integer
- responseTime < 800ms
- Content-Type header contains application/json

Accept all / Edit individually / Reject
```

Once accepted 6 assertions will be created.

The agents will receive the inputs in structured prompt using markdown file which is a highly effective technique. 

Prompt.md
```` markdown
# API Assertion Generation Prompt

## Role
You are an API testing assistant. Your job is to analyze an HTTP response
and suggest a complete set of assertions that validate the response is
correct, complete, and performant.
---

## Selector Types Available

| Selector | Used For | Example |
|---|---|---|
| `status_code` | HTTP response status | `== 200` |
| `jsonpath` | Fields inside the response body | `$.data.token EXISTS` |
| `regex` | Formatted strings — emails, UUIDs, dates, tokens | `^[a-zA-Z0-9+/]+={0,2}$` |
| `header` | Response headers | `Content-Type contains application/json` |
| `response_time` | Latency threshold in milliseconds | `< 800` |

---

## HTTP Response to Analyze
``` json
Status:  200
Time:    245ms

Headers:
  Content-Type: application/json

Body:
  {
    "data": {
      "id": 42,
      "email": "raj@gmail.com",
      "token": "eyJhbGci..."
    },
    "meta": {
      "total": 1
    }
  }
```

---

## Output Format

Return a JSON array of assertion objects. Each object must follow this
exact schema:
```json
[
  {
    "selector_type": "status_code | jsonpath | regex | header | response_time",
    "path": "field path, header name, or null if not applicable",
    "operator": "exists | equals | not_equals | contains | matches_regex | gt | lt",
    "expected": "expected value or pattern",
    "description": "one line explaining what this assertion validates"
  }
]
```

---

## Rules
- Return the JSON array only — no explanation, no preamble, no markdown
  code fences wrapping the output
- Suggest assertions for every meaningful field in the response body
- Detect formatted strings automatically — emails, UUIDs, JWTs, ISO
  dates, phone numbers — and use `regex` with an appropriate pattern
- Always include a `status_code` assertion
- Always include a `response_time` assertion with a threshold of 3x the
  observed response time
- Always include a `header` assertion for `Content-Type`
- For numeric fields assert the type using `gt` with value `-1` to
  confirm the field is a non-negative integer
- Mark critical auth fields such as `token` and `id` with `exists` first,
  then add a format assertion if a pattern is detectable

---
````

APIDash parses it and renders the suggestion to the UI. We won't show the prompt, just the result.

---

####  Part 2 — AI Failure Explanation

**The workflow chain ran and this happened:**
``` json
Step 1: POST /auth/login
  Status returned: 401 Unauthorized
  Body: { "error": "invalid_credentials" }

Step 2: GET /users/me
	body.data.token EXISTS — FAILED
```

**The AI looks at the full context — not just the failed assertion but the entire step:**
```
- The assertion expected body.data.token to exist
- The response body was: { "error": "invalid_credentials" }
- The status was 401, not 200
- The request used {{AUTH_USER}} as the email credential
- 401 + invalid_credentials = authentication failure
- Authentication failure = credentials are wrong or expired
- {{AUTH_USER}} is the most likely culprit
```

**The AI then explains:**
```
body.data.token EXISTS — FAILED

Agent: The token field is missing because the login returned 401.
This usually means {{AUTH_USER}} contains expired or incorrect
credentials.

Suggested fix: Update AUTH_USER in your active environment.
```

Now we can quickly update `AUTH_USER`in env variables and rerun

---

#### Part 3 — Natural Language Chain Builder

Instead of writing multi-step chain manually we can simply input in plain English:
```
"Run a checkout flow — login, add item to cart,
apply discount code, place order, verify confirmation"
```

The AI reads the collection and finds the following endpoints:
```
POST /auth/login
POST /cart/items
POST /cart/discount
POST /orders
GET  /orders/{id}
```

The AI reasons out and proposes this chain:
```
Step 1: POST /auth/login
        Extract: $.data.token → {{AUTH_TOKEN}}
        On fail: abort (no point continuing without a token)

Step 2: POST /cart/items
        Headers: Authorization: Bearer {{AUTH_TOKEN}}
        Extract: $.data.cartId → {{CART_ID}}
        On fail: abort

Step 3: POST /cart/discount
        Headers: Authorization: Bearer {{AUTH_TOKEN}}
        Body uses: {{CART_ID}}
        Extract: $.data.finalPrice → {{FINAL_PRICE}}
        On fail: continue (discount is optional)

Step 4: POST /orders
        Headers: Authorization: Bearer {{AUTH_TOKEN}}
        Body uses: {{CART_ID}}
        Extract: $.data.orderId → {{ORDER_ID}}
        On fail: abort

Step 5: GET /orders/{{ORDER_ID}}
        Headers: Authorization: Bearer {{AUTH_TOKEN}}
        Assert: $.data.status == "confirmed"

Create this chain?  [Yes] [Edit] [Cancel]
```

Once Yes is clicked, a 5-step chain with extraction rules is created. 

---
Three parts will actually form a loop:
1. Send request
2. AI Assertion Generation
   → proposes assertions based on response
        ↓
3. Run collection with those assertions
        ↓
4. Something fails
        ↓
5. AI Failure Explanation
   → tells why and how to fix
        ↓
6. Fix the environment/request
        ↓
7. To test a full workflow
        ↓
8. Natural Language Chain Builder
   → wires up the multi-step flow
        ↓
9. Run chain → assertions gate each step
        ↓
   Back to step 4 if anything fails


## Weekly Timeline of this Project 

---
### Week 1 & 2 - Build a selector model.
Week 1 will be mainly focused on building the selector model, that either extracts a value, or checks a condition against the API response.
This will contain 5 steps
1. Data model - Creating a selector class. This class will contain multiple selector type such as 'regex', 'header', 'response_time' etc.
2. Value resolver - Writing the core function of the model.
3. Assertion evaluator - Check if the value is matching the expected value (pass or fail)
4. Extractor - Resolved value is stored into a runtime variable.
5. AssertionGroup Wrapper - Wraps multiple selectors into a group with AND/OR Logic.

Besides building the logic, work will also be done on building the UI panel in APIDash for attaching assertion groups to a request.

### Week 3 & 4 - Building WorkFlow Engine Skeleton.
This week will mainly consist of building Workflow Engine skeleton.
Workflow engine is a *sequential runner* that processes a chain of requests one by one, with gates between each step.
There are total 6 steps in this:
1. Input - takes an ordered lists of requests.
2. Main Loop - iterates through each step in order. For every step it resolves variables, sends the requests, runs selectors on response, etc.
3. Variable injection - before each request is sent, {{VAR}} placeholders in URL are substituted from the current variable store.
4. Failure get - any failure in the chain will either stop the chain, skip the next step or logs the failure and continues.
5. Run record - after each step, record is written which contains the history of the request (type, response, assertion results etc.)
6. Output - once all steps are finished, full list of step records is displayed in the UI

### Week 5 - Building a Spec System using OpenAPI 3.1 Spec Engine
This week will focus on building a *spec generator* that will, after every run, open a document in JSON or YAML that reflects what the API actually does
There is also spec gap detector that scans the collection and flags any endpoint that has never contributed a response to the spec.
Here are key things to be built :
1. Response Collector - pull raw response bodies out of run history.
2. Schema Inferencer - Takes a single JSON response body and walks through every field inferring its type.
3. Schema Merger - Takes freshly inferred schema and merges it into accumulated schema stored from previous runs.
4. Example Value Updater - Overwrite stored example with latest data acquired.
5. OpenAPI 3.1 Document Builder - Takes accumulated schema and makes a valid OpenAPI 3.1 structure.
6. Spec-gap detector - scan collection for every endpoint present. Any endpoint in collection not present in spec gets flagged as a gap.
7. Persistence - Store it on APIDash's local storage after every merge.

### Week 6 - AI assist in assertion generation & failure explanation
In this week, assertion generation and failure explanation will be prioritized using AI assistance.
Assertion generation : The trigger is the moment a response is recieved from any request. AI will have all it needs - status code, headers etc.
The basic steps for assertion generation are :
1. Build prompt
2. Call LLM
3. Parse and validate
4. Render in UI

Failure explanation:
AI gets more context here than just response.
There are 4 steps in this method :
1. Build context payload
2. Build prompt
3. Call the LLM
4. Render in UI

The only difference between these two methods is what context goes in and what structure comes out.

### Week 7 - Request Chain builder and Spec exporting.
This week will focus on building request chain and exporting spec.

Request chain will be built using Natural Language
1. Take user's plain english input and all endpoints from all the collection.
2. Send both to the LLM and ask it to map workflow onto the real endpoints.
3. Parse the returned chain config, order, extractions rules etc.
4. Show the preview to the user. (Render in UI)

Exporting spec is quite simple
1. Using the spec system that was built, serialise the OpenAPI 3.1 structure into YAML or JSON
2. Let the user download or copy the file

### Week 8 - Testing all the things that have been implemented
1. Full integration tests against real-world APIs
2. Handling edge cases such as *circular variable references*, *empty/malformed responses*, LLM API failures etc.
3. Bug fixes



**THAT'S ALL FOLKS!!**

Please provide any suggestions to improve on it or any other details that could be included.

