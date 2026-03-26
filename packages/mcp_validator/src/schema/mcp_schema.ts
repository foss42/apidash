import { z } from 'zod';

/**
 * JSON-RPC 2.0 Base Schema
 */
export const JsonRpcIdSchema = z.union([z.string(), z.number(), z.null()]);

export const JsonRpcBaseSchema = z.object({
  jsonrpc: z.literal('2.0'),
  id: JsonRpcIdSchema.optional(),
});

/**
 * MCP Request Schema
 */
export const McpRequestSchema = JsonRpcBaseSchema.extend({
  method: z.string(),
  params: z.record(z.unknown()).optional(),
}).strict();

/**
 * MCP Response Schema
 */
export const McpResponseSchema = JsonRpcBaseSchema.extend({
  result: z.unknown(),
}).strict().refine((data) => data.id !== undefined, {
  message: "Response must have an ID",
});

/**
 * MCP Error Schema
 */
export const McpErrorSchema = JsonRpcBaseSchema.extend({
  error: z.object({
    code: z.number(),
    message: z.string(),
    data: z.unknown().optional(),
  }).strict(),
}).strict().refine((data) => data.id !== undefined, {
  message: "Error response must have an ID",
});

/**
 * Unified MCP Message Schema
 */
export const McpMessageSchema = z.union([
  McpRequestSchema,
  McpResponseSchema,
  McpErrorSchema,
]);

export type McpRequest = z.infer<typeof McpRequestSchema>;
export type McpResponse = z.infer<typeof McpResponseSchema>;
export type McpError = z.infer<typeof McpErrorSchema>;
export type McpMessage = z.infer<typeof McpMessageSchema>;
