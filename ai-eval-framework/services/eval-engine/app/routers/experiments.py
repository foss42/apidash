import asyncio
import os
import uuid
from datetime import datetime
from enum import Enum
from typing import Any, Dict, List

import httpx
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.engine.runner import run_experiment
from app.storage import _cancel_requested, _experiments, _results


class ExperimentStatus(str, Enum):
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELLED = "cancelled"


class ExperimentCreate(BaseModel):
    name: str
    dataset_id: str
    adapter: str = "mock"
    model: str = "gpt-4"
    metrics: List[str] = ["exact_match"]
    parameters: Dict[str, Any] = {}

router = APIRouter(prefix="/experiments", tags=["experiments"])


def _dataset_base_url() -> str:
    return os.environ.get("DATASET_SERVICE_URL", "http://dataset-service:8004").rstrip("/")


async def _fetch_dataset_rows(dataset_id: str) -> List[dict]:
    base = _dataset_base_url()
    url = f"{base}/datasets/{dataset_id}/rows"
    async with httpx.AsyncClient(timeout=120.0) as client:
        resp = await client.get(url)
        resp.raise_for_status()
        data = resp.json()
    if isinstance(data, list):
        return data
    if isinstance(data, dict):
        rows = data.get("rows")
        if isinstance(rows, list):
            return rows
    return []


async def _evaluation_job(experiment_id: str) -> None:
    exp = _experiments.get(experiment_id)
    if not exp:
        return
    try:
        exp["status"] = ExperimentStatus.RUNNING.value
        rows = await _fetch_dataset_rows(exp["dataset_id"])
        if not rows:
            exp["status"] = ExperimentStatus.FAILED.value
            exp["error"] = "No rows returned from dataset service"
            exp["progress"] = 0.0
            return

        config: Dict[str, Any] = {
            "adapter": exp["adapter"],
            "model": exp["model"],
            "metrics": exp["metrics"],
            "parameters": exp["parameters"],
        }
        await run_experiment(experiment_id, config, rows)
    except Exception as e:
        if exp:
            exp["status"] = ExperimentStatus.FAILED.value
            exp["error"] = str(e)
            exp["progress"] = exp.get("progress", 0.0)


@router.post("")
async def create_experiment(body: ExperimentCreate):
    experiment_id = str(uuid.uuid4())
    now = datetime.utcnow().isoformat() + "Z"
    _cancel_requested[experiment_id] = False
    _experiments[experiment_id] = {
        "id": experiment_id,
        "name": body.name,
        "dataset_id": body.dataset_id,
        "adapter": body.adapter,
        "model": body.model,
        "metrics": list(body.metrics),
        "parameters": dict(body.parameters),
        "status": ExperimentStatus.PENDING.value,
        "created_at": now,
        "progress": 0.0,
        "results": None,
        "error": None,
    }
    asyncio.create_task(_evaluation_job(experiment_id))
    return _experiments[experiment_id]


@router.get("")
async def list_experiments():
    return list(_experiments.values())


@router.get("/{experiment_id}")
async def get_experiment(experiment_id: str):
    exp = _experiments.get(experiment_id)
    if not exp:
        raise HTTPException(status_code=404, detail="Experiment not found")
    out = dict(exp)
    out["full_results_available"] = experiment_id in _results
    return out


@router.get("/{experiment_id}/results")
async def get_experiment_results(experiment_id: str):
    if experiment_id not in _experiments:
        raise HTTPException(status_code=404, detail="Experiment not found")
    res = _results.get(experiment_id)
    if res is None:
        raise HTTPException(status_code=404, detail="Results not available yet")
    return res


@router.post("/{experiment_id}/cancel")
async def cancel_experiment(experiment_id: str):
    exp = _experiments.get(experiment_id)
    if not exp:
        raise HTTPException(status_code=404, detail="Experiment not found")
    status = exp.get("status")
    if status in (ExperimentStatus.COMPLETED.value, ExperimentStatus.CANCELLED.value, ExperimentStatus.FAILED.value):
        return {"experiment_id": experiment_id, "status": status, "cancel_requested": False}
    _cancel_requested[experiment_id] = True
    return {"experiment_id": experiment_id, "status": status, "cancel_requested": True}
