"""Python MCP Audit Agent — automated probe for MCP servers.

This module implements an audit agent that connects to a live MCP server via
the stdio transport, discovers all available tools, and runs a suite of
protocol-level probes to validate compliance with the JSON-RPC 2.0 and MCP
specifications.

Each probe records a :class:`ProbeResult` that captures the raw response,
the classified error layer (if any), and a short description of the assertion
that was checked.

Typical usage::

    agent = AuditAgent(command=["npx", "@modelcontextprotocol/server-everything"])
    report = agent.run()
    print(report.summary())
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from mcp_testing.utils.classifier import Layer, classify_error
from mcp_testing.utils.mcp_client import JsonRpcError, McpClient, McpClientError


@dataclass
class ProbeResult:
    """Result of a single audit probe.

    Attributes:
        probe_name: Short identifier for the probe (e.g. ``"initialize"``).
        passed: Whether the probe assertion succeeded.
        description: Human-readable description of what was checked.
        layer: The protocol layer involved; ``None`` on success.
        raw_response: The raw server response dict, if any.
        error_message: The error string if the probe failed.
    """

    probe_name: str
    passed: bool
    description: str
    layer: Layer | None = None
    raw_response: dict[str, Any] | None = None
    error_message: str | None = None


@dataclass
class AuditReport:
    """Aggregated results from a full audit run.

    Attributes:
        command: The server command that was audited.
        results: Ordered list of :class:`ProbeResult` objects.
    """

    command: list[str]
    results: list[ProbeResult] = field(default_factory=list)

    # ------------------------------------------------------------------
    # Convenience helpers
    # ------------------------------------------------------------------

    @property
    def passed(self) -> int:
        """Return the number of probes that passed."""
        return sum(1 for r in self.results if r.passed)

    @property
    def failed(self) -> int:
        """Return the number of probes that failed."""
        return sum(1 for r in self.results if not r.passed)

    def summary(self) -> str:
        """Return a human-readable summary string.

        Returns:
            A multi-line string with pass/fail counts and per-probe details.
        """
        lines = [
            f"MCP Audit Report — {' '.join(self.command)}",
            f"{'='*60}",
            f"Passed: {self.passed} / {len(self.results)}",
            "",
        ]
        for r in self.results:
            status = "✓" if r.passed else "✗"
            layer_tag = f" [{r.layer}]" if r.layer else ""
            lines.append(f"  {status} {r.probe_name}{layer_tag}: {r.description}")
            if r.error_message:
                lines.append(f"      → {r.error_message}")
        return "\n".join(lines)

    def to_dict(self) -> dict[str, Any]:
        """Serialise the report to a JSON-compatible dict.

        Returns:
            A dict representing the full audit report.
        """
        return {
            "command": self.command,
            "passed": self.passed,
            "failed": self.failed,
            "total": len(self.results),
            "probes": [
                {
                    "name": r.probe_name,
                    "passed": r.passed,
                    "description": r.description,
                    "layer": r.layer,
                    "error": r.error_message,
                }
                for r in self.results
            ],
        }


class AuditAgent:
    """Automated audit agent for MCP servers.

    Connects to an MCP server via stdio transport and runs a suite of
    probes validating:

    - Successful initialisation handshake
    - ``tools/list`` returns a list
    - ``resources/list`` returns a list (or a graceful Method-Not-Found)
    - Invalid-method requests return the correct JSON-RPC error code
    - Invalid-params requests are classified at the protocol layer
    - ``tools/call`` with a missing tool name is rejected at the protocol layer

    Args:
        command: The command to spawn the MCP server (e.g. ``["python",
            "server.py"]``).
        env: Optional extra environment variables for the server process.
        timeout: Per-request timeout in seconds.

    Example::

        agent = AuditAgent(["npx", "@modelcontextprotocol/server-everything"])
        report = agent.run()
        print(report.summary())
    """

    # The client info sent during the MCP handshake.
    _CLIENT_INFO: dict[str, Any] = {
        "name": "apidash-mcp-audit-agent",
        "version": "0.1.0",
    }
    _CAPABILITIES: dict[str, Any] = {}

    def __init__(
        self,
        command: list[str],
        env: dict[str, str] | None = None,
        timeout: float = 5.0,
    ) -> None:
        """Initialise the audit agent.

        Args:
            command: Shell command to launch the MCP server.
            env: Extra environment variables for the server process.
            timeout: Per-request timeout in seconds.
        """
        self._command = command
        self._env = env or {}
        self._timeout = timeout

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def run(self) -> AuditReport:
        """Run all probes and return an :class:`AuditReport`.

        Returns:
            An :class:`AuditReport` containing per-probe results and
            aggregated pass/fail counts.
        """
        report = AuditReport(command=self._command)

        try:
            client = McpClient(
                command=self._command,
                env=self._env,
                timeout=self._timeout,
            )
            client.connect()
        except Exception as exc:  # noqa: BLE001
            report.results.append(
                ProbeResult(
                    probe_name="spawn",
                    passed=False,
                    description="Server process could not be started",
                    layer="transport",
                    error_message=str(exc),
                )
            )
            return report

        with client:
            self._probe_initialize(client, report)
            self._probe_tools_list(client, report)
            self._probe_resources_list(client, report)
            self._probe_invalid_method(client, report)
            self._probe_invalid_params(client, report)
            self._probe_missing_tool_name(client, report)

        return report

    # ------------------------------------------------------------------
    # Individual probes
    # ------------------------------------------------------------------

    def _probe_initialize(self, client: McpClient, report: AuditReport) -> None:
        """Probe: the initialize handshake must succeed and return serverInfo."""
        try:
            result = client.send(
                "initialize",
                {
                    "protocolVersion": "2024-11-05",
                    "clientInfo": self._CLIENT_INFO,
                    "capabilities": self._CAPABILITIES,
                },
            )
            passed = isinstance(result, dict) and "serverInfo" in result
            report.results.append(
                ProbeResult(
                    probe_name="initialize",
                    passed=passed,
                    description="initialize handshake returns serverInfo",
                    raw_response=result if isinstance(result, dict) else None,
                    error_message=(
                        None if passed else "serverInfo missing from response"
                    ),
                )
            )
        except (McpClientError, TimeoutError) as exc:
            report.results.append(
                ProbeResult(
                    probe_name="initialize",
                    passed=False,
                    description="initialize handshake returns serverInfo",
                    layer="transport",
                    error_message=str(exc),
                )
            )

    def _probe_tools_list(self, client: McpClient, report: AuditReport) -> None:
        """Probe: tools/list must return a list of tool descriptors."""
        try:
            result = client.send("tools/list", {})
            tools = result.get("tools", []) if isinstance(result, dict) else []
            passed = isinstance(tools, list)
            report.results.append(
                ProbeResult(
                    probe_name="tools/list",
                    passed=passed,
                    description="tools/list returns a list of tools",
                    raw_response=result if isinstance(result, dict) else None,
                    error_message=None if passed else "result.tools is not a list",
                )
            )
        except JsonRpcError as exc:
            layer = classify_error(
                {"code": exc.code, "message": str(exc)},
                {"method": "tools/list"},
            )
            report.results.append(
                ProbeResult(
                    probe_name="tools/list",
                    passed=False,
                    description="tools/list returns a list of tools",
                    layer=layer,
                    error_message=str(exc),
                )
            )

    def _probe_resources_list(
        self, client: McpClient, report: AuditReport
    ) -> None:
        """Probe: resources/list should return a list or -32601."""
        try:
            result = client.send("resources/list", {})
            resources = (
                result.get("resources", []) if isinstance(result, dict) else []
            )
            passed = isinstance(resources, list)
            report.results.append(
                ProbeResult(
                    probe_name="resources/list",
                    passed=passed,
                    description="resources/list returns a list or graceful -32601",
                    raw_response=result if isinstance(result, dict) else None,
                )
            )
        except JsonRpcError as exc:
            # -32601 is acceptable — not all servers expose resources.
            passed = exc.code == -32601
            layer = classify_error({"code": exc.code, "message": str(exc)})
            report.results.append(
                ProbeResult(
                    probe_name="resources/list",
                    passed=passed,
                    description="resources/list returns a list or graceful -32601",
                    layer=layer if not passed else None,
                    error_message=None if passed else str(exc),
                )
            )

    def _probe_invalid_method(self, client: McpClient, report: AuditReport) -> None:
        """Probe: an unknown method must return -32601 (Method Not Found)."""
        method = "audit/nonexistent_method_xyz"
        try:
            client.send(method, {})
            report.results.append(
                ProbeResult(
                    probe_name="invalid_method",
                    passed=False,
                    description="unknown method must return -32601",
                    error_message="Server returned a result instead of an error",
                )
            )
        except JsonRpcError as exc:
            passed = exc.code == -32601
            layer = classify_error(
                {"code": exc.code, "message": str(exc)},
                {"method": method},
            )
            report.results.append(
                ProbeResult(
                    probe_name="invalid_method",
                    passed=passed,
                    description="unknown method must return -32601",
                    layer=layer if not passed else None,
                    error_message=None if passed else str(exc),
                )
            )

    def _probe_invalid_params(self, client: McpClient, report: AuditReport) -> None:
        """Probe: missing required params should return -32602 (Invalid Params)."""
        method = "tools/call"
        try:
            # tools/call requires a 'name' field — deliberately omit it.
            client.send(method, {})
            report.results.append(
                ProbeResult(
                    probe_name="invalid_params",
                    passed=False,
                    description="tools/call with empty params returns -32602",
                    error_message="Server returned a result instead of an error",
                )
            )
        except JsonRpcError as exc:
            # -32602 or -32600 both indicate the server correctly rejected bad params.
            passed = exc.code in (-32602, -32600)
            layer = classify_error(
                {"code": exc.code, "message": str(exc)},
                {"method": method},
            )
            report.results.append(
                ProbeResult(
                    probe_name="invalid_params",
                    passed=passed,
                    description="tools/call with empty params returns -32602",
                    layer=layer if not passed else None,
                    error_message=None if passed else str(exc),
                )
            )

    def _probe_missing_tool_name(self, client: McpClient, report: AuditReport) -> None:
        """Probe: tools/call with a non-existent tool must not crash the server."""
        method = "tools/call"
        try:
            client.send(method, {"name": "__audit_nonexistent__", "arguments": {}})
            # Some servers return isError:true in result rather than a JSON-RPC error.
            report.results.append(
                ProbeResult(
                    probe_name="missing_tool_name",
                    passed=True,
                    description=(
                        "tools/call with unknown tool name is handled gracefully"
                    ),
                )
            )
        except JsonRpcError as exc:
            passed = exc.code in (-32601, -32602, -32603)
            layer = classify_error(
                {"code": exc.code, "message": str(exc)},
                {"method": method},
            )
            report.results.append(
                ProbeResult(
                    probe_name="missing_tool_name",
                    passed=passed,
                    description=(
                        "tools/call with unknown tool name is handled gracefully"
                    ),
                    layer=layer if not passed else None,
                    error_message=None if passed else str(exc),
                )
            )
