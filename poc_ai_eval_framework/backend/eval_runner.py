import lm_eval
import logging
import asyncio
import os

class QueueLogHandler(logging.Handler):
    def __init__(self, queue: asyncio.Queue, loop: asyncio.AbstractEventLoop):
        super().__init__()
        self.queue = queue
        self.loop = loop

    def emit(self, record):
        msg = self.format(record)
        # Safely push the log into the async queue from this synchronous thread
        asyncio.run_coroutine_threadsafe(self.queue.put(msg), self.loop)

def run_evaluation_thread(run_id: str, model_name: str, api_key: str, queue: asyncio.Queue, loop: asyncio.AbstractEventLoop, results_store: dict):
    # 1. Attach our custom handler to the root logger so we catch everything
    logger = logging.getLogger()
    handler = QueueLogHandler(queue, loop)
    handler.setFormatter(logging.Formatter('%(message)s'))
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)

    try:
        os.environ["OPENAI_API_KEY"] = api_key

        # 2. for running the eval, we are pointing base_url to our FastAPI proxy route if it's a Gemini model. This allows us to strip the 'seed' parameter that causes issues.
        if "gemini" in model_name.lower():
            # Route through our Gemini proxy
            args_string = f"model={model_name},base_url=http://localhost:8000/proxy/v1/chat/completions"
        elif "llama" in model_name.lower() or "mixtral" in model_name.lower() or "gemma" in model_name.lower():
            # THE FIX: Route through our new Groq proxy to sanitize the message array
            args_string = f"model={model_name},base_url=http://localhost:8000/proxy/groq/v1/chat/completions"
        else:
            # Default behavior: Let lm-eval talk straight to OpenAI
            args_string = f"model={model_name}"

        results = lm_eval.simple_evaluate(
            model="local-chat-completions",
            model_args=args_string, 
            tasks=["gsm8k"],
            limit=5,
            log_samples=False,
            apply_chat_template=True
        )

        # 3. Store the final results and signal completion
        results_store[run_id] = {"status": "completed", "data": results['results']}
        asyncio.run_coroutine_threadsafe(queue.put("[EVAL_DONE]"), loop)

    except Exception as e:
        results_store[run_id] = {"status": "error", "error": str(e)}
        asyncio.run_coroutine_threadsafe(queue.put(f"[EVAL_ERROR] {str(e)}"), loop)
    finally:
        # Clean up the handler so it doesn't leak across different runs
        logger.removeHandler(handler)