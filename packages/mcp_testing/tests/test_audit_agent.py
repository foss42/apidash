"""Unit tests for the Audit Agent using a mock MCP server.

The mock server is implemented as a simple Python subprocess that reads
JSON-RPC requests from stdin and writes responses to stdout. This lets us
run the full Audit Agent integration tests without a real MCP server
installed in the test environment.
"""

import json
from unittest.mock import MagicMock

from mcp_testing.agents.audit_agent import AuditAgent, AuditReport, ProbeResult
from mcp_testing.utils.classifier import classify_error

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _make_mock_client(responses: dict) -> MagicMock:
    """Return a mock McpClient where send() returns pre-configured responses."""
    client = MagicMock()
    client.__enter__ = MagicMock(return_value=client)
    client.__exit__ = MagicMock(return_value=False)
    client.send.side_effect = lambda method, params: responses.get(method)
    return client


# ---------------------------------------------------------------------------
# ProbeResult tests
# ---------------------------------------------------------------------------


def test_probe_result_defaults() -> None:
    """ProbeResult must default layer and error_message to None."""
    result = ProbeResult(probe_name="test", passed=True, description="ok")
    assert result.layer is None
    assert result.error_message is None


def test_probe_result_failed_stores_error() -> None:
    """A failed ProbeResult must preserve the error_message."""
    result = ProbeResult(
        probe_name="test",
        passed=False,
        description="fail",
        layer="transport",
        error_message="connection refused",
    )
    assert not result.passed
    assert result.layer == "transport"
    assert "connection refused" in result.error_message


# ---------------------------------------------------------------------------
# AuditReport tests
# ---------------------------------------------------------------------------


def test_audit_report_passed_count() -> None:
    """AuditReport.passed must count only passing probes."""
    report = AuditReport(command=["server"])
    report.results = [
        ProbeResult("a", True, ""),
        ProbeResult("b", False, ""),
        ProbeResult("c", True, ""),
    ]
    assert report.passed == 2
    assert report.failed == 1


def test_audit_report_summary_contains_probe_names() -> None:
    """summary() output must include probe names."""
    report = AuditReport(command=["server"])
    report.results = [
        ProbeResult("initialize", True, "handshake ok"),
        ProbeResult("tools/list", False, "no tools", layer="protocol"),
    ]
    summary = report.summary()
    assert "initialize" in summary
    assert "tools/list" in summary
    assert "✓" in summary
    assert "✗" in summary


def test_audit_report_to_dict_structure() -> None:
    """to_dict() must return a JSON-serialisable dict with expected keys."""
    report = AuditReport(command=["server"])
    report.results = [
        ProbeResult("initialize", True, "ok"),
    ]
    d = report.to_dict()
    assert d["passed"] == 1
    assert d["failed"] == 0
    assert d["total"] == 1
    assert len(d["probes"]) == 1
    assert d["probes"][0]["name"] == "initialize"
    # Must be JSON-serialisable
    json.dumps(d)


# ---------------------------------------------------------------------------
# Classifier integration (used inside audit probes)
# ---------------------------------------------------------------------------


def test_classifier_used_in_tools_list_failure() -> None:
    """Verify the classifier produces 'protocol' for a -32601 tools/list error."""
    layer = classify_error(
        {"code": -32601, "message": "Method not found"},
        {"method": "tools/list"},
    )
    assert layer == "protocol"


def test_classifier_used_in_ui_probe() -> None:
    """Verify the classifier produces 'ui-handshake' for a ui/* failure."""
    layer = classify_error(
        {"code": -99, "message": "failed"},
        {"method": "ui/initialize"},
    )
    assert layer == "ui-handshake"


# ---------------------------------------------------------------------------
# AuditAgent spawn-failure smoke test
# ---------------------------------------------------------------------------


def test_audit_agent_handles_spawn_failure() -> None:
    """AuditAgent must record a transport-layer failure when spawn fails."""
    agent = AuditAgent(
        command=["__nonexistent_binary_that_does_not_exist__"],
        timeout=1.0,
    )
    report = agent.run()
    # The agent must not raise — it must capture the failure.
    assert isinstance(report, AuditReport)
    assert report.failed >= 1
    spawn_probe = next(r for r in report.results if r.probe_name == "spawn")
    assert not spawn_probe.passed
    assert spawn_probe.layer == "transport"
