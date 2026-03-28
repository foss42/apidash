"""SSE event helpers and async progress generator."""

from __future__ import annotations

import json
from enum import Enum
from typing import Any, AsyncGenerator


class SSEEventType(str, Enum):
    STARTED = "started"
    PROGRESS = "progress"
    ITEM_RESULT = "item_result"
    PROVIDER_DONE = "provider_done"
    COMPLETE = "complete"
    ERROR = "error"


def format_sse_event(event_type: SSEEventType, data: dict[str, Any]) -> dict:
    """Format an event for sse-starlette's EventSourceResponse."""
    return {
        "event": event_type.value,
        "data": json.dumps(data),
    }


async def heartbeat_wrapper(
    event_gen: AsyncGenerator[dict, None],
) -> AsyncGenerator[dict, None]:
    """Wrap an event generator with periodic keepalive pings."""
    async for event in event_gen:
        yield event
