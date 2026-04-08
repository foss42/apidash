#!/usr/bin/env python3
"""Mock server for APIDash PoC screenshots.
Run: python3 mock_server.py
Then use http://localhost:8765/<endpoint> in APIDash.
"""
from http.server import BaseHTTPRequestHandler, HTTPServer
import json

# --- Payload 1: Open Responses (JSON) ---
# Triggers: Structured + Raw tabs
# Shows: Reasoning card, Web Search card, File Search card,
#        Tool Call group (with expandable args + result), Message card, token usage bar
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

# --- Payload 2: A2UI Generative UI (JSONL) ---
# Triggers: GenUI + Raw tabs
# Shows: surfaceTitle header, Column layout, Cards, Row with stats,
#        Progress bar, Chips, Buttons — all bound to data model
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


# --- Payload 3: Agent Chat (JSON) ---
# Triggers: AgentChatView demo
# Shows: two-turn chatflow where each agent turn is a full Open Responses
# object (reasoning + tool calls + message) rendered inline in the chat.
# Demonstrates the MCP Apps pattern:
#   user query → agent reasoning → tool invocations → inline structured output
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
                                "text": "## Recommended Payment APIs to Test\n\nBased on your checkout flow, here are the **5 critical endpoints** to cover:\n\n| Priority | API | What to verify |\n|----------|-----|----------------|\n| 🔴 High | **Stripe Charges** | Request/response schema, error codes |\n| 🔴 High | **Stripe Balance** | Auth, currency format |\n| 🟡 Medium | **PayPal Orders** | Create + capture flow |\n| 🟡 Medium | **Razorpay Orders** | INR amount format |\n| 🟢 Low | **Braintree Transactions** | Sandbox vs production URLs |\n\nStart with the Stripe endpoints — they're used in the hot path and any regression there would break checkout immediately."
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
                                "text": "**Stripe Balance — HTTP 200 ✅**\n\nThe endpoint is healthy and returning the expected schema:\n\n```json\n{\n  \"object\": \"balance\",\n  \"available\": [{ \"amount\": 92340, \"currency\": \"usd\" }],\n  \"pending\":   [{ \"amount\":  4200, \"currency\": \"usd\" }],\n  \"livemode\": false\n}\n```\n\n- `livemode: false` confirms we're hitting the **sandbox** correctly.\n- `available.amount` is in **cents** (92340 = $923.40) — make sure your assertions account for that.\n- No auth errors, schema is valid. You can now add this as an automated test in your collection."
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

        elif self.path == '/agent-chat':
            body = json.dumps(AGENT_CHAT_JSON, indent=2).encode()
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Content-Length', str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        else:
            msg = b'Endpoints: /open-responses  /a2ui  /agent-chat'
            self.send_response(404)
            self.send_header('Content-Type', 'text/plain')
            self.send_header('Content-Length', str(len(msg)))
            self.end_headers()
            self.wfile.write(msg)

    def do_POST(self):
        self.do_GET()


if __name__ == '__main__':
    port = 8765
    print(f"\nMock server running on http://localhost:{port}")
    print(f"  /open-responses  ->  Structured view (reasoning + web/file search + tool call + message)")
    print(f"  /a2ui            ->  GenUI view (dashboard with cards, progress, chips, buttons)")
    print(f"  /agent-chat      ->  Agent chatflow (2-turn MCP-style chat, each turn is Open Responses)\n")
    HTTPServer(('localhost', port), Handler).serve_forever()
