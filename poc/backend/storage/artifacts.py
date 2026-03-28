"""Save/load media artifacts on disk by ID."""

from __future__ import annotations

import uuid
from pathlib import Path
from typing import Optional

from config import settings


def _artifact_dir() -> Path:
    return settings.get_artifact_dir()


def get_artifact_path(artifact_id: str, extension: str = "") -> Path:
    """Return the full path for an artifact ID."""
    return _artifact_dir() / f"{artifact_id}{extension}"


def save_artifact(
    data: bytes,
    extension: str = "",
    artifact_id: Optional[str] = None,
    subdirectory: Optional[str] = None,
) -> str:
    """Save binary data to disk, return the artifact ID."""
    aid = artifact_id or str(uuid.uuid4())[:8]
    base = _artifact_dir()
    if subdirectory:
        base = base / subdirectory
        base.mkdir(parents=True, exist_ok=True)
    path = base / f"{aid}{extension}"
    path.write_bytes(data)
    return aid


def load_artifact(artifact_id: str, extension: str = "", subdirectory: Optional[str] = None) -> Optional[bytes]:
    """Load binary data from disk by ID."""
    base = _artifact_dir()
    if subdirectory:
        base = base / subdirectory
    path = base / f"{artifact_id}{extension}"
    if path.exists():
        return path.read_bytes()
    return None
