import json
from typing import Optional

import httpx
from fastmcp import FastMCP

mcp = FastMCP("API Dash")


@mcp.tool
async def send_request(
    url: str,
    method: str = "GET",
    headers: Optional[dict[str, str]] = None,
    body: Optional[str] = None,
) -> str:
    """Send an HTTP request and return the response.

    Args:
        url: The URL to send the request to.
        method: HTTP method (GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS).
        headers: Optional dictionary of HTTP headers.
        body: Optional request body as a string.
    """
    async with httpx.AsyncClient() as client:
        response = await client.request(
            method=method.upper(),
            url=url,
            headers=headers,
            content=body,
            timeout=30.0,
        )

        return json.dumps(
            {
                "status_code": response.status_code,
                "headers": dict(response.headers),
                "body": response.text,
            },
            indent=2,
        )


def main():
    """Entry point for the apidash-mcp console script."""
    mcp.run()


if __name__ == "__main__":
    main()
