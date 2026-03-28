"""API router aggregation."""

from fastapi import APIRouter

from api.provider_routes import router as provider_router
from api.dataset_routes import router as dataset_router
from api.eval_routes import router as eval_router
from api.job_routes import router as job_router
from api.benchmark_routes import router as benchmark_router

router = APIRouter()
router.include_router(provider_router)
router.include_router(dataset_router)
router.include_router(eval_router)
router.include_router(job_router)
router.include_router(benchmark_router)
