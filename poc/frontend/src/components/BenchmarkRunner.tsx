import { useState, useRef, useEffect } from "react";
import { useLocation } from "react-router-dom";
import type { BenchmarkRun, ProviderStatusData } from "../types";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Play, AlertCircle, Loader2, Download, Check, Plus, X, RefreshCw, Square, Trash2, ChevronDown } from "lucide-react";

interface TaskInfo {
  name: string;
  description: string;
  category: string;
}

interface LmEvalStatus {
  installed: boolean;
  version: string | null;
  tasks: Record<string, TaskInfo>;
}

interface ModelSelection {
  providerId: string;
  modelId: string;
  id: string;
}

interface BenchmarkRunResults {
  results?: Record<string, Record<string, number | string>>;
  n_samples?: { original: number; effective: number };
  total_time?: number | string;
}

interface BenchmarkRunnerProps {
  providers?: ProviderStatusData[];
}

export default function BenchmarkRunner({ providers: externalProviders }: BenchmarkRunnerProps) {
  const location = useLocation();
  const presetState = location.state as { task?: string; sampleCount?: number } | null;

  const [providers, setProviders] = useState<ProviderStatusData[]>(externalProviders ?? []);
  const [lmEvalStatus, setLmEvalStatus] = useState<LmEvalStatus | null>(null);
  const [checking, setChecking] = useState(true);

  const [taskName, setTaskName] = useState<string>(presetState?.task ?? "gsm8k");
  const [customTask, setCustomTask] = useState<string>("");
  const [selectedModels, setSelectedModels] = useState<ModelSelection[]>([]);
  const [sampleLimit, setSampleLimit] = useState<number>(presetState?.sampleCount ?? 5);

  const [isRunning, setIsRunning] = useState(false);
  const [activeRuns, setActiveRuns] = useState<Record<string, { logs: string[]; score: number | null; status: string; results: BenchmarkRunResults | null }>>({});
  const [historicalRuns, setHistoricalRuns] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);
  const logEndRef = useRef<HTMLDivElement>(null);
  const esRefs = useRef<Record<string, EventSource>>({});
  const [expandedResults, setExpandedResults] = useState<Record<string, boolean>>({});

  useEffect(() => {
    fetchLmEvalStatus();
    fetchHistoricalRuns();
    if (externalProviders) {
      setProviders(externalProviders);
    } else {
      fetchProviders();
    }
  }, [externalProviders]);

  useEffect(() => {
    logEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [activeRuns]);

  useEffect(() => {
    return () => {
      Object.values(esRefs.current).forEach(es => es.close());
    };
  }, []);

  const fetchLmEvalStatus = async () => {
    setChecking(true);
    try {
      const res = await fetch("/api/benchmarks/status");
      const data = await res.json();
      setLmEvalStatus(data);
    } catch {
      setLmEvalStatus({ installed: false, version: null, tasks: {} });
    } finally {
      setChecking(false);
    }
  };

  const fetchProviders = async () => {
    try {
      const res = await fetch("/api/providers");
      const data = await res.json();
      setProviders(data.providers ?? []);
    } catch {}
  };

  const fetchHistoricalRuns = async () => {
    try {
      const res = await fetch("/api/benchmarks");
      const data = await res.json();
      setHistoricalRuns(data.runs || []);
    } catch {}
  };

  const availableProviders = providers.filter(
    (p) => p.available && p.supported_modalities.includes("text"),
  );

  const pickDefaultBenchmarkModel = (models: string[]) => {
    const preferredTextModel = models.find((model) => /^(qwen|smollm2)/i.test(model));
    if (preferredTextModel) return preferredTextModel;
    const nonVisionModel = models.find((model) => !/(llava|moondream|minicpm-v|vision)/i.test(model));
    return nonVisionModel ?? models[0] ?? "";
  };

  const addModel = (providerId: string) => {
    const provider = providers.find((p) => p.id === providerId);
    const defaultModel = pickDefaultBenchmarkModel(provider?.models ?? []);
    setSelectedModels((prev) => [
      ...prev,
      { providerId, modelId: defaultModel, id: `${providerId}-${Date.now()}` },
    ]);
  };

  const removeModel = (id: string) => {
    setSelectedModels((prev) => prev.filter((m) => m.id !== id));
  };

  const updateModel = (id: string, modelId: string) => {
    setSelectedModels((prev) => prev.map((m) => (m.id === id ? { ...m, modelId } : m)));
  };

  const getTaskInfo = (): TaskInfo => {
    if (taskName === "custom") {
      return { name: customTask || "Custom", description: "Custom task", category: "custom" };
    }
    return lmEvalStatus?.tasks?.[taskName] ?? { name: taskName, description: "", category: "unknown" };
  };

  const handleRun = async () => {
    if (!lmEvalStatus?.installed) {
      setError("lm-eval is not installed. Click 'Install lm-eval' first.");
      return;
    }
    const effectiveTask = taskName === "custom" ? customTask.trim() : taskName;
    if (!effectiveTask) {
      setError("Please select or enter a task name");
      return;
    }
    if (selectedModels.length === 0) {
      setError("Please add at least one model to compare");
      return;
    }

    setIsRunning(true);
    setError(null);
    setActiveRuns({});

    try {
      const res = await fetch("/api/benchmarks/multi", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          task_name: effectiveTask,
          providers: selectedModels.map((m) => ({ id: m.providerId, model: m.modelId })),
          num_samples: sampleLimit > 0 ? sampleLimit : null,
        }),
      });

      if (!res.ok) {
        const body = await res.text();
        let msg = body;
        try { msg = JSON.parse(body).detail ?? body; } catch {}
        setError(msg);
        setIsRunning(false);
        return;
      }

      const data = await res.json();
      const runs = data.runs as BenchmarkRun[];

      const initialRuns: Record<string, { logs: string[]; score: number | null; status: string; results: BenchmarkRunResults | null }> = {};
      runs.forEach((run) => {
        initialRuns[run.id] = { logs: [], score: null, status: "running", results: null };
      });
      setActiveRuns(initialRuns);

      runs.forEach((run) => {
        const es = new EventSource(`/api/benchmarks/${run.id}/stream`);
        esRefs.current[run.id] = es;

        es.addEventListener("log", (e) => {
          const eventData = JSON.parse(e.data);
          setActiveRuns((prev) => ({
            ...prev,
            [run.id]: {
              ...prev[run.id],
              logs: [...prev[run.id].logs, eventData.line],
            },
          }));
        });

        es.addEventListener("complete", (e) => {
          const eventData = JSON.parse(e.data);
          setActiveRuns((prev) => ({
            ...prev,
            [run.id]: {
              ...prev[run.id],
              score: eventData.final_score,
              status: "completed",
              results: eventData.details || null,
            },
          }));
          es.close();
          delete esRefs.current[run.id];
          checkAllComplete();
        });

        es.addEventListener("error", (e) => {
          const eventData = (e as MessageEvent).data ? JSON.parse((e as MessageEvent).data) : {};
          setActiveRuns((prev) => ({
            ...prev,
            [run.id]: {
              ...prev[run.id],
              status: "failed",
              logs: [...prev[run.id].logs, `Error: ${eventData.error || "Unknown error"}`],
            },
          }));
          es.close();
          delete esRefs.current[run.id];
          checkAllComplete();
        });
      });
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unknown error");
      setIsRunning(false);
    }
  };

  const checkAllComplete = () => {
    setTimeout(() => {
      const allDone = Object.values(esRefs.current).length === 0;
      if (allDone) {
        setIsRunning(false);
      }
    }, 100);
  };

  const handleCancelRun = async (runId: string) => {
    esRefs.current[runId]?.close();
    delete esRefs.current[runId];
    await fetch(`/api/benchmarks/${runId}/cancel`, { method: "POST" });
    setActiveRuns((prev) => ({
      ...prev,
      [runId]: { ...prev[runId], status: "failed", logs: [...prev[runId].logs, "Cancelled by user"] },
    }));
    checkAllComplete();
  };

  const handleDeleteRun = async (runId: string) => {
    await fetch(`/api/benchmarks/${runId}`, { method: "DELETE" });
    setActiveRuns((prev) => {
      const next = { ...prev };
      delete next[runId];
      return next;
    });
  };

  const taskInfo = getTaskInfo();

  if (checking) {
    return (
      <Card>
        <CardContent className="flex items-center gap-3 py-6">
          <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
          <p className="text-sm text-muted-foreground">Checking for lm-eval…</p>
        </CardContent>
      </Card>
    );
  }

  if (!lmEvalStatus?.installed) {
    return (
      <Card className="border-amber-500/30 bg-amber-500/5">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <div className="flex h-6 w-6 items-center justify-center rounded-md bg-amber-500/20">
                <Download className="h-3.5 w-3.5 text-amber-400" />
              </div>
              <CardTitle className="text-sm">lm-eval not detected</CardTitle>
            </div>
            <Button
              variant="ghost"
              size="sm"
              onClick={fetchLmEvalStatus}
              disabled={checking}
              className="h-7 gap-1.5 text-xs text-muted-foreground"
            >
              {checking ? (
                <Loader2 className="h-3.5 w-3.5 animate-spin" />
              ) : (
                <RefreshCw className="h-3.5 w-3.5" />
              )}
              Re-check
            </Button>
          </div>
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="text-sm text-muted-foreground">
            lm-eval is not found in the active Python environment. Install it, then click{" "}
            <span className="font-medium text-foreground">Re-check</span>.
          </div>
          <div className="rounded-lg border border-border bg-muted/30 px-3 py-2.5">
            <div className="mb-1 text-[10px] font-medium text-muted-foreground uppercase tracking-wide">Install command</div>
            <code className="text-xs text-primary font-mono">pip install lm-eval</code>
          </div>
          <div className="text-[11px] text-muted-foreground/50">
            Make sure to install into the same Python environment the backend server is running in.
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="flex h-6 w-6 items-center justify-center rounded-md bg-purple-500/20">
              <Play className="h-3.5 w-3.5 text-purple-400" />
            </div>
            <CardTitle className="text-sm">Run Benchmark</CardTitle>
          </div>
          <div className="flex items-center gap-2">
            {lmEvalStatus?.version && (
              <Badge variant="secondary" className="text-[10px]">
                v{lmEvalStatus.version}
              </Badge>
            )}
            <Badge variant="purple">lm-eval</Badge>
          </div>
        </div>
      </CardHeader>

      <CardContent className="space-y-4">
        {/* Task Selection */}
        <div className="space-y-1.5">
          <Label>Benchmark Task</Label>
          <div className="grid grid-cols-1 gap-2 md:grid-cols-2">
            <Select value={taskName} onValueChange={setTaskName} disabled={isRunning}>
              <SelectTrigger>
                <SelectValue placeholder="Select a benchmark" />
              </SelectTrigger>
              <SelectContent>
                {lmEvalStatus?.tasks && Object.entries(lmEvalStatus.tasks).map(([id, info]) => (
                  <SelectItem key={id} value={id}>
                    <div className="flex flex-col">
                      <span className="font-medium">{info.name}</span>
                      <span className="text-[10px] text-muted-foreground">{info.description}</span>
                    </div>
                  </SelectItem>
                ))}
                <SelectItem value="custom">Custom task...</SelectItem>
              </SelectContent>
            </Select>
            {taskName === "custom" && (
              <Input
                value={customTask}
                onChange={(e) => setCustomTask(e.target.value)}
                placeholder="e.g., truthfulqa_mc2"
                disabled={isRunning}
              />
            )}
          </div>
          {taskInfo.category !== "custom" && (
            <div className="text-[11px] text-muted-foreground">
              Category: <span className="font-medium">{taskInfo.category}</span>
            </div>
          )}
        </div>

        {/* Models Selection */}
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <Label>Models to Compare</Label>
            <span className="text-[11px] text-muted-foreground">{selectedModels.length} selected</span>
          </div>

          {selectedModels.length > 0 && (
            <div className="space-y-1.5">
              {selectedModels.map((model) => {
                const provider = providers.find((p) => p.id === model.providerId);
                const models = provider?.models ?? [];
                return (
                  <div key={model.id} className="flex items-center gap-2 rounded-lg border border-primary/30 bg-primary/5 px-3 py-2">
                    <div className="text-[10px] font-medium text-muted-foreground">{model.providerId}</div>
                    {models.length > 0 ? (
                      <Select value={model.modelId} onValueChange={(v) => updateModel(model.id, v)} disabled={isRunning}>
                        <SelectTrigger className="h-7 flex-1 text-xs">
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {models.map((m: string) => (
                            <SelectItem key={m} value={m}>{m}</SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    ) : (
                      <Input
                        value={model.modelId}
                        onChange={(e) => updateModel(model.id, e.target.value)}
                        placeholder="model name"
                        disabled={isRunning}
                        className="h-7 flex-1 text-xs"
                      />
                    )}
                    <button
                      onClick={() => removeModel(model.id)}
                      disabled={isRunning}
                      className="text-muted-foreground hover:text-destructive transition"
                    >
                      <X className="h-4 w-4" />
                    </button>
                  </div>
                );
              })}
            </div>
          )}

          <div className="flex flex-wrap gap-1.5">
            {availableProviders.map((p) => (
              <Button
                key={p.id}
                variant="outline"
                size="sm"
                onClick={() => addModel(p.id)}
                disabled={isRunning}
                className="h-7 gap-1 text-xs"
              >
                <Plus className="h-3 w-3" />
                {p.name}
              </Button>
            ))}
          </div>
        </div>

        {/* Sample Limit */}
        <div className="space-y-1.5">
          <Label>Sample Limit (optional)</Label>
          <Input
            type="number"
            min={0}
            value={sampleLimit}
            onChange={(e) => setSampleLimit(parseInt(e.target.value) || 0)}
            placeholder="0 = all samples"
            disabled={isRunning}
            className="max-w-32"
          />
          <div className="text-[11px] text-muted-foreground">
            Use a small number (5-20) for quick tests. 0 runs the full benchmark.
          </div>
        </div>

        {/* Run Button */}
        <Button
          onClick={handleRun}
          disabled={!lmEvalStatus?.installed || isRunning || selectedModels.length === 0}
          className="w-full gap-2 bg-purple-600 text-white shadow-lg shadow-purple-600/20 hover:bg-purple-500"
          size="lg"
        >
          {isRunning ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" />
              Running {Object.keys(activeRuns).length} models...
            </>
          ) : (
            <>
              <Play className="h-4 w-4" />
              Run Benchmark {selectedModels.length > 0 ? `(${selectedModels.length} models)` : ""}
            </>
          )}
        </Button>

        {/* Error Display */}
        {error && (
          <div className="flex items-start gap-2 rounded-lg border border-destructive/20 bg-destructive/10 px-3 py-2.5">
            <AlertCircle className="mt-0.5 h-4 w-4 shrink-0 text-destructive" />
            <div className="text-sm text-destructive">{error}</div>
          </div>
        )}

        {/* Active Runs Display */}
        {Object.keys(activeRuns).length > 0 && (
          <div className="space-y-3">
            <Label>Results</Label>
            <div className="grid grid-cols-1 gap-3 md:grid-cols-2">
              {Object.entries(activeRuns).map(([runId, run]) => {
                const modelConfig = selectedModels.find((_, i) => i === Object.keys(activeRuns).indexOf(runId));
                return (
                  <Card key={runId} className="border-border/50">
                    <CardContent className="p-3">
                      <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <div className="text-[10px] text-muted-foreground">{modelConfig?.providerId}</div>
                          <div className="text-xs font-medium">{modelConfig?.modelId}</div>
                        </div>
                        <div className="flex items-center gap-1.5">
                          {run.status === "completed" ? (
                            <>
                              <Badge variant="success" className="gap-1">
                                <Check className="h-3 w-3" />
                                {run.score !== null ? `${(run.score * 100).toFixed(1)}%` : "Done"}
                              </Badge>
                              <button
                                onClick={() => handleDeleteRun(runId)}
                                className="text-muted-foreground hover:text-destructive transition"
                                title="Delete run"
                              >
                                <Trash2 className="h-3.5 w-3.5" />
                              </button>
                            </>
                          ) : run.status === "failed" ? (
                            <>
                              <Badge variant="destructive">Failed</Badge>
                              <button
                                onClick={() => handleDeleteRun(runId)}
                                className="text-muted-foreground hover:text-destructive transition"
                                title="Delete run"
                              >
                                <Trash2 className="h-3.5 w-3.5" />
                              </button>
                            </>
                          ) : (
                            <>
                              <Badge variant="warning">
                                <Loader2 className="h-3 w-3 animate-spin mr-1" />
                                Running
                              </Badge>
                              <button
                                onClick={() => handleCancelRun(runId)}
                                className="text-muted-foreground hover:text-destructive transition"
                                title="Cancel run"
                              >
                                <Square className="h-3.5 w-3.5" />
                              </button>
                            </>
                          )}
                        </div>
                      </div>
                      {run.logs.length > 0 && (
                        <ScrollArea className="h-24 rounded border border-border/50 bg-muted/30 p-2">
                          <pre className="text-[10px] text-muted-foreground whitespace-pre-wrap">
                            {run.logs.slice(-20).join("\n")}
                          </pre>
                        </ScrollArea>
                      )}
                      
                      {run.status === "completed" && run.results && (
                        <div className="mt-3">
                          <button
                            onClick={() => setExpandedResults({ ...expandedResults, [runId]: !expandedResults[runId] })}
                            className="w-full flex items-center justify-between px-3 py-2 text-sm rounded border border-border/50 bg-muted/10 hover:bg-muted/30 transition-colors"
                          >
                            <div className="flex items-center gap-2">
                              <Check className="h-3.5 w-3.5 text-primary" />
                              <span className="font-medium">Benchmark Complete</span>
                            </div>
                            <div className="flex items-center gap-4">
                              {run.score !== null && (
                                <div className="text-right flex items-center gap-1.5">
                                  <span className="text-xs text-muted-foreground uppercase tracking-wide">Score</span>
                                  <span className="font-mono font-bold">{(run.score * 100).toFixed(1)}%</span>
                                </div>
                              )}
                              <ChevronDown className={`h-4 w-4 text-muted-foreground transition-transform ${expandedResults[runId] ? 'rotate-180' : ''}`} />
                            </div>
                          </button>

                          {expandedResults[runId] && (
                            <DetailedResultsView results={run.results} />
                          )}
                        </div>
                      )}
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </div>
        )}

        {/* Historical Runs Section */}
        {historicalRuns.length > 0 && (
          <div className="mt-8 space-y-4 pt-6 border-t border-border">
            <div className="flex items-center justify-between">
              <Label className="text-xs uppercase tracking-widest text-muted-foreground font-semibold">Benchmark History</Label>
              <button
                onClick={fetchHistoricalRuns}
                className="flex items-center gap-1.5 text-[11px] font-medium text-muted-foreground hover:text-foreground transition-colors"
              >
                <RefreshCw className="h-3 w-3" />
                REFRESH
              </button>
            </div>
            <div className="flex flex-col gap-2">
              {historicalRuns.map((run) => (
                <HistoricalRunRow
                  key={run.id}
                  run={run}
                  isExpanded={expandedResults[run.id] || false}
                  onToggle={() => setExpandedResults((prev) => ({ ...prev, [run.id]: !prev[run.id] }))}
                  onDelete={async () => {
                    await fetch(`/api/benchmarks/${run.id}`, { method: "DELETE" });
                    fetchHistoricalRuns();
                  }}
                />
              ))}
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function DetailedResultsView({ results }: { results: BenchmarkRunResults }) {
  if (!results) return null;

  return (
    <div className="mt-3 space-y-4">
      <div className="flex flex-wrap items-center gap-4 text-xs text-muted-foreground">
        {results.n_samples && (
          <div className="flex items-center gap-1.5 bg-muted/30 px-2 py-1 rounded">
            <span className="uppercase tracking-wider font-semibold">Samples</span>
            <span className="font-mono text-foreground">{results.n_samples.effective}</span>
            <span>of {results.n_samples.original}</span>
          </div>
        )}
        {results.total_time && (
          <div className="flex items-center gap-1.5 bg-muted/30 px-2 py-1 rounded">
            <span className="uppercase tracking-wider font-semibold">Time</span>
            <span className="font-mono text-foreground">{Number(results.total_time).toFixed(1)}s</span>
          </div>
        )}
      </div>

      <div className="grid grid-cols-1 gap-4">
        {results.results && Object.entries(results.results).map(([task, metrics]) => (
          <div key={task} className="rounded border border-border/50 overflow-hidden">
            <div className="flex items-center justify-between px-3 py-2 bg-muted/30 border-b border-border/50">
              <span className="text-sm font-semibold">{task}</span>
              {metrics.alias && <span className="text-[10px] text-muted-foreground uppercase tracking-wider">{metrics.alias as string}</span>}
            </div>
            <table className="w-full text-xs text-left">
              <tbody>
                {Object.entries(metrics)
                  .filter(([key]) => !key.includes('stderr') && !key.includes('alias'))
                  .map(([metric, value], idx) => {
                    const numValue = typeof value === 'number' ? value : parseFloat(String(value));
                    const isNumber = !isNaN(numValue);
                    const displayValue = isNumber ? `${(numValue * 100).toFixed(2)}%` : String(value);
                    
                    return (
                      <tr key={metric} className={`border-b border-border/20 last:border-0 ${idx % 2 === 0 ? 'bg-background' : 'bg-muted/10'}`}>
                        <td className="py-1.5 px-3 text-muted-foreground">
                          {metric}
                        </td>
                        <td className="py-1.5 px-3 text-right font-mono font-medium">
                          {displayValue}
                        </td>
                      </tr>
                    );
                  })}
              </tbody>
            </table>
          </div>
        ))}
      </div>
    </div>
  );
}

interface HistoricalRunRowProps {
  run: any;
  isExpanded: boolean;
  onToggle: () => void;
  onDelete: () => void;
}

function HistoricalRunRow({ run, isExpanded, onToggle, onDelete }: HistoricalRunRowProps) {
  const formatDate = (dateStr: string) => {
    const date = new Date(dateStr);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
  };

  const getModelDisplayName = (modelId: string) => {
    if (modelId.length > 35) {
      const parts = modelId.split('/');
      return parts.length >= 2 ? `${parts[0]}/${parts[1].substring(0, 20)}...` : modelId.substring(0, 32) + '...';
    }
    return modelId;
  };

  return (
    <div className="rounded border border-border/50 bg-card overflow-hidden">
      <div 
        onClick={onToggle}
        className="flex items-center justify-between px-3 py-2 hover:bg-muted/20 cursor-pointer transition-colors"
      >
        <div className="flex items-center gap-3">
          {run.status === 'completed' ? (
            <Check className="h-4 w-4 text-primary" />
          ) : run.status === 'failed' ? (
            <X className="h-4 w-4 text-destructive" />
          ) : (
            <Loader2 className="h-4 w-4 text-muted-foreground animate-spin" />
          )}
          <div className="flex flex-col">
            <div className="flex items-baseline gap-2">
              <span className="text-sm font-semibold">{run.task_name}</span>
              <span className="text-[10px] font-mono text-muted-foreground bg-muted/40 px-1 rounded">{getModelDisplayName(run.model_id)}</span>
            </div>
            <span className="text-[10px] text-muted-foreground">{formatDate(run.created_at)}</span>
          </div>
        </div>

        <div className="flex items-center gap-4">
          {run.status === 'completed' && run.final_score !== null && (
            <div className="text-right flex items-center gap-1.5">
              <span className="text-[10px] text-muted-foreground uppercase tracking-wide">Score</span>
              <span className="font-mono font-bold text-sm">{(run.final_score * 100).toFixed(1)}%</span>
            </div>
          )}
          {run.status === 'failed' && (
            <span className="text-xs text-destructive font-medium uppercase tracking-wide">Failed</span>
          )}
          <ChevronDown className={`h-4 w-4 text-muted-foreground transition-transform ${isExpanded ? 'rotate-180' : ''}`} />
        </div>
      </div>

      {isExpanded && (
        <div className="px-3 pb-3 border-t border-border/30 bg-muted/5">
          {run.status === 'completed' && run.details && (
            <DetailedResultsView results={typeof run.details === 'string' ? JSON.parse(run.details) : run.details} />
          )}
          {run.status === 'failed' && (
            <div className="mt-3 text-xs text-destructive font-mono bg-destructive/10 p-2 rounded">
              {run.error_message || "Unknown error"}
            </div>
          )}
          <div className="flex justify-end mt-3 pt-2 border-t border-border/30">
            <button
              onClick={(e) => { e.stopPropagation(); onDelete(); }}
              className="text-[11px] font-medium uppercase tracking-wider text-muted-foreground hover:text-destructive transition-colors flex items-center gap-1"
            >
              <Trash2 className="h-3 w-3" />
              Delete
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
