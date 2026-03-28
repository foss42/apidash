"""Image understanding evaluator — send image+prompt to vision providers, score responses."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from evaluators.base import Evaluator, EvaluationContext, EvaluationItemResult
from metrics.base import Metric, MetricContext
from providers.base import ProviderAdapter, ProviderInvocation, TaskKind


class ImageUnderstandingEvaluator(Evaluator):
    task_kind = TaskKind.IMAGE_UNDERSTANDING

    def __init__(self, metrics: list[Metric] | None = None) -> None:
        self.metrics = metrics or []

    async def evaluate_item(
        self,
        context: EvaluationContext,
        provider: ProviderAdapter,
        model: str,
        config: dict[str, Any],
    ) -> EvaluationItemResult:
        # Load image bytes if not provided
        media_bytes = context.media_bytes
        media_type = context.media_type
        if not media_bytes and context.media_path:
            p = Path(context.media_path)
            if p.exists():
                media_bytes = p.read_bytes()
                # Detect MIME from extension
                ext = p.suffix.lower()
                media_type = media_type or {
                    ".png": "image/png", ".jpg": "image/jpeg",
                    ".jpeg": "image/jpeg", ".gif": "image/gif",
                    ".webp": "image/webp",
                }.get(ext, "image/png")

        # Build invocation
        invocation = ProviderInvocation(
            task_kind=TaskKind.IMAGE_UNDERSTANDING,
            model=model,
            prompt=context.prompt,
            media_bytes=media_bytes,
            media_type=media_type,
            config=config,
        )

        # Call provider
        result = await provider.invoke(invocation)

        # Score with metrics
        metric_results = []
        if result.success:
            for metric in self.metrics:
                if TaskKind.IMAGE_UNDERSTANDING in metric.applicable_tasks:
                    mc = MetricContext(
                        prompt=context.prompt,
                        expected_text=context.expected_text,
                        provider_result=result,
                        task_kind=TaskKind.IMAGE_UNDERSTANDING,
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
