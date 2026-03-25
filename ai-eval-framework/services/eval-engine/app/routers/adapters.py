from fastapi import APIRouter

from app.adapters.registry import ADAPTER_REGISTRY

router = APIRouter(prefix="/adapters", tags=["adapters"])


@router.get("")
async def list_adapters():
    out = []
    for a in ADAPTER_REGISTRY.values():
        out.append(
            {
                "name": a.name,
                "display_name": a.display_name,
                "models": list(a.models),
            }
        )
    return out
