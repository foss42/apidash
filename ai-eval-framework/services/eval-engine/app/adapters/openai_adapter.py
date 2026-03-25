import os
import time
from typing import Any, Dict

import httpx

from app.adapters.base import BaseModelAdapter
from app.adapters.mock import MockAdapter


class OpenAIAdapter(BaseModelAdapter):
    name = "openai"
    display_name = "OpenAI"
    models = ["gpt-4", "gpt-4-turbo", "gpt-3.5-turbo"]

    def __init__(self) -> None:
        self._fallback = MockAdapter()

    async def generate(self, prompt: str, model: str, parameters: Dict[str, Any] = None) -> dict:
        if parameters is None:
            parameters = {}
        api_key = os.environ.get("OPENAI_API_KEY", "").strip()
        if not api_key:
            return await self._fallback.generate(prompt, model, parameters)

        url = "https://api.openai.com/v1/chat/completions"
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
        if parameters:
            for k in ("temperature", "max_tokens", "top_p", "frequency_penalty", "presence_penalty"):
                if k in parameters:
                    body[k] = parameters[k]

        start = time.perf_counter()
        try:
            async with httpx.AsyncClient(timeout=120.0) as client:
                resp = await client.post(url, json=body, headers=headers)
                resp.raise_for_status()
                data = resp.json()
        except (httpx.HTTPError, ValueError, KeyError):
            return await self._fallback.generate(prompt, model, parameters)

        latency_ms = (time.perf_counter() - start) * 1000.0
        try:
            choice = data["choices"][0]
            text = choice["message"]["content"] or ""
        except (KeyError, IndexError, TypeError):
            return await self._fallback.generate(prompt, model, parameters)

        usage = data.get("usage") or {}
        tokens_used = int(usage.get("total_tokens", 0))
        return {
            "text": text,
            "tokens_used": tokens_used,
            "latency_ms": latency_ms,
            "cost": 0.0,
        }
