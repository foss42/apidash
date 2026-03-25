from typing import Any, Dict, List, Optional

from app.adapters.registry import ADAPTER_REGISTRY
from app.metrics.registry import METRIC_REGISTRY
from app.storage import _cancel_requested, _experiments, _results


async def run_experiment(experiment_id: str, config: Dict[str, Any], rows: List[dict]) -> None:
    adapter_name = config.get("adapter", "mock")
    model = config.get("model", "gpt-4")
    metric_names: List[str] = list(config.get("metrics") or ["exact_match"])
    parameters: Dict[str, Any] = dict(config.get("parameters") or {})

    adapter = ADAPTER_REGISTRY.get(adapter_name)
    if adapter is None:
        exp = _experiments.get(experiment_id)
        if exp:
            exp["status"] = "failed"
            exp["error"] = f"Unknown adapter: {adapter_name}"
            exp["progress"] = 0.0
        return

    samples: List[Dict[str, Any]] = []
    total_tokens = 0
    total_cost = 0.0
    total_latency_ms = 0.0
    metric_sums: Dict[str, float] = {m: 0.0 for m in metric_names if m in METRIC_REGISTRY}
    n_scored = 0

    total_rows = max(len(rows), 1)
    exp = _experiments.get(experiment_id)

    for i, row in enumerate(rows):
        if _cancel_requested.get(experiment_id):
            if exp:
                exp["status"] = "cancelled"
                exp["progress"] = float(i) / float(total_rows)
            break

        prompt = row.get("input") or row.get("prompt") or ""
        expected: Optional[str] = row.get("expected_output") or row.get("expected")

        gen = await adapter.generate(prompt, model, parameters)
        text = gen.get("text", "")
        total_tokens += int(gen.get("tokens_used") or 0)
        total_cost += float(gen.get("cost") or 0.0)
        total_latency_ms += float(gen.get("latency_ms") or 0.0)

        scores: Dict[str, float] = {}
        for m in metric_names:
            fn = METRIC_REGISTRY.get(m)
            if fn is None:
                continue
            scores[m] = float(fn(text, expected))

        samples.append(
            {
                "input": prompt,
                "expected": expected,
                "predicted": text,
                "scores": scores,
            }
        )

        for m, v in scores.items():
            if m in metric_sums:
                metric_sums[m] += v
        n_scored += 1

        if exp:
            exp["progress"] = float(i + 1) / float(total_rows)

    aggregate_metrics: Dict[str, float] = {}
    if n_scored > 0:
        for m, s in metric_sums.items():
            aggregate_metrics[m] = s / float(n_scored)

    result_payload = {
        "experiment_id": experiment_id,
        "samples": samples,
        "aggregate_metrics": aggregate_metrics,
        "total_tokens": total_tokens,
        "total_cost": total_cost,
        "total_latency_ms": total_latency_ms,
    }
    _results[experiment_id] = result_payload

    if exp:
        exp["results"] = {
            "aggregate_metrics": aggregate_metrics,
            "total_tokens": total_tokens,
            "total_cost": total_cost,
            "total_latency_ms": total_latency_ms,
            "sample_count": len(samples),
        }
        if _cancel_requested.get(experiment_id) or exp.get("status") == "cancelled":
            exp["status"] = "cancelled"
        elif exp.get("status") != "failed":
            exp["status"] = "completed"
        exp["progress"] = 1.0 if exp.get("status") == "completed" else exp.get("progress", 0.0)
