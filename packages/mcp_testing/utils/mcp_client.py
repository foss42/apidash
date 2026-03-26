"""Lightweight JSON-RPC 2.0 MCP client for stdio-based MCP servers.

This module provides a synchronous MCP client that communicates with a server
process via stdin/stdout pipes, as specified by the MCP protocol.
"""

from __future__ import annotations

import json
import subprocess
import threading
from typing import Any


class McpClientError(Exception):
    """Raised when an MCP client operation fails."""


class JsonRpcError(McpClientError):
    """Raised when the server returns a JSON-RPC error response."""

    def __init__(self, code: int, message: str, data: Any = None) -> None:
        """Initialise with JSON-RPC error fields.

        Args:
            code: The JSON-RPC error code.
            message: The human-readable error message.
            data: Optional additional error data.
        """
        super().__init__(f"[{code}] {message}")
        self.code = code
        self.data = data


class McpClient:
    """A synchronous MCP client that communicates via stdio transport.

    Spawns an MCP server as a child process and exchanges JSON-RPC 2.0
    messages over its stdin/stdout pipes. Designed for testing and audit
    use-cases where tight control over the connection lifecycle is required.

    Example::

        client = McpClient(command=["npx", "@modelcontextprotocol/server-everything"])
        with client:
            result = client.send("tools/list", {})
            print(result)
    """

    def __init__(
        self,
        command: list[str],
        env: dict[str, str] | None = None,
        timeout: float = 5.0,
    ) -> None:
        """Initialise the client without starting the server process.

        Args:
            command: The command and arguments to spawn the MCP server.
            env: Optional extra environment variables merged into the process env.
            timeout: Seconds to wait for a response before raising a timeout.
        """
        self._command = command
        self._env = env or {}
        self._timeout = timeout
        self._proc: subprocess.Popen[str] | None = None
        self._pending: dict[int, Any] = {}
        self._lock = threading.Lock()
        self._reader: threading.Thread | None = None
        self._next_id = 0

    # ------------------------------------------------------------------
    # Context manager helpers
    # ------------------------------------------------------------------

    def connect(self) -> None:
        """Spawn the server process and start the reader thread."""
        import os

        merged_env = {**os.environ, **self._env}
        self._proc = subprocess.Popen(
            self._command,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            bufsize=1,
            env=merged_env,
        )
        self._reader = threading.Thread(target=self._read_loop, daemon=True)
        self._reader.start()

    def disconnect(self) -> None:
        """Terminate the server process and clean up resources."""
        if self._proc and self._proc.poll() is None:
            self._proc.terminate()
            try:
                self._proc.wait(timeout=2)
            except subprocess.TimeoutExpired:
                self._proc.kill()
        self._proc = None

    def __enter__(self) -> McpClient:
        """Connect when used as a context manager."""
        self.connect()
        return self

    def __exit__(self, *_: object) -> None:
        """Disconnect when exiting the context manager."""
        self.disconnect()

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def send(self, method: str, params: dict[str, Any]) -> Any:
        """Send a JSON-RPC request and wait for the response.

        Args:
            method: The JSON-RPC method name (e.g. ``"tools/list"``).
            params: The parameters dict for the request.

        Returns:
            The ``result`` field from the server's response.

        Raises:
            McpClientError: If the server process is not running.
            JsonRpcError: If the server returns a JSON-RPC error.
            TimeoutError: If no response is received within *timeout* seconds.
        """
        if self._proc is None:
            raise McpClientError("Client is not connected. Call connect() first.")

        msg_id = self._allocate_id()
        event = threading.Event()
        response_holder: list[Any] = []

        with self._lock:
            self._pending[msg_id] = (event, response_holder)

        request = {
            "jsonrpc": "2.0",
            "id": msg_id,
            "method": method,
            "params": params,
        }
        assert self._proc.stdin is not None  # noqa: S101 (test-only code)
        self._proc.stdin.write(json.dumps(request) + "\n")
        self._proc.stdin.flush()

        if not event.wait(timeout=self._timeout):
            with self._lock:
                self._pending.pop(msg_id, None)
            raise TimeoutError(
                f"No response for method '{method}' within {self._timeout}s"
            )

        payload = response_holder[0]
        if "error" in payload:
            err = payload["error"]
            raise JsonRpcError(err["code"], err["message"], err.get("data"))
        return payload.get("result")

    def notify(self, method: str, params: dict[str, Any]) -> None:
        """Send a JSON-RPC notification (no response expected).

        Args:
            method: The JSON-RPC method name.
            params: The parameters dict.
        """
        if self._proc is None:
            raise McpClientError("Client is not connected.")
        msg = {"jsonrpc": "2.0", "method": method, "params": params}
        assert self._proc.stdin is not None  # noqa: S101
        self._proc.stdin.write(json.dumps(msg) + "\n")
        self._proc.stdin.flush()

    # ------------------------------------------------------------------
    # Internals
    # ------------------------------------------------------------------

    def _allocate_id(self) -> int:
        """Return the next monotonically increasing request ID."""
        self._next_id += 1
        return self._next_id

    def _read_loop(self) -> None:
        """Background thread: read lines from stdout and resolve pending futures."""
        assert self._proc and self._proc.stdout  # noqa: S101
        for line in self._proc.stdout:
            line = line.strip()
            if not line:
                continue
            try:
                msg = json.loads(line)
            except json.JSONDecodeError:
                continue
            msg_id = msg.get("id")
            if msg_id is None:
                continue
            with self._lock:
                entry = self._pending.pop(msg_id, None)
            if entry is not None:
                event, holder = entry
                holder.append(msg)
                event.set()
