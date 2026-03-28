"""Anthropic provider adapter — vision (Claude)."""

from __future__ import annotations

import base64
import time
from typing import Any

from anthropic import AsyncAnthropic

from config import settings
from providers.base import (
    HealthStatus,
    ProviderAdapter,
    ProviderInvocation,
    ProviderResult,
    TaskKind,
)

_PRICING = {
    "claude-sonnet-4-20250514": {"input": 0.003, "output": 0.015},
    "claude-haiku-4-20250414": {"input": 0.0008, "output": 0.004},
}


def _estimate_cost(model: str, input_tokens: int, output_tokens: int) -> float:
    rates = _PRICING.get(model, {"input": 0.003, "output": 0.015})
    return (input_tokens * rates["input"] + output_tokens * rates["output"]) / 1000


class AnthropicProvider(ProviderAdapter):
    id = "anthropic"
    name = "Anthropic"
    provider_type = "cloud"
    supported_tasks = [TaskKind.IMAGE_UNDERSTANDING, TaskKind.TEXT]

    def __init__(self) -> None:
        self._client = AsyncAnthropic(api_key=settings.anthropic_api_key) if settings.anthropic_api_key else None

    async def invoke(self, invocation: ProviderInvocation) -> ProviderResult:
        if not self._client:
            return ProviderResult(
                provider_id=self.id, model=invocation.model,
                task_kind=invocation.task_kind, error="Anthropic API key not configured",
            )

        start = time.perf_counter()
        try:
            if invocation.task_kind == TaskKind.IMAGE_UNDERSTANDING:
                return await self._image_understanding(invocation, start)
            elif invocation.task_kind == TaskKind.TEXT:
                return await self._text(invocation, start)
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

    def _request_params(self, inv: ProviderInvocation) -> dict:
        """Extract temperature, max_tokens, system from request params."""
        params: dict = {}
        temp = inv.temperature if inv.temperature is not None else inv.config.get("temperature")
        mtok = inv.max_tokens if inv.max_tokens is not None else inv.config.get("max_tokens", 1024)
        sys_p = inv.system_prompt or inv.config.get("system_prompt")
        if temp is not None:
            params["temperature"] = temp
        params["max_tokens"] = mtok
        if sys_p:
            params["system"] = sys_p
        return params

    async def _image_understanding(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        assert inv.media_bytes and inv.media_type
        b64 = base64.b64encode(inv.media_bytes).decode()

        # Anthropic requires explicit media_type
        media_type = inv.media_type
        if media_type not in ("image/png", "image/jpeg", "image/gif", "image/webp"):
            media_type = "image/png"

        resp = await self._client.messages.create(
            model=inv.model,
            messages=[{
                "role": "user",
                "content": [
                    {"type": "image", "source": {"type": "base64", "media_type": media_type, "data": b64}},
                    {"type": "text", "text": inv.prompt},
                ],
            }],
            **self._request_params(inv),
        )
        text = resp.content[0].text if resp.content else ""
        it = resp.usage.input_tokens
        ot = resp.usage.output_tokens
        return ProviderResult(
            provider_id=self.id, model=inv.model,
            task_kind=inv.task_kind,
            text_output=text,
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it, output_tokens=ot,
            cost_usd=_estimate_cost(inv.model, it, ot),
            raw_response={"id": resp.id, "stop_reason": resp.stop_reason},
        )

    async def _text(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        resp = await self._client.messages.create(
            model=inv.model,
            messages=[{"role": "user", "content": inv.prompt}],
            **self._request_params(inv),
        )
        text = resp.content[0].text if resp.content else ""
        it = resp.usage.input_tokens
        ot = resp.usage.output_tokens
        return ProviderResult(
            provider_id=self.id, model=inv.model,
            task_kind=inv.task_kind,
            text_output=text,
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it, output_tokens=ot,
            cost_usd=_estimate_cost(inv.model, it, ot),
            raw_response={"id": resp.id, "stop_reason": resp.stop_reason},
        )

    async def health_check(self) -> HealthStatus:
        if not self._client:
            return HealthStatus(available=False, error="API key not configured")
        try:
            start = time.perf_counter()
            # Quick health check with minimal request
            await self._client.messages.create(
                model="claude-haiku-4-20250414",
                max_tokens=1,
                messages=[{"role": "user", "content": "hi"}],
            )
            return HealthStatus(
                available=True,
                latency_ms=(time.perf_counter() - start) * 1000,
                models=["claude-sonnet-4-20250514", "claude-haiku-4-20250414"],
            )
        except Exception as exc:
            return HealthStatus(available=False, error=str(exc))
