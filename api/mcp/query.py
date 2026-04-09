"""
POST /mcp/query

Accepts a JSON body with a "message" field and returns a mock OpenAI Responses
API response routed by keyword matching.

Request body:
    { "message": "<user query string>" }

Routing (handled by mcp_query_response in _data.py):
    weather / london / temperature / forecast  -> London weather tool call
    stripe / payment / checkout / balance      -> Stripe balance HTTP request
    health / status / uptime / dashboard       -> multi-service health check
    (anything else)                            -> default helper message

Response shape matches the OpenAI Responses API object so the APIDash UI
can render the full agent trace (reasoning, tool calls, assistant message).

Used by the APIDash PoC to demonstrate interactive MCP-style querying.
"""
from http.server import BaseHTTPRequestHandler
import json
import sys
import os

# Walk up one level from api/mcp/ to reach api/ where _data.py lives
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))
from _data import mcp_query_response


class handler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        # Handle CORS preflight requests from browser clients
        self.send_response(200)
        self._cors()
        self.end_headers()

    def do_POST(self):
        # Read the exact number of bytes declared by Content-Length
        length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(length)

        # Parse JSON body; fall back to empty message on malformed input
        try:
            payload = json.loads(body)
            message = payload.get('message', '')
        except Exception:
            message = ''

        # Route to the appropriate mock response based on message keywords
        response = mcp_query_response(message)
        out = json.dumps(response, indent=2).encode()

        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self._cors()
        self.end_headers()
        self.wfile.write(out)

    def _cors(self):
        # Allow cross-origin POST requests from the Flutter web client and APIDash UI
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
