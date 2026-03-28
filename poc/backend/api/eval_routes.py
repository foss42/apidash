"""Evaluation API routes — start eval, stream progress."""

from __future__ import annotations

import json
from typing import Any

from fastapi import APIRouter, HTTPException
from sse_starlette.sse import EventSourceResponse

from eval_datasets.loader import DatasetRow
from evaluators.image_understanding import ImageUnderstandingEvaluator
from evaluators.image_generation import ImageGenerationEvaluator
from evaluators.audio_stt import AudioSTTEvaluator
from evaluators.text_eval import TextEvaluator
from jobs import db
from jobs.executor import run_evaluation
from jobs.models import EvalRequest, EvalConfig
from metrics.text_similarity import ExactMatchMetric, ContainsMatchMetric, BLEUMetric
from metrics.llm_judge import LLMJudgeMetric
from metrics.wer_cer import WERMetric, CERMetric
from providers.base import TaskKind
from providers.registry import registry

router = APIRouter(tags=["evaluation"])


def _get_evaluator(modality: str):
    """Get the evaluator for a given modality."""
    text_metrics = [ExactMatchMetric(), ContainsMatchMetric(), BLEUMetric()]

    if modality == TaskKind.IMAGE_UNDERSTANDING:
        return ImageUnderstandingEvaluator(metrics=text_metrics)

    if modality == TaskKind.IMAGE_GENERATION:
        judge = registry.get("openai")
        if judge is None:
            raise HTTPException(status_code=400, detail="OpenAI provider required as LLM judge for image generation eval")
        return ImageGenerationEvaluator(metrics=[LLMJudgeMetric()], judge_provider=judge)

    if modality == TaskKind.AUDIO_STT:
        return AudioSTTEvaluator(metrics=[WERMetric(), CERMetric()])

    # Import conditionally for later phases
    try:
        if modality == TaskKind.AUDIO_TTS:
            from evaluators.audio_tts import AudioTTSEvaluator
            judge = registry.get("openai")
            if judge is None:
                raise HTTPException(status_code=400, detail="OpenAI provider required as LLM judge for audio TTS eval")
            return AudioTTSEvaluator(metrics=[LLMJudgeMetric()], judge_provider=judge)
    except ImportError:
        pass

    try:
        if modality == TaskKind.VIDEO_UNDERSTANDING:
            from evaluators.video_understanding import VideoUnderstandingEvaluator
            return VideoUnderstandingEvaluator(metrics=text_metrics)
    except ImportError:
        pass

    if modality == TaskKind.TEXT:
        return TextEvaluator(metrics=text_metrics)

    # Fallback to image understanding
    return ImageUnderstandingEvaluator(metrics=text_metrics)


# Store running job generators for SSE streaming
_job_streams: dict[str, Any] = {}


@router.post("/eval")
async def start_evaluation(req: EvalRequest) -> dict[str, Any]:
    """Start a new evaluation job."""

    # Validate dataset exists
    ds = await db.get_dataset(req.dataset_id)
    if not ds:
        raise HTTPException(status_code=404, detail="Dataset not found")

    # Validate providers
    provider_pairs = []
    for p_sel in req.providers:
        provider = registry.get(p_sel.id)
        if not provider:
            raise HTTPException(status_code=400, detail=f"Provider '{p_sel.id}' not found")
        provider_pairs.append((provider, p_sel.model))

    # Load dataset items
    raw_items = await db.get_dataset_items(req.dataset_id)
    items = [
        DatasetRow(
            index=item["seq_index"],
            task_kind=item["task_kind"],
            prompt=item["prompt_text"],
            expected_text=item["expected_text"],
            media_path=item["media_path"],
            media_type=item["media_type"],
        )
        for item in raw_items
    ]

    total = len(items) * len(provider_pairs)

    # Merge eval_config params into the config dict so evaluators pass them to providers
    merged_config = dict(req.config)
    ec: EvalConfig = req.eval_config or EvalConfig()
    if ec.temperature is not None:
        merged_config["temperature"] = ec.temperature
    if ec.max_tokens is not None:
        merged_config["max_tokens"] = ec.max_tokens
    if ec.system_prompt:
        merged_config["system_prompt"] = ec.system_prompt

    # Create job in DB (persist eval_config params on the job row)
    job_id = await db.create_job(
        name=req.name,
        dataset_id=req.dataset_id,
        modality=req.modality,
        providers=[p.model_dump() for p in req.providers],
        config=merged_config,
        total=total,
        temperature=ec.temperature,
        max_tokens=ec.max_tokens,
        system_prompt=ec.system_prompt,
    )

    # Get evaluator
    evaluator = _get_evaluator(req.modality)

    # Store the generator for streaming
    _job_streams[job_id] = run_evaluation(
        job_id=job_id,
        items=items,
        providers=provider_pairs,
        evaluator=evaluator,
        config=merged_config,
    )

    return {
        "job_id": job_id,
        "status": "pending",
        "stream_url": f"/api/eval/{job_id}/stream",
    }


@router.get("/eval/{job_id}/stream")
async def stream_evaluation(job_id: str):
    """SSE stream of evaluation progress."""
    gen = _job_streams.get(job_id)
    if not gen:
        raise HTTPException(status_code=404, detail="Job stream not found")

    async def event_generator():
        try:
            async for event in gen:
                yield event
        except Exception as exc:
            import traceback
            traceback.print_exc()
            yield {
                "event": "error",
                "data": json.dumps({"error": str(exc), "type": type(exc).__name__}),
            }
        finally:
            _job_streams.pop(job_id, None)

    return EventSourceResponse(event_generator())
