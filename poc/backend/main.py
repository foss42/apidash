"""FastAPI application entry point."""

from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from config import settings
from jobs.db import init_db, close_db


def _register_providers() -> None:
    """Register all available provider adapters."""
    from providers.registry import registry
    from providers.openai_provider import OpenAIProvider
    from providers.ollama_provider import OllamaProvider

    registry.register(OpenAIProvider())
    registry.register(OllamaProvider())

    # Anthropic and Gemini registered when implemented
    try:
        from providers.anthropic_provider import AnthropicProvider

        registry.register(AnthropicProvider())
    except ImportError:
        pass
    try:
        from providers.gemini_provider import GeminiProvider

        registry.register(GeminiProvider())
    except ImportError:
        pass
    try:
        from providers.whisper_provider import WhisperProvider

        registry.register(WhisperProvider())
    except ImportError:
        pass
    try:
        from providers.openrouter_provider import OpenRouterProvider

        registry.register(OpenRouterProvider())
    except ImportError:
        pass


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup/shutdown: init SQLite, register providers, ensure artifact dir."""
    await init_db(settings.get_db_path())
    settings.get_artifact_dir()
    _register_providers()
    yield
    await close_db()


app = FastAPI(
    title="Multimodal Eval API",
    version="0.1.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Mount routers — imported lazily after app is created
from api import router as api_router  # noqa: E402

app.include_router(api_router, prefix="/api")
