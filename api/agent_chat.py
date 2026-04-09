"""
GET /agent-chat

Returns a multi-turn agent conversation in the OpenAI Responses API format.
Each turn contains a user message and a full agent response with:
  - reasoning       : model's chain-of-thought before acting
  - tool calls      : list_api_templates or send_http_request
  - tool outputs    : results returned to the model
  - assistant message : final markdown-formatted answer

Used by the APIDash PoC to demonstrate interactive agent chat rendering.
"""
from http.server import BaseHTTPRequestHandler
import json
import sys
import os

# Make the parent api/ directory importable so _data.py can be found
sys.path.insert(0, os.path.dirname(__file__))
from _data import AGENT_CHAT_JSON


class handler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        # Handle CORS preflight requests from browser clients
        self.send_response(200)
        self._cors()
        self.end_headers()

    def do_GET(self):
        # Serialize all conversation turns and return as JSON
        body = json.dumps(AGENT_CHAT_JSON, indent=2).encode()
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self._cors()
        self.end_headers()
        self.wfile.write(body)

    def _cors(self):
        # Allow cross-origin requests from the Flutter web client and APIDash UI
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
