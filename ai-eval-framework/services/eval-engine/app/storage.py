from typing import Any, Dict

_experiments: Dict[str, dict] = {}
_results: Dict[str, dict] = {}
_cancel_requested: Dict[str, bool] = {}
