"""Image generation evaluator — text → image, LLM-as-judge scoring."""

from __future__ import annotations

from typing import Any

from evaluators.base import Evaluator, EvaluationContext, EvaluationItemResult
from metrics.base import Metric, MetricContext
from providers.base import ProviderAdapter, ProviderInvocation, TaskKind


class ImageGenerationEvaluator(Evaluator):
    task_kind = TaskKind.IMAGE_GENERATION

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
            task_kind=TaskKind.IMAGE_GENERATION,
            model=model,
            prompt=context.prompt,
            config=config,
        )

        result = await provider.invoke(invocation)

        metric_results = []
        if result.success:
            for metric in self.metrics:
                if TaskKind.IMAGE_GENERATION in metric.applicable_tasks:
                    mc = MetricContext(
                        prompt=context.prompt,
                        expected_text=context.expected_text,
                        provider_result=result,
                        task_kind=TaskKind.IMAGE_GENERATION,
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
