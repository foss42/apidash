"""lm-eval subprocess runner — optional dependency.

lm-eval (lm-harness) must be installed separately:
    pip install lm-eval

The framework works without it; the Benchmarks tab shows a clear error if absent.
"""

from __future__ import annotations

import asyncio
import json
import sys
import tempfile
from pathlib import Path
from typing import Optional

from config import settings
from jobs import db

# Optional import check — constitution Principle III: lm-eval MUST be optional
_LM_EVAL_AVAILABLE = False
try:
    import lm_eval  # noqa: F401

    _LM_EVAL_AVAILABLE = True
except ImportError:
    pass


def is_available() -> bool:
    """Return True if lm-eval is installed in the current Python environment."""
    return _LM_EVAL_AVAILABLE


def get_version() -> Optional[str]:
    """Return lm-eval version string or None if not installed."""
    if not _LM_EVAL_AVAILABLE:
        return None
    try:
        import lm_eval

        return getattr(lm_eval, "__version__", "installed")
    except Exception:
        return "installed"


async def install_lm_eval() -> dict:
    """Not supported - installation must be done manually."""
    return {
        "status": "failed",
        "output": [],
        "error": "Auto-install not supported. Run: pip install lm-eval",
    }


def reset_check() -> None:
    """No-op for compatibility."""
    pass


LM_EVAL_TASKS = {
    "gsm8k": {
        "name": "GSM8K",
        "description": "Grade school math (generative)",
        "category": "math",
        "generative": True,
    },
    "humaneval": {
        "name": "HumanEval",
        "description": "Code generation (generative)",
        "category": "code",
        "generative": True,
    },
    "mbpp": {
        "name": "MBPP",
        "description": "Basic Python problems (generative)",
        "category": "code",
        "generative": True,
    },
}


def get_task_info(task_name: str) -> dict:
    """Return metadata about a benchmark task."""
    return LM_EVAL_TASKS.get(
        task_name,
        {"name": task_name, "description": "Custom task", "category": "custom"},
    )


_cancel_events: dict[str, asyncio.Event] = {}


def cancel_benchmark(run_id: str) -> bool:
    """Signal a running benchmark to stop."""
    evt = _cancel_events.get(run_id)
    if evt:
        evt.set()
        return True
    return False


async def run_benchmark_multi(
    run_ids: list[str],
    task_name: str,
    provider_configs: list[dict],
    num_samples: Optional[int] = None,
) -> None:
    """Run the same benchmark across multiple providers simultaneously."""
    await asyncio.gather(
        *[
            run_benchmark(run_id, task_name, cfg.get("model_id", ""), num_samples)
            for run_id, cfg in zip(run_ids, provider_configs)
        ],
        return_exceptions=True,
    )


async def run_benchmark(
    run_id: str, task_name: str, model_id: str, num_samples: Optional[int] = None
) -> None:
    """Launch lm-eval as a background subprocess and stream stdout to the DB.

    Targets Ollama's OpenAI-compatible endpoint at localhost:11434/v1 or OpenRouter.
    Uses asyncio.create_subprocess_exec (not shell=True) to prevent injection.
    """
    output_dir = Path(tempfile.gettempdir()) / "lm_eval_output" / run_id
    output_dir.mkdir(parents=True, exist_ok=True)

    openrouter_key = getattr(settings, "openrouter_api_key", "") or ""
    is_openrouter = model_id.startswith("openrouter:") or "/" in model_id

    if is_openrouter:
        actual_model = (
            model_id.replace("openrouter:", "")
            if model_id.startswith("openrouter:")
            else model_id
        )
        base_url = "https://openrouter.ai/api/v1"
        args = [
            sys.executable,
            "-m",
            "lm_eval",
            "run",
            "--model",
            "openai-chat-completions",
            "--model_args",
            f"base_url={base_url}/chat/completions,model={actual_model}",
            "--tasks",
            task_name,
            "--num_fewshot",
            "0",
        ]
        if num_samples and num_samples > 0:
            args.extend(["--limit", str(num_samples)])
        args.extend(
            [
                "--output_path",
                str(output_dir),
                "--log_samples",
            ]
        )
    else:
        ollama_base = getattr(
            settings, "ollama_base_url", "http://localhost:11434"
        ).rstrip("/")
        base_url = f"{ollama_base}/v1"

        args = [
            sys.executable,
            "-m",
            "lm_eval",
            "run",
            "--model",
            "local-chat-completions",
            "--model_args",
            f"base_url={base_url}/chat/completions,model={model_id}",
            "--tasks",
            task_name,
            "--num_fewshot",
            "0",
            "--apply_chat_template=true",
        ]

        if num_samples and num_samples > 0:
            args.extend(["--limit", str(num_samples)])

        args.extend(
            [
                "--output_path",
                str(output_dir),
                "--log_samples",
            ]
        )

    cmd_str = " ".join(args)
    await db.append_benchmark_log(run_id, f"[DEBUG] Running: {cmd_str}")

    await db.set_benchmark_run_status(run_id, "running")

    env: dict[str, str] | None = None
    if is_openrouter and openrouter_key:
        import os

        env = os.environ.copy()
        env["OPENAI_API_KEY"] = openrouter_key
        env["PYTHONIOENCODING"] = "utf-8"
        env["PYTHONUTF8"] = "1"
    else:
        import os

        env = os.environ.copy()
        env["PYTHONIOENCODING"] = "utf-8"
        env["PYTHONUTF8"] = "1"

    try:
        proc = await asyncio.create_subprocess_exec(
            *args,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.STDOUT,
            env=env,
        )

        assert proc.stdout is not None
        async for raw_line in proc.stdout:
            line = raw_line.decode("utf-8", errors="replace").rstrip()
            if line:
                await db.append_benchmark_log(run_id, line)

        await proc.wait()

        # Check if results were saved (even if returncode != 0 due to Unicode encoding error)
        final_score, details = _parse_score(output_dir, task_name)
        if final_score is not None or details is not None:
            await db.complete_benchmark_run(run_id, final_score, details)
        elif proc.returncode != 0:
            await db.fail_benchmark_run(
                run_id, f"lm-eval exited with code {proc.returncode}"
            )
        else:
            await db.complete_benchmark_run(run_id, final_score, details)

    except Exception as exc:
        await db.fail_benchmark_run(run_id, str(exc))


def _parse_score(
    output_dir: Path, task_name: str
) -> tuple[Optional[float], Optional[dict]]:
    """Extract the primary accuracy metric and detailed results from lm-eval's JSON output.

    Returns (score, details) where details contains:
    - results: dict of task -> metric -> value
    - n_samples: {original, effective}
    - total_time: seconds
    """
    # Find all results.json files recursively (lm-eval creates them in subdirectories)
    all_json_files = list(output_dir.rglob("results*.json"))
    candidates = sorted(
        all_json_files,
        key=lambda p: p.stat().st_mtime,
        reverse=True,
    )
    if not candidates:
        return None, None

    try:
        data = json.loads(candidates[0].read_text())
        results = data.get("results", {})
        task_results = results.get(task_name, {})

        # Check common metric keys in priority order
        score = None
        for key in (
            "exact_match,flexible-extract",
            "exact_match,strict-match",
            "acc,none",
            "acc_norm,none",
            "exact_match,none",
            "f1,none",
        ):
            if key in task_results:
                score = float(task_results[key])
                break

        # Fall back: first numeric value
        if score is None:
            for v in task_results.values():
                if isinstance(v, (int, float)) and not isinstance(v, bool):
                    score = float(v)
                    break

        # Build details
        details = {
            "results": results,
            "n_samples": data.get("n-samples", {}),
            "total_time": data.get("total_evaluation_time_seconds"),
        }

        return score, details
    except Exception:
        pass

    return None, None
