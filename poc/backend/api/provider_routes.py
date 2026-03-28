"""Provider API routes — list providers, health check, configure API keys."""

from __future__ import annotations

from typing import Any, Optional

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from config import settings
from providers.registry import registry

router = APIRouter(prefix="/providers", tags=["providers"])


class ProviderKeyUpdate(BaseModel):
    api_key: Optional[str] = None


@router.get("")
async def list_providers() -> dict[str, Any]:
    health = await registry.health_check_all()
    providers = []
    for p in registry.list_all():
        status = health.get(p.id)
        has_key = False
        if p.id == "openai":
            has_key = bool(settings.openai_api_key)
        elif p.id == "anthropic":
            has_key = bool(settings.anthropic_api_key)
        elif p.id == "gemini":
            has_key = bool(settings.gemini_api_key)
        elif p.id == "ollama":
            has_key = True  # Local, no key required
        elif p.id == "openrouter":
            has_key = bool(settings.openrouter_api_key)

        providers.append(
            {
                "id": p.id,
                "name": p.name,
                "type": p.provider_type,
                "available": status.available if status else False,
                "api_key_set": has_key,
                "supported_modalities": [t.value for t in p.supported_tasks],
                "models": status.models if status else [],
            }
        )
    return {"providers": providers}


@router.get("/health")
async def health_check() -> dict[str, Any]:
    results = await registry.health_check_all()
    return {
        pid: {
            "available": status.available,
            "latency_ms": round(status.latency_ms, 1),
            "error": status.error,
            "models": status.models,
        }
        for pid, status in results.items()
    }


@router.post("/{provider_id}/key")
async def set_provider_key(provider_id: str, req: ProviderKeyUpdate) -> dict[str, Any]:
    """Set API key for a provider (runtime, not persisted to .env)."""
    if provider_id == "openai":
        settings.openai_api_key = req.api_key or ""
    elif provider_id == "anthropic":
        settings.anthropic_api_key = req.api_key or ""
    elif provider_id == "gemini":
        settings.gemini_api_key = req.api_key or ""
    elif provider_id == "openrouter":
        settings.openrouter_api_key = req.api_key or ""
    else:
        raise HTTPException(400, f"Cannot set key for provider: {provider_id}")

    return {"success": True, "provider_id": provider_id, "key_set": bool(req.api_key)}
