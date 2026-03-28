"""Ollama provider adapter — local vision (LLaVA) and text models."""

from __future__ import annotations

import asyncio
import base64
import time
from typing import Any

import httpx

from config import settings
from providers.base import (
    HealthStatus,
    ProviderAdapter,
    ProviderInvocation,
    ProviderResult,
    TaskKind,
)


class OllamaProvider(ProviderAdapter):
    id = "ollama"
    name = "Ollama (Local)"
    provider_type = "local"
    supported_tasks = [
        TaskKind.IMAGE_UNDERSTANDING,
        TaskKind.TEXT,
    ]

    def __init__(self) -> None:
        self._base_url = settings.ollama_base_url.rstrip("/")

    async def invoke(self, invocation: ProviderInvocation) -> ProviderResult:
        start = time.perf_counter()
        try:
            if invocation.task_kind in (TaskKind.IMAGE_UNDERSTANDING, TaskKind.TEXT):
                return await self._chat(invocation, start)
            else:
                return ProviderResult(
                    provider_id=self.id, model=invocation.model,
                    task_kind=invocation.task_kind,
                    error=f"Unsupported task: {invocation.task_kind}",
                )
        except Exception as exc:
            return ProviderResult(
                provider_id=self.id, model=invocation.model,
                task_kind=invocation.task_kind,
                latency_ms=(time.perf_counter() - start) * 1000,
                error=str(exc),
            )

    @staticmethod
    def _strip_thinking(text: str) -> str:
        """Remove <think>...</think> blocks from qwen3.5 and similar models."""
        import re
        return re.sub(r"<think>.*?</think>", "", text, flags=re.DOTALL).strip()

    async def _chat(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        options: dict[str, Any] = {
            "num_predict": inv.max_tokens or inv.config.get("max_tokens", 512),
        }
        temp = inv.temperature if inv.temperature is not None else inv.config.get("temperature")
        if temp is not None:
            options["temperature"] = temp

        messages = []
        sys_p = inv.system_prompt or inv.config.get("system_prompt")
        if sys_p:
            messages.append({"role": "system", "content": sys_p})
        messages.append({"role": "user", "content": inv.prompt})

        payload: dict[str, Any] = {
            "model": inv.model,
            "messages": messages,
            "stream": False,
            "options": options,
        }

        # Add image for vision tasks
        if inv.task_kind == TaskKind.IMAGE_UNDERSTANDING and inv.media_bytes:
            b64 = base64.b64encode(inv.media_bytes).decode()
            payload["messages"][-1]["images"] = [b64]

        # Retry once on model load failures (Ollama may need time to swap models)
        data = None
        last_error = ""
        for attempt in range(2):
            async with httpx.AsyncClient(timeout=120.0) as client:
                resp = await client.post(f"{self._base_url}/api/chat", json=payload)
                data = resp.json()
                if "error" in data:
                    last_error = data["error"]
                    if attempt == 0 and "failed to load" in last_error:
                        await asyncio.sleep(3)  # Give Ollama time to free memory
                        continue
                    return ProviderResult(
                        provider_id=self.id, model=inv.model,
                        task_kind=inv.task_kind,
                        latency_ms=(time.perf_counter() - start) * 1000,
                        error=f"Ollama: {last_error}",
                    )
                resp.raise_for_status()
                break

        raw_text = data.get("message", {}).get("content", "")
        clean_text = self._strip_thinking(raw_text)

        return ProviderResult(
            provider_id=self.id,
            model=inv.model,
            task_kind=inv.task_kind,
            text_output=clean_text,
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=0,
            output_tokens=0,
            cost_usd=0.0,
            raw_response=data,
        )

    async def unload_model(self, model: str) -> None:
        """Tell Ollama to unload a model from GPU memory."""
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                await client.post(
                    f"{self._base_url}/api/generate",
                    json={"model": model, "keep_alive": 0},
                )
        except Exception:
            pass  # Best-effort; don't fail the eval if unload fails

    async def health_check(self) -> HealthStatus:
        try:
            start = time.perf_counter()
            async with httpx.AsyncClient(timeout=5.0) as client:
                resp = await client.get(f"{self._base_url}/api/tags")
                resp.raise_for_status()
                data = resp.json()
            models = [m["name"] for m in data.get("models", [])]
            return HealthStatus(
                available=True,
                latency_ms=(time.perf_counter() - start) * 1000,
                models=models,
            )
        except Exception as exc:
            return HealthStatus(available=False, error=str(exc))
