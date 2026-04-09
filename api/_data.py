"""
Shared mock data for all Vercel serverless API handlers.
This file is NOT deployed as an endpoint — it's imported by the other handlers.

Covers four response shapes used across the PoC:
  - OPEN_RESPONSES_JSON : single completed response (GET /open-responses)
  - A2UI_JSONL          : newline-delimited JSON for agent-to-UI rendering (GET /a2ui)
  - AGENT_CHAT_JSON     : multi-turn agent conversation (GET /agent-chat)
  - SSE_EVENTS          : ordered list of SSE events for streaming (GET /stream)
  - mcp_query_response  : keyword-based response selector (POST /mcp/query)
"""
import json

# ---------------------------------------------------------------------------
# /open-responses  — mock OpenAI Responses API output
# Simulates a completed multi-step agent response:
#   reasoning -> web_search -> file_search -> function_call -> message
# ---------------------------------------------------------------------------
OPEN_RESPONSES_JSON = {
    "id": "resp_mock_001",
    "object": "response",
    "model": "gpt-4o-2024-11-20",
    "status": "completed",
    "output": [
        {
            # Step 1: model's internal chain-of-thought before acting
            "type": "reasoning",
            "id": "rs_001",
            "status": "completed",
            "summary": [{"text": "User wants current weather in San Francisco. I'll use web search and the get_weather tool to fetch live data, then summarise it clearly."}]
        },
        # Step 2: web search tool invocation (no result payload — just a signal)
        {"type": "web_search_call", "id": "ws_001", "status": "completed"},
        {
            # Step 3: file/knowledge-base search with the queries the model used
            "type": "file_search_call",
            "id": "fsc_001",
            "status": "completed",
            "queries": ["San Francisco weather patterns", "Bay Area climate normals"]
        },
        {
            # Step 4: structured function call — arguments are a JSON string (matches OpenAI spec)
            "type": "function_call",
            "id": "fc_001",
            "call_id": "call_abc123",       # links this call to its output below
            "name": "get_weather",
            "arguments": "{\"location\": \"San Francisco, CA\", \"unit\": \"celsius\"}",
            "status": "completed"
        },
        {
            # Step 5: function result keyed by call_id so the model can correlate
            "type": "function_call_output",
            "id": "fco_001",
            "call_id": "call_abc123",
            "output": "{\"temperature\": 18, \"condition\": \"Partly cloudy\", \"humidity\": 72, \"wind_kph\": 14}",
            "status": "completed"
        },
        {
            # Step 6: final assistant message with markdown-formatted answer
            "type": "message",
            "id": "msg_001",
            "role": "assistant",
            "status": "completed",
            "content": [
                {
                    "type": "output_text",
                    "text": "## Current Weather in San Francisco\n\nThe current weather in **San Francisco, CA** is **18\u00b0C** with partly cloudy skies.\n\n| Metric | Value |\n|--------|-------|\n| Temperature | 18\u00b0C |\n| Condition | Partly cloudy |\n| Humidity | 72% |\n| Wind | 14 km/h |\n\nThe city\u2019s coastal location keeps temperatures mild year-round. The famous Karl the Fog typically rolls in during summer mornings, burning off by midday."
                }
            ]
        }
    ],
    "usage": {"input_tokens": 245, "output_tokens": 312, "total_tokens": 557}
}

# ---------------------------------------------------------------------------
# /a2ui  — agent-to-UI newline-delimited JSON (JSONL)
# Each line is a separate UI command the Flutter client processes in order:
#   1. createSurface  — initialise the canvas with an id, title, and layout
#   2. updateComponents — declare the full component tree (Column, Row, Card…)
#   3. updateDataModel  — push live values into data-bound text components
# ---------------------------------------------------------------------------
A2UI_JSONL = '\n'.join([
    # Command 1: create the top-level surface
    json.dumps({"createSurface": {"id": "dash_001", "title": "API Health Dashboard", "layout": "scroll"}}),

    # Command 2: declare all UI components in one batch
    json.dumps({"updateComponents": {"components": [
        # Root column — defines the visual order of all sections
        {"id": "root", "component": "Column",
         "children": ["header", "stats_row", "div1", "health_card", "div2", "actions_row"]},

        # Page title
        {"id": "header", "component": "Text", "variant": "h1", "text": "API Health Dashboard"},

        # Top stats row — three metric cards side by side
        {"id": "stats_row", "component": "Row", "justify": "spaceBetween",
         "children": ["card_uptime", "card_latency", "card_errors"]},

        # Uptime card — label + data-bound value
        {"id": "card_uptime", "component": "Card", "children": ["lbl_uptime", "val_uptime"]},
        {"id": "lbl_uptime", "component": "Text", "variant": "caption", "text": "Uptime"},
        # {"path": "/uptime"} tells the renderer to pull the value from the data model
        {"id": "val_uptime", "component": "Text", "variant": "h2", "text": {"path": "/uptime"}},

        # Latency card
        {"id": "card_latency", "component": "Card", "children": ["lbl_latency", "val_latency"]},
        {"id": "lbl_latency", "component": "Text", "variant": "caption", "text": "Avg Latency"},
        {"id": "val_latency", "component": "Text", "variant": "h2", "text": {"path": "/latency"}},

        # Error rate card
        {"id": "card_errors", "component": "Card", "children": ["lbl_errors", "val_errors"]},
        {"id": "lbl_errors", "component": "Text", "variant": "caption", "text": "Error Rate"},
        {"id": "val_errors", "component": "Text", "variant": "h2", "text": {"path": "/error_rate"}},

        # Visual separator
        {"id": "div1", "component": "Divider"},

        # System health card with a progress bar and status chips
        {"id": "health_card", "component": "Card",
         "children": ["health_title", "health_progress", "chip_row"]},
        {"id": "health_title", "component": "Text", "variant": "h3", "text": "System Health"},
        # value is 0–1 (92% healthy)
        {"id": "health_progress", "component": "Progress", "label": "Overall Health", "value": 0.92},
        {"id": "chip_row", "component": "Row", "children": ["chip_api", "chip_db", "chip_cache"]},
        {"id": "chip_api",   "component": "Chip", "label": "API: OK"},
        {"id": "chip_db",    "component": "Chip", "label": "DB: OK"},
        {"id": "chip_cache", "component": "Chip", "label": "Cache: OK"},

        {"id": "div2", "component": "Divider"},

        # Action buttons row
        {"id": "actions_row", "component": "Row", "children": ["btn_refresh", "btn_logs"]},
        # action strings are handled by the Flutter side's action dispatcher
        {"id": "btn_refresh", "component": "Button", "variant": "primary",
         "text": "Refresh", "action": "refresh_dashboard"},
        {"id": "btn_logs", "component": "Button", "variant": "outlined",
         "text": "View Logs", "action": "view_logs"},
    ]}}),

    # Commands 3-5: push live metric values into the data-bound text nodes above
    json.dumps({"updateDataModel": {"path": "/uptime",     "value": "99.9%"}}),
    json.dumps({"updateDataModel": {"path": "/latency",    "value": "142ms"}}),
    json.dumps({"updateDataModel": {"path": "/error_rate", "value": "0.1%"}}),
])

# ---------------------------------------------------------------------------
# /agent-chat  — multi-turn agent conversation
# Two complete turns showing different tool-use patterns:
#   Turn 1: list_api_templates  — fetches relevant API names from a catalogue
#   Turn 2: send_http_request   — fires a live HTTP call and parses the result
# ---------------------------------------------------------------------------
AGENT_CHAT_JSON = {
    "turns": [
        {
            "user": "Which payment APIs should I test for our checkout flow?",
            "response": {
                "id": "resp_agent_001",
                "object": "response",
                "model": "gpt-4o-2024-11-20",
                "status": "completed",
                "output": [
                    # Reasoning: plan before acting
                    {"type": "reasoning", "id": "rs_a001", "status": "completed",
                     "summary": [{"text": "User needs payment API test coverage. I'll search for common payment gateway endpoints and cross-reference with their API collection to recommend the most critical ones."}]},
                    # Web search to supplement knowledge
                    {"type": "web_search_call", "id": "ws_a001", "status": "completed"},
                    # File search across the user's saved API collection
                    {"type": "file_search_call", "id": "fsc_a001", "status": "completed",
                     "queries": ["payment API endpoints", "Stripe checkout integration", "payment gateway health check"]},
                    # Tool call: fetch top-5 payment templates from APIDash catalogue
                    {"type": "function_call", "id": "fc_a001", "call_id": "call_list_apis",
                     "name": "list_api_templates",
                     "arguments": "{\"category\": \"payment\", \"limit\": 5}",
                     "status": "completed"},
                    # Tool result: five template names returned
                    {"type": "function_call_output", "id": "fco_a001", "call_id": "call_list_apis",
                     "output": "{\"templates\": [\"Stripe Balance\", \"Stripe Charges\", \"PayPal Orders\", \"Razorpay Orders\", \"Braintree Transactions\"]}",
                     "status": "completed"},
                    # Final answer: priority table with test notes
                    {"type": "message", "id": "msg_a001", "role": "assistant", "status": "completed",
                     "content": [{"type": "output_text",
                                  "text": "## Recommended Payment APIs to Test\n\nBased on your checkout flow, here are the 5 critical endpoints to cover:\n\n| Priority | API | What to verify |\n|----------|-----|----------------|\n| High | **Stripe Charges** | Request/response schema, error codes |\n| High | **Stripe Balance** | Auth, currency format |\n| Medium | **PayPal Orders** | Create + capture flow |\n| Medium | **Razorpay Orders** | INR amount format |\n| Low | **Braintree Transactions** | Sandbox vs production URLs |\n\nStart with the Stripe endpoints — they're used in the hot path and any regression there would break checkout immediately."}]}
                ],
                "usage": {"input_tokens": 189, "output_tokens": 278, "total_tokens": 467}
            }
        },
        {
            "user": "Send a test request to the Stripe balance endpoint",
            "response": {
                "id": "resp_agent_002",
                "object": "response",
                "model": "gpt-4o-2024-11-20",
                "status": "completed",
                "output": [
                    # Reasoning: decide to use send_http_request directly
                    {"type": "reasoning", "id": "rs_a002", "status": "completed",
                     "summary": [{"text": "User wants to fire a live test against Stripe's balance API. I'll call the send_http_request tool with the correct auth header and parse the response."}]},
                    # Tool call: GET Stripe balance with a redacted test key
                    {"type": "function_call", "id": "fc_a002", "call_id": "call_http_req",
                     "name": "send_http_request",
                     "arguments": "{\"method\": \"GET\", \"url\": \"https://api.stripe.com/v1/balance\", \"headers\": {\"Authorization\": \"Bearer sk_test_***\"}}",
                     "status": "completed"},
                    # Tool result: mock 200 response with balance object
                    {"type": "function_call_output", "id": "fco_a002", "call_id": "call_http_req",
                     "output": "{\"status\": 200, \"body\": {\"object\": \"balance\", \"available\": [{\"amount\": 92340, \"currency\": \"usd\"}], \"pending\": [{\"amount\": 4200, \"currency\": \"usd\"}], \"livemode\": false}}",
                     "status": "completed"},
                    # Final answer: annotated response breakdown
                    {"type": "message", "id": "msg_a002", "role": "assistant", "status": "completed",
                     "content": [{"type": "output_text",
                                  "text": "**Stripe Balance — HTTP 200**\n\nThe endpoint is healthy and returning the expected schema:\n\n```json\n{\n  \"object\": \"balance\",\n  \"available\": [{ \"amount\": 92340, \"currency\": \"usd\" }],\n  \"pending\":   [{ \"amount\":  4200, \"currency\": \"usd\" }],\n  \"livemode\": false\n}\n```\n\n- `livemode: false` confirms we're hitting the **sandbox** correctly.\n- `available.amount` is in **cents** (92340 = $923.40) — make sure your assertions account for that.\n- No auth errors, schema is valid. You can now add this as an automated test in your collection."}]}
                ],
                "usage": {"input_tokens": 312, "output_tokens": 241, "total_tokens": 553}
            }
        }
    ]
}

# ---------------------------------------------------------------------------
# /stream  — ordered SSE event list
# Replays a full OpenAI Responses streaming sequence for a London weather query.
# Events follow the official spec:
#   response.created -> output_item.added/done (per item type) -> output_text.delta -> response.completed
# The stream.py handler writes these as "data: <json>\n\n" lines without sleep
# because Vercel functions have a 10 s execution budget.
# ---------------------------------------------------------------------------
SSE_EVENTS = [
    # 1. Response object created; status=in_progress, output list is empty
    {"type": "response.created", "response": {
        "id": "resp_stream_001", "object": "response",
        "model": "gpt-4o-2024-11-20", "status": "in_progress", "output": []
    }},

    # 2. Reasoning item starts streaming
    {"type": "response.output_item.added", "output_index": 0,
     "item": {"type": "reasoning", "id": "rs_s001", "status": "in_progress"}},
    # 3-4. Reasoning text arrives in two delta chunks
    {"type": "response.reasoning_summary_text.delta", "output_index": 0,
     "delta": "User asked for London weather."},
    {"type": "response.reasoning_summary_text.delta", "output_index": 0,
     "delta": " I'll call get_weather and format the result clearly."},
    # 5. Reasoning item complete
    {"type": "response.output_item.done", "output_index": 0,
     "item": {"type": "reasoning", "id": "rs_s001", "status": "completed",
              "summary": [{"text": "User asked for London weather. I'll call get_weather and format the result clearly."}]}},

    # 6-7. Web search tool call (no result payload — just start/done signals)
    {"type": "response.output_item.added", "output_index": 1,
     "item": {"type": "web_search_call", "id": "ws_s001", "status": "in_progress"}},
    {"type": "response.output_item.done", "output_index": 1,
     "item": {"type": "web_search_call", "id": "ws_s001", "status": "completed"}},

    # 8. Function call starts; arguments will stream as deltas
    {"type": "response.output_item.added", "output_index": 2,
     "item": {"type": "function_call", "id": "fc_s001", "call_id": "call_xyz",
              "name": "get_weather", "status": "in_progress", "arguments": ""}},
    # 9-11. Arguments arrive in three chunks (simulates token-by-token streaming)
    {"type": "response.function_call_arguments.delta", "output_index": 2, "delta": "{\"location\""},
    {"type": "response.function_call_arguments.delta", "output_index": 2, "delta": ": \"London\","},
    {"type": "response.function_call_arguments.delta", "output_index": 2, "delta": " \"unit\": \"celsius\"}"},
    # 12. Function call complete with full arguments
    {"type": "response.output_item.done", "output_index": 2,
     "item": {"type": "function_call", "id": "fc_s001", "call_id": "call_xyz",
              "name": "get_weather", "status": "completed",
              "arguments": "{\"location\": \"London\", \"unit\": \"celsius\"}"}},

    # 13-14. Function output (added + done together — no streaming for tool results)
    {"type": "response.output_item.added", "output_index": 3,
     "item": {"type": "function_call_output", "id": "fco_s001", "call_id": "call_xyz",
              "status": "completed",
              "output": "{\"temperature\": 14, \"condition\": \"Overcast\", \"humidity\": 81}"}},
    {"type": "response.output_item.done", "output_index": 3,
     "item": {"type": "function_call_output", "id": "fco_s001", "call_id": "call_xyz",
              "status": "completed",
              "output": "{\"temperature\": 14, \"condition\": \"Overcast\", \"humidity\": 81}"}},

    # 15. Assistant message starts; content list is empty until deltas arrive
    {"type": "response.output_item.added", "output_index": 4,
     "item": {"type": "message", "id": "msg_s001", "role": "assistant",
              "status": "in_progress", "content": []}},
    # 16-22. Text deltas — each chunk appended by the client to build the final message
    {"type": "response.output_text.delta", "output_index": 4, "delta": "## London Weather\n\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "Current conditions: **14\u00b0C**"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": ", overcast skies.\n\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Metric | Value |\n|--------|-------|\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Temperature | 14\u00b0C |\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Condition | Overcast |\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Humidity | 81% |\n\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "Classic London — bring an umbrella."},
    # 23. Message item done — full text included for clients that skipped deltas
    {"type": "response.output_item.done", "output_index": 4,
     "item": {"type": "message", "id": "msg_s001", "role": "assistant", "status": "completed",
              "content": [{"type": "output_text",
                           "text": "## London Weather\n\nCurrent conditions: **14\u00b0C**, overcast skies.\n\n| Metric | Value |\n|--------|-------|\n| Temperature | 14\u00b0C |\n| Condition | Overcast |\n| Humidity | 81% |\n\nClassic London — bring an umbrella."}]}},

    # 24. Final event — response object with complete output list and token usage
    {"type": "response.completed", "response": {
        "id": "resp_stream_001", "object": "response",
        "model": "gpt-4o-2024-11-20", "status": "completed",
        "output": [
            {"type": "reasoning", "id": "rs_s001", "status": "completed",
             "summary": [{"text": "User asked for London weather. I'll call get_weather and format the result clearly."}]},
            {"type": "web_search_call", "id": "ws_s001", "status": "completed"},
            {"type": "function_call", "id": "fc_s001", "call_id": "call_xyz",
             "name": "get_weather", "status": "completed",
             "arguments": "{\"location\": \"London\", \"unit\": \"celsius\"}"},
            {"type": "function_call_output", "id": "fco_s001", "call_id": "call_xyz",
             "status": "completed",
             "output": "{\"temperature\": 14, \"condition\": \"Overcast\", \"humidity\": 81}"},
            {"type": "message", "id": "msg_s001", "role": "assistant", "status": "completed",
             "content": [{"type": "output_text",
                          "text": "## London Weather\n\nCurrent conditions: **14\u00b0C**, overcast skies.\n\n| Metric | Value |\n|--------|-------|\n| Temperature | 14\u00b0C |\n| Condition | Overcast |\n| Humidity | 81% |\n\nClassic London — bring an umbrella."}]}
        ],
        "usage": {"input_tokens": 142, "output_tokens": 97, "total_tokens": 239}
    }},
]


def mcp_query_response(message: str) -> dict:
    """
    Route an MCP query to the appropriate mock response based on keywords.

    The function inspects the lowercased message and returns one of four
    canned response objects that mimic the OpenAI Responses API shape:

      - weather keywords  -> London weather tool call + summary
      - payment keywords  -> Stripe balance HTTP request + result
      - health keywords   -> multi-service health check + status table
      - anything else     -> default helper message listing example queries

    Each branch includes reasoning, tool calls, and a final assistant message
    so the APIDash UI can render the full agent trace.
    """
    msg = message.lower()

    # --- Branch 1: weather-related queries ---
    if any(k in msg for k in ('weather', 'london', 'temperature', 'forecast')):
        return {
            "id": "resp_q_weather", "object": "response",
            "model": "gpt-4o-2024-11-20", "status": "completed",
            "output": [
                {"type": "reasoning", "id": "rs_q1", "status": "completed",
                 "summary": [{"text": "User wants weather info. I'll call get_weather for London."}]},
                {"type": "web_search_call", "id": "ws_q1", "status": "completed"},
                {"type": "function_call", "id": "fc_q1", "call_id": "call_wq1",
                 "name": "get_weather",
                 "arguments": "{\"location\": \"London\", \"unit\": \"celsius\"}",
                 "status": "completed"},
                {"type": "function_call_output", "id": "fco_q1", "call_id": "call_wq1",
                 "output": "{\"temperature\": 13, \"condition\": \"Cloudy\", \"humidity\": 78, \"wind_kph\": 18}",
                 "status": "completed"},
                {"type": "message", "id": "msg_q1", "role": "assistant", "status": "completed",
                 "content": [{"type": "output_text",
                              "text": "## London Weather\n\n**13\u00b0C**, cloudy. Humidity 78%, wind 18 km/h.\n\n| Metric | Value |\n|--------|-------|\n| Temperature | 13\u00b0C |\n| Condition | Cloudy |\n| Humidity | 78% |\n| Wind | 18 km/h |"}]}
            ],
            "usage": {"input_tokens": 98, "output_tokens": 112, "total_tokens": 210}
        }

    # --- Branch 2: payment / Stripe queries ---
    if any(k in msg for k in ('stripe', 'payment', 'checkout', 'api test', 'balance')):
        return {
            "id": "resp_q_stripe", "object": "response",
            "model": "gpt-4o-2024-11-20", "status": "completed",
            "output": [
                {"type": "reasoning", "id": "rs_q2", "status": "completed",
                 "summary": [{"text": "User wants to test the Stripe balance endpoint. I'll fire a GET request with the test key."}]},
                # send_http_request fires an actual HTTP call; key is redacted in mock
                {"type": "function_call", "id": "fc_q2", "call_id": "call_sq2",
                 "name": "send_http_request",
                 "arguments": "{\"method\": \"GET\", \"url\": \"https://api.stripe.com/v1/balance\", \"headers\": {\"Authorization\": \"Bearer sk_test_***\"}}",
                 "status": "completed"},
                {"type": "function_call_output", "id": "fco_q2", "call_id": "call_sq2",
                 "output": "{\"object\": \"balance\", \"available\": [{\"amount\": 92340, \"currency\": \"usd\"}], \"pending\": [{\"amount\": 4200, \"currency\": \"usd\"}], \"livemode\": false}",
                 "status": "completed"},
                {"type": "message", "id": "msg_q2", "role": "assistant", "status": "completed",
                 "content": [{"type": "output_text",
                              "text": "**Stripe Balance — HTTP 200**\n\nEndpoint is healthy. `available: $923.40`, `pending: $42.00`, `livemode: false` (sandbox)."}]}
            ],
            "usage": {"input_tokens": 143, "output_tokens": 97, "total_tokens": 240}
        }

    # --- Branch 3: health / monitoring queries ---
    if any(k in msg for k in ('health', 'status', 'uptime', 'dashboard', 'monitor')):
        return {
            "id": "resp_q_health", "object": "response",
            "model": "gpt-4o-2024-11-20", "status": "completed",
            "output": [
                {"type": "reasoning", "id": "rs_q3", "status": "completed",
                 "summary": [{"text": "User wants an API health check. I'll query the health endpoint and summarise the key metrics."}]},
                # check_api_health polls multiple services in one call
                {"type": "function_call", "id": "fc_q3", "call_id": "call_hq3",
                 "name": "check_api_health",
                 "arguments": "{\"endpoints\": [\"auth\", \"payments\", \"inventory\", \"notifications\"]}",
                 "status": "completed"},
                # inventory is intentionally degraded to show a realistic mixed-status response
                {"type": "function_call_output", "id": "fco_q3", "call_id": "call_hq3",
                 "output": "{\"auth\": \"ok\", \"payments\": \"ok\", \"inventory\": \"degraded\", \"notifications\": \"ok\", \"uptime_pct\": 99.1, \"avg_latency_ms\": 187}",
                 "status": "completed"},
                {"type": "message", "id": "msg_q3", "role": "assistant", "status": "completed",
                 "content": [{"type": "output_text",
                              "text": "## API Health\n\n| Service | Status |\n|---------|--------|\n| Auth | OK |\n| Payments | OK |\n| Inventory | Degraded |\n| Notifications | OK |\n\n**Uptime:** 99.1% | **Avg latency:** 187ms\n\n`inventory` is degraded — worth investigating before the next deploy."}]}
            ],
            "usage": {"input_tokens": 121, "output_tokens": 134, "total_tokens": 255}
        }

    # --- Default: unrecognised query — return example prompts ---
    return {
        "id": "resp_q_default", "object": "response",
        "model": "gpt-4o-2024-11-20", "status": "completed",
        "output": [
            {"type": "reasoning", "id": "rs_q0", "status": "completed",
             "summary": [{"text": "General question. I'll answer based on what I know about API Dash."}]},
            {"type": "message", "id": "msg_q0", "role": "assistant", "status": "completed",
             "content": [{"type": "output_text",
                          "text": "I can help with **API testing** inside APIDash. Try asking:\n\n- *\"Check London weather\"* — reasoning + web search + tool call\n- *\"Test the Stripe balance endpoint\"* — HTTP request tool + result\n- *\"Show API health dashboard\"* — multi-service health check\n\nEach response shows the full agent trace: reasoning, tool calls, and the final answer."}]}
        ],
        "usage": {"input_tokens": 54, "output_tokens": 76, "total_tokens": 130}
    }
