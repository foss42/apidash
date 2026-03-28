"""Abstract base for all AI provider adapters.

Implements the unified invocation contract from
specs/001-multimodal-eval-poc/contracts/provider-interface.md
"""

from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from enum import Enum
from typing import Any


class TaskKind(str, Enum):
    """What operation the provider should perform."""
    IMAGE_UNDERSTANDING = "image_understanding"
    IMAGE_GENERATION = "image_generation"
    AUDIO_STT = "audio_stt"
    AUDIO_TTS = "audio_tts"
    VIDEO_UNDERSTANDING = "video_understanding"
    TEXT = "text"


@dataclass
class ProviderInvocation:
    """Unified request envelope sent to any provider."""
    task_kind: TaskKind
    model: str
    prompt: str = ""
    media_bytes: bytes | None = None
    media_type: str | None = None  # MIME type, e.g. "image/png"
    config: dict[str, Any] = field(default_factory=dict)
    # Request parameter overrides (from eval config UI)
    temperature: float | None = None
    max_tokens: int | None = None
    system_prompt: str | None = None


@dataclass
class ProviderResult:
    """Normalized response from any provider."""
    provider_id: str
    model: str
    task_kind: TaskKind
    text_output: str | None = None
    media_output: bytes | None = None
    media_type: str | None = None  # MIME type of generated media
    latency_ms: float = 0.0
    input_tokens: int = 0
    output_tokens: int = 0
    cost_usd: float = 0.0
    error: str | None = None
    raw_response: dict[str, Any] = field(default_factory=dict)

    @property
    def success(self) -> bool:
        return self.error is None


@dataclass
class HealthStatus:
    """Result of a provider health check."""
    available: bool
    latency_ms: float = 0.0
    error: str | None = None
    models: list[str] = field(default_factory=list)


class ProviderAdapter(ABC):
    """Every provider adapter implements this single-method interface."""

    id: str
    name: str
    provider_type: str  # "cloud" or "local"
    supported_tasks: list[TaskKind]

    @abstractmethod
    async def invoke(self, invocation: ProviderInvocation) -> ProviderResult:
        """Single entry point for all operations.

        The adapter:
        1. Validates the invocation against its supported_tasks
        2. Translates the unified invocation to provider-specific SDK call
        3. Handles provider-specific quirks
        4. Normalizes the response to ProviderResult
        5. Computes cost based on token counts and known pricing
        """
        ...

    @abstractmethod
    async def health_check(self) -> HealthStatus:
        """Check if this provider is available and responsive."""
        ...

    def supports(self, task_kind: TaskKind) -> bool:
        return task_kind in self.supported_tasks
