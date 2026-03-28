"""Dataset API routes — upload, list, get details."""

from __future__ import annotations

import shutil
from pathlib import Path
from typing import Any

from fastapi import APIRouter, File, Form, HTTPException, UploadFile
from typing import Optional

from config import settings
from eval_datasets.loader import load_manifest, rows_to_dataset
from eval_datasets.validator import validate_dataset
from jobs import db

router = APIRouter(prefix="/datasets", tags=["datasets"])


@router.post("")
async def upload_dataset(
    name: str = Form(...),
    modality: str = Form("image_understanding"),
    metadata: UploadFile = File(...),
    files: Optional[list[UploadFile]] = File(default=None),
) -> dict[str, Any]:
    """Upload a dataset: metadata manifest + media files."""

    # Determine format from filename
    fmt = "csv"
    if metadata.filename:
        if metadata.filename.endswith(".json"):
            fmt = "json"
        elif metadata.filename.endswith(".jsonl"):
            fmt = "jsonl"

    content = (await metadata.read()).decode("utf-8")

    # Create dataset directory for media
    artifact_dir = settings.get_artifact_dir()
    ds_dir = artifact_dir / f"dataset_{name.replace(' ', '_').lower()}"
    ds_dir.mkdir(parents=True, exist_ok=True)

    # Save uploaded media files
    for f in (files or []):
        if f.filename:
            dest = ds_dir / f.filename
            with open(dest, "wb") as out:
                shutil.copyfileobj(f.file, out)

    # Parse manifest
    raw_rows = load_manifest(content, fmt)
    rows = rows_to_dataset(raw_rows, default_task_kind=modality, media_root=ds_dir)

    # Validate
    validation = validate_dataset(rows)
    if not validation.valid:
        raise HTTPException(
            status_code=422,
            detail={
                "error": "validation_failed",
                "missing_files": validation.missing_files,
                "message": "; ".join(validation.errors),
            },
        )

    # Save to DB
    ds = await db.create_dataset(
        name=name,
        modality=modality,
        item_count=len(rows),
        root_dir=str(ds_dir),
        manifest_format=fmt,
    )

    # Save individual items
    for row in rows:
        await db.create_dataset_item(
            dataset_id=ds["id"],
            seq_index=row.index,
            task_kind=row.task_kind,
            prompt_text=row.prompt,
            expected_text=row.expected_text,
            media_path=row.media_path,
            media_type=row.media_type,
            metadata=row.metadata,
        )

    return {
        "id": ds["id"],
        "name": name,
        "modality": modality,
        "item_count": len(rows),
        "created_at": ds["created_at"],
        "warnings": validation.warnings,
    }


@router.get("")
async def list_datasets() -> dict[str, Any]:
    datasets = await db.list_datasets()
    return {"datasets": datasets}


@router.get("/{dataset_id}")
async def get_dataset(dataset_id: str) -> dict[str, Any]:
    ds = await db.get_dataset(dataset_id)
    if not ds:
        raise HTTPException(status_code=404, detail="Dataset not found")
    items = await db.get_dataset_items(dataset_id)
    return {"dataset": ds, "items": items}
