from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os
import threading
from dotenv import load_dotenv
import lm_eval
import urllib

load_dotenv()

# 1. Hardcode your Gemini API Key
# We set it as OPENAI_API_KEY because we are utilizing the OpenAI-compatible wrapper.
# Ensure you replace this with your actual Gemini key before running.
os.environ["OPENAI_API_KEY"] = os.getenv("GEMINI_API_KEY")
api_key = os.getenv("OPENAI_API_KEY")

class GeminiProxyHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass # Suppress proxy logs to keep your terminal clean

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        payload = json.loads(post_data)
        
        # THE FIX: Strip 'seed' (and other penalty params) that Gemini rejects
        payload.pop('seed', None)
        payload.pop('presence_penalty', None)
        payload.pop('frequency_penalty', None)
        
        # Forward the sanitized request directly to Google
        url = "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"
        req = urllib.request.Request(
            url, 
            data=json.dumps(payload).encode('utf-8'), 
            headers={
                'Content-Type': 'application/json', 
                'Authorization': f'Bearer {api_key}'
            }
        )
        try:
            with urllib.request.urlopen(req) as response:
                self.send_response(response.getcode())
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(response.read())
        except urllib.error.HTTPError as e:
            self.send_response(e.code)
            self.end_headers()
            self.wfile.write(e.read())

def start_proxy():
    server = HTTPServer(('localhost', 8080), GeminiProxyHandler)
    server.serve_forever()

# Start the inline proxy in a daemon background thread
threading.Thread(target=start_proxy, daemon=True).start()




def run_raw_logic_prover():
    print("Initializing Phase 1: Raw Logic Prover...")
    print("Booting lm-eval with local/OpenAI-compatible syntax targeting Gemini...")

    try:
        # 2. Execute the blocking evaluation call
        # We use the 'openai-chat-completions' model type and point the base_url 
        # to Google's official OpenAI-compatible endpoint.
        results = lm_eval.simple_evaluate(
            model="local-chat-completions",
            model_args="model=gemini-flash-latest,base_url=http://localhost:8080/v1", 
            tasks=["gsm8k"],  
            limit=5,
            log_samples=False,
            apply_chat_template=True 
        )

        print("\n--- Evaluation Successful ---")
        
        # 3. Dump the raw JSON output to map the UI extraction
        print("\n--- Raw JSON Payload ---")
        print(json.dumps(results['results'], indent=2))

    except Exception as e:
        print(f"\n[ERROR] Evaluation failed: {e}")

if __name__ == "__main__":
    run_raw_logic_prover()