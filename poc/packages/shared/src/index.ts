import { z } from 'zod';

// ============================================================
// Enums
// ============================================================

export const SeveritySchema = z.enum(['critical', 'high', 'medium', 'low', 'info']);
export type Severity = z.infer<typeof SeveritySchema>;

export const AnalyzerNameSchema = z.enum([
  'tool-poisoning',
  'auth-credential',
  'protocol-compliance',
  'input-injection',
]);
export type AnalyzerName = z.infer<typeof AnalyzerNameSchema>;

export const TransportSchema = z.enum(['stdio', 'streamable-http', 'sse']);
export type Transport = z.infer<typeof TransportSchema>;

// ============================================================
// Finding (security scan result)
// ============================================================

export const FindingSchema = z.object({
  id: z.string(),
  analyzer: AnalyzerNameSchema,
  severity: SeveritySchema,
  title: z.string(),
  description: z.string(),
  toolName: z.string().optional(),
  evidence: z.string().optional(),
  remediation: z.string().optional(),
  timestamp: z.string(),
});
export type Finding = z.infer<typeof FindingSchema>;

// ============================================================
// Connection profiles
// ============================================================

export const StdioConfigSchema = z.object({
  command: z.string().min(1, 'Command is required'),
  args: z.array(z.string()),
  workingDirectory: z.string().optional(),
  env: z.record(z.string()).optional(),
});
export type StdioConfig = z.infer<typeof StdioConfigSchema>;

export const HttpConfigSchema = z.object({
  url: z.string().url('Must be a valid URL'),
  auth: z.enum(['none', 'oauth', 'bearer']).optional(),
  bearerToken: z.string().optional(),
});
export type HttpConfig = z.infer<typeof HttpConfigSchema>;

export const ConnectionProfileSchema = z.object({
  id: z.string(),
  name: z.string(),
  transport: TransportSchema,
  config: z.union([StdioConfigSchema, HttpConfigSchema]),
  createdAt: z.string(),
  lastUsed: z.string().optional(),
});
export type ConnectionProfile = z.infer<typeof ConnectionProfileSchema>;

// ============================================================
// Capability Registry types
// ============================================================

export const ToolInfoSchema = z.object({
  name: z.string(),
  description: z.string().optional(),
  inputSchema: z.record(z.unknown()),
});
export type ToolInfo = z.infer<typeof ToolInfoSchema>;

export const ResourceInfoSchema = z.object({
  uri: z.string(),
  name: z.string(),
  description: z.string().optional(),
  mimeType: z.string().optional(), // media type of the resource's content
});
export type ResourceInfo = z.infer<typeof ResourceInfoSchema>;

export const PromptArgumentSchema = z.object({
  name: z.string(),
  description: z.string().optional(),
  required: z.boolean().optional(),
});

export const PromptInfoSchema = z.object({
  name: z.string(),
  description: z.string().optional(),
  arguments: z.array(PromptArgumentSchema).optional(),
});
export type PromptInfo = z.infer<typeof PromptInfoSchema>;

export const ServerCapabilitiesSchema = z.object({
  serverInfo: z.object({
    name: z.string(),
    version: z.string(),
  }),
  capabilities: z.record(z.unknown()),
  protocolVersion: z.string().optional(),
  tools: z.array(ToolInfoSchema),
  resources: z.array(ResourceInfoSchema),
  prompts: z.array(PromptInfoSchema),
});
export type ServerCapabilities = z.infer<typeof ServerCapabilitiesSchema>;

// ============================================================
// Server scorecard
// ============================================================

export const ServerScorecardSchema = z.object({
  healthScore: z.number().min(0).max(100),
  securityScore: z.number().min(0).max(100),
  totalFindings: z.number().int().min(0),
  findings: z.object({
    critical: z.number().int().min(0),
    high: z.number().int().min(0),
    medium: z.number().int().min(0),
    low: z.number().int().min(0),
    info: z.number().int().min(0),
  }),
  generatedAt: z.string(),
});
export type ServerScorecard = z.infer<typeof ServerScorecardSchema>;

// ============================================================
// API request/response schemas
// ============================================================

export const ConnectRequestSchema = z.object({
  profile: ConnectionProfileSchema,
});
export type ConnectRequest = z.infer<typeof ConnectRequestSchema>;

export const InvokeRequestSchema = z.object({
  toolName: z.string().min(1, 'Tool name is required'),
  args: z.record(z.unknown()),
});
export type InvokeRequest = z.infer<typeof InvokeRequestSchema>;

export const InvokeResponseSchema = z.object({
  result: z.unknown(),
  isError: z.boolean(),
  latencyMs: z.number(),
});
export type InvokeResponse = z.infer<typeof InvokeResponseSchema>;

export const ScanResultSchema = z.object({
  score: z.number().min(0).max(100),
  findings: z.array(FindingSchema),
  severityCounts: z.record(z.number()),
  totalFindings: z.number().int().min(0),
  scannedAt: z.string(),
});
export type ScanResult = z.infer<typeof ScanResultSchema>;

export const StatusResponseSchema = z.object({
  connected: z.boolean(),
  serverInfo: z.object({ name: z.string(), version: z.string() }).nullable(),
});
export type StatusResponse = z.infer<typeof StatusResponseSchema>;

// ============================================================
// Security analyzer interface (not a Zod schema — runtime contract)
// ============================================================

export interface SecurityAnalyzer {
  name: AnalyzerName;
  analyze(capabilities: ServerCapabilities): Promise<Finding[]>;
}
