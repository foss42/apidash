from typing import Callable, Dict, Optional

from app.metrics import text

METRIC_REGISTRY: Dict[str, Callable[[str, Optional[str]], float]] = {
    "exact_match": text.exact_match,
    "contains_match": text.contains_match,
    "case_insensitive_match": text.case_insensitive_match,
    "bleu_score": text.bleu_score,
}
