"""Audio TTS evaluator — text → audio, quality assessment via LLM-judge."""

from __future__ import annotations

from typing import Any

from evaluators.base import Evaluator, EvaluationContext, EvaluationItemResult
from metrics.base import Metric, MetricContext
from providers.base import ProviderAdapter, ProviderInvocation, TaskKind
from storage.artifacts import save_artifact


class AudioTTSEvaluator(Evaluator):
    task_kind = TaskKind.AUDIO_TTS

    def __init__(
        self,
        metrics: list[Metric] | None = None,
        judge_provider: ProviderAdapter | None = None,
    ) -> None:
        self.metrics = metrics or []
        self.judge_provider = judge_provider

    async def evaluate_item(
        self,
        context: EvaluationContext,
        provider: ProviderAdapter,
        model: str,
        config: dict[str, Any],
    ) -> EvaluationItemResult:
        invocation = ProviderInvocation(
            task_kind=TaskKind.AUDIO_TTS,
            model=model,
            prompt=context.prompt,
            config=config,
        )

        result = await provider.invoke(invocation)

        # Save generated audio to disk
        if result.success and result.media_output:
            ext = ".mp3" if result.media_type == "audio/mp3" else ".wav"
            save_artifact(result.media_output, extension=ext, subdirectory="tts_output")

        metric_results = []
        if result.success:
            for metric in self.metrics:
                if TaskKind.AUDIO_TTS in metric.applicable_tasks:
                    mc = MetricContext(
                        prompt=context.prompt,
                        expected_text=context.expected_text,
                        provider_result=result,
                        task_kind=TaskKind.AUDIO_TTS,
                        judge_provider=self.judge_provider,
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
