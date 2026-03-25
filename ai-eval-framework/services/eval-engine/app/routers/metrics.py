from fastapi import APIRouter

from app.metrics.registry import METRIC_REGISTRY

router = APIRouter(prefix="/metrics", tags=["metrics"])

_METRIC_META = {
    "exact_match": {
        "display_name": "Exact match",
        "modalities": ["text"],
        "description": "1.0 if predicted text equals expected after strip.",
    },
    "contains_match": {
        "display_name": "Contains match",
        "modalities": ["text"],
        "description": "1.0 if expected substring appears in predicted text.",
    },
    "bleu_score": {
        "display_name": "BLEU (unigram)",
        "modalities": ["text"],
        "description": "Unigram clipped precision with brevity penalty (approximate BLEU-1).",
    },
}


@router.get("")
async def list_metrics():
    out = []
    for name in METRIC_REGISTRY:
        meta = _METRIC_META.get(name, {})
        out.append(
            {
                "name": name,
                "display_name": meta.get("display_name", name),
                "modalities": meta.get("modalities", ["text"]),
                "description": meta.get("description", ""),
            }
        )
    return out
