"""
GET /stream

Streams a mock OpenAI Responses API event sequence using Server-Sent Events (SSE).
Each event is written as "data: <json>\n\n" per the SSE spec.

The event sequence replays a London weather query end-to-end:
  response.created
  -> reasoning item (summary text deltas)
  -> web_search_call
  -> function_call (arguments stream as deltas)
  -> function_call_output
  -> message (output_text deltas)
  -> response.completed

All events are flushed immediately without sleep — Vercel functions have a
300 s execution timeout but SSE connections can be cut short by the platform,
so we avoid any artificial delays.

The stream ends with a "data: [DONE]\n\n" sentinel that clients use to detect
end-of-stream (mirrors the OpenAI streaming convention).
"""
from http.server import BaseHTTPRequestHandler
import json
import sys
import os

# Make the parent api/ directory importable so _data.py can be found
sys.path.insert(0, os.path.dirname(__file__))
from _data import SSE_EVENTS


class handler(BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        # Handle CORS preflight requests from browser clients
        self.send_response(200)
        self._cors()
        self.end_headers()

    def do_GET(self):
        # SSE requires Content-Type: text/event-stream and no caching
        self.send_response(200)
        self.send_header('Content-Type', 'text/event-stream')
        self.send_header('Cache-Control', 'no-cache')
        self.send_header('Connection', 'keep-alive')
        self._cors()
        self.end_headers()

        # Write each event immediately — no sleep between events because
        # Vercel functions have a 10 s timeout on the free plan
        for event in SSE_EVENTS:
            line = f"data: {json.dumps(event)}\n\n".encode()
            self.wfile.write(line)
            self.wfile.flush()

        # SSE end-of-stream sentinel (mirrors OpenAI convention)
        self.wfile.write(b"data: [DONE]\n\n")
        self.wfile.flush()

    def _cors(self):
        # Allow cross-origin requests from the Flutter web client and APIDash UI
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
