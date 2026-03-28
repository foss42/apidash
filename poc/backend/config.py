"""Application settings via pydantic-settings."""

from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
    )

    # Provider API keys
    openai_api_key: str = ""
    anthropic_api_key: str = ""
    gemini_api_key: str = ""
    openrouter_api_key: str = ""

    # Local providers
    ollama_base_url: str = "http://localhost:11434"

    # Storage
    sqlite_path: str = "./runtime/eval.db"
    artifact_root: str = "./runtime/artifacts"

    # Limits
    max_upload_mb: int = 100
    default_job_concurrency: int = 4

    def get_db_path(self) -> Path:
        p = Path(self.sqlite_path)
        p.parent.mkdir(parents=True, exist_ok=True)
        return p

    def get_artifact_dir(self) -> Path:
        p = Path(self.artifact_root)
        p.mkdir(parents=True, exist_ok=True)
        return p


settings = Settings()
