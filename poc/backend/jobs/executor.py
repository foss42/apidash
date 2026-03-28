"""Async job executor with progress tracking and SSE emission."""

from __future__ import annotations

import asyncio
import json
from typing import Any, AsyncGenerator

from eval_datasets.loader import DatasetRow
from evaluators.base import Evaluator, EvaluationContext, EvaluationItemResult
from jobs import db
from jobs.models import ProviderSelection
from providers.base import ProviderAdapter, TaskKind
from streaming.sse import SSEEventType, format_sse_event


async def run_evaluation(
    job_id: str,
    items: list[DatasetRow],
    providers: list[tuple[ProviderAdapter, str]],  # (adapter, model)
    evaluator: Evaluator,
    config: dict[str, Any],
) -> AsyncGenerator[dict, None]:
    """Run an evaluation job, yielding SSE events as progress is made."""

    total = len(items) * len(providers)
    completed = 0

    await db.update_job_status(job_id, "running")

    yield format_sse_event(SSEEventType.STARTED, {
        "job_id": job_id,
        "total_items": len(items),
        "providers": [p.id for p, _ in providers],
    })

    provider_summaries: dict[str, dict[str, Any]] = {}

    for provider, model in providers:
        # Use provider:model as key to distinguish same provider with different models
        provider_key = f"{provider.id}:{model}"
        provider_scores: list[float] = []
        provider_cost = 0.0
        provider_latency: list[float] = []

        for item in items:
            ctx = EvaluationContext(
                item_index=item.index,
                prompt=item.prompt,
                expected_text=item.expected_text,
                media_path=item.media_path,
                media_type=item.media_type,
                metadata=item.metadata,
            )

            try:
                result: EvaluationItemResult = await evaluator.evaluate_item(
                    ctx, provider, model, config,
                )

                # Aggregate metrics
                metrics_dict: dict[str, float] = {}
                for mr in result.metric_results:
                    metrics_dict[mr.metric_id] = mr.score

                avg_score = sum(metrics_dict.values()) / len(metrics_dict) if metrics_dict else 0.0
                provider_scores.append(avg_score)
                provider_cost += result.provider_result.cost_usd
                provider_latency.append(result.provider_result.latency_ms)

                # Save to DB
                await db.save_job_result(
                    job_id=job_id,
                    item_index=item.index,
                    provider_id=provider.id,
                    model_name=model,
                    response_text=result.provider_result.text_output,
                    metrics=metrics_dict,
                    latency_ms=result.provider_result.latency_ms,
                    input_tokens=result.provider_result.input_tokens,
                    output_tokens=result.provider_result.output_tokens,
                    cost_usd=result.provider_result.cost_usd,
                    error_text=result.provider_result.error,
                )

                completed += 1
                await db.update_job_status(job_id, "running", progress_completed=completed)

                # Emit item result
                yield format_sse_event(SSEEventType.ITEM_RESULT, {
                    "provider": provider_key,
                    "model": model,
                    "item_index": item.index,
                    "metrics": metrics_dict,
                    "latency_ms": result.provider_result.latency_ms,
                    "cost_usd": result.provider_result.cost_usd,
                    "error": result.provider_result.error,
                })

                # Emit progress
                yield format_sse_event(SSEEventType.PROGRESS, {
                    "job_id": job_id,
                    "completed": completed,
                    "total": total,
                    "pct": round(completed / total * 100, 1),
                    "current_provider": provider_key,
                    "current_item": item.index,
                })

            except Exception as exc:
                completed += 1
                yield format_sse_event(SSEEventType.ITEM_RESULT, {
                    "provider": provider_key,
                    "model": model,
                    "item_index": item.index,
                    "error": str(exc),
                })

        # Provider done
        avg = sum(provider_scores) / len(provider_scores) if provider_scores else 0.0
        provider_summaries[provider_key] = {
            "provider_id": provider.id,
            "model": model,
            "avg_score": round(avg, 4),
            "cost": round(provider_cost, 6),
            "avg_latency_ms": round(sum(provider_latency) / len(provider_latency), 1) if provider_latency else 0.0,
            "items_processed": len(items),
        }

        yield format_sse_event(SSEEventType.PROVIDER_DONE, {
            "provider": provider_key,
            "model": model,
            **provider_summaries[provider_key],
        })

        # Unload Ollama model from GPU to free memory for the next provider
        if hasattr(provider, "unload_model"):
            await provider.unload_model(model)

    # Job complete
    await db.update_job_status(job_id, "completed", summary_json=provider_summaries)

    yield format_sse_event(SSEEventType.COMPLETE, {
        "job_id": job_id,
        "summary": provider_summaries,
    })
