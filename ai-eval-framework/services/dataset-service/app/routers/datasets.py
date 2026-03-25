import csv
import io
import json
import uuid
from datetime import datetime
from enum import Enum
from pathlib import Path
from typing import Any, Dict, List, Optional

from fastapi import APIRouter, File, HTTPException, Query, UploadFile
from pydantic import BaseModel, Field

DATA_DIR = Path(__file__).resolve().parent.parent.parent / "data"

_datasets: Dict[str, dict] = {}
_dataset_rows: Dict[str, List[dict]] = {}


class Modality(str, Enum):
    TEXT = "text"
    IMAGE = "image"
    VOICE = "voice"


class DatasetMetadata(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    filename: str
    row_count: int = 0
    columns: List[str] = []
    modality: Modality = Modality.TEXT
    created_at: datetime = Field(default_factory=datetime.utcnow)


router = APIRouter(prefix="/datasets", tags=["datasets"])


def _ensure_data_dir() -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)


def _detect_format(filename: str) -> str:
    lower = filename.lower()
    if lower.endswith(".csv"):
        return "csv"
    if lower.endswith(".jsonl") or lower.endswith(".ndjson"):
        return "jsonl"
    raise HTTPException(
        status_code=400,
        detail="File must have extension .csv, .jsonl, or .ndjson",
    )


def _parse_csv(text: str) -> tuple[List[dict], List[str]]:
    reader = csv.DictReader(io.StringIO(text))
    fieldnames = reader.fieldnames or []
    rows = [dict(row) for row in reader]
    return rows, list(fieldnames)


def _parse_jsonl(text: str) -> tuple[List[dict], List[str]]:
    rows: List[dict] = []
    columns: Optional[List[str]] = None
    for line in text.splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            obj = json.loads(line)
        except json.JSONDecodeError as e:
            raise HTTPException(status_code=400, detail=f"Invalid JSONL: {e}") from e
        if not isinstance(obj, dict):
            raise HTTPException(
                status_code=400,
                detail="Each JSONL line must be a JSON object",
            )
        if columns is None:
            columns = list(obj.keys())
        rows.append(obj)
    return rows, columns or []


def _get_dataset_or_404(dataset_id: str) -> dict:
    meta = _datasets.get(dataset_id)
    if meta is None:
        raise HTTPException(status_code=404, detail="Dataset not found")
    return meta


@router.post("/upload", response_model=DatasetMetadata)
async def upload_dataset(file: UploadFile = File(...)) -> DatasetMetadata:
    fmt = _detect_format(file.filename or "")
    raw = await file.read()
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as e:
        raise HTTPException(status_code=400, detail="File must be UTF-8 encoded") from e

    if fmt == "csv":
        rows, columns = _parse_csv(text)
    else:
        rows, columns = _parse_jsonl(text)

    dataset_id = str(uuid.uuid4())
    _ensure_data_dir()
    disk_name = f"{dataset_id}.{'csv' if fmt == 'csv' else 'jsonl'}"
    disk_path = DATA_DIR / disk_name
    disk_path.write_bytes(raw)

    stem = Path(file.filename or disk_name).stem
    meta = DatasetMetadata(
        id=dataset_id,
        name=stem,
        filename=file.filename or disk_name,
        row_count=len(rows),
        columns=columns,
        modality=Modality.TEXT,
        created_at=datetime.utcnow(),
    )
    _datasets[dataset_id] = meta.model_dump(mode="json")
    _dataset_rows[dataset_id] = rows
    return meta


@router.get("", response_model=List[DatasetMetadata])
async def list_datasets() -> List[DatasetMetadata]:
    return [DatasetMetadata.model_validate(m) for m in _datasets.values()]


@router.get("/{dataset_id}", response_model=DatasetMetadata)
async def get_dataset(dataset_id: str) -> DatasetMetadata:
    return DatasetMetadata.model_validate(_get_dataset_or_404(dataset_id))


@router.get("/{dataset_id}/sample", response_model=List[Dict[str, Any]])
async def sample_dataset(
    dataset_id: str,
    n: int = Query(5, ge=1, le=10_000),
) -> List[Dict[str, Any]]:
    _get_dataset_or_404(dataset_id)
    rows = _dataset_rows.get(dataset_id, [])
    return rows[:n]


@router.get("/{dataset_id}/rows", response_model=List[Dict[str, Any]])
async def get_dataset_rows(dataset_id: str) -> List[Dict[str, Any]]:
    _get_dataset_or_404(dataset_id)
    return list(_dataset_rows.get(dataset_id, []))


@router.get("/{dataset_id}/stream", response_model=List[Dict[str, Any]])
async def stream_dataset(dataset_id: str) -> List[Dict[str, Any]]:
    _get_dataset_or_404(dataset_id)
    return list(_dataset_rows.get(dataset_id, []))


@router.delete("/{dataset_id}", status_code=204)
async def delete_dataset(dataset_id: str) -> None:
    meta = _get_dataset_or_404(dataset_id)
    did = str(meta.get("id", dataset_id))
    for suffix in ("csv", "jsonl"):
        p = DATA_DIR / f"{did}.{suffix}"
        if p.is_file():
            p.unlink()
            break
    _datasets.pop(dataset_id, None)
    _dataset_rows.pop(dataset_id, None)
