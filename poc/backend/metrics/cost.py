"""Cost tracking metric — aggregate tokens, compute USD, latency stats."""

from __future__ import annotations

from metrics.base import Metric, MetricContext, MetricResult
from providers.base import TaskKind


class CostMetric(Metric):
    id = "cost"
    name = "Cost (USD)"
    applicable_tasks = list(TaskKind)  # Applies to all task kinds
    higher_is_better = False  # Lower cost is better

    async def evaluate(self, context: MetricContext) -> MetricResult:
        pr = context.provider_result
        return MetricResult(
            metric_id=self.id,
            score=max(0.0, 1.0 - pr.cost_usd * 100),  # Normalize: $0.01 → 0.0 score
            raw_value=pr.cost_usd,
            details={
                "cost_usd": pr.cost_usd,
                "input_tokens": pr.input_tokens,
                "output_tokens": pr.output_tokens,
                "latency_ms": pr.latency_ms,
            },
        )


class LatencyMetric(Metric):
    id = "latency"
    name = "Latency (ms)"
    applicable_tasks = list(TaskKind)
    higher_is_better = False

    async def evaluate(self, context: MetricContext) -> MetricResult:
        pr = context.provider_result
        # Normalize: 0ms = 1.0, 10000ms = 0.0
        score = max(0.0, 1.0 - pr.latency_ms / 10000)
        return MetricResult(
            metric_id=self.id,
            score=round(score, 4),
            raw_value=pr.latency_ms,
            details={"latency_ms": pr.latency_ms},
        )
