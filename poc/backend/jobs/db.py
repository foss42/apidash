"""SQLite schema and async CRUD via aiosqlite."""

from __future__ import annotations

import json
import uuid
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Optional

import aiosqlite

_db: Optional[aiosqlite.Connection] = None


def _now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _new_id() -> str:
    return str(uuid.uuid4())[:8]


_SCHEMA = """
CREATE TABLE IF NOT EXISTS datasets (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    modality TEXT NOT NULL,
    item_count INTEGER NOT NULL DEFAULT 0,
    root_dir TEXT NOT NULL DEFAULT '',
    manifest_format TEXT NOT NULL DEFAULT 'csv',
    status TEXT NOT NULL DEFAULT 'uploaded',
    validation_summary TEXT DEFAULT '{}',
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS dataset_items (
    id TEXT PRIMARY KEY,
    dataset_id TEXT NOT NULL REFERENCES datasets(id),
    seq_index INTEGER NOT NULL,
    task_kind TEXT NOT NULL,
    prompt_text TEXT DEFAULT '',
    expected_text TEXT DEFAULT '',
    media_path TEXT DEFAULT '',
    media_type TEXT DEFAULT '',
    metadata_json TEXT DEFAULT '{}',
    status TEXT NOT NULL DEFAULT 'valid',
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS jobs (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    dataset_id TEXT NOT NULL REFERENCES datasets(id),
    modality TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    providers_json TEXT NOT NULL DEFAULT '[]',
    config_json TEXT NOT NULL DEFAULT '{}',
    progress_completed INTEGER NOT NULL DEFAULT 0,
    progress_total INTEGER NOT NULL DEFAULT 0,
    summary_json TEXT DEFAULT '{}',
    error_text TEXT,
    created_at TEXT NOT NULL,
    started_at TEXT,
    completed_at TEXT
);

CREATE TABLE IF NOT EXISTS job_results (
    id TEXT PRIMARY KEY,
    job_id TEXT NOT NULL REFERENCES jobs(id),
    item_index INTEGER NOT NULL,
    provider_id TEXT NOT NULL,
    model_name TEXT NOT NULL,
    response_text TEXT,
    media_output_path TEXT,
    metrics_json TEXT NOT NULL DEFAULT '{}',
    latency_ms REAL NOT NULL DEFAULT 0,
    input_tokens INTEGER NOT NULL DEFAULT 0,
    output_tokens INTEGER NOT NULL DEFAULT 0,
    cost_usd REAL NOT NULL DEFAULT 0,
    error_text TEXT,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS job_events (
    id TEXT PRIMARY KEY,
    job_id TEXT NOT NULL REFERENCES jobs(id),
    seq_no INTEGER NOT NULL,
    event_type TEXT NOT NULL,
    level TEXT NOT NULL DEFAULT 'info',
    message TEXT NOT NULL,
    payload_json TEXT DEFAULT '{}',
    created_at TEXT NOT NULL
);
"""


_BENCHMARK_SCHEMA = """
CREATE TABLE IF NOT EXISTS benchmark_runs (
    id TEXT PRIMARY KEY,
    task_name TEXT NOT NULL,
    model_id TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    log_lines TEXT NOT NULL DEFAULT '[]',
    final_score REAL,
    details TEXT,
    error_message TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_benchmark_runs_status
    ON benchmark_runs(status);
CREATE INDEX IF NOT EXISTS idx_benchmark_runs_created_at
    ON benchmark_runs(created_at);
"""

_JOBS_MIGRATIONS = [
    "ALTER TABLE jobs ADD COLUMN temperature REAL",
    "ALTER TABLE jobs ADD COLUMN max_tokens INTEGER",
    "ALTER TABLE jobs ADD COLUMN system_prompt TEXT",
]

_BENCHMARK_MIGRATIONS = [
    "ALTER TABLE benchmark_runs ADD COLUMN details TEXT",
]


async def _run_migrations(db: aiosqlite.Connection) -> None:
    """Apply additive schema migrations (safe to re-run)."""
    for stmt in _JOBS_MIGRATIONS:
        try:
            await db.execute(stmt)
        except Exception:
            pass  # Column already exists — ignore
    for stmt in _BENCHMARK_MIGRATIONS:
        try:
            await db.execute(stmt)
        except Exception:
            pass  # Column already exists — ignore
    await db.executescript(_BENCHMARK_SCHEMA)
    await db.commit()


async def init_db(db_path: Path) -> None:
    global _db
    db_path.parent.mkdir(parents=True, exist_ok=True)
    _db = await aiosqlite.connect(str(db_path))
    _db.row_factory = aiosqlite.Row
    await _db.execute("PRAGMA journal_mode=WAL")
    await _db.executescript(_SCHEMA)
    await _run_migrations(_db)
    # Clean up stale running jobs from previous crashes
    await _db.execute(
        "UPDATE jobs SET status = 'failed', error_text = 'Server restarted', "
        "completed_at = ? WHERE status IN ('pending', 'running')",
        (_now(),),
    )
    await _db.commit()


async def close_db() -> None:
    global _db
    if _db:
        await _db.close()
        _db = None


def get_db() -> aiosqlite.Connection:
    assert _db is not None, "Database not initialized"
    return _db


# ── Dataset CRUD ──


async def create_dataset(
    name: str,
    modality: str,
    item_count: int,
    root_dir: str,
    manifest_format: str = "csv",
) -> dict[str, Any]:
    db = get_db()
    row_id = _new_id()
    now = _now()
    await db.execute(
        "INSERT INTO datasets (id, name, modality, item_count, root_dir, manifest_format, status, created_at, updated_at) "
        "VALUES (?, ?, ?, ?, ?, ?, 'ready', ?, ?)",
        (row_id, name, modality, item_count, root_dir, manifest_format, now, now),
    )
    await db.commit()
    return {
        "id": row_id,
        "name": name,
        "modality": modality,
        "item_count": item_count,
        "created_at": now,
    }


async def list_datasets() -> list[dict[str, Any]]:
    db = get_db()
    cursor = await db.execute(
        "SELECT id, name, modality, item_count, created_at FROM datasets ORDER BY created_at DESC"
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


async def get_dataset(dataset_id: str) -> Optional[dict[str, Any]]:
    db = get_db()
    cursor = await db.execute("SELECT * FROM datasets WHERE id = ?", (dataset_id,))
    row = await cursor.fetchone()
    return dict(row) if row else None


async def create_dataset_item(
    dataset_id: str,
    seq_index: int,
    task_kind: str,
    prompt_text: str,
    expected_text: str,
    media_path: str,
    media_type: str,
    metadata: dict[str, Any] | None = None,
) -> str:
    db = get_db()
    row_id = _new_id()
    await db.execute(
        "INSERT INTO dataset_items (id, dataset_id, seq_index, task_kind, prompt_text, expected_text, media_path, media_type, metadata_json, status, created_at) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'valid', ?)",
        (
            row_id,
            dataset_id,
            seq_index,
            task_kind,
            prompt_text,
            expected_text,
            media_path,
            media_type,
            json.dumps(metadata or {}),
            _now(),
        ),
    )
    await db.commit()
    return row_id


async def get_dataset_items(dataset_id: str) -> list[dict[str, Any]]:
    db = get_db()
    cursor = await db.execute(
        "SELECT * FROM dataset_items WHERE dataset_id = ? ORDER BY seq_index",
        (dataset_id,),
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


# ── Job CRUD ──


async def create_job(
    name: str,
    dataset_id: str,
    modality: str,
    providers: list[dict],
    config: dict,
    total: int,
    temperature: Optional[float] = None,
    max_tokens: Optional[int] = None,
    system_prompt: Optional[str] = None,
) -> str:
    db = get_db()
    job_id = _new_id()
    now = _now()
    await db.execute(
        "INSERT INTO jobs (id, name, dataset_id, modality, status, providers_json, config_json, "
        "progress_total, temperature, max_tokens, system_prompt, created_at) "
        "VALUES (?, ?, ?, ?, 'pending', ?, ?, ?, ?, ?, ?, ?)",
        (
            job_id,
            name,
            dataset_id,
            modality,
            json.dumps(providers),
            json.dumps(config),
            total,
            temperature,
            max_tokens,
            system_prompt,
            now,
        ),
    )
    await db.commit()
    return job_id


async def update_job_status(job_id: str, status: str, **kwargs: Any) -> None:
    db = get_db()
    sets = ["status = ?"]
    vals: list[Any] = [status]
    if "progress_completed" in kwargs:
        sets.append("progress_completed = ?")
        vals.append(kwargs["progress_completed"])
    if "summary_json" in kwargs:
        sets.append("summary_json = ?")
        vals.append(json.dumps(kwargs["summary_json"]))
    if "error_text" in kwargs:
        sets.append("error_text = ?")
        vals.append(kwargs["error_text"])
    if status == "running":
        sets.append("started_at = ?")
        vals.append(_now())
    if status in ("completed", "failed", "canceled"):
        sets.append("completed_at = ?")
        vals.append(_now())
    vals.append(job_id)
    await db.execute(f"UPDATE jobs SET {', '.join(sets)} WHERE id = ?", vals)
    await db.commit()


async def list_jobs(
    status: Optional[str] = None, limit: int = 20, offset: int = 0
) -> list[dict[str, Any]]:
    db = get_db()
    q = "SELECT id, name, dataset_id, modality, status, providers_json, created_at, summary_json FROM jobs"
    params: list[Any] = []
    if status:
        q += " WHERE status = ?"
        params.append(status)
    q += " ORDER BY created_at DESC LIMIT ? OFFSET ?"
    params.extend([limit, offset])
    cursor = await db.execute(q, params)
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


async def get_job(job_id: str) -> Optional[dict[str, Any]]:
    db = get_db()
    cursor = await db.execute("SELECT * FROM jobs WHERE id = ?", (job_id,))
    row = await cursor.fetchone()
    return dict(row) if row else None


async def save_job_result(
    job_id: str,
    item_index: int,
    provider_id: str,
    model_name: str,
    response_text: Optional[str],
    metrics: dict,
    latency_ms: float,
    input_tokens: int,
    output_tokens: int,
    cost_usd: float,
    error_text: Optional[str] = None,
    media_output_path: Optional[str] = None,
) -> str:
    db = get_db()
    row_id = _new_id()
    await db.execute(
        "INSERT INTO job_results (id, job_id, item_index, provider_id, model_name, response_text, "
        "media_output_path, metrics_json, latency_ms, input_tokens, output_tokens, cost_usd, error_text, created_at) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        (
            row_id,
            job_id,
            item_index,
            provider_id,
            model_name,
            response_text,
            media_output_path,
            json.dumps(metrics),
            latency_ms,
            input_tokens,
            output_tokens,
            cost_usd,
            error_text,
            _now(),
        ),
    )
    await db.commit()
    return row_id


async def get_job_results(job_id: str) -> list[dict[str, Any]]:
    db = get_db()
    cursor = await db.execute(
        "SELECT * FROM job_results WHERE job_id = ? ORDER BY item_index, provider_id",
        (job_id,),
    )
    rows = await cursor.fetchall()
    return [dict(r) for r in rows]


# ── BenchmarkRun CRUD ──


async def create_benchmark_run(task_name: str, model_id: str) -> dict[str, Any]:
    db = get_db()
    run_id = str(uuid.uuid4())
    now = _now()
    await db.execute(
        "INSERT INTO benchmark_runs (id, task_name, model_id, status, log_lines, created_at, updated_at) "
        "VALUES (?, ?, ?, 'pending', '[]', ?, ?)",
        (run_id, task_name, model_id, now, now),
    )
    await db.commit()
    return {
        "id": run_id,
        "task_name": task_name,
        "model_id": model_id,
        "status": "pending",
        "log_lines": [],
        "final_score": None,
        "details": None,
        "error_message": None,
        "created_at": now,
        "updated_at": now,
    }


async def get_benchmark_run(run_id: str) -> Optional[dict[str, Any]]:
    db = get_db()
    cursor = await db.execute("SELECT * FROM benchmark_runs WHERE id = ?", (run_id,))
    row = await cursor.fetchone()
    if not row:
        return None
    d = dict(row)
    d["log_lines"] = json.loads(d["log_lines"])
    if d.get("details"):
        d["details"] = json.loads(d["details"])
    return d


async def list_benchmark_runs() -> list[dict[str, Any]]:
    db = get_db()
    cursor = await db.execute(
        "SELECT id, task_name, model_id, status, final_score, details, error_message, created_at, updated_at "
        "FROM benchmark_runs ORDER BY created_at DESC"
    )
    rows = await cursor.fetchall()
    result = []
    for r in rows:
        d = dict(r)
        if d.get("details"):
            d["details"] = json.loads(d["details"])
        result.append(d)
    return result


async def append_benchmark_log(run_id: str, line: str) -> None:
    db = get_db()
    cursor = await db.execute(
        "SELECT log_lines FROM benchmark_runs WHERE id = ?", (run_id,)
    )
    row = await cursor.fetchone()
    if not row:
        return
    lines = json.loads(row["log_lines"])
    lines.append(line)
    await db.execute(
        "UPDATE benchmark_runs SET log_lines = ?, updated_at = ? WHERE id = ?",
        (json.dumps(lines), _now(), run_id),
    )
    await db.commit()


async def complete_benchmark_run(
    run_id: str, final_score: Optional[float], details: Optional[dict] = None
) -> None:
    db = get_db()
    details_json = json.dumps(details) if details else None
    await db.execute(
        "UPDATE benchmark_runs SET status = 'completed', final_score = ?, details = ?, updated_at = ? WHERE id = ?",
        (final_score, details_json, _now(), run_id),
    )
    await db.commit()


async def fail_benchmark_run(run_id: str, error_message: str) -> None:
    db = get_db()
    await db.execute(
        "UPDATE benchmark_runs SET status = 'failed', error_message = ?, updated_at = ? WHERE id = ?",
        (error_message, _now(), run_id),
    )
    await db.commit()


async def set_benchmark_run_status(run_id: str, status: str) -> None:
    db = get_db()
    await db.execute(
        "UPDATE benchmark_runs SET status = ?, updated_at = ? WHERE id = ?",
        (status, _now(), run_id),
    )
    await db.commit()


async def delete_benchmark_run(run_id: str) -> bool:
    """Delete a benchmark run record. Returns True if a row was deleted."""
    db = get_db()
    cursor = await db.execute("DELETE FROM benchmark_runs WHERE id = ?", (run_id,))
    await db.commit()
    return (cursor.rowcount or 0) > 0
