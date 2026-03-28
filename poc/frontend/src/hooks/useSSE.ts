import { useCallback, useEffect, useRef, useState } from "react";

interface SSEEvent {
  type: string;
  data: unknown;
}

interface UseSSEOptions {
  url: string | null;
  onEvent?: (event: SSEEvent) => void;
}

// SSE connects directly to backend to avoid Vite proxy buffering issues
const SSE_BASE = "http://localhost:8000";

export function useSSE({ url, onEvent }: UseSSEOptions) {
  const [connected, setConnected] = useState(false);
  const [events, setEvents] = useState<SSEEvent[]>([]);
  const [error, setError] = useState<string | null>(null);
  const sourceRef = useRef<EventSource | null>(null);
  const onEventRef = useRef(onEvent);
  onEventRef.current = onEvent;

  const close = useCallback(() => {
    if (sourceRef.current) {
      sourceRef.current.close();
      sourceRef.current = null;
      setConnected(false);
    }
  }, []);

  useEffect(() => {
    if (!url) return;

    // Connect directly to backend for SSE (bypass Vite proxy)
    const fullUrl = url.startsWith("http") ? url : `${SSE_BASE}${url}`;
    const eventSource = new EventSource(fullUrl);
    sourceRef.current = eventSource;

    eventSource.onopen = () => {
      setConnected(true);
      setError(null);
    };

    eventSource.onerror = () => {
      // Only set error if we never connected (not just a normal close)
      if (eventSource.readyState === EventSource.CLOSED) return;
      setError("SSE connection error");
      setConnected(false);
    };

    const eventTypes = [
      "started",
      "progress",
      "item_result",
      "provider_done",
      "complete",
      "error",
    ];

    for (const type of eventTypes) {
      eventSource.addEventListener(type, (e: MessageEvent) => {
        const parsed: SSEEvent = { type, data: JSON.parse(e.data) };
        setEvents((prev) => [...prev, parsed]);
        onEventRef.current?.(parsed);

        // Auto-close on complete or error
        if (type === "complete" || type === "error") {
          eventSource.close();
          setConnected(false);
        }
      });
    }

    return () => {
      eventSource.close();
      setConnected(false);
    };
  }, [url]);

  const reset = useCallback(() => {
    setEvents([]);
    setError(null);
  }, []);

  return { connected, events, error, close, reset };
}
