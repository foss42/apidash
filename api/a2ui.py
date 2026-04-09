"""
GET /a2ui

Returns an agent-to-UI JSONL payload — newline-delimited JSON commands that
the Flutter client processes sequentially to build a live UI surface.

Command sequence:
  1. createSurface    — initialise the canvas (id, title, layout)
  2. updateComponents — declare the full component tree in one batch
  3. updateDataModel  — push live metric values into data-bound nodes

The response MIME type is text/plain because each line is a self-contained
JSON object; clients split on newlines and parse each line individually.

Used by the APIDash PoC to demonstrate Generative UI / agent-driven rendering.
"""
from http.server import BaseHTTPRequestHandler
import sys
import os

# Make the parent api/ directory importable so _data.py can be found
sys.path.insert(0, os.path.dirname(__file__))
from _data import A2UI_JSONL


class handler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        # Handle CORS preflight requests from browser clients
        self.send_response(200)
        self._cors()
        self.end_headers()

    def do_GET(self):
        # Return the pre-built JSONL string as plain text
        # Clients split on '\n' and parse each line as a separate JSON command
        body = A2UI_JSONL.encode()
        self.send_response(200)
        self.send_header('Content-Type', 'text/plain')
        self._cors()
        self.end_headers()
        self.wfile.write(body)

    def _cors(self):
        # Allow cross-origin requests from the Flutter web client and APIDash UI
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
