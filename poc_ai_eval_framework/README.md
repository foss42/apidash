
# API Dash Eval PoC

A local-first, end-to-end web interface for running LLM benchmarks via the EleutherAI `lm-eval` harness. Built as a Proof of Concept for the AI eval project. This is for testing cloud api's like gemini and groq models, the same proxy pattern can be used for local model testing too.

![App Demo](./demo.gif) 

## How It Works (The Architecture)

The core challenge of this PoC was that `lm-eval` expects every API to behave exactly like OpenAI. But in reality, different providers have incredibly strict, weird, annoying schema validators. 

For eg:
* **Google Gemini** instantly throws a `400 Bad Request` if it receives OpenAI-specific parameters like `seed`.
* **Groq** crashes if it receives unexpected `type` properties inside the `messages` array.

### The Proxy Middleware Solution
(this was the coolest part :)
Instead of running evaluations directly from the React UI, we trigger an HTTP POST to a decoupled FastAPI backend. This backend runs `lm-eval` safely in a background thread. 

To fix the schema crashes, we built a **Native Middleware Pattern**:
1. `lm-eval` is instructed to send its API requests to our local FastAPI proxy routes (e.g., `http://localhost:8000/proxy/v1/...`) instead of the cloud provider.
2. The proxy intercepts the payload, strips out the vendor-incompatible parameters (like removing `seed` for Gemini, or popping `type` for Groq).
3. It seamlessly forwards the sanitized request to the actual provider, gets the response, and hands it back to `lm-eval`.

### Real-Time Log Streaming
To get the live terminal feel in the browser. Here, we attached a custom `logging.Handler` directly into Python's `logging` module inside the background thread. This intercepts the logs as `lm-eval` generates them and streams them to the React frontend in real-time using Server-Sent Events (SSE).

## Key Features
* **Zero-File I/O:** Evaluations run entirely in-memory using background threads, requiring no temp file generation.
* **Live Log Streaming:** Real-time execution logs piped directly to a custom web terminal via SSE.
* **Multiple Vendors:** Demonstrated compatibility with strict APIs (Gemini, Groq) via custom payload sanitization routes.
* **Modern Stack:** FastAPI backend + Vite/React (TypeScript, SWC, Tailwind v4) frontend.

---
## this was all for the standard repo installation, use your own preferred way for testing now
## One-Command Setup

**Prerequisites:** Ensure you have **Python 3.10+** and **Node.js 18+** installed on your machine.

**Note:** The first boot might take 2-5 minutes as it downloads  `lm-eval`, and Node modules.

Clone the repository and run the startup script in your terminal (like the VS Code integrated terminal). This will automatically create the Python virtual environment, install all dependencies, and boot both servers.

**For Windows:**
```cmd
.\start.bat
```

**For Mac/Linux:**
```bash
chmod +x start.sh
./start.sh
```

### Manual Setup (Fallback)
If the automated scripts fail due to strict execution policies on your machine, you can start the servers manually using two terminals.

**Terminal 1: Backend**
```bash
cd backend
python -m venv venv
# On Windows use: venv\Scripts\activate
# On Mac/Linux use: source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload
```

Terminal 2 – Frontend
```bash
cd frontend
npm install
npm run dev
```
Open http://localhost:5173 in your browser once both are running.

## How to Use & Concrete Results

Open your browser to http://localhost:5173
Enter your own API Key. (Note: This PoC is verified specifically for Gemini and Groq keys. Standard OpenAI keys may fail until a dedicated OpenAI passthrough route is added).
Enter the corresponding model name (e.g., gemini-flash-latest or llama-3.3-70b-versatile )
Enter your desired task (e.g., gsm8k) and Sample Limit
Click Run Evaluation and watch the logs stream in real-time
Test Results:
In local testing using this framework, I tested these:

Gemini 3.0 Flash on GSM8K (5 samples): 0.2000 (20%) Exact Match
Llama 3.3 70B on GSM8K (5 samples): 1.0000 (100%) Exact Match
