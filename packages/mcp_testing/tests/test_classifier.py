"""Unit tests for the 4-layer MCP error classifier.

Tests follow the plain pytest function style used throughout the repository.
No external dependencies are required — only the stdlib and the
``mcp_testing.utils.classifier`` module under test.
"""

from mcp_testing.utils.classifier import classify_error

# ---------------------------------------------------------------------------
# Transport layer
# ---------------------------------------------------------------------------


def test_classify_spawn_failed_is_transport() -> None:
    """spawn_failed context flag must yield transport layer."""
    result = classify_error({"code": 0, "message": ""}, {"spawn_failed": True})
    assert result == "transport"


def test_classify_pipe_broken_is_transport() -> None:
    """pipe_broken context flag must yield transport layer."""
    result = classify_error({"code": 0, "message": ""}, {"pipe_broken": True})
    assert result == "transport"


def test_classify_parse_error_is_transport() -> None:
    """JSON-RPC -32700 (Parse Error) must map to the transport layer."""
    result = classify_error({"code": -32700, "message": "Parse error"})
    assert result == "transport"


# ---------------------------------------------------------------------------
# Protocol layer
# ---------------------------------------------------------------------------


def test_classify_invalid_request_is_protocol() -> None:
    """-32600 (Invalid Request) must map to the protocol layer."""
    result = classify_error({"code": -32600, "message": "Invalid Request"})
    assert result == "protocol"


def test_classify_method_not_found_is_protocol() -> None:
    """-32601 (Method Not Found) must map to the protocol layer."""
    result = classify_error({"code": -32601, "message": "Method not found"})
    assert result == "protocol"


def test_classify_invalid_params_is_protocol() -> None:
    """-32602 (Invalid Params) must map to the protocol layer."""
    result = classify_error({"code": -32602, "message": "Invalid params"})
    assert result == "protocol"


# ---------------------------------------------------------------------------
# UI Handshake layer
# ---------------------------------------------------------------------------


def test_classify_ui_method_is_ui_handshake() -> None:
    """Any error on a ``ui/*`` method must map to the ui-handshake layer."""
    result = classify_error(
        {"code": -99, "message": "handshake failed"},
        {"method": "ui/initialize"},
    )
    assert result == "ui-handshake"


def test_classify_ui_notifications_is_ui_handshake() -> None:
    """``ui/notifications/*`` errors must also map to ui-handshake."""
    result = classify_error(
        {"code": -1, "message": "error"},
        {"method": "ui/notifications/initialized"},
    )
    assert result == "ui-handshake"


# ---------------------------------------------------------------------------
# Tool Execution layer (default)
# ---------------------------------------------------------------------------


def test_classify_tool_exec_is_default() -> None:
    """An unrecognised error code without context must fall back to tool-exec."""
    result = classify_error({"code": -32000, "message": "Internal server error"})
    assert result == "tool-exec"


def test_classify_non_ui_method_is_tool_exec() -> None:
    """A tools/call error with no special code must map to tool-exec."""
    result = classify_error(
        {"code": -32000, "message": "tool crashed"},
        {"method": "tools/call"},
    )
    assert result == "tool-exec"
