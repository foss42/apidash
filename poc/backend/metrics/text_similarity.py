"""Text similarity metrics: exact_match, contains_match, BLEU."""

from __future__ import annotations

from metrics.base import Metric, MetricContext, MetricResult
from providers.base import TaskKind


class ExactMatchMetric(Metric):
    id = "exact_match"
    name = "Exact Match"
    applicable_tasks = [
        TaskKind.IMAGE_UNDERSTANDING, TaskKind.AUDIO_STT,
        TaskKind.VIDEO_UNDERSTANDING, TaskKind.TEXT,
    ]
    higher_is_better = True

    async def evaluate(self, context: MetricContext) -> MetricResult:
        if not context.expected_text or not context.provider_result.text_output:
            return MetricResult(metric_id=self.id, score=0.0, explanation="Missing expected or actual text")

        expected = context.expected_text.strip().lower()
        actual = context.provider_result.text_output.strip().lower()
        match = 1.0 if expected == actual else 0.0
        return MetricResult(metric_id=self.id, score=match, raw_value=match)


class ContainsMatchMetric(Metric):
    id = "contains_match"
    name = "Contains Match"
    applicable_tasks = [
        TaskKind.IMAGE_UNDERSTANDING, TaskKind.AUDIO_STT,
        TaskKind.VIDEO_UNDERSTANDING, TaskKind.TEXT,
    ]
    higher_is_better = True

    async def evaluate(self, context: MetricContext) -> MetricResult:
        if not context.expected_text or not context.provider_result.text_output:
            return MetricResult(metric_id=self.id, score=0.0, explanation="Missing expected or actual text")

        expected_words = set(context.expected_text.strip().lower().split())
        actual = context.provider_result.text_output.strip().lower()

        if not expected_words:
            return MetricResult(metric_id=self.id, score=0.0)

        matched = sum(1 for w in expected_words if w in actual)
        score = matched / len(expected_words)
        return MetricResult(
            metric_id=self.id, score=score, raw_value=score,
            details={"matched": matched, "total": len(expected_words)},
        )


class BLEUMetric(Metric):
    id = "bleu"
    name = "BLEU Score"
    applicable_tasks = [
        TaskKind.IMAGE_UNDERSTANDING, TaskKind.AUDIO_STT,
        TaskKind.VIDEO_UNDERSTANDING, TaskKind.TEXT,
    ]
    higher_is_better = True

    async def evaluate(self, context: MetricContext) -> MetricResult:
        if not context.expected_text or not context.provider_result.text_output:
            return MetricResult(metric_id=self.id, score=0.0, explanation="Missing expected or actual text")

        try:
            from nltk.translate.bleu_score import sentence_bleu, SmoothingFunction
            reference = context.expected_text.strip().lower().split()
            hypothesis = context.provider_result.text_output.strip().lower().split()
            smoothie = SmoothingFunction().method1
            score = sentence_bleu([reference], hypothesis, smoothing_function=smoothie)
            return MetricResult(metric_id=self.id, score=score, raw_value=score)
        except ImportError:
            return MetricResult(metric_id=self.id, score=0.0, explanation="nltk not installed")
