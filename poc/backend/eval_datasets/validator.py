"""Validate dataset completeness before evaluation."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

from eval_datasets.loader import DatasetRow


@dataclass
class ValidationResult:
    valid: bool = True
    item_count: int = 0
    missing_files: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)
    errors: list[str] = field(default_factory=list)


def validate_dataset(rows: list[DatasetRow]) -> ValidationResult:
    """Validate a parsed dataset for completeness."""
    result = ValidationResult(item_count=len(rows))

    if not rows:
        result.valid = False
        result.errors.append("Dataset is empty")
        return result

    for row in rows:
        # Check media file exists for tasks that need it
        needs_media = row.task_kind in (
            "image_understanding", "audio_stt", "video_understanding",
        )
        if needs_media and row.media_path:
            if not Path(row.media_path).exists():
                result.missing_files.append(row.media_path)

        # Check prompt exists for tasks that need it
        needs_prompt = row.task_kind in (
            "image_understanding", "image_generation", "text_to_speech",
            "video_understanding", "text",
        )
        if needs_prompt and not row.prompt:
            result.warnings.append(f"Item {row.index}: missing prompt")

        # Check expected text for scoring tasks
        if row.task_kind in ("image_understanding", "audio_stt", "text") and not row.expected_text:
            result.warnings.append(f"Item {row.index}: missing expected text (scoring will be limited)")

    if result.missing_files:
        result.valid = False
        result.errors.append(f"{len(result.missing_files)} media file(s) not found")

    return result
