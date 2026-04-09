"""
GET /open-responses

Returns a single completed mock response in the OpenAI Responses API format.
The response simulates a multi-step agent trace:
  reasoning -> web_search -> file_search -> function_call -> message

Used by the APIDash PoC to demonstrate Open Responses rendering in the UI.
"""
from http.server import BaseHTTPRequestHandler
import json
import sys
import os

# Make the parent api/ directory importable so _data.py can be found
sys.path.insert(0, os.path.dirname(__file__))
from _data import OPEN_RESPONSES_JSON


class handler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        # Handle CORS preflight requests from browser clients
        self.send_response(200)
        self._cors()
        self.end_headers()

    def do_GET(self):
        # Serialize the mock response and return it as JSON
        body = json.dumps(OPEN_RESPONSES_JSON, indent=2).encode()
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
