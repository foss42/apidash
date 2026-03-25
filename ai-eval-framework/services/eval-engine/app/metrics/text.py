import math
from collections import Counter
from typing import Optional


def exact_match(predicted: str, expected: Optional[str]) -> float:
    if expected is None:
        return 0.0
    return 1.0 if (predicted or "").strip() == (expected or "").strip() else 0.0


def contains_match(predicted: str, expected: Optional[str]) -> float:
    if expected is None:
        return 0.0
    return 1.0 if (expected or "").lower() in (predicted or "").lower() else 0.0


def case_insensitive_match(predicted: str, expected: Optional[str]) -> float:
    if expected is None:
        return 0.0
    return 1.0 if (predicted or "").strip().lower() == (expected or "").strip().lower() else 0.0


def bleu_score(predicted: str, expected: Optional[str]) -> float:
    """Simple unigram BLEU-style score: clipped precision with brevity penalty."""
    if expected is None:
        return 0.0
    pred_tokens = (predicted or "").lower().split()
    ref_tokens = (expected or "").lower().split()
    if not pred_tokens or not ref_tokens:
        return 0.0

    pred_counts = Counter(pred_tokens)
    ref_counts = Counter(ref_tokens)
    clipped = sum(min(pred_counts[w], ref_counts[w]) for w in pred_counts)
    precision = clipped / max(len(pred_tokens), 1)

    if len(pred_tokens) > len(ref_tokens):
        bp = 1.0
    else:
        bp = math.exp(1.0 - float(len(ref_tokens)) / max(len(pred_tokens), 1))

    return float(max(0.0, min(1.0, precision * bp)))
