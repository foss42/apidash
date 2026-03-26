import { describe, it, expect } from 'vitest';
import { validateMcpMessage } from '../src/index';

describe('validateMcpMessage', () => {
  it('should validate a correct MCP request', () => {
    const request = {
      jsonrpc: '2.0',
      id: 1,
      method: 'tools/list',
      params: {}
    };
    const result = validateMcpMessage(request);
    expect(result.valid).toBe(true);
    expect(result.type).toBe('request');
  });

  it('should validate a correct MCP response', () => {
    const response = {
      jsonrpc: '2.0',
      id: 1,
      result: { tools: [] }
    };
    const result = validateMcpMessage(response);
    expect(result.valid).toBe(true);
    expect(result.type).toBe('response');
  });

  it('should validate a correct MCP error', () => {
    const error = {
      jsonrpc: '2.0',
      id: 1,
      error: {
        code: -32601,
        message: 'Method not found'
      }
    };
    const result = validateMcpMessage(error);
    expect(result.valid).toBe(true);
    expect(result.type).toBe('error');
  });

  it('should reject invalid JSON-RPC version', () => {
    const invalid = {
      jsonrpc: '1.0',
      id: 1,
      method: 'tools/list'
    };
    const result = validateMcpMessage(invalid);
    expect(result.valid).toBe(false);
    expect(result.layer).toBe('protocol');
    expect(result.error).toContain('Invalid JSON-RPC 2.0 structure');
  });

  it('should reject response without id', () => {
    const noId = {
      jsonrpc: '2.0',
      result: {}
    };
    const result = validateMcpMessage(noId);
    expect(result.valid).toBe(false);
    expect(result.error).toContain('Response must have an ID');
  });

  it('should reject non-object messages', () => {
    const result = validateMcpMessage('not an object');
    expect(result.valid).toBe(false);
    expect(result.layer).toBe('transport');
  });
});
