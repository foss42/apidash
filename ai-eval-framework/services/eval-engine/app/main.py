from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from app.routers import experiments, adapters, metrics

_env_candidates = [Path("/app/.env")]
_here = Path(__file__).resolve()
if len(_here.parents) > 3:
    _env_candidates.append(_here.parents[3] / ".env")
for _candidate in _env_candidates:
    if _candidate.is_file():
        load_dotenv(_candidate)
        break


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


app = FastAPI(title="Eval Engine", version="0.1.0", lifespan=lifespan)
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])
app.include_router(experiments.router)
app.include_router(adapters.router)
app.include_router(metrics.router)


@app.get("/health")
async def health():
    return {"service": "eval-engine", "status": "healthy"}
