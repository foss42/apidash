#!/usr/bin/env python3
"""Mock server for APIDash PoC screenshots.
Run: python3 mock_server.py
Then use http://localhost:8765/<endpoint> in APIDash.
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import time

# open responses payload — hits the Structured tab in apidash
OPEN_RESPONSES_JSON = {
    "id": "resp_mock_001",
    "object": "response",
    "model": "gpt-4o-2024-11-20",
    "status": "completed",
    "output": [
        {
            "type": "reasoning",
            "id": "rs_001",
            "status": "completed",
            "summary": [{"text": "User wants current weather in San Francisco. I'll use web search and the get_weather tool to fetch live data, then summarise it clearly."}]
        },
        {
            "type": "web_search_call",
            "id": "ws_001",
            "status": "completed"
        },
        {
            "type": "file_search_call",
            "id": "fsc_001",
            "status": "completed",
            "queries": ["San Francisco weather patterns", "Bay Area climate normals"]
        },
        {
            "type": "function_call",
            "id": "fc_001",
            "call_id": "call_abc123",
            "name": "get_weather",
            "arguments": "{\"location\": \"San Francisco, CA\", \"unit\": \"celsius\"}",
            "status": "completed"
        },
        {
            "type": "function_call_output",
            "id": "fco_001",
            "call_id": "call_abc123",
            "output": "{\"temperature\": 18, \"condition\": \"Partly cloudy\", \"humidity\": 72, \"wind_kph\": 14}",
            "status": "completed"
        },
        {
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
    "usage": {
        "input_tokens": 245,
        "output_tokens": 312,
        "total_tokens": 557
    }
}

# a2ui payload — hits the GenUI tab
A2UI_JSONL = '\n'.join([
    json.dumps({"createSurface": {"id": "dash_001", "title": "API Health Dashboard", "layout": "scroll"}}),
    json.dumps({"updateComponents": {"components": [
        {"id": "root", "component": "Column",
         "children": ["header", "stats_row", "div1", "health_card", "div2", "actions_row"]},
        {"id": "header", "component": "Text", "variant": "h1", "text": "API Health Dashboard"},
        # stats row
        {"id": "stats_row", "component": "Row", "justify": "spaceBetween",
         "children": ["card_uptime", "card_latency", "card_errors"]},
        {"id": "card_uptime", "component": "Card",
         "children": ["lbl_uptime", "val_uptime"]},
        {"id": "lbl_uptime", "component": "Text", "variant": "caption", "text": "Uptime"},
        {"id": "val_uptime", "component": "Text", "variant": "h2", "text": {"path": "/uptime"}},
        {"id": "card_latency", "component": "Card",
         "children": ["lbl_latency", "val_latency"]},
        {"id": "lbl_latency", "component": "Text", "variant": "caption", "text": "Avg Latency"},
        {"id": "val_latency", "component": "Text", "variant": "h2", "text": {"path": "/latency"}},
        {"id": "card_errors", "component": "Card",
         "children": ["lbl_errors", "val_errors"]},
        {"id": "lbl_errors", "component": "Text", "variant": "caption", "text": "Error Rate"},
        {"id": "val_errors", "component": "Text", "variant": "h2", "text": {"path": "/error_rate"}},
        # dividers & health card
        {"id": "div1", "component": "Divider"},
        {"id": "health_card", "component": "Card",
         "children": ["health_title", "health_progress", "chip_row"]},
        {"id": "health_title", "component": "Text", "variant": "h3", "text": "System Health"},
        {"id": "health_progress", "component": "Progress",
         "label": "Overall Health", "value": 0.92},
        {"id": "chip_row", "component": "Row",
         "children": ["chip_api", "chip_db", "chip_cache"]},
        {"id": "chip_api",   "component": "Chip", "label": "API: OK"},
        {"id": "chip_db",    "component": "Chip", "label": "DB: OK"},
        {"id": "chip_cache", "component": "Chip", "label": "Cache: OK"},
        # actions
        {"id": "div2", "component": "Divider"},
        {"id": "actions_row", "component": "Row",
         "children": ["btn_refresh", "btn_logs"]},
        {"id": "btn_refresh", "component": "Button", "variant": "primary",
         "text": "Refresh", "action": "refresh_dashboard"},
        {"id": "btn_logs", "component": "Button", "variant": "outlined",
         "text": "View Logs", "action": "view_logs"},
    ]}}),
    json.dumps({"updateDataModel": {"path": "/uptime",     "value": "99.9%"}}),
    json.dumps({"updateDataModel": {"path": "/latency",    "value": "142ms"}}),
    json.dumps({"updateDataModel": {"path": "/error_rate", "value": "0.1%"}}),
])


# SSE stream — emits Open Responses events that OpenResponsesStreamParser can consume live
SSE_EVENTS = [
    {"type": "response.created", "response": {
        "id": "resp_stream_001", "object": "response",
        "model": "gpt-4o-2024-11-20", "status": "in_progress", "output": []
    }},

    # reasoning
    {"type": "response.output_item.added", "output_index": 0,
     "item": {"type": "reasoning", "id": "rs_s001", "status": "in_progress"}},
    {"type": "response.reasoning_summary_text.delta", "output_index": 0,
     "delta": "User asked for London weather."},
    {"type": "response.reasoning_summary_text.delta", "output_index": 0,
     "delta": " I'll call get_weather and format the result clearly."},
    {"type": "response.output_item.done", "output_index": 0,
     "item": {"type": "reasoning", "id": "rs_s001", "status": "completed",
              "summary": [{"text": "User asked for London weather. I'll call get_weather and format the result clearly."}]}},

    # web search
    {"type": "response.output_item.added", "output_index": 1,
     "item": {"type": "web_search_call", "id": "ws_s001", "status": "in_progress"}},
    {"type": "response.output_item.done", "output_index": 1,
     "item": {"type": "web_search_call", "id": "ws_s001", "status": "completed"}},

    # function call (streamed args)
    {"type": "response.output_item.added", "output_index": 2,
     "item": {"type": "function_call", "id": "fc_s001", "call_id": "call_xyz",
              "name": "get_weather", "status": "in_progress", "arguments": ""}},
    {"type": "response.function_call_arguments.delta", "output_index": 2, "delta": "{\"location\""},
    {"type": "response.function_call_arguments.delta", "output_index": 2, "delta": ": \"London\","},
    {"type": "response.function_call_arguments.delta", "output_index": 2, "delta": " \"unit\": \"celsius\"}"},
    {"type": "response.output_item.done", "output_index": 2,
     "item": {"type": "function_call", "id": "fc_s001", "call_id": "call_xyz",
              "name": "get_weather", "status": "completed",
              "arguments": "{\"location\": \"London\", \"unit\": \"celsius\"}"}},

    # function call output
    {"type": "response.output_item.added", "output_index": 3,
     "item": {"type": "function_call_output", "id": "fco_s001", "call_id": "call_xyz",
              "status": "completed",
              "output": "{\"temperature\": 14, \"condition\": \"Overcast\", \"humidity\": 81}"}},
    {"type": "response.output_item.done", "output_index": 3,
     "item": {"type": "function_call_output", "id": "fco_s001", "call_id": "call_xyz",
              "status": "completed",
              "output": "{\"temperature\": 14, \"condition\": \"Overcast\", \"humidity\": 81}"}},

    # message (streamed text)
    {"type": "response.output_item.added", "output_index": 4,
     "item": {"type": "message", "id": "msg_s001", "role": "assistant",
              "status": "in_progress", "content": []}},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "## London Weather\n\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "Current conditions: **14°C**"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": ", overcast skies.\n\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Metric | Value |\n|--------|-------|\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Temperature | 14°C |\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Condition | Overcast |\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "| Humidity | 81% |\n\n"},
    {"type": "response.output_text.delta", "output_index": 4, "delta": "Classic London — bring an umbrella."},
    {"type": "response.output_item.done", "output_index": 4,
     "item": {"type": "message", "id": "msg_s001", "role": "assistant", "status": "completed",
              "content": [{"type": "output_text",
                           "text": "## London Weather\n\nCurrent conditions: **14°C**, overcast skies.\n\n| Metric | Value |\n|--------|-------|\n| Temperature | 14°C |\n| Condition | Overcast |\n| Humidity | 81% |\n\nClassic London — bring an umbrella."}]}},

    # completed — full response object so the parser can use the clean final state
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
                          "text": "## London Weather\n\nCurrent conditions: **14°C**, overcast skies.\n\n| Metric | Value |\n|--------|-------|\n| Temperature | 14°C |\n| Condition | Overcast |\n| Humidity | 81% |\n\nClassic London — bring an umbrella."}]}
        ],
        "usage": {"input_tokens": 142, "output_tokens": 97, "total_tokens": 239}
    }},
]


# two-turn agent chatflow — each agent response is a full open responses object
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
                    {
                        "type": "reasoning",
                        "id": "rs_a001",
                        "status": "completed",
                        "summary": [{"text": "User needs payment API test coverage. I'll search for common payment gateway endpoints and cross-reference with their API collection to recommend the most critical ones."}]
                    },
                    {
                        "type": "web_search_call",
                        "id": "ws_a001",
                        "status": "completed"
                    },
                    {
                        "type": "file_search_call",
                        "id": "fsc_a001",
                        "status": "completed",
                        "queries": ["payment API endpoints", "Stripe checkout integration", "payment gateway health check"]
                    },
                    {
                        "type": "function_call",
                        "id": "fc_a001",
                        "call_id": "call_list_apis",
                        "name": "list_api_templates",
                        "arguments": "{\"category\": \"payment\", \"limit\": 5}",
                        "status": "completed"
                    },
                    {
                        "type": "function_call_output",
                        "id": "fco_a001",
                        "call_id": "call_list_apis",
                        "output": "{\"templates\": [\"Stripe Balance\", \"Stripe Charges\", \"PayPal Orders\", \"Razorpay Orders\", \"Braintree Transactions\"]}",
                        "status": "completed"
                    },
                    {
                        "type": "message",
                        "id": "msg_a001",
                        "role": "assistant",
                        "status": "completed",
                        "content": [
                            {
                                "type": "output_text",
                                "text": "## Recommended Payment APIs to Test\n\nBased on your checkout flow, here are the 5 critical endpoints to cover:\n\n| Priority | API | What to verify |\n|----------|-----|----------------|\n| High | **Stripe Charges** | Request/response schema, error codes |\n| High | **Stripe Balance** | Auth, currency format |\n| Medium | **PayPal Orders** | Create + capture flow |\n| Medium | **Razorpay Orders** | INR amount format |\n| Low | **Braintree Transactions** | Sandbox vs production URLs |\n\nStart with the Stripe endpoints — they're used in the hot path and any regression there would break checkout immediately."
                            }
                        ]
                    }
                ],
                "usage": {
                    "input_tokens": 189,
                    "output_tokens": 278,
                    "total_tokens": 467
                }
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
                    {
                        "type": "reasoning",
                        "id": "rs_a002",
                        "status": "completed",
                        "summary": [{"text": "User wants to fire a live test against Stripe's balance API. I'll call the send_http_request tool with the correct auth header and parse the response."}]
                    },
                    {
                        "type": "function_call",
                        "id": "fc_a002",
                        "call_id": "call_http_req",
                        "name": "send_http_request",
                        "arguments": "{\"method\": \"GET\", \"url\": \"https://api.stripe.com/v1/balance\", \"headers\": {\"Authorization\": \"Bearer sk_test_***\"}}",
                        "status": "completed"
                    },
                    {
                        "type": "function_call_output",
                        "id": "fco_a002",
                        "call_id": "call_http_req",
                        "output": "{\"status\": 200, \"body\": {\"object\": \"balance\", \"available\": [{\"amount\": 92340, \"currency\": \"usd\"}], \"pending\": [{\"amount\": 4200, \"currency\": \"usd\"}], \"livemode\": false}}",
                        "status": "completed"
                    },
                    {
                        "type": "message",
                        "id": "msg_a002",
                        "role": "assistant",
                        "status": "completed",
                        "content": [
                            {
                                "type": "output_text",
                                "text": "**Stripe Balance — HTTP 200**\n\nThe endpoint is healthy and returning the expected schema:\n\n```json\n{\n  \"object\": \"balance\",\n  \"available\": [{ \"amount\": 92340, \"currency\": \"usd\" }],\n  \"pending\":   [{ \"amount\":  4200, \"currency\": \"usd\" }],\n  \"livemode\": false\n}\n```\n\n- `livemode: false` confirms we're hitting the **sandbox** correctly.\n- `available.amount` is in **cents** (92340 = $923.40) — make sure your assertions account for that.\n- No auth errors, schema is valid. You can now add this as an automated test in your collection."
                            }
                        ]
                    }
                ],
                "usage": {
                    "input_tokens": 312,
                    "output_tokens": 241,
                    "total_tokens": 553
                }
            }
        }
    ]
}


def _mcp_query_response(message: str) -> dict:
    """Route an incoming chat message to a canned Open Responses reply."""
    if any(k in message for k in ('weather', 'london', 'temperature', 'forecast')):
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
                              "text": "## London Weather\n\n**13°C**, cloudy. Humidity 78%, wind 18 km/h.\n\n| Metric | Value |\n|--------|-------|\n| Temperature | 13°C |\n| Condition | Cloudy |\n| Humidity | 78% |\n| Wind | 18 km/h |"}]}
            ],
            "usage": {"input_tokens": 98, "output_tokens": 112, "total_tokens": 210}
        }

    if any(k in message for k in ('stripe', 'payment', 'checkout', 'api test', 'balance')):
        return {
            "id": "resp_q_stripe", "object": "response",
            "model": "gpt-4o-2024-11-20", "status": "completed",
            "output": [
                {"type": "reasoning", "id": "rs_q2", "status": "completed",
                 "summary": [{"text": "User wants to test the Stripe balance endpoint. I'll fire a GET request with the test key."}]},
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

    if any(k in message for k in ('health', 'status', 'uptime', 'dashboard', 'monitor')):
        return {
            "id": "resp_q_health", "object": "response",
            "model": "gpt-4o-2024-11-20", "status": "completed",
            "output": [
                {"type": "reasoning", "id": "rs_q3", "status": "completed",
                 "summary": [{"text": "User wants an API health check. I'll query the health endpoint and summarise the key metrics."}]},
                {"type": "function_call", "id": "fc_q3", "call_id": "call_hq3",
                 "name": "check_api_health",
                 "arguments": "{\"endpoints\": [\"auth\", \"payments\", \"inventory\", \"notifications\"]}",
                 "status": "completed"},
                {"type": "function_call_output", "id": "fco_q3", "call_id": "call_hq3",
                 "output": "{\"auth\": \"ok\", \"payments\": \"ok\", \"inventory\": \"degraded\", \"notifications\": \"ok\", \"uptime_pct\": 99.1, \"avg_latency_ms\": 187}",
                 "status": "completed"},
                {"type": "message", "id": "msg_q3", "role": "assistant", "status": "completed",
                 "content": [{"type": "output_text",
                              "text": "## API Health\n\n| Service | Status |\n|---------|--------|\n| Auth | OK |\n| Payments | OK |\n| Inventory | Degraded |\n| Notifications | OK |\n\n**Uptime:** 99.1% | **Avg latency:** 187ms\n\n`inventory` is degraded — worth investigating before the next deploy."}]}
            ],
            "usage": {"input_tokens": 121, "output_tokens": 134, "total_tokens": 255}
        }

    # default — generic help
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


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        print(f"  {self.path}  {args[1]}")

    def do_GET(self):
        if self.path == '/open-responses':
            body = json.dumps(OPEN_RESPONSES_JSON, indent=2).encode()
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        elif self.path == '/a2ui':
            body = A2UI_JSONL.encode()
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        elif self.path == '/stream':
            self.send_response(200)
            self.send_header('Content-Type', 'text/event-stream')
            self.send_header('Cache-Control', 'no-cache')
            self.send_header('Connection', 'keep-alive')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            for event in SSE_EVENTS:
                line = f"data: {json.dumps(event)}\n\n".encode()
                self.wfile.write(line)
                self.wfile.flush()
                time.sleep(0.12)
            self.wfile.write(b"data: [DONE]\n\n")
            self.wfile.flush()

        elif self.path == '/agent-chat':
            body = json.dumps(AGENT_CHAT_JSON, indent=2).encode()
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        else:
            msg = b'Endpoints: /open-responses  /a2ui  /agent-chat  /stream  POST /mcp/query'
            self.send_response(404)
            self.send_header('Content-Type', 'text/plain')
            self.send_header('Content-Length', str(len(msg)))
            self.end_headers()
            self.wfile.write(msg)

    def do_POST(self):
        if self.path == '/mcp/query':
            length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(length)
            try:
                payload = json.loads(body)
                message = payload.get('message', '').lower()
            except Exception:
                message = ''

            response = _mcp_query_response(message)
            out = json.dumps(response, indent=2).encode()
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(out)))
            self.end_headers()
            self.wfile.write(out)
        else:
            self.do_GET()


if __name__ == '__main__':
    port = 8765
    print(f"\nMock server running on http://localhost:{port}")
    print(f"  /open-responses  ->  Structured view (reasoning + web/file search + tool call + message)")
    print(f"  /a2ui            ->  GenUI view (dashboard with cards, progress, chips, buttons)")
    print(f"  /agent-chat      ->  Agent chatflow (2-turn MCP-style chat, each turn is Open Responses)")
    print(f"  /stream          ->  SSE stream (Open Responses events, use with SSE request in APIDash)")
    print(f"  POST /mcp/query  ->  Interactive agent (AgentChatView backend, keyword-routed)\n")
    HTTPServer(('localhost', port), Handler).serve_forever()
