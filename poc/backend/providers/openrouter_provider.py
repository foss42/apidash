"""OpenRouter provider adapter — OpenAI-compatible API gateway."""

from __future__ import annotations

import time
from typing import Any

from openai import AsyncOpenAI

from config import settings
from providers.base import (
    HealthStatus,
    ProviderAdapter,
    ProviderInvocation,
    ProviderResult,
    TaskKind,
)

_OPENROUTER_BASE_URL = "https://openrouter.ai/api/v1"

_FREE_MODELS = [
    "nvidia/nemotron-3-super-120b-a12b:free",
    "nvidia/nemotron-3-nano-30b-a3b:free",
    "nvidia/nemotron-nano-12b-v2-vl:free",
    "nvidia/nemotron-nano-9b-v2:free",
    "qwen/qwen3-next-80b-a3b-instruct:free",
    "qwen/qwen3-coder:free",
    "qwen/qwen3-4b:free",
    "google/gemma-3n-e2b-it:free",
    "google/gemma-3n-e4b-it:free",
    "google/gemma-3-4b-it:free",
    "google/gemma-3-12b-it:free",
    "google/gemma-3-27b-it:free",
    "openai/gpt-oss-120b:free",
    "openai/gpt-oss-20b:free",
    "meta-llama/llama-3.3-70b-instruct:free",
    "meta-llama/llama-3.2-3b-instruct:free",
    "mistralai/mistral-small-3.1-24b-instruct:free",
]


class OpenRouterProvider(ProviderAdapter):
    id = "openrouter"
    name = "OpenRouter"
    provider_type = "cloud"
    supported_tasks = [
        TaskKind.TEXT,
        TaskKind.IMAGE_UNDERSTANDING,
    ]

    def __init__(self) -> None:
        self._client: AsyncOpenAI | None = None

    def _get_client(self) -> AsyncOpenAI | None:
        if settings.openrouter_api_key:
            return AsyncOpenAI(
                api_key=settings.openrouter_api_key,
                base_url=_OPENROUTER_BASE_URL,
            )
        return None

    @property
    def client(self) -> AsyncOpenAI | None:
        if self._client is None:
            self._client = self._get_client()
        elif (
            settings.openrouter_api_key
            and self._client.api_key != settings.openrouter_api_key
        ):
            self._client = self._get_client()
        return self._client

    async def invoke(self, invocation: ProviderInvocation) -> ProviderResult:
        client = self.client
        if not client:
            return ProviderResult(
                provider_id=self.id,
                model=invocation.model,
                task_kind=invocation.task_kind,
                error="OpenRouter API key not configured",
            )

        start = time.perf_counter()
        try:
            if invocation.task_kind == TaskKind.TEXT:
                return await self._text(invocation, start)
            elif invocation.task_kind == TaskKind.IMAGE_UNDERSTANDING:
                return await self._image_understanding(invocation, start)
            else:
                return ProviderResult(
                    provider_id=self.id,
                    model=invocation.model,
                    task_kind=invocation.task_kind,
                    error=f"Unsupported task: {invocation.task_kind}",
                )
        except Exception as exc:
            return ProviderResult(
                provider_id=self.id,
                model=invocation.model,
                task_kind=invocation.task_kind,
                latency_ms=(time.perf_counter() - start) * 1000,
                error=str(exc),
            )

    @staticmethod
    def _build_chat_kwargs(inv: ProviderInvocation) -> dict:
        kwargs: dict = {}
        temp = (
            inv.temperature
            if inv.temperature is not None
            else inv.config.get("temperature")
        )
        mtok = (
            inv.max_tokens
            if inv.max_tokens is not None
            else inv.config.get("max_tokens")
        )
        if temp is not None:
            kwargs["temperature"] = temp
        if mtok is not None:
            kwargs["max_tokens"] = mtok
        return kwargs

    @staticmethod
    def _build_messages(inv: ProviderInvocation) -> list:
        msgs = []
        sys_p = inv.system_prompt or inv.config.get("system_prompt")
        if sys_p:
            msgs.append({"role": "system", "content": sys_p})
        return msgs

    async def _text(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        client = self.client
        msgs = self._build_messages(inv)
        msgs.append({"role": "user", "content": inv.prompt})
        resp = await client.chat.completions.create(
            model=inv.model,
            messages=msgs,
            **self._build_chat_kwargs(inv),
        )
        usage = resp.usage
        it = usage.prompt_tokens if usage else 0
        ot = usage.completion_tokens if usage else 0
        return ProviderResult(
            provider_id=self.id,
            model=inv.model,
            task_kind=inv.task_kind,
            text_output=resp.choices[0].message.content or "",
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it,
            output_tokens=ot,
            cost_usd=0.0,
            raw_response=resp.model_dump(),
        )

    async def _image_understanding(
        self, inv: ProviderInvocation, start: float
    ) -> ProviderResult:
        import base64

        client = self.client

        assert inv.media_bytes and inv.media_type
        b64 = base64.b64encode(inv.media_bytes).decode()
        data_uri = f"data:{inv.media_type};base64,{b64}"

        msgs = self._build_messages(inv)
        msgs.append(
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": inv.prompt},
                    {"type": "image_url", "image_url": {"url": data_uri}},
                ],
            }
        )

        resp = await client.chat.completions.create(
            model=inv.model,
            messages=msgs,
            **self._build_chat_kwargs(inv),
        )
        usage = resp.usage
        it = usage.prompt_tokens if usage else 0
        ot = usage.completion_tokens if usage else 0
        return ProviderResult(
            provider_id=self.id,
            model=inv.model,
            task_kind=inv.task_kind,
            text_output=resp.choices[0].message.content or "",
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it,
            output_tokens=ot,
            cost_usd=0.0,
            raw_response=resp.model_dump(),
        )

    async def health_check(self) -> HealthStatus:
        client = self.client
        if not client:
            return HealthStatus(available=True, models=_FREE_MODELS)
        try:
            start = time.perf_counter()
            models_resp = await client.models.list()
            model_ids = [m.id for m in models_resp.data][:10]
            for free_model in _FREE_MODELS:
                if free_model not in model_ids:
                    model_ids.append(free_model)
            return HealthStatus(
                available=True,
                latency_ms=(time.perf_counter() - start) * 1000,
                models=model_ids,
            )
        except Exception as exc:
            return HealthStatus(
                available=True,
                latency_ms=0,
                models=_FREE_MODELS,
            )
