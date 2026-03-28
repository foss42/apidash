import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import BenchmarkRunner from "../components/BenchmarkRunner";
import type { BenchmarkRun, ProviderStatusData } from "../types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Card, CardContent } from "@/components/ui/card";
import { ArrowLeft, Terminal, Trash2 } from "lucide-react";

type BenchmarkStatus = "pending" | "running" | "completed" | "failed";

const STATUS_VARIANT: Record<BenchmarkStatus, "secondary" | "warning" | "success" | "destructive"> = {
  pending:   "secondary",
  running:   "warning",
  completed: "success",
  failed:    "destructive",
};

export default function BenchmarksPage() {
  const navigate = useNavigate();
  const [runs, setRuns] = useState<BenchmarkRun[]>([]);
  const [providers, setProviders] = useState<ProviderStatusData[]>([]);
  const [lmEvalInstalled, setLmEvalInstalled] = useState<boolean | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([
      fetch("/api/benchmarks").then((res) => res.json()).catch(() => ({ runs: [] })),
      fetch("/api/providers").then((res) => res.json()).catch(() => ({ providers: [] })),
      fetch("/api/benchmarks/status").then((res) => res.json()).catch(() => ({ installed: false })),
    ])
      .then(([benchmarksData, providersData, statusData]) => {
        setRuns(benchmarksData.runs ?? []);
        setProviders(providersData.providers ?? []);
        setLmEvalInstalled(Boolean(statusData.installed));
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  const installCommand = "pip install lm-eval";

  const handleDeleteRun = async (runId: string) => {
    await fetch(`/api/benchmarks/${runId}`, { method: "DELETE" });
    setRuns((prev) => prev.filter((r) => r.id !== runId));
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <Button
          variant="ghost"
          size="sm"
          onClick={() => navigate("/")}
          className="text-muted-foreground"
        >
          <ArrowLeft className="h-4 w-4 mr-1" />
          Back
        </Button>
      </div>

      <div>
        <div className="flex items-center gap-2">
          <h1 className="text-xl font-bold text-foreground">Benchmarks</h1>
          <Badge variant="purple">lm-eval</Badge>
        </div>
        <p className="mt-1 text-sm text-muted-foreground">
          Run standard NLP benchmarks from lm-eval harness against your models.
        </p>
      </div>

      {!loading && lmEvalInstalled === false && (
        <Card className="border-amber-500/30 bg-amber-500/5">
          <CardContent className="py-4">
            <div className="flex items-start gap-3">
              <Terminal className="h-5 w-5 text-amber-400 shrink-0 mt-0.5" />
              <div className="flex-1">
                <p className="text-sm font-medium text-foreground">lm-eval not installed</p>
                <p className="text-xs text-muted-foreground mt-1">
                  Install it to run standard benchmarks:
                </p>
                <code className="mt-2 block rounded bg-muted px-2 py-1 text-xs font-mono text-primary">
                  {installCommand}
                </code>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      <BenchmarkRunner providers={providers} />

      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <h2 className="text-sm font-semibold text-foreground/80">Run History</h2>
          {runs.length > 0 && (
            <span className="text-xs text-muted-foreground">{runs.length} total</span>
          )}
        </div>

        {loading ? (
          <div className="flex justify-center py-8">
            <span className="h-5 w-5 animate-spin rounded-full border-2 border-border border-t-primary" />
          </div>
        ) : runs.length === 0 ? (
          <div className="rounded-xl border border-dashed border-border p-10 text-center">
            <p className="text-sm text-muted-foreground/50">No benchmark runs yet.</p>
            <p className="text-xs text-muted-foreground/40 mt-1">
              Configure the options above and click Run to start.
            </p>
          </div>
        ) : (
          <Card>
            <ScrollArea>
              <Table>
                <TableHeader>
                  <TableRow className="bg-muted/40">
                    <TableHead>Task</TableHead>
                    <TableHead>Model</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Score</TableHead>
                    <TableHead>Started</TableHead>
                    <TableHead className="w-8"></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {runs.map((run) => {
                    const statusKey = (run.status as BenchmarkStatus) in STATUS_VARIANT
                      ? run.status as BenchmarkStatus
                      : "pending";
                    const canDelete = run.status === "completed" || run.status === "failed";
                    return (
                      <TableRow key={run.id}>
                        <TableCell className="font-mono text-sm text-primary">{run.task_name}</TableCell>
                        <TableCell className="text-foreground/80">{run.model_id}</TableCell>
                        <TableCell>
                          <Badge variant={STATUS_VARIANT[statusKey]}>
                            {statusKey.charAt(0).toUpperCase() + statusKey.slice(1)}
                          </Badge>
                        </TableCell>
                        <TableCell className="font-mono">
                          {run.final_score != null ? (
                            <span className="font-semibold text-emerald-400">
                              {(run.final_score * 100).toFixed(2)}%
                            </span>
                          ) : run.status === "failed" ? (
                            <span className="text-xs text-destructive">{run.error_message ?? "—"}</span>
                          ) : (
                            <span className="text-muted-foreground/30">—</span>
                          )}
                        </TableCell>
                        <TableCell className="text-xs text-muted-foreground">
                          {new Date(run.created_at).toLocaleString()}
                        </TableCell>
                        <TableCell>
                          {canDelete && (
                            <button
                              onClick={() => handleDeleteRun(run.id)}
                              className="text-muted-foreground/40 hover:text-destructive transition"
                              title="Delete run"
                            >
                              <Trash2 className="h-3.5 w-3.5" />
                            </button>
                          )}
                        </TableCell>
                      </TableRow>
                    );
                  })}
                </TableBody>
              </Table>
            </ScrollArea>
          </Card>
        )}
      </div>
    </div>
  );
}
