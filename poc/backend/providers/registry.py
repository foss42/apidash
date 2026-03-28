"""Provider registry — discover, register, and health-check providers."""

from __future__ import annotations

import asyncio
from typing import Optional

from providers.base import HealthStatus, ProviderAdapter, TaskKind


class ProviderRegistry:
    """Central registry of all provider adapters."""

    def __init__(self) -> None:
        self._providers: dict[str, ProviderAdapter] = {}

    def register(self, provider: ProviderAdapter) -> None:
        self._providers[provider.id] = provider

    def get(self, provider_id: str) -> Optional[ProviderAdapter]:
        return self._providers.get(provider_id)

    def list_all(self) -> list[ProviderAdapter]:
        return list(self._providers.values())

    def list_for_task(self, task_kind: TaskKind) -> list[ProviderAdapter]:
        return [p for p in self._providers.values() if p.supports(task_kind)]

    async def health_check_all(self) -> dict[str, HealthStatus]:
        results: dict[str, HealthStatus] = {}
        checks = {
            pid: provider.health_check()
            for pid, provider in self._providers.items()
        }
        for pid, coro in checks.items():
            try:
                results[pid] = await coro
            except Exception as exc:
                results[pid] = HealthStatus(
                    available=False, error=str(exc)
                )
        return results


# Singleton used by the app
registry = ProviderRegistry()
