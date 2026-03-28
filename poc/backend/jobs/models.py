"""Pydantic request/response models for the API layer."""

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import Any, Optional

from pydantic import BaseModel, Field


class JobStatus(str, Enum):
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"
    CANCELED = "canceled"


class ProviderSelection(BaseModel):
    id: str
    model: str


class EvalConfig(BaseModel):
    """Optional request parameter overrides for a job."""

    temperature: float | None = Field(None, ge=0.0, le=2.0)
    max_tokens: int | None = Field(None, ge=1)
    system_prompt: str | None = None


class EvalRequest(BaseModel):
    name: str
    dataset_id: str
    modality: str  # TaskKind value
    providers: list[ProviderSelection]
    config: dict[str, Any] = Field(default_factory=dict)
    eval_config: EvalConfig | None = None


class EvalStartResponse(BaseModel):
    job_id: str
    status: str = "pending"
    stream_url: str


class DatasetInfo(BaseModel):
    id: str
    name: str
    modality: str
    item_count: int
    created_at: datetime


class ProviderModelInfo(BaseModel):
    id: str
    modalities: list[str]


class ProviderInfo(BaseModel):
    id: str
    name: str
    type: str
    is_available: bool = False
    supported_modalities: list[str] = Field(default_factory=list)
    models: list[ProviderModelInfo] = Field(default_factory=list)


class MetricScore(BaseModel):
    metric_id: str
    score: float
    raw_value: Any = None
    explanation: Optional[str] = None


class ItemProviderResult(BaseModel):
    response: Optional[str] = None
    metrics: dict[str, float] = Field(default_factory=dict)
    latency_ms: float = 0.0
    cost_usd: float = 0.0
    error: Optional[str] = None


class ItemResult(BaseModel):
    item_index: int
    prompt: str
    expected: Optional[str] = None
    providers: dict[str, ItemProviderResult] = Field(default_factory=dict)


class CostSummary(BaseModel):
    total_tokens: int = 0
    total_cost: float = 0.0
    avg_latency_ms: float = 0.0


class JobSummary(BaseModel):
    id: str
    name: str
    status: JobStatus
    modality: str
    providers: list[str] = Field(default_factory=list)
    created_at: datetime
    summary: dict[str, Any] = Field(default_factory=dict)


class JobDetail(BaseModel):
    job: JobSummary
    results: list[ItemResult] = Field(default_factory=list)
    cost_summary: dict[str, CostSummary] = Field(default_factory=dict)


class BenchmarkRunCreate(BaseModel):
    task_name: str = Field(..., min_length=1)
    model_id: str = Field(..., min_length=1)
    num_samples: int | None = Field(None, ge=1, le=1000)


class BenchmarkRunCreateMulti(BaseModel):
    task_name: str = Field(..., min_length=1)
    providers: list[ProviderSelection] = Field(..., min_length=1)
    num_samples: int | None = Field(None, ge=1, le=1000)


class BenchmarkRun(BaseModel):
    id: str
    task_name: str
    model_id: str
    status: str  # pending | running | completed | failed
    log_lines: list[str] = Field(default_factory=list)
    final_score: Optional[float] = None
    error_message: Optional[str] = None
    created_at: str
    updated_at: str


class LmEvalStatus(BaseModel):
    installed: bool
    version: str | None = None


class LmEvalInstallProgress(BaseModel):
    status: str  # installing | success | failed
    output: list[str] = Field(default_factory=list)
    error: str | None = None
