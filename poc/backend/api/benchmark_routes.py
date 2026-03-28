"""Benchmark API routes — lm-eval direct-import integration."""

from __future__ import annotations

import asyncio
import json
from typing import Any

from fastapi import APIRouter, BackgroundTasks, HTTPException
from pydantic import BaseModel
from sse_starlette.sse import EventSourceResponse

from benchmarks.runner import (
    is_available,
    get_version,
    install_lm_eval,
    reset_check,
    run_benchmark,
    run_benchmark_multi,
    cancel_benchmark,
    get_task_info,
    LM_EVAL_TASKS,
)

from jobs import db
from jobs.db import delete_benchmark_run
from jobs.models import (
    BenchmarkRunCreate,
    BenchmarkRunCreateMulti,
    BenchmarkRun,
    ProviderSelection,
)

router = APIRouter(prefix="/benchmarks", tags=["benchmarks"])


class LmEvalStatusResponse(BaseModel):
    installed: bool
    version: str | None = None
    tasks: dict[str, dict]


# In-memory install status for SSE streaming
_install_status: dict = {
    "status": "idle",  # idle | installing | success | failed
    "output": [],
    "error": None,
    "version": None,
}


@router.get("/status", response_model=LmEvalStatusResponse)
async def get_lmeval_status() -> LmEvalStatusResponse:
    """Check if lm-eval is installed and return available tasks."""
    return LmEvalStatusResponse(
        installed=is_available(),
        version=get_version(),
        tasks=LM_EVAL_TASKS,
    )


@router.post("/install")
async def install_lmeval(background_tasks: BackgroundTasks):
    """Start lm-eval installation in the background."""
    global _install_status

    if is_available():
        return {
            "status": "already_installed",
            "version": get_version(),
        }

    # Check if already installing
    if _install_status["status"] == "installing":
        return {
            "status": "installing",
            "output": _install_status["output"],
        }

    # Reset and start installation
    _install_status = {
        "status": "installing",
        "output": [],
        "error": None,
        "version": None,
    }

    background_tasks.add_task(_do_install)

    return {
        "status": "installing",
        "message": "Installation started",
    }


@router.get("/install/status")
async def get_install_status():
    """Get the current status of lm-eval installation."""
    global _install_status
    return {
        "status": _install_status["status"],
        "output": _install_status["output"],
        "error": _install_status["error"],
        "version": _install_status["version"],
        "installed": is_available(),
    }


async def _do_install():
    """Background task that performs the actual installation."""
    global _install_status

    try:
        result = await install_lm_eval()

        if result["status"] == "success":
            reset_check()  # clear the cache so is_available() re-checks
            _install_status = {
                "status": "success",
                "output": result.get("output", [])[-20:],  # Last 20 lines
                "error": None,
                "version": result.get("version") or get_version(),
            }
        else:
            _install_status = {
                "status": "failed",
                "output": result.get("output", [])[-20:],
                "error": result.get("error", "Unknown error"),
                "version": None,
            }
    except Exception as exc:
        _install_status = {
            "status": "failed",
            "output": [],
            "error": str(exc),
            "version": None,
        }


@router.get("/tasks")
async def list_benchmark_tasks() -> dict[str, Any]:
    """List all available lm-eval tasks with metadata."""
    return {
        "tasks": LM_EVAL_TASKS,
        "categories": {
            "math": ["gsm8k"],
            "code": ["humaneval", "mbpp"],
        },
    }


@router.get("")
async def list_benchmark_runs() -> dict[str, Any]:
    """List all past benchmark runs (log_lines omitted for brevity)."""
    runs = await db.list_benchmark_runs()
    # Add task info to each run
    for run in runs:
        run["task_info"] = get_task_info(run.get("task_name", ""))
    return {"runs": runs}


@router.post("", status_code=201)
async def create_benchmark_run(
    req: BenchmarkRunCreate,
    background_tasks: BackgroundTasks,
) -> dict[str, Any]:
    """Start a new lm-eval benchmark run. Returns 503 if lm-eval is not installed."""
    if not is_available():
        raise HTTPException(
            status_code=503,
            detail="lm-eval is not installed. Click 'Install lm-eval' or run: pip install lm-eval",
        )

    run = await db.create_benchmark_run(req.task_name, req.model_id)
    background_tasks.add_task(
        run_benchmark,
        run["id"],
        req.task_name,
        req.model_id,
        req.num_samples,
    )
    return {**run, "task_info": get_task_info(req.task_name)}


@router.post("/multi", status_code=201)
async def create_multi_benchmark_run(
    req: BenchmarkRunCreateMulti,
    background_tasks: BackgroundTasks,
) -> dict[str, Any]:
    """Run the same benchmark across multiple providers/models simultaneously."""
    if not is_available():
        raise HTTPException(
            status_code=503,
            detail="lm-eval is not installed. Click 'Install lm-eval' or run: pip install lm-eval",
        )

    # Create a run for each provider
    runs = []
    run_ids = []
    provider_configs = []

    for provider in req.providers:
        run = await db.create_benchmark_run(req.task_name, provider.model)
        runs.append(run)
        run_ids.append(run["id"])
        provider_configs.append(
            {
                "provider_id": provider.id,
                "model_id": provider.model,
            }
        )

    # Run all in parallel
    background_tasks.add_task(
        run_benchmark_multi,
        run_ids,
        req.task_name,
        provider_configs,
        req.num_samples,
    )

    return {
        "runs": runs,
        "task_info": get_task_info(req.task_name),
    }


@router.get("/{run_id}/stream")
async def stream_benchmark_run(run_id: str):
    """SSE stream of log lines for a running or completed benchmark run."""
    run = await db.get_benchmark_run(run_id)
    if not run:
        raise HTTPException(status_code=404, detail="Benchmark run not found")

    async def event_gen():
        last_idx = 0
        while True:
            current = await db.get_benchmark_run(run_id)
            if not current:
                break

            lines: list[str] = current["log_lines"]
            if len(lines) > last_idx:
                for line in lines[last_idx:]:
                    yield {
                        "event": "log",
                        "data": json.dumps({"line": line}),
                    }
                last_idx = len(lines)

            status = current["status"]
            if status == "completed":
                yield {
                    "event": "complete",
                    "data": json.dumps(
                        {
                            "status": "completed",
                            "final_score": current["final_score"],
                            "details": current.get("details"),
                            "task_info": get_task_info(current["task_name"]),
                        }
                    ),
                }
                break
            elif status == "failed":
                yield {
                    "event": "error",
                    "data": json.dumps(
                        {
                            "status": "failed",
                            "error": current["error_message"] or "Unknown error",
                        }
                    ),
                }
                break

            await asyncio.sleep(0.5)

    return EventSourceResponse(event_gen())


@router.post("/{run_id}/cancel")
async def cancel_benchmark_run(run_id: str) -> dict[str, Any]:
    """Cancel a running benchmark. Signals the background thread to stop."""
    run = await db.get_benchmark_run(run_id)
    if not run:
        raise HTTPException(status_code=404, detail="Benchmark run not found")
    if run["status"] not in ("pending", "running"):
        return {"status": run["status"], "message": "Run is not active"}

    cancel_benchmark(run_id)
    # Immediately mark as failed in DB so the frontend sees the change
    await db.fail_benchmark_run(run_id, "Cancelled by user")
    return {"status": "cancelled", "run_id": run_id}


@router.delete("/{run_id}")
async def delete_benchmark_run_endpoint(run_id: str) -> dict[str, Any]:
    """Delete a completed or failed benchmark run from history."""
    run = await db.get_benchmark_run(run_id)
    if not run:
        raise HTTPException(status_code=404, detail="Benchmark run not found")
    if run["status"] in ("pending", "running"):
        raise HTTPException(
            status_code=409,
            detail="Cannot delete a run that is still active. Cancel it first.",
        )

    deleted = await delete_benchmark_run(run_id)
    if not deleted:
        raise HTTPException(status_code=404, detail="Benchmark run not found")
    return {"status": "deleted", "run_id": run_id}
