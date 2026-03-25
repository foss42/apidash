import asyncio
import os
import time
from typing import Any, Dict

import httpx

from app.adapters.base import BaseModelAdapter

MAX_RETRIES = 5


class GroqAdapter(BaseModelAdapter):
    name = "groq"
    display_name = "Groq"
    models = [
        "llama-3.3-70b-versatile",
        "llama-3.1-8b-instant",
        "gemma2-9b-it",
        "mixtral-8x7b-32768",
    ]

    async def generate(self, prompt: str, model: str, parameters: Dict[str, Any] = None) -> dict:
        if parameters is None:
            parameters = {}
        api_key = os.environ.get("GROQ_API_KEY", "").strip()
        if not api_key:
            raise RuntimeError("GROQ_API_KEY is not set in .env")

        url = "https://api.groq.com/openai/v1/chat/completions"
        headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        }
        system_prompt = parameters.pop("system_prompt", None) or (
            "You are being evaluated. Reply with ONLY the answer — "
            "no explanation, no extra text, no formatting."
        )
        body: Dict[str, Any] = {
            "model": model,
            "messages": [
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": prompt},
            ],
        }
        for k in ("temperature", "max_tokens", "top_p"):
            if k in parameters:
                body[k] = parameters[k]
        if "max_tokens" not in body:
            body["max_tokens"] = 256

        last_error: str | None = None
        for attempt in range(MAX_RETRIES):
            start = time.perf_counter()
            try:
                async with httpx.AsyncClient(timeout=60.0) as client:
                    resp = await client.post(url, json=body, headers=headers)

                    if resp.status_code == 401:
                        raise RuntimeError("Groq API key is invalid (401 Unauthorized). Check your .env file.")

                    if resp.status_code == 429:
                        error_body = resp.json().get("error", {})
                        msg = error_body.get("message", "")
                        if "RPD" in msg or "per day" in msg.lower():
                            raise RuntimeError(
                                f"Groq daily rate limit reached (1,000 req/day on free tier). "
                                f"Wait until tomorrow or upgrade at https://console.groq.com"
                            )
                        wait = min(float(resp.headers.get("retry-after", 2 * (attempt + 1))), 15)
                        await asyncio.sleep(wait)
                        continue

                    resp.raise_for_status()
                    data = resp.json()
            except RuntimeError:
                raise
            except httpx.HTTPError as e:
                last_error = str(e)
                await asyncio.sleep(2 * (attempt + 1))
                continue

            latency_ms = (time.perf_counter() - start) * 1000.0
            choice = data["choices"][0]
            text = choice["message"]["content"] or ""
            usage = data.get("usage") or {}
            tokens_used = int(usage.get("total_tokens", 0))
            return {
                "text": text.strip(),
                "tokens_used": tokens_used,
                "latency_ms": latency_ms,
                "cost": 0.0,
            }

        raise RuntimeError(f"Groq API failed after {MAX_RETRIES} retries: {last_error}")
