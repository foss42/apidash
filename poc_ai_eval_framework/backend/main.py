from fastapi import FastAPI, Request, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
import uuid
import asyncio
import httpx
import json
import threading
from eval_runner import run_evaluation_thread

app = FastAPI()

# Enable CORS for the Vite frontend (port 5173)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# In-memory state management
queues = {}
results_store = {}

@app.post("/api/evaluate")
async def start_eval(request: Request):
    data = await request.json()
    run_id = str(uuid.uuid4())
    
    queues[run_id] = asyncio.Queue()
    results_store[run_id] = {"status": "running"}
    
    # Spawn the background thread
    loop = asyncio.get_running_loop()
    threading.Thread(
        target=run_evaluation_thread,
        args=(run_id, data['model'], data['api_key'], queues[run_id], loop, results_store),
        daemon=True
    ).start()
    
    return {"run_id": run_id}

@app.get("/api/stream/{run_id}")
async def stream_logs(run_id: str):
    async def event_generator():
        queue = queues.get(run_id)
        if not queue:
            yield f"data: {json.dumps({'error': 'Invalid run_id'})}\n\n"
            return
        
        while True:
            msg = await queue.get()
            if msg == "[EVAL_DONE]":
                final_data = results_store.get(run_id, {})
                yield f"data: {json.dumps({'done': True, 'results': final_data.get('data')})}\n\n"
                break
            elif msg.startswith("[EVAL_ERROR]"):
                yield f"data: {json.dumps({'error': msg})}\n\n"
                break
            else:
                yield f"data: {json.dumps({'log': msg})}\n\n"
    
    return StreamingResponse(event_generator(), media_type="text/event-stream")

#this is to strip the 'seed' parameter, this is for gemini, this can all be moved to a separate file in the future.
@app.post("/proxy/v1/chat/completions")
async def gemini_proxy(request: Request):
    payload = await request.json()
    
    payload.pop('seed', None)
    payload.pop('presence_penalty', None)
    payload.pop('frequency_penalty', None)
    
    auth_header = request.headers.get('Authorization')
    url = "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions"
    
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            url, 
            json=payload, 
            headers={'Authorization': auth_header},
            timeout=60.0
        )
        return Response(content=resp.content, status_code=resp.status_code, media_type="application/json")
    
#this is the groq adapter, to remove type from messages array as groq doesn't accept it
@app.post("/proxy/groq/v1/chat/completions")
async def groq_proxy(request: Request):
    payload = await request.json()
    
    # 1. Groq rejects the 'type' property inside message objects
    if 'messages' in payload:
        for msg in payload['messages']:
            msg.pop('type', None) # Strip the unsupported 'type' key
            
            # If lm-eval accidentally sends the new vision format (list of dicts), 
            # flatten it down to a standard string for Groq.
            if isinstance(msg.get('content'), list):
                text_content = " ".join([item.get('text', '') for item in msg['content'] if item.get('type') == 'text'])
                msg['content'] = text_content
                
    # 2. Groq also doesn't support logprobs yet on chat completions
    payload.pop('logprobs', None)
    payload.pop('top_logprobs', None)

    auth_header = request.headers.get('Authorization')
    url = "https://api.groq.com/openai/v1/chat/completions"
    
    async with httpx.AsyncClient() as client:
        resp = await client.post(
            url, 
            json=payload, 
            headers={'Authorization': auth_header},
            timeout=60.0
        )
        return Response(content=resp.content, status_code=resp.status_code, media_type="application/json")