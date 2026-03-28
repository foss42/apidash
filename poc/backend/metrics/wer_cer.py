"""WER and CER metrics via jiwer."""

from __future__ import annotations

from metrics.base import Metric, MetricContext, MetricResult
from providers.base import TaskKind


class WERMetric(Metric):
    id = "wer"
    name = "Word Error Rate"
    applicable_tasks = [TaskKind.AUDIO_STT]
    higher_is_better = False  # Lower WER is better

    async def evaluate(self, context: MetricContext) -> MetricResult:
        if not context.expected_text or not context.provider_result.text_output:
            return MetricResult(metric_id=self.id, score=0.0, explanation="Missing reference or hypothesis")

        try:
            from jiwer import wer, process_words

            reference = context.expected_text.strip()
            hypothesis = context.provider_result.text_output.strip()

            error_rate = wer(reference, hypothesis)
            # Invert for normalized score (1.0 = perfect, 0.0 = terrible)
            score = max(0.0, 1.0 - error_rate)

            # Get detailed breakdown
            output = process_words(reference, hypothesis)
            details = {
                "wer": round(error_rate, 4),
                "substitutions": output.substitutions,
                "deletions": output.deletions,
                "insertions": output.insertions,
                "hits": output.hits,
            }

            return MetricResult(
                metric_id=self.id,
                score=round(score, 4),
                raw_value=round(error_rate, 4),
                details=details,
            )
        except ImportError:
            return MetricResult(metric_id=self.id, score=0.0, explanation="jiwer not installed")


class CERMetric(Metric):
    id = "cer"
    name = "Character Error Rate"
    applicable_tasks = [TaskKind.AUDIO_STT]
    higher_is_better = False

    async def evaluate(self, context: MetricContext) -> MetricResult:
        if not context.expected_text or not context.provider_result.text_output:
            return MetricResult(metric_id=self.id, score=0.0, explanation="Missing reference or hypothesis")

        try:
            from jiwer import cer

            reference = context.expected_text.strip()
            hypothesis = context.provider_result.text_output.strip()

            error_rate = cer(reference, hypothesis)
            score = max(0.0, 1.0 - error_rate)

            return MetricResult(
                metric_id=self.id,
                score=round(score, 4),
                raw_value=round(error_rate, 4),
                details={"cer": round(error_rate, 4)},
            )
        except ImportError:
            return MetricResult(metric_id=self.id, score=0.0, explanation="jiwer not installed")
