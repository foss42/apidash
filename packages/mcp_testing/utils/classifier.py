"""4-layer MCP error classifier.

Maps JSON-RPC error codes and context flags to the protocol layer that
originated the failure. Based on the classification scheme described in
Discussion #1225 (MCP Testing).

Layers
------
transport      Process could not be spawned, pipe broke, or JSON was malformed
               on the wire (code -32700).
protocol       JSON-RPC framing was correct but the method / params were wrong
               (codes -32600 / -32601 / -32602).
ui-handshake   Failure occurred during a ``ui/*`` method exchange.
tool-exec      All other failures — the server understood the request but the
               tool itself erred.
"""

from __future__ import annotations

from typing import Any

# JSON-RPC 2.0 standard error codes
_PARSE_ERROR = -32700
_INVALID_REQUEST = -32600
_METHOD_NOT_FOUND = -32601
_INVALID_PARAMS = -32602

Layer = str  # "transport" | "protocol" | "ui-handshake" | "tool-exec"


def classify_error(
    error: dict[str, Any],
    context: dict[str, Any] | None = None,
) -> Layer:
    """Classify an MCP error into its originating protocol layer.

    Args:
        error: The ``error`` object from a JSON-RPC response, containing at
            least a ``code`` (int) and ``message`` (str).
        context: Optional dict of additional flags:
            - ``spawn_failed`` (bool): True when the server process could not
              start.
            - ``pipe_broken`` (bool): True when the stdio pipe was lost.
            - ``method`` (str): The method name that triggered the error.

    Returns:
        A string literal identifying the layer:
        ``"transport"``, ``"protocol"``, ``"ui-handshake"``, or
        ``"tool-exec"``.

    Example::

        >>> classify_error({"code": -32601, "message": "Method not found"})
        'protocol'
        >>> classify_error({"code": -99}, {"method": "ui/initialize"})
        'ui-handshake'
    """
    ctx = context or {}
    code: int = error.get("code", 0)

    # --- Layer 1: Transport ---
    if ctx.get("spawn_failed") or ctx.get("pipe_broken"):
        return "transport"
    if code == _PARSE_ERROR:
        return "transport"

    # --- Layer 2: Protocol ---
    if code in (_INVALID_REQUEST, _METHOD_NOT_FOUND, _INVALID_PARAMS):
        return "protocol"

    # --- Layer 4: UI Handshake ---
    method: str = ctx.get("method", "")
    if method.startswith("ui/"):
        return "ui-handshake"

    # --- Layer 3: Tool Execution (default) ---
    return "tool-exec"
