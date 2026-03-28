"""Local Whisper provider using faster-whisper for offline STT."""

from __future__ import annotations

import time
from typing import Any

from providers.base import (
    HealthStatus,
    ProviderAdapter,
    ProviderInvocation,
    ProviderResult,
    TaskKind,
)

# Default models available in faster-whisper
WHISPER_MODELS = ["tiny", "base", "small", "medium", "large-v2", "large-v3"]


class WhisperProvider(ProviderAdapter):
    id = "whisper"
    name = "Whisper (Local)"
    provider_type = "local"
    supported_tasks = [TaskKind.AUDIO_STT]

    def __init__(self) -> None:
        self._models: dict[str, Any] = {}  # Cache loaded models

    def _load_model(self, model_name: str) -> Any:
        if model_name not in self._models:
            from faster_whisper import WhisperModel
            self._models[model_name] = WhisperModel(model_name, device="cpu", compute_type="int8")
        return self._models[model_name]

    async def invoke(self, invocation: ProviderInvocation) -> ProviderResult:
        start = time.perf_counter()
        try:
            if invocation.task_kind != TaskKind.AUDIO_STT:
                return ProviderResult(
                    provider_id=self.id, model=invocation.model,
                    task_kind=invocation.task_kind,
                    error=f"Unsupported task: {invocation.task_kind}",
                )
            if not invocation.media_bytes:
                return ProviderResult(
                    provider_id=self.id, model=invocation.model,
                    task_kind=invocation.task_kind,
                    error="No audio data provided",
                )

            import asyncio
            import io
            import tempfile
            import os

            model = self._load_model(invocation.model)

            # Write bytes to a temp file (faster-whisper needs a file path)
            suffix = ".wav"
            if invocation.media_type == "audio/mpeg":
                suffix = ".mp3"
            elif invocation.media_type == "audio/flac":
                suffix = ".flac"

            def _transcribe() -> str:
                with tempfile.NamedTemporaryFile(suffix=suffix, delete=False) as tmp:
                    tmp.write(invocation.media_bytes)
                    tmp_path = tmp.name
                try:
                    segments, _ = model.transcribe(tmp_path, beam_size=5)
                    return " ".join(s.text.strip() for s in segments).strip()
                finally:
                    os.unlink(tmp_path)

            # Run in thread pool to avoid blocking the event loop
            loop = asyncio.get_event_loop()
            transcript = await loop.run_in_executor(None, _transcribe)

            return ProviderResult(
                provider_id=self.id,
                model=invocation.model,
                task_kind=invocation.task_kind,
                text_output=transcript,
                latency_ms=(time.perf_counter() - start) * 1000,
                cost_usd=0.0,
            )

        except Exception as exc:
            return ProviderResult(
                provider_id=self.id, model=invocation.model,
                task_kind=invocation.task_kind,
                latency_ms=(time.perf_counter() - start) * 1000,
                error=str(exc),
            )

    async def health_check(self) -> HealthStatus:
        try:
            import faster_whisper  # noqa: F401
            return HealthStatus(available=True, models=WHISPER_MODELS)
        except ImportError:
            return HealthStatus(available=False, error="faster-whisper not installed")
