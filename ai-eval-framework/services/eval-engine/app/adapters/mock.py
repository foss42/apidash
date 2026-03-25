import asyncio
import time
from typing import Any, Dict

from app.adapters.base import BaseModelAdapter


class MockAdapter(BaseModelAdapter):
    name = "mock"
    display_name = "Mock (deterministic)"
    models = ["mock-model", "gpt-4", "gpt-3.5-turbo"]

    async def generate(self, prompt: str, model: str, parameters: Dict[str, Any] = None) -> dict:
        if parameters is None:
            parameters = {}
        await asyncio.sleep(0.1)
        text = prompt[::-1]
        return {
            "text": text,
            "tokens_used": max(1, len(prompt) // 4),
            "latency_ms": 100.0,
            "cost": 0.0,
        }
