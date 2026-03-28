"""Abstract base for all evaluation metrics."""

from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Any, Optional

from providers.base import ProviderAdapter, ProviderResult, TaskKind


@dataclass
class MetricContext:
    """Everything a metric needs to compute a score."""

    prompt: str
    expected_text: Optional[str]
    provider_result: ProviderResult
    task_kind: TaskKind
    job_config: dict[str, Any] = field(default_factory=dict)
    judge_provider: Optional[ProviderAdapter] = None
    # Media references if needed
    input_media_path: Optional[str] = None
    generated_media_path: Optional[str] = None


@dataclass
class MetricResult:
    """Output of a metric evaluation."""

    metric_id: str
    score: float  # 0.0–1.0 normalized
    raw_value: Any = None
    explanation: Optional[str] = None
    details: dict[str, Any] = field(default_factory=dict)


class Metric(ABC):
    """Every metric plugin implements this interface."""

    id: str
    name: str
    applicable_tasks: list[TaskKind]
    higher_is_better: bool = True

    @abstractmethod
    async def evaluate(self, context: MetricContext) -> MetricResult:
        """Score a single provider result."""
        ...
