"""Basic text evaluator — exact_match, BLEU (minimal Tier 2)."""

from __future__ import annotations

from typing import Any

from evaluators.base import Evaluator, EvaluationContext, EvaluationItemResult
from metrics.base import Metric, MetricContext
from providers.base import ProviderAdapter, ProviderInvocation, TaskKind


class TextEvaluator(Evaluator):
    task_kind = TaskKind.TEXT

    def __init__(self, metrics: list[Metric] | None = None) -> None:
        self.metrics = metrics or []

    async def evaluate_item(
        self,
        context: EvaluationContext,
        provider: ProviderAdapter,
        model: str,
        config: dict[str, Any],
    ) -> EvaluationItemResult:
        invocation = ProviderInvocation(
            task_kind=TaskKind.TEXT,
            model=model,
            prompt=context.prompt,
            config=config,
        )

        result = await provider.invoke(invocation)

        metric_results = []
        if result.success:
            for metric in self.metrics:
                if TaskKind.TEXT in metric.applicable_tasks:
                    mc = MetricContext(
                        prompt=context.prompt,
                        expected_text=context.expected_text,
                        provider_result=result,
                        task_kind=TaskKind.TEXT,
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
