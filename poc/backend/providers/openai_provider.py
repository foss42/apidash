"""OpenAI provider adapter — vision, DALL-E, Whisper, TTS."""

from __future__ import annotations

import base64
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

# Pricing per 1K tokens (USD) — approximate, updated 2026-03
_PRICING = {
    "gpt-4o": {"input": 0.0025, "output": 0.01},
    "gpt-4o-mini": {"input": 0.00015, "output": 0.0006},
    "gpt-4.1-nano": {"input": 0.0001, "output": 0.0004},
}


def _estimate_cost(model: str, input_tokens: int, output_tokens: int) -> float:
    rates = _PRICING.get(model, {"input": 0.0025, "output": 0.01})
    return (input_tokens * rates["input"] + output_tokens * rates["output"]) / 1000


class OpenAIProvider(ProviderAdapter):
    id = "openai"
    name = "OpenAI"
    provider_type = "cloud"
    supported_tasks = [
        TaskKind.IMAGE_UNDERSTANDING,
        TaskKind.IMAGE_GENERATION,
        TaskKind.AUDIO_STT,
        TaskKind.AUDIO_TTS,
        TaskKind.TEXT,
    ]

    def __init__(self) -> None:
        self._client = AsyncOpenAI(api_key=settings.openai_api_key) if settings.openai_api_key else None

    async def invoke(self, invocation: ProviderInvocation) -> ProviderResult:
        if not self._client:
            return ProviderResult(
                provider_id=self.id, model=invocation.model,
                task_kind=invocation.task_kind, error="OpenAI API key not configured",
            )

        start = time.perf_counter()
        try:
            if invocation.task_kind == TaskKind.IMAGE_UNDERSTANDING:
                return await self._image_understanding(invocation, start)
            elif invocation.task_kind == TaskKind.TEXT:
                return await self._text(invocation, start)
            elif invocation.task_kind == TaskKind.IMAGE_GENERATION:
                return await self._image_generation(invocation, start)
            elif invocation.task_kind == TaskKind.AUDIO_STT:
                return await self._audio_stt(invocation, start)
            elif invocation.task_kind == TaskKind.AUDIO_TTS:
                return await self._audio_tts(invocation, start)
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
    def _build_chat_kwargs(inv: ProviderInvocation) -> dict:
        """Build extra kwargs for chat.completions.create from request params."""
        kwargs: dict = {}
        temp = inv.temperature if inv.temperature is not None else inv.config.get("temperature")
        mtok = inv.max_tokens if inv.max_tokens is not None else inv.config.get("max_tokens")
        if temp is not None:
            kwargs["temperature"] = temp
        if mtok is not None:
            kwargs["max_tokens"] = mtok
        return kwargs

    @staticmethod
    def _build_messages(inv: ProviderInvocation) -> list:
        """Build messages list, prepending system prompt if set."""
        msgs = []
        sys_p = inv.system_prompt or inv.config.get("system_prompt")
        if sys_p:
            msgs.append({"role": "system", "content": sys_p})
        return msgs

    async def _image_understanding(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        assert inv.media_bytes and inv.media_type
        b64 = base64.b64encode(inv.media_bytes).decode()
        data_uri = f"data:{inv.media_type};base64,{b64}"

        msgs = self._build_messages(inv)
        msgs.append({
            "role": "user",
            "content": [
                {"type": "text", "text": inv.prompt},
                {"type": "image_url", "image_url": {"url": data_uri}},
            ],
        })

        resp = await self._client.chat.completions.create(
            model=inv.model,
            messages=msgs,
            **self._build_chat_kwargs(inv),
        )
        usage = resp.usage
        it = usage.prompt_tokens if usage else 0
        ot = usage.completion_tokens if usage else 0
        return ProviderResult(
            provider_id=self.id, model=inv.model,
            task_kind=inv.task_kind,
            text_output=resp.choices[0].message.content or "",
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it, output_tokens=ot,
            cost_usd=_estimate_cost(inv.model, it, ot),
            raw_response=resp.model_dump(),
        )

    async def _text(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        msgs = self._build_messages(inv)
        msgs.append({"role": "user", "content": inv.prompt})
        resp = await self._client.chat.completions.create(
            model=inv.model,
            messages=msgs,
            **self._build_chat_kwargs(inv),
        )
        usage = resp.usage
        it = usage.prompt_tokens if usage else 0
        ot = usage.completion_tokens if usage else 0
        return ProviderResult(
            provider_id=self.id, model=inv.model,
            task_kind=inv.task_kind,
            text_output=resp.choices[0].message.content or "",
            latency_ms=(time.perf_counter() - start) * 1000,
            input_tokens=it, output_tokens=ot,
            cost_usd=_estimate_cost(inv.model, it, ot),
            raw_response=resp.model_dump(),
        )

    async def _image_generation(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        resp = await self._client.images.generate(
            model=inv.model or "dall-e-3",
            prompt=inv.prompt,
            n=1,
            size=inv.config.get("size", "1024x1024"),
            response_format="b64_json",
        )
        b64_data = resp.data[0].b64_json or ""
        media_bytes = base64.b64decode(b64_data)
        return ProviderResult(
            provider_id=self.id, model=inv.model or "dall-e-3",
            task_kind=inv.task_kind,
            media_output=media_bytes,
            media_type="image/png",
            latency_ms=(time.perf_counter() - start) * 1000,
            cost_usd=0.04,  # DALL-E 3 standard pricing
            raw_response={"revised_prompt": resp.data[0].revised_prompt},
        )

    async def _audio_stt(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        assert inv.media_bytes
        # Create a file-like object for the API
        import io
        ext = (inv.media_type or "audio/wav").split("/")[-1]
        audio_file = io.BytesIO(inv.media_bytes)
        audio_file.name = f"audio.{ext}"

        resp = await self._client.audio.transcriptions.create(
            model=inv.model or "whisper-1",
            file=audio_file,
            language=inv.config.get("language"),
        )
        return ProviderResult(
            provider_id=self.id, model=inv.model or "whisper-1",
            task_kind=inv.task_kind,
            text_output=resp.text,
            latency_ms=(time.perf_counter() - start) * 1000,
            cost_usd=0.006,  # ~$0.006/min, estimate 1 min
        )

    async def _audio_tts(self, inv: ProviderInvocation, start: float) -> ProviderResult:
        resp = await self._client.audio.speech.create(
            model=inv.model or "tts-1",
            voice=inv.config.get("voice", "alloy"),
            input=inv.prompt,
        )
        audio_bytes = resp.content
        return ProviderResult(
            provider_id=self.id, model=inv.model or "tts-1",
            task_kind=inv.task_kind,
            media_output=audio_bytes,
            media_type="audio/mp3",
            latency_ms=(time.perf_counter() - start) * 1000,
            cost_usd=0.015,  # ~$15/1M chars, estimate 1K chars
        )

    async def health_check(self) -> HealthStatus:
        if not self._client:
            return HealthStatus(available=False, error="API key not configured")
        try:
            start = time.perf_counter()
            await self._client.models.list()
            return HealthStatus(
                available=True,
                latency_ms=(time.perf_counter() - start) * 1000,
                models=["gpt-4o", "gpt-4o-mini", "dall-e-3", "whisper-1", "tts-1"],
            )
        except Exception as exc:
            return HealthStatus(available=False, error=str(exc))
