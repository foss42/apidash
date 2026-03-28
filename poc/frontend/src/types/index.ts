/* Shared TypeScript types for the eval dashboard. */

export type TaskKind =
  | "image_understanding"
  | "image_generation"
  | "audio_stt"
  | "audio_tts"
  | "video_understanding"
  | "text";

export type JobStatus = "pending" | "running" | "completed" | "failed" | "canceled";

export interface ProviderModel {
  id: string;
  modalities: TaskKind[];
}

export interface Provider {
  id: string;
  name: string;
  type: "cloud" | "local";
  available?: boolean;
  api_key_set?: boolean;
  supported_modalities: TaskKind[];
  models: string[];
}

export interface Dataset {
  id: string;
  name: string;
  modality: string;
  item_count: number;
  created_at: string;
}

export interface ProviderSelection {
  id: string;
  model: string;
}

export interface EvalRequest {
  name: string;
  dataset_id: string;
  modality: TaskKind;
  providers: ProviderSelection[];
  config: Record<string, unknown>;
}

export interface EvalStartResponse {
  job_id: string;
  status: string;
  stream_url: string;
}

export interface MetricScore {
  metric_id: string;
  score: number;
  raw_value?: unknown;
  explanation?: string;
}

export interface ItemProviderResult {
  response?: string;
  metrics: Record<string, number>;
  latency_ms: number;
  cost_usd: number;
  error?: string;
  media_url?: string;
}

export interface ItemResult {
  item_index: number;
  prompt: string;
  expected?: string;
  providers: Record<string, ItemProviderResult>;
}

export interface CostSummary {
  total_tokens: number;
  total_cost: number;
  avg_latency_ms: number;
}

export interface JobSummary {
  id: string;
  name: string;
  status: JobStatus;
  modality: string;
  providers: string[];
  created_at: string;
  summary: Record<string, unknown>;
  eval_config?: EvalConfig;
}

export interface JobDetail {
  job: JobSummary;
  results: ItemResult[];
  cost_summary: Record<string, CostSummary>;
}

export interface EvalConfig {
  temperature?: number;
  max_tokens?: number;
  system_prompt?: string;
}

export type BenchmarkStatus = "pending" | "running" | "completed" | "failed";

export interface BenchmarkRun {
  id: string;
  task_name: string;
  model_id: string;
  status: BenchmarkStatus;
  log_lines: string[];
  final_score: number | null;
  error_message: string | null;
  created_at: string;
  updated_at: string;
  details?: any;
}

/* SSE event types */
export type SSEEventType =
  | "started"
  | "progress"
  | "item_result"
  | "provider_done"
  | "complete"
  | "error";

export interface SSEProgressEvent {
  job_id: string;
  completed: number;
  total: number;
  pct: number;
  current_provider?: string;
  current_item?: number;
}

export interface SSECompleteEvent {
  job_id: string;
  summary: Record<string, unknown>;
}

export type ProviderStatusData = Provider;
