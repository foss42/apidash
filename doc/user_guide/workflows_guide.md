# Workflows Guide

Workflows let you run multi-step API scenarios on a visual canvas: chain requests, pass data between steps, run independent steps in parallel, branch on results, and repeat actions.

**Desktop only for now** — the mobile app does not include a Workflows tab; use the desktop (wide) layout to build and run workflows.


## What workflows do

Use workflows when a single request is not enough — for example login → fetch profile → update profile, fetch several resources at once, or run the same request once per item in a list.

## Create with Dashbot

1. Open Dashbot → **Generate Workflow** (same idea as Import cURL: Dashbot asks you to describe the flow first; it does not invent a workflow until you send details).
2. Describe steps, URLs, extractions, and loops/conditions if needed. Say **parallel** or **at the same time** when you want independent calls from Start (or another node).
3. Review the reply and confirm **Create Workflow**. The flow is saved under your workspace `workflows/` folder and opened on the canvas.

Tips for better results:

- Use full URLs (prefer `https://api.apidash.dev/...` for the public demo API).
- Name extract variables exactly as you will use them later (`userId` → `{{userId}}`).
- For parallel branches that later meet, use **different** extract names on each branch (`users` vs `posts`) so the join can merge them.
- Paths like `data.0.id` or `data[0].id` both work; prefer dotted indexes in prompts.
- Dashbot does not call your API when guessing JSON paths — if the response shape differs, edit the extraction after create.

On create, missing connections are chained automatically and the graph is auto-arranged.


## Request nodes

A request node calls an API.

- Double-click a request node to edit URL, headers, body, and related settings.
- Add **extractions** to save values from the response into workflow variables for later steps.

### Extractions and JSON paths

Extractions read from the response (usually `response.body`) using a path, then store the value as a workflow variable. Downstream steps use it as `{{variableName}}`.

#### Normal object fields

Response:

```json
{
  "id": 42,
  "name": "Ada",
  "auth": {
    "token": "abc123",
    "expiresIn": 3600
  }
}
```

| Variable | Path | Value stored |
|----------|------|--------------|
| `userId` | `id` | `42` |
| `userName` | `name` | `Ada` |
| `token` | `auth.token` | `abc123` |

Next request examples:

- URL: `https://api.example.com/users/{{userId}}`
- Header: `Authorization: Bearer {{token}}`

#### Array fields

Response:

```json
{
  "users": [
    { "id": 1, "email": "a@example.com" },
    { "id": 2, "email": "b@example.com" }
  ],
  "tags": ["api", "beta"]
}
```

Use a **numeric index** in the path (`0` = first item, `1` = second). Both dotted and bracket forms work:

| Variable | Path (either form) | Value stored |
|----------|--------------------|--------------|
| `firstUserId` | `users.0.id` or `users[0].id` | `1` |
| `secondEmail` | `users.1.email` or `users[1].email` | `b@example.com` |
| `firstTag` | `tags.0` or `tags[0]` | `api` |

Next request example:

- URL: `https://api.example.com/users/{{firstUserId}}/posts`


## Parallel execution and joins

Wire **more than one** outgoing connection from the same port (for example Start → Users and Start → Posts) to run those branches **in parallel**.

- Each branch keeps its **own** chain variables. A sibling does not see another branch’s extractions until they meet.
- When both branches connect into the **same** next node, the runner **waits for both**, then **merges** variables and continues.
- If both branches write the **same** variable name with **different** values, the run **fails** with a conflict. Use distinct names (`users` / `posts`) when both feed the joined step.
- Same name and same value is fine; the merged step sees that value once.
- A **linear** chain (Start → A → B) is still sequential; B sees A’s extractions as before.

Example:

```
Start → GET /users  (extract data → users)  ─┐
     → GET /posts  (extract data → posts)  ─┴→ next step can use {{users}} and {{posts}}
```

## Condition nodes

A condition node branches after a request.

- Wire **True** and **False** ports to different next steps.
- Use presets such as HTTP success, or check a workflow variable.
- Only **one** side runs (not parallel). The unused branch is skipped.

## Delay nodes

A delay node pauses the workflow for a fixed number of milliseconds.

- Wire **In** from the previous step and **Next** to the step that should run after waiting.
- Useful for rate limits, polling gaps, or giving a service time to settle.
- Pressing **Stop** during a delay cancels the wait.

## Loop nodes (For each / Repeat)

Loop **Each** iterations always run **one after another** (not in parallel), even if the loop sits on a parallel branch.

### For each

Runs the body once per item in a list from a previous step (or an Environment variable).

**Setup**

1. On the list request, add a response extraction for the array — Variable `users`, Path `data`.
2. Open the loop node:
   - **List** (required): `{{users}}` — the loop will not run if this is empty.
   - **Item extraction** (same labels as response extractions):
     - **Variable** `userId`
     - **Path** `id`
   - While typing Path, a live line shows e.g. `Will be extracted from {{users}}.id`.
   - Optional **Max items** to cap how many entries run.
3. Wire ports:
   - Previous step → loop **In**
   - Loop **Each** → body request (do not wire back into the loop)
   - Loop **Done** → optional step after all items finish
4. Body request URL (or header/body): `https://api.apidash.dev/users/{{userId}}`

**Example with the public API**

```
Start → GET https://api.apidash.dev/users  (extract data → users)
     → For each  List {{users}}  Variable userId  Path id
          Each → GET https://api.apidash.dev/users/{{userId}}
```

### Repeat

Runs the **Each** branch a fixed number of times (no list).

- **Times to repeat**: choose **1–10**, or **Custom** and type digits only.

## Variables

- Use **Environments** for shared inputs (`{{name}}` in URLs, headers, and bodies).
- Use **extractions** on request nodes to pass response values into later steps on the **same chain**.
- Use **Item extraction** on a for-each loop to pass a field from each list item into the body (same Variable + Path pattern).
- If an environment variable and an extraction share the same name, the **extraction wins** during the run.
- Parallel branches only share extractions after an AND-join (see above); conflicting names fail the run.

## Connecting nodes

Drag from an output port to an input port to connect steps. The runner follows those connections when you press Run. Multiple outs from one port run in parallel; a single chain stays sequential. Use **Arrange** on the canvas to tidy layout (Dashbot-created flows are auto-arranged on create).
