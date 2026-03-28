"""Video understanding evaluator — frame extraction + vision API analysis."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from evaluators.base import Evaluator, EvaluationContext, EvaluationItemResult
from metrics.base import Metric, MetricContext, MetricResult
from providers.base import ProviderAdapter, ProviderInvocation, ProviderResult, TaskKind


def extract_frames(video_path: str, max_frames: int = 5) -> list[tuple[bytes, int]]:
    """Extract frames from a video file at fixed intervals.

    Returns list of (frame_bytes_png, frame_index).
    """
    import cv2
    import numpy as np

    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        raise ValueError(f"Cannot open video: {video_path}")

    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    if total_frames <= 0:
        cap.release()
        raise ValueError(f"Video has no frames: {video_path}")

    # Calculate frame indices at fixed intervals
    interval = max(1, total_frames // max_frames)
    target_indices = [i * interval for i in range(max_frames) if i * interval < total_frames]

    frames: list[tuple[bytes, int]] = []
    for idx in target_indices:
        cap.set(cv2.CAP_PROP_POS_FRAMES, idx)
        ret, frame = cap.read()
        if ret:
            _, buf = cv2.imencode(".png", frame)
            frames.append((buf.tobytes(), idx))

    cap.release()
    return frames


class VideoUnderstandingEvaluator(Evaluator):
    task_kind = TaskKind.VIDEO_UNDERSTANDING

    def __init__(self, metrics: list[Metric] | None = None, max_frames: int = 5) -> None:
        self.metrics = metrics or []
        self.max_frames = max_frames

    async def evaluate_item(
        self,
        context: EvaluationContext,
        provider: ProviderAdapter,
        model: str,
        config: dict[str, Any],
    ) -> EvaluationItemResult:
        # Extract frames from video
        video_path = context.media_path
        if not video_path or not Path(video_path).exists():
            return EvaluationItemResult(
                item_index=context.item_index,
                provider_id=provider.id,
                model=model,
                provider_result=ProviderResult(
                    provider_id=provider.id, model=model,
                    task_kind=TaskKind.VIDEO_UNDERSTANDING,
                    error=f"Video file not found: {video_path}",
                ),
            )

        try:
            frames = extract_frames(video_path, self.max_frames)
        except Exception as exc:
            return EvaluationItemResult(
                item_index=context.item_index,
                provider_id=provider.id,
                model=model,
                provider_result=ProviderResult(
                    provider_id=provider.id, model=model,
                    task_kind=TaskKind.VIDEO_UNDERSTANDING,
                    error=f"Frame extraction failed: {exc}",
                ),
            )

        # Send each frame to the vision provider
        frame_responses: list[str] = []
        total_latency = 0.0
        total_cost = 0.0
        total_input_tokens = 0
        total_output_tokens = 0

        for frame_bytes, frame_idx in frames:
            invocation = ProviderInvocation(
                task_kind=TaskKind.IMAGE_UNDERSTANDING,
                model=model,
                prompt=f"{context.prompt} (Frame {frame_idx})",
                media_bytes=frame_bytes,
                media_type="image/png",
                config=config,
            )
            result = await provider.invoke(invocation)
            if result.success and result.text_output:
                frame_responses.append(result.text_output)
            else:
                frame_responses.append(f"[Error: {result.error}]")
            total_latency += result.latency_ms
            total_cost += result.cost_usd
            total_input_tokens += result.input_tokens
            total_output_tokens += result.output_tokens

        # Combine frame responses into a unified video description
        combined = "\n".join(
            f"Frame {i}: {resp}" for i, resp in enumerate(frame_responses)
        )

        # Build aggregate result
        video_result = ProviderResult(
            provider_id=provider.id,
            model=model,
            task_kind=TaskKind.VIDEO_UNDERSTANDING,
            text_output=combined,
            latency_ms=total_latency,
            input_tokens=total_input_tokens,
            output_tokens=total_output_tokens,
            cost_usd=total_cost,
            raw_response={"frame_count": len(frames), "frame_responses": frame_responses},
        )

        # Score with metrics
        metric_results = []
        for metric in self.metrics:
            if TaskKind.VIDEO_UNDERSTANDING in metric.applicable_tasks:
                mc = MetricContext(
                    prompt=context.prompt,
                    expected_text=context.expected_text,
                    provider_result=video_result,
                    task_kind=TaskKind.VIDEO_UNDERSTANDING,
                )
                mr = await metric.evaluate(mc)
                metric_results.append(mr)

        # Add temporal consistency score
        if len(frame_responses) > 1:
            consistency = self._compute_temporal_consistency(frame_responses)
            metric_results.append(MetricResult(
                metric_id="temporal_consistency",
                score=consistency,
                explanation=f"Consistency across {len(frame_responses)} frames",
            ))

        return EvaluationItemResult(
            item_index=context.item_index,
            provider_id=provider.id,
            model=model,
            provider_result=video_result,
            metric_results=metric_results,
        )

    def _compute_temporal_consistency(self, responses: list[str]) -> float:
        """Simple temporal consistency: measure overlap of keywords across frames."""
        if len(responses) < 2:
            return 1.0

        word_sets = [set(r.lower().split()) for r in responses if not r.startswith("[Error")]
        if len(word_sets) < 2:
            return 0.0

        # Compute pairwise Jaccard similarity
        similarities = []
        for i in range(len(word_sets) - 1):
            intersection = word_sets[i] & word_sets[i + 1]
            union = word_sets[i] | word_sets[i + 1]
            if union:
                similarities.append(len(intersection) / len(union))

        return sum(similarities) / len(similarities) if similarities else 0.0
