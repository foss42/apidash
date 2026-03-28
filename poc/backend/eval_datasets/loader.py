"""Parse CSV/JSON/JSONL dataset manifests and resolve media file references."""

from __future__ import annotations

import csv
import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Optional


@dataclass
class DatasetRow:
    """One parsed row from a dataset manifest."""

    index: int
    task_kind: str
    prompt: str = ""
    expected_text: str = ""
    media_path: str = ""
    media_type: str = ""
    metadata: dict[str, Any] = field(default_factory=dict)


def _guess_media_type(path: str) -> str:
    ext = Path(path).suffix.lower()
    return {
        ".png": "image/png",
        ".jpg": "image/jpeg",
        ".jpeg": "image/jpeg",
        ".gif": "image/gif",
        ".webp": "image/webp",
        ".wav": "audio/wav",
        ".mp3": "audio/mpeg",
        ".flac": "audio/flac",
        ".ogg": "audio/ogg",
        ".mp4": "video/mp4",
        ".avi": "video/x-msvideo",
        ".mov": "video/quicktime",
        ".webm": "video/webm",
    }.get(ext, "application/octet-stream")


def _parse_csv(content: str) -> list[dict[str, str]]:
    reader = csv.DictReader(content.strip().splitlines())
    return [dict(row) for row in reader]


def _parse_json(content: str) -> list[dict[str, Any]]:
    data = json.loads(content)
    if isinstance(data, list):
        return data
    if isinstance(data, dict) and "items" in data:
        return data["items"]
    return [data]


def _parse_jsonl(content: str) -> list[dict[str, Any]]:
    return [json.loads(line) for line in content.strip().splitlines() if line.strip()]


def load_manifest(content: str, format: str = "csv") -> list[dict[str, Any]]:
    """Parse a manifest file into a list of row dicts."""
    parsers = {"csv": _parse_csv, "json": _parse_json, "jsonl": _parse_jsonl}
    parser = parsers.get(format, _parse_csv)
    return parser(content)


def rows_to_dataset(
    raw_rows: list[dict[str, Any]],
    default_task_kind: str = "image_understanding",
    media_root: Optional[Path] = None,
) -> list[DatasetRow]:
    """Convert parsed manifest rows to DatasetRow objects."""
    result: list[DatasetRow] = []

    for i, raw in enumerate(raw_rows):
        # Flexible column mapping
        prompt = raw.get("prompt") or raw.get("prompt_text") or raw.get("question") or ""
        expected = raw.get("expected") or raw.get("expected_text") or raw.get("expected_output") or raw.get("reference") or ""
        media = raw.get("media_path") or raw.get("image_path") or raw.get("audio_path") or raw.get("video_path") or raw.get("file") or ""
        task_kind = raw.get("task_kind") or raw.get("modality") or default_task_kind
        media_type = raw.get("media_type") or (_guess_media_type(media) if media else "")

        # Resolve media path relative to media_root
        if media and media_root:
            resolved = media_root / media
            media = str(resolved)

        result.append(DatasetRow(
            index=i,
            task_kind=task_kind,
            prompt=str(prompt),
            expected_text=str(expected),
            media_path=str(media),
            media_type=media_type,
            metadata={k: v for k, v in raw.items()
                      if k not in ("prompt", "prompt_text", "question", "expected",
                                   "expected_text", "expected_output", "reference",
                                   "media_path", "image_path", "audio_path", "video_path",
                                   "file", "task_kind", "modality", "media_type")},
        ))

    return result
