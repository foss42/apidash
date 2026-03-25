from abc import ABC, abstractmethod
from typing import Dict, Any


class BaseModelAdapter(ABC):
    name: str
    display_name: str
    models: list

    @abstractmethod
    async def generate(self, prompt: str, model: str, parameters: Dict[str, Any] = {}) -> dict:
        """Returns dict with keys: text, tokens_used, latency_ms, cost"""
        pass
