# Dashboard

The **Dashboard** (desktop only) shows health and activity for your requests and workflows from local history. It does not create a separate telemetry store. Send a few requests or run a workflow first so charts have data.

Open it from the nav rail: **Dashboard**.

## Scope controls

At the top of the page:

1. Choose **Collections** or **Workflows**.
2. Pick a time range: `24h`, `7d`, `30d`, or `All`.
3. Optionally filter by one collection or one workflow (or leave **All**).

KPIs and charts always respect this scope.

## Collections tab

Pinned at the top: health score, success rate, request count, failures, and latency (for example P95).

**Trends & health** (open by default): response timing trend and status distribution (2xx / 3xx / 4xx / 5xx). Tap a point or bar to see its value.

Other sections start collapsed:

| Section | What you see |
|---------|----------------|
| Distributions | HTTP methods and API types (HTTP, GraphQL, AI) |
| Endpoints & slowest | Most called URLs and slowest calls |
| Recent errors | 4xx / 5xx entries (tap opens History) |
| Test & script coverage | Share of requests with post-response scripts (treated as tests), plus missing coverage |
| Request execution history | Recent request runs (tap opens History for that entry) |

> AI requests count under **API types → AI**. They usually also count as **POST** in the methods chart because providers send HTTP POST.

## Workflows tab

Pinned KPIs: run count, success rate, failures, average and peak duration.

**Trends & status** (open by default): run duration trend and success / fail split.

Collapsed by default:

| Section | What you see |
|---------|----------------|
| Failing nodes | Nodes that failed most often in sampled failed runs |
| Recent runs | Latest workflow runs |
| Workflow execution history | Same idea, longer list |

Tap a run (Recent runs or execution history) to open **Workflows**, select that workflow file, and open the **run inspector** for that run.

## Webhook reports

Use **Webhook reports** to POST the current tab’s metrics to an HTTP endpoint (CI, Slack, Discord, or your own server).

1. Set a **Report name** (optional).
2. Choose **Format**:
   - **JSON**: full structured metrics (default, good for CI or custom hooks).
   - **Slack**: Slack Incoming Webhook shape (`text` + Block Kit).
   - **Discord**: Discord webhook shape (`content` + embed).
3. Paste the webhook URL.
4. Check **Payload preview** (this is exactly what will be sent).
5. **Copy**, **Send now**, or **Start auto-send** (`5m` / `15m` / `30m` / `60m`).

Auto-send uses the same format and the live Dashboard scope (tab, range, filters) at each tick.

### Small examples

**JSON** (truncated collection report):

```json
{
  "reportName": "API Dash Health Report",
  "type": "collection",
  "scope": { "timeRange": "7d", "collectionId": "all" },
  "collection": {
    "totalRequests": 42,
    "healthScore": 88,
    "successRate": 0.95,
    "p95Ms": 120
  }
}
```

**Slack** (what Slack expects):

```json
{
  "text": "API Dash Health Report · Collections · 7d · health 88 · success 95.0% · P95 120ms",
  "blocks": [
    {
      "type": "header",
      "text": { "type": "plain_text", "text": "API Dash Health Report" }
    }
  ]
}
```

Create the URL in Slack: App → Incoming Webhooks → Add to channel → copy `https://hooks.slack.com/services/...`. In Dashboard pick **Slack**, paste URL, **Send now**. A `400` with raw **JSON** format usually means Slack rejected a non-Slack body; switch to **Slack**.

**Discord** (truncated):

```json
{
  "content": "API Dash Health Report · Collections · 7d · health 88 · success 95.0% · P95 120ms",
  "embeds": [
    {
      "title": "API Dash Health Report",
      "fields": [
        { "name": "Health", "value": "88", "inline": true },
        { "name": "Success", "value": "95.0%", "inline": true }
      ]
    }
  ]
}
```

Discord: Server Settings → Integrations → Webhooks → New Webhook → copy URL. Pick **Discord** in Dashboard, paste, **Send now**.

Treat webhook URLs as secrets. Do not commit them or paste them into public chats.

## Quick checklist

1. Send requests and/or run workflows so history exists.
2. Open **Dashboard** (desktop).
3. Set tab, range, and filter.
4. Read KPIs and the open chart section; expand others as needed.
5. Tap history rows to jump to History or the workflow inspector.
6. Optional: Webhook reports → format → preview → Send or auto-send.
