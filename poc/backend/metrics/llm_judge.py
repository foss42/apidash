"""LLM-as-judge metric — uses a vision LLM to score generated images and TTS quality."""

from __future__ import annotations

from metrics.base import Metric, MetricContext, MetricResult
from providers.base import ProviderInvocation, TaskKind


_IMAGE_JUDGE_PROMPT = """You are an image quality judge. Given a text prompt and a generated image,
score how well the image matches the prompt on a scale of 0.0 to 1.0.

Criteria:
- Prompt adherence: Does the image depict what was requested?
- Quality: Is the image clear and well-composed?
- Accuracy: Are details correct?

Prompt: {prompt}

Respond with ONLY a JSON object: {{"score": 0.X, "explanation": "brief reason"}}"""

_AUDIO_JUDGE_PROMPT = """You are a text-to-speech quality judge. Given the original text and an audio
transcription of the generated speech, score the quality on a scale of 0.0 to 1.0.

Criteria:
- Accuracy: Does the speech match the original text?
- Completeness: Are any words missing or added?

Original text: {original}
Transcription of generated speech: {transcription}

Respond with ONLY a JSON object: {{"score": 0.X, "explanation": "brief reason"}}"""


class LLMJudgeMetric(Metric):
    id = "llm_judge"
    name = "LLM-as-Judge"
    applicable_tasks = [TaskKind.IMAGE_GENERATION, TaskKind.AUDIO_TTS]
    higher_is_better = True

    async def evaluate(self, context: MetricContext) -> MetricResult:
        if not context.judge_provider:
            return MetricResult(
                metric_id=self.id, score=0.0,
                explanation="No judge provider configured",
            )

        try:
            if context.task_kind == TaskKind.IMAGE_GENERATION:
                return await self._judge_image(context)
            elif context.task_kind == TaskKind.AUDIO_TTS:
                return await self._judge_audio(context)
            else:
                return MetricResult(
                    metric_id=self.id, score=0.0,
                    explanation=f"LLM judge not applicable to {context.task_kind}",
                )
        except Exception as exc:
            return MetricResult(
                metric_id=self.id, score=0.0,
                explanation=f"Judge error: {exc}",
            )

    async def _judge_image(self, context: MetricContext) -> MetricResult:
        """Use vision LLM to judge generated image quality."""
        assert context.judge_provider
        assert context.provider_result.media_output

        prompt = _IMAGE_JUDGE_PROMPT.format(prompt=context.prompt)
        invocation = ProviderInvocation(
            task_kind=TaskKind.IMAGE_UNDERSTANDING,
            model="gpt-4o-mini",
            prompt=prompt,
            media_bytes=context.provider_result.media_output,
            media_type=context.provider_result.media_type or "image/png",
        )
        result = await context.judge_provider.invoke(invocation)

        if not result.success or not result.text_output:
            return MetricResult(
                metric_id=self.id, score=0.0,
                explanation=f"Judge failed: {result.error}",
            )

        return self._parse_judge_response(result.text_output)

    async def _judge_audio(self, context: MetricContext) -> MetricResult:
        """Use LLM to judge TTS output quality by comparing transcription."""
        assert context.judge_provider

        # For TTS, we compare the original text with a transcription
        transcription = context.provider_result.text_output or ""
        prompt = _AUDIO_JUDGE_PROMPT.format(
            original=context.prompt,
            transcription=transcription,
        )
        invocation = ProviderInvocation(
            task_kind=TaskKind.TEXT,
            model="gpt-4o-mini",
            prompt=prompt,
        )
        result = await context.judge_provider.invoke(invocation)

        if not result.success or not result.text_output:
            return MetricResult(
                metric_id=self.id, score=0.0,
                explanation=f"Judge failed: {result.error}",
            )

        return self._parse_judge_response(result.text_output)

    def _parse_judge_response(self, response: str) -> MetricResult:
        """Parse the JSON score from the judge's response."""
        import json
        try:
            # Try to extract JSON from the response
            text = response.strip()
            if text.startswith("```"):
                text = text.split("```")[1]
                if text.startswith("json"):
                    text = text[4:]
            data = json.loads(text)
            score = float(data.get("score", 0.0))
            explanation = data.get("explanation", "")
            return MetricResult(
                metric_id=self.id,
                score=max(0.0, min(1.0, score)),
                raw_value=score,
                explanation=explanation,
            )
        except (json.JSONDecodeError, ValueError, KeyError):
            return MetricResult(
                metric_id=self.id, score=0.5,
                explanation=f"Could not parse judge response: {response[:100]}",
            )
