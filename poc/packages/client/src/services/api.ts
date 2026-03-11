import {
  ServerCapabilitiesSchema,
  InvokeResponseSchema,
  ScanResultSchema,
  StatusResponseSchema,
} from '@mcp-suite/shared';
import type {
  ServerCapabilities,
  ConnectionProfile,
  InvokeResponse,
  ScanResult,
  StatusResponse,
} from '@mcp-suite/shared';

const BASE = '/api';

async function request(path: string, options?: RequestInit): Promise<unknown> {
  const res = await fetch(`${BASE}${path}`, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error ?? `Request failed: ${res.status}`);
  return data;
}

export const api = {
  async connect(profile: ConnectionProfile): Promise<ServerCapabilities> {
    const data = await request('/connect', {
      method: 'POST',
      body: JSON.stringify({ profile }),
    });
    return ServerCapabilitiesSchema.parse(data);
  },

  async disconnect(): Promise<{ ok: boolean }> {
    const data = await request('/disconnect', { method: 'POST' });
    return data as { ok: boolean };
  },

  async getCapabilities(): Promise<ServerCapabilities> {
    const data = await request('/capabilities');
    return ServerCapabilitiesSchema.parse(data);
  },

  async invoke(toolName: string, args: Record<string, unknown>): Promise<InvokeResponse> {
    const data = await request('/invoke', {
      method: 'POST',
      body: JSON.stringify({ toolName, args }),
    });
    return InvokeResponseSchema.parse(data);
  },

  async scan(): Promise<ScanResult> {
    const data = await request('/security/scan', { method: 'POST' });
    return ScanResultSchema.parse(data);
  },

  async status(): Promise<StatusResponse> {
    const data = await request('/status');
    return StatusResponseSchema.parse(data);
  },
};
