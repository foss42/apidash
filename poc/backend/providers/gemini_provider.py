"""Gemini provider adapter — vision, text, and audio using google-genai SDK."""

from __future__ import annotations

import time
from typing import Any

from config import settings
from providers.base import (
    HealthStatus,
    ProviderAdapter,
    ProviderInvocation,
    ProviderResult,
    TaskKind,
)

# Params that Gemini rejects
_UNSUPPORTED_PARAMS = {"seed", "frequency_penalty", "presence_penalty", "logprobs", "top_logprobs"}

# Param renaming for Gemini
_PARAM_MAP = {"max_tokens": "max_output_tokens"}


def _sanitize_config(config: dict[str, Any]) -> dict[str, Any]:
    result = {}
    for k, v in config.items():
        if k in _UNSUPPORTED_PARAMS or k in ("system_prompt",):
            continue
        key = _PARAM_MAP.get(k, k)
        result[key] = v
    return result


def _build_gemini_config(inv: "ProviderInvocation", base_config: dict[str, Any]) -> dict[str, Any]:
    """Merge explicit request params into the Gemini config dict."""
    cfg = dict(base_config)
    temp = inv.temperature if inv.temperature is not None else None
    mtok = inv.max_tokens if inv.max_tokens is not None else None
    if temp is not None:
        cfg["temperature"] = temp
    if mtok is not None:
        cfg["max_output_tokens"] = mtok
    return cfg


class GeminiProvider(ProviderAdapter):
    id = "gemini"
    name = "Google Gemini"
    provider_type = "cloud"
    supported_tasks = [
        TaskKind.IMAGE_UNDERSTANDING,
        TaskKind.TEXT,
        TaskKind.AUDIO_STT,
    ]

    def __init__(self) -> None:
        self._client = None
        if settings.gemini_api_key:
            try:
                from google import genai
                self._genai = genai
                self._types = genai.types
                self._client = genai.Client(api_key=settings.gemini_api_key)
            except ImportError:
                pass

    async def invoke(self, invocation: ProviderInvocation) -> ProviderResult:
        if not self._client:
            return ProviderResult(
                provider_id=self.id, model=invocation.model,
                task_kind=invocation.task_kind,
                error="Gemini API key not configured or google-genai not installed",
            )

        start = time.perf_counter()
        try:
            config = _build_gemini_config(invocation, _sanitize_config(invocation.config))
            sys_p = invocation.system_prompt or invocation.config.get("system_prompt")
            if sys_p:
                config["system_instruction"] = sys_p

            if invocation.task_kind == TaskKind.IMAGE_UNDERSTANDING:
                return await self._image_understanding(invocation, config, start)
            elif invocation.task_kind == TaskKind.TEXT:
                return await self._text(invocation, config, start)
            elif invocation.task_kind == TaskKind.AUDIO_STT:
                return await self._audio_stt(invocation, config, start)
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

    async def _image_understanding(self, inv: ProviderInvocation, config: dict, start: float) -> ProviderResult:
        assert inv.media_bytes and inv.media_type
        image_part = self._types.Part.from_bytes(
            data=inv.media_bytes,
            mime_type=inv.media_type,
        )
        gen_config = self._types.GenerateContentConfig(**config) if config else None
        resp = await self._client.aio.models.generate_content(
            model=inv.model,
            contents=[inv.prompt, image_part],
            config=gen_config,
        )
        text = resp.text or ""
        usage = getattr(resp, "usage_metadata", None)
        it = getattr(usage, "prompt_token_count", 0) if usage else 0
        ot = getattr(usage, "candidates_token_count", 0) if usage else 0
        return ProviderResult(
            provider_id=self.id, model=inv.model,
            task_kind=inv.task_kind,
            text_output=text,
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it, output_tokens=ot,
            cost_usd=0.0,
        )

    async def _text(self, inv: ProviderInvocation, config: dict, start: float) -> ProviderResult:
        gen_config = self._types.GenerateContentConfig(**config) if config else None
        resp = await self._client.aio.models.generate_content(
            model=inv.model,
            contents=[inv.prompt],
            config=gen_config,
        )
        text = resp.text or ""
        usage = getattr(resp, "usage_metadata", None)
        it = getattr(usage, "prompt_token_count", 0) if usage else 0
        ot = getattr(usage, "candidates_token_count", 0) if usage else 0
        return ProviderResult(
            provider_id=self.id, model=inv.model,
            task_kind=inv.task_kind,
            text_output=text,
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it, output_tokens=ot,
            cost_usd=0.0,
        )

    async def _audio_stt(self, inv: ProviderInvocation, config: dict, start: float) -> ProviderResult:
        assert inv.media_bytes and inv.media_type
        audio_part = self._types.Part.from_bytes(
            data=inv.media_bytes,
            mime_type=inv.media_type,
        )
        gen_config = self._types.GenerateContentConfig(**config) if config else None
        resp = await self._client.aio.models.generate_content(
            model=inv.model,
            contents=["Transcribe this audio exactly, no commentary:", audio_part],
            config=gen_config,
        )
        text = resp.text or ""
        return ProviderResult(
            provider_id=self.id, model=inv.model,
            task_kind=inv.task_kind,
            text_output=text,
            latency_ms=(time.perf_counter() - start) * 1000,
            cost_usd=0.0,
        )

    async def health_check(self) -> HealthStatus:
        if not self._client:
            return HealthStatus(available=False, error="API key not configured")
        try:
            start = time.perf_counter()
            resp = await self._client.aio.models.generate_content(
                model="gemini-2.0-flash",
                contents=["hi"],
                config=self._types.GenerateContentConfig(max_output_tokens=1),
            )
            _ = resp.text
            return HealthStatus(
                available=True,
                latency_ms=(time.perf_counter() - start) * 1000,
                models=["gemini-2.0-flash", "gemini-1.5-flash", "gemini-1.5-pro"],
            )
        except Exception as exc:
            return HealthStatus(available=False, error=str(exc))
