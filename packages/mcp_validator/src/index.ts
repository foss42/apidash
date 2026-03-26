import { 
  McpMessageSchema, 
  McpMessage
} from './schema/mcp_schema';

export type ValidationResult = {
  valid: boolean;
  type?: 'request' | 'response' | 'error';
  data?: McpMessage;
  error?: string;
  layer: 'transport' | 'protocol' | 'application';
}

/**
 * Validates a JSON-RPC message against the MCP specification.
 * 
 * @param message The raw JSON object to validate.
 * @returns A ValidationResult indicating validity and specific error details.
 */
export function validateMcpMessage(message: unknown): ValidationResult {
  if (typeof message !== 'object' || message === null) {
    return {
      valid: false,
      error: 'Message must be a non-null object',
      layer: 'transport'
    };
  }

  // Check JSON-RPC version
  const baseCheck = McpMessageSchema.safeParse(message);
  if (!baseCheck.success) {
    const errorMsg = baseCheck.error.errors.map(e => e.message).join(', ');
    return {
      valid: false,
      error: `Invalid JSON-RPC 2.0 structure: ${errorMsg}`,
      layer: 'protocol'
    };
  }

  const data = baseCheck.data;

  // Determine specific type
  if ('method' in data) {
    return { valid: true, type: 'request', data, layer: 'protocol' };
  }
  if ('error' in data) {
    return { valid: true, type: 'error', data, layer: 'protocol' };
  }
  if ('result' in data) {
    return { valid: true, type: 'response', data, layer: 'protocol' };
  }

  return {
    valid: false,
    error: 'Unknown message type',
    layer: 'protocol'
  };
}
