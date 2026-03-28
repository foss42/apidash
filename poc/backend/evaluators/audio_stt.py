"""Audio STT evaluator — send audio to transcription providers, score with WER/CER."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from evaluators.base import Evaluator, EvaluationContext, EvaluationItemResult
from metrics.base import Metric, MetricContext
from providers.base import ProviderAdapter, ProviderInvocation, TaskKind


class AudioSTTEvaluator(Evaluator):
    task_kind = TaskKind.AUDIO_STT

    def __init__(self, metrics: list[Metric] | None = None) -> None:
        self.metrics = metrics or []

    async def evaluate_item(
        self,
        context: EvaluationContext,
        provider: ProviderAdapter,
        model: str,
        config: dict[str, Any],
    ) -> EvaluationItemResult:
        # Load audio bytes
        media_bytes = context.media_bytes
        media_type = context.media_type
        if not media_bytes and context.media_path:
            p = Path(context.media_path)
            if p.exists():
                media_bytes = p.read_bytes()
                ext = p.suffix.lower()
                media_type = media_type or {
                    ".wav": "audio/wav", ".mp3": "audio/mpeg",
                    ".flac": "audio/flac", ".ogg": "audio/ogg",
                }.get(ext, "audio/wav")

        invocation = ProviderInvocation(
            task_kind=TaskKind.AUDIO_STT,
            model=model,
            prompt=context.prompt,
            media_bytes=media_bytes,
            media_type=media_type,
            config=config,
        )

        result = await provider.invoke(invocation)

        metric_results = []
        if result.success:
            for metric in self.metrics:
                if TaskKind.AUDIO_STT in metric.applicable_tasks:
                    mc = MetricContext(
                        prompt=context.prompt,
                        expected_text=context.expected_text,
                        provider_result=result,
                        task_kind=TaskKind.AUDIO_STT,
                    )
                    mr = await metric.evaluate(mc)
                    metric_results.append(mr)

        return EvaluationItemResult(
            item_index=context.item_index,
            provider_id=provider.id,
            model=model,
            provider_result=result,
            metric_results=metric_results,
        )
