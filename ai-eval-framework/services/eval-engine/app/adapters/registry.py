from typing import Dict

from app.adapters.base import BaseModelAdapter
from app.adapters.groq_adapter import GroqAdapter
from app.adapters.mock import MockAdapter
from app.adapters.openai_adapter import OpenAIAdapter

ADAPTER_REGISTRY: Dict[str, BaseModelAdapter] = {
    "mock": MockAdapter(),
    "openai": OpenAIAdapter(),
    "groq": GroqAdapter(),
}
