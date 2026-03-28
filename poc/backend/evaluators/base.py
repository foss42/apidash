"""Abstract base for all evaluators."""

from __future__ import annotations

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Any, Callable, Optional

from metrics.base import MetricResult
from providers.base import ProviderAdapter, ProviderResult, TaskKind


@dataclass
class EvaluationContext:
    """Context for a single evaluation item."""

    item_index: int
    prompt: str
    expected_text: Optional[str] = None
    media_path: Optional[str] = None
    media_bytes: Optional[bytes] = None
    media_type: Optional[str] = None
    metadata: dict[str, Any] = field(default_factory=dict)


@dataclass
class EvaluationItemResult:
    """Result of evaluating one dataset item against one provider."""

    item_index: int
    provider_id: str
    model: str
    provider_result: ProviderResult
    metric_results: list[MetricResult] = field(default_factory=list)


ProgressCallback = Callable[[int, int, str], None]  # (completed, total, message)


class Evaluator(ABC):
    """Every evaluator handles a specific task kind."""

    task_kind: TaskKind

    @abstractmethod
    async def evaluate_item(
        self,
        context: EvaluationContext,
        provider: ProviderAdapter,
        model: str,
        config: dict[str, Any],
    ) -> EvaluationItemResult:
        """Evaluate a single item with a single provider."""
        ...
