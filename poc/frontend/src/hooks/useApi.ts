import { useCallback, useState } from "react";

const BASE = "/api";
const UPLOAD_BASE = "http://localhost:8000/api";

interface ApiState<T> {
  data: T | null;
  loading: boolean;
  error: string | null;
}

async function apiFetch<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(`${BASE}${path}`, {
    headers: { "Content-Type": "application/json", ...init?.headers },
    ...init,
  });
  if (!res.ok) {
    const body = await res.text();
    throw new Error(body || `${res.status} ${res.statusText}`);
  }
  return res.json();
}

export function useApi<T>() {
  const [state, setState] = useState<ApiState<T>>({
    data: null,
    loading: false,
    error: null,
  });

  const get = useCallback(async (path: string) => {
    setState({ data: null, loading: true, error: null });
    try {
      const data = await apiFetch<T>(path);
      setState({ data, loading: false, error: null });
      return data;
    } catch (e) {
      const msg = e instanceof Error ? e.message : "Unknown error";
      setState({ data: null, loading: false, error: msg });
      throw e;
    }
  }, []);

  const post = useCallback(async (path: string, body?: unknown) => {
    setState({ data: null, loading: true, error: null });
    try {
      const data = await apiFetch<T>(path, {
        method: "POST",
        body: body ? JSON.stringify(body) : undefined,
      });
      setState({ data, loading: false, error: null });
      return data;
    } catch (e) {
      const msg = e instanceof Error ? e.message : "Unknown error";
      setState({ data: null, loading: false, error: msg });
      throw e;
    }
  }, []);

  const upload = useCallback(async (path: string, formData: FormData) => {
    setState({ data: null, loading: true, error: null });
    try {
      // Bypass Vite proxy for uploads — it can drop binary multipart data
      const res = await fetch(`${UPLOAD_BASE}${path}`, {
        method: "POST",
        body: formData,
      });
      if (!res.ok) {
        const body = await res.text();
        throw new Error(body || `${res.status}`);
      }
      const data: T = await res.json();
      setState({ data, loading: false, error: null });
      return data;
    } catch (e) {
      const msg = e instanceof Error ? e.message : "Unknown error";
      setState({ data: null, loading: false, error: msg });
      throw e;
    }
  }, []);

  return { ...state, get, post, upload };
}
