import { useEffect, useRef } from "react";
import { useParams, Link } from "react-router-dom";
import ResultsTable from "../components/ResultsTable";
import ComparisonView from "../components/ComparisonView";
import LiveProgress from "../components/LiveProgress";
import { useApi } from "../hooks/useApi";
import type { JobDetail } from "../types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Plus, AlertCircle } from "lucide-react";

type StatusKey = "completed" | "failed" | "running" | "pending";

const STATUS_VARIANT: Record<StatusKey, "success" | "destructive" | "warning" | "secondary"> = {
  completed: "success",
  failed:    "destructive",
  running:   "warning",
  pending:   "secondary",
};

const STATUS_LABEL: Record<StatusKey, string> = {
  completed: "Completed",
  failed:    "Failed",
  running:   "Running",
  pending:   "Pending",
};

export default function ResultsPage() {
  const { jobId } = useParams<{ jobId: string }>();
  const api = useApi<JobDetail>();
  const pollRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const fetchJob = () => { if (jobId) api.get(`/jobs/${jobId}`); };

  useEffect(() => {
    fetchJob();
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, [jobId]);

  useEffect(() => {
    const status = api.data?.job?.status;
    if (status === "running" || status === "pending") {
      pollRef.current = setInterval(fetchJob, 3000);
    } else {
      if (pollRef.current) { clearInterval(pollRef.current); pollRef.current = null; }
    }
    return () => { if (pollRef.current) clearInterval(pollRef.current); };
  }, [api.data?.job?.status]);

  if (api.loading && !api.data) {
    return (
      <div className="flex items-center justify-center py-24">
        <span className="h-6 w-6 animate-spin rounded-full border-2 border-border border-t-primary" />
      </div>
    );
  }

  if (api.error && !api.data) {
    return (
      <Card className="border-destructive/20 bg-destructive/10 p-6">
        <div className="flex items-start gap-3">
          <AlertCircle className="mt-0.5 h-4 w-4 text-destructive" />
          <div>
            <p className="text-sm text-destructive">Error loading results: {api.error}</p>
            <Link to="/" className="mt-2 inline-flex items-center gap-1 text-xs text-primary hover:underline">
              ← Back to Evaluate
            </Link>
          </div>
        </div>
      </Card>
    );
  }

  if (!api.data) return null;

  const { job, results, cost_summary } = api.data;
  const providers = job.providers;
  const isRunning = job.status === "running" || job.status === "pending";
  const statusKey = (job.status as StatusKey) in STATUS_VARIANT ? job.status as StatusKey : "pending";
  const ec = job.eval_config;
  const hasEvalConfig = ec && (ec.temperature != null || ec.max_tokens != null || ec.system_prompt);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-start justify-between gap-4">
        <div className="min-w-0">
          <div className="flex items-center gap-2.5">
            <h1 className="truncate text-xl font-bold text-foreground">{job.name}</h1>
            <Badge variant={STATUS_VARIANT[statusKey]}>
              {STATUS_LABEL[statusKey]}
              {isRunning && (
                <span className="ml-1.5 inline-flex">
                  <span className="h-1.5 w-1.5 animate-ping rounded-full bg-current opacity-75" />
                </span>
              )}
            </Badge>
          </div>
          <p className="mt-1 text-sm text-muted-foreground">
            {job.modality.replace(/_/g, " ")} · {providers.join(" vs ")}
          </p>
        </div>
        <Button asChild variant="outline" size="sm" className="shrink-0 gap-1.5">
          <Link to="/">
            <Plus className="h-3.5 w-3.5" />
            New Evaluation
          </Link>
        </Button>
      </div>

      {/* Eval config pill row */}
      {hasEvalConfig && (
        <Card>
          <CardContent className="flex flex-wrap items-center gap-2 py-2.5">
            <span className="text-xs font-medium text-muted-foreground">Request params</span>
            <span className="text-muted-foreground/30">·</span>
            {ec?.temperature != null && (
              <span className="flex items-center gap-1 rounded-md bg-muted px-2 py-0.5 text-xs">
                <span className="text-muted-foreground">temp</span>
                <span className="font-mono text-primary">{ec.temperature}</span>
              </span>
            )}
            {ec?.max_tokens != null && (
              <span className="flex items-center gap-1 rounded-md bg-muted px-2 py-0.5 text-xs">
                <span className="text-muted-foreground">max_tokens</span>
                <span className="font-mono text-primary">{ec.max_tokens}</span>
              </span>
            )}
            {ec?.system_prompt && (
              <span
                className="flex items-center gap-1 rounded-md bg-muted px-2 py-0.5 text-xs"
                title={ec.system_prompt}
              >
                <span className="text-muted-foreground">system</span>
                <span className="font-mono text-primary">
                  "{ec.system_prompt.slice(0, 40)}{ec.system_prompt.length > 40 ? "…" : ""}"
                </span>
              </span>
            )}
          </CardContent>
        </Card>
      )}

      {/* Running banner */}
      {isRunning && (
        <Card className="border-amber-500/20 bg-amber-500/10">
          <CardContent className="flex items-center gap-3 py-3">
            <span className="relative flex h-2 w-2">
              <span className="absolute h-2 w-2 animate-ping rounded-full bg-amber-400/50" />
              <span className="h-2 w-2 rounded-full bg-amber-400" />
            </span>
            <p className="text-sm text-amber-300">
              Evaluation in progress — results appear as they complete.
              {results.length > 0 && (
                <span className="ml-1.5 text-amber-400/60">{results.length} items so far</span>
              )}
            </p>
          </CardContent>
        </Card>
      )}

      <LiveProgress streamUrl={null} onComplete={() => {}} />

      {/* Results */}
      {results.length > 0 && (
        <Tabs defaultValue="comparison">
          <TabsList className="w-full">
            <TabsTrigger value="comparison" className="flex-1">Comparison</TabsTrigger>
            <TabsTrigger value="table" className="flex-1">Detailed Results</TabsTrigger>
          </TabsList>
          <TabsContent value="comparison" className="mt-4">
            <ComparisonView results={results} providers={providers} costSummary={cost_summary} />
          </TabsContent>
          <TabsContent value="table" className="mt-4">
            <ResultsTable results={results} providers={providers} />
          </TabsContent>
        </Tabs>
      )}

      {!isRunning && results.length === 0 && (
        <div className="rounded-xl border border-dashed border-border p-12 text-center">
          <p className="text-sm text-muted-foreground/50">No results available for this job.</p>
        </div>
      )}
    </div>
  );
}
