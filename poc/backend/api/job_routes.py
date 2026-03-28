"""Job API routes — list, get details, re-run."""

from __future__ import annotations

import json
from typing import Any

from fastapi import APIRouter, HTTPException

from jobs import db
from jobs.models import (
    CostSummary,
    ItemProviderResult,
    ItemResult,
    JobDetail,
    JobStatus,
    JobSummary,
)

router = APIRouter(prefix="/jobs", tags=["jobs"])


@router.get("")
async def list_jobs(
    status: str | None = None,
    limit: int = 20,
    offset: int = 0,
) -> dict[str, Any]:
    jobs = await db.list_jobs(status=status, limit=limit, offset=offset)
    result = []
    for j in jobs:
        providers_raw = json.loads(j["providers_json"]) if j["providers_json"] else []
        provider_labels = [f"{p['id']}:{p['model']}" for p in providers_raw]
        result.append({
            "id": j["id"],
            "name": j["name"],
            "status": j["status"],
            "modality": j["modality"],
            "providers": provider_labels,
            "created_at": j["created_at"],
            "summary": json.loads(j["summary_json"]) if j["summary_json"] else {},
        })
    return {"jobs": result}


@router.get("/{job_id}")
async def get_job(job_id: str) -> dict[str, Any]:
    job = await db.get_job(job_id)
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    results_raw = await db.get_job_results(job_id)

    # Group results by item index
    items_map: dict[int, dict[str, Any]] = {}
    cost_map: dict[str, dict[str, float]] = {}

    # Pre-fetch dataset items
    ds_items = await db.get_dataset_items(job["dataset_id"])

    for r in results_raw:
        idx = r["item_index"]
        # Use provider:model as key to distinguish same provider with different models
        provider_key = f"{r['provider_id']}:{r['model_name']}"

        if idx not in items_map:
            item_data = next((i for i in ds_items if i["seq_index"] == idx), {})
            items_map[idx] = {
                "item_index": idx,
                "prompt": item_data.get("prompt_text", ""),
                "expected": item_data.get("expected_text", ""),
                "providers": {},
            }

        items_map[idx]["providers"][provider_key] = {
            "response": r["response_text"],
            "metrics": json.loads(r["metrics_json"]) if r["metrics_json"] else {},
            "latency_ms": r["latency_ms"],
            "cost_usd": r["cost_usd"],
            "error": r["error_text"],
        }

        # Accumulate cost
        if provider_key not in cost_map:
            cost_map[provider_key] = {"tokens": 0, "cost": 0.0, "latency_sum": 0.0, "count": 0}
        cost_map[provider_key]["tokens"] += r["input_tokens"] + r["output_tokens"]
        cost_map[provider_key]["cost"] += r["cost_usd"]
        cost_map[provider_key]["latency_sum"] += r["latency_ms"]
        cost_map[provider_key]["count"] += 1

    providers_raw = json.loads(job["providers_json"]) if job["providers_json"] else []
    providers_list = [f"{p['id']}:{p['model']}" for p in providers_raw]

    return {
        "job": {
            "id": job["id"],
            "name": job["name"],
            "status": job["status"],
            "modality": job["modality"],
            "providers": providers_list,
            "created_at": job["created_at"],
            "summary": json.loads(job["summary_json"]) if job["summary_json"] else {},
            "eval_config": {
                "temperature": job.get("temperature"),
                "max_tokens": job.get("max_tokens"),
                "system_prompt": job.get("system_prompt"),
            },
        },
        "results": sorted(items_map.values(), key=lambda x: x["item_index"]),
        "cost_summary": {
            pid: {
                "total_tokens": int(data["tokens"]),
                "total_cost": data["cost"],
                "avg_latency_ms": data["latency_sum"] / data["count"] if data["count"] > 0 else 0,
            }
            for pid, data in cost_map.items()
        },
    }


@router.post("/{job_id}/rerun")
async def rerun_job(job_id: str) -> dict[str, Any]:
    job = await db.get_job(job_id)
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    providers = json.loads(job["providers_json"]) if job["providers_json"] else []
    config = json.loads(job["config_json"]) if job["config_json"] else {}

    # Return the original config so the client can re-submit via POST /api/eval.
    # We do not pre-create a DB record here — that would leave a phantom pending job
    # with no running evaluation attached to it (the stream dict is managed in eval_routes).
    return {
        "original_job_id": job_id,
        "eval_request": {
            "name": f"{job['name']} (re-run)",
            "dataset_id": job["dataset_id"],
            "modality": job["modality"],
            "providers": providers,
            "config": config,
        },
    }
