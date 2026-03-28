import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useApi } from "../hooks/useApi";
import type { JobSummary } from "../types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Play, Clock, ArrowRight, BarChart2, Trash2 } from "lucide-react";

type StatusKey = "completed" | "running" | "failed" | "pending";

const STATUS_VARIANT: Record<StatusKey, "success" | "info" | "destructive" | "secondary"> = {
  completed: "success",
  running:   "info",
  failed:    "destructive",
  pending:   "secondary",
};

const STATUS_LABEL: Record<StatusKey, string> = {
  completed: "Completed",
  running:   "Running",
  failed:    "Failed",
  pending:   "Pending",
};

const MODALITY_ICON: Record<string, string> = {
  image_understanding: "🖼",
  image_generation:    "🎨",
  audio_stt:           "🎙",
  audio_tts:           "🔊",
  video_understanding: "🎬",
  text:                "📝",
};

interface BenchmarkRun {
  id: string;
  task_name: string;
  model_id: string;
  status: string;
  final_score: number | null;
  created_at: string;
}

interface UnifiedEntry {
  id: string;
  type: "eval" | "benchmark";
  name: string;
  status: StatusKey;
  modality: string;
  providers: string[];
  created_at: string;
  score?: number | null;
  link: string;
}

export default function JobHistory() {
  const navigate = useNavigate();
  const api = useApi<{ jobs: JobSummary[] }>();
  const [benchmarks, setBenchmarks] = useState<BenchmarkRun[]>([]);
  const [loading, setLoading] = useState(true);

  const jobs = api.data?.jobs ?? [];

  // Combine and sort evaluations and benchmarks
  const evalEntries: UnifiedEntry[] = jobs.map((job) => ({
    id: job.id,
    type: "eval" as const,
    name: job.name,
    status: (job.status as StatusKey) in STATUS_VARIANT ? job.status as StatusKey : "pending",
    modality: job.modality,
    providers: job.providers,
    created_at: job.created_at,
    link: `/results/${job.id}`,
  }));

  const benchmarkEntries: UnifiedEntry[] = benchmarks.map((b) => ({
    id: b.id,
    type: "benchmark" as const,
    name: b.task_name,
    status: (b.status as StatusKey) in STATUS_VARIANT ? b.status as StatusKey : "pending",
    modality: "benchmark",
    providers: [b.model_id],
    created_at: b.created_at,
    score: b.final_score,
    link: `/benchmarks`,
  }));

  const [allEntries, setAllEntries] = useState<UnifiedEntry[]>([]);

  useEffect(() => {
    const combined = [...evalEntries, ...benchmarkEntries].sort(
      (a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    );
    setAllEntries(combined);
  }, [jobs, benchmarks]);

  useEffect(() => {
    api.get("/jobs");
    fetch("/api/benchmarks")
      .then((r) => r.json())
      .then((data) => {
        setBenchmarks(data.runs || []);
        setLoading(false);
      })
      .catch(() => {
        setBenchmarks([]);
        setLoading(false);
      });
  }, []);

  const handleDelete = async (entry: UnifiedEntry) => {
    const endpoint = entry.type === "eval" ? `/api/jobs/${entry.id}` : `/api/benchmarks/${entry.id}`;
    try {
      await fetch(endpoint, { method: "DELETE" });
      setAllEntries((prev) => prev.filter((e) => !(e.id === entry.id && e.type === entry.type)));
      if (entry.type === "benchmark") {
        setBenchmarks((prev) => prev.filter((b) => b.id !== entry.id));
      }
    } catch (err) {
      console.error("Failed to delete:", err);
    }
  };

  if (api.loading || loading) {
    return (
      <div className="flex justify-center py-12">
        <span className="h-5 w-5 animate-spin rounded-full border-2 border-border border-t-primary" />
      </div>
    );
  }

  if (allEntries.length === 0) {
    return (
      <div className="rounded-xl border border-dashed border-border p-12 text-center">
        <div className="mx-auto mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-muted">
          <Clock className="h-5 w-5 text-muted-foreground/50" />
        </div>
        <p className="text-sm font-medium text-muted-foreground">No history yet</p>
        <p className="mt-1 text-xs text-muted-foreground/50">Runs you execute will appear here.</p>
        <Button asChild size="sm" className="mt-4 gap-1.5">
          <Link to="/">
            <Play className="h-3 w-3" />
            Run your first evaluation
          </Link>
        </Button>
      </div>
    );
  }

  return (
    <ScrollArea className="rounded-xl border border-border">
      <Table>
        <TableHeader>
          <TableRow className="bg-muted/40">
            <TableHead>Type</TableHead>
            <TableHead>Name</TableHead>
            <TableHead>Status</TableHead>
            <TableHead>Providers / Model</TableHead>
            <TableHead>Score</TableHead>
            <TableHead>Date</TableHead>
            <TableHead />
          </TableRow>
        </TableHeader>
        <TableBody>
          {allEntries.map((entry) => {
            const icon = entry.type === "benchmark" ? "📊" : (MODALITY_ICON[entry.modality] ?? "•");
            const typeLabel = entry.type === "benchmark" ? "Benchmark" : entry.modality.replace(/_/g, " ");
            return (
              <TableRow key={`${entry.type}-${entry.id}`}>
                <TableCell>
                  <div className="flex items-center gap-1.5">
                    {entry.type === "benchmark" ? (
                      <BarChart2 className="h-4 w-4 text-purple-400" />
                    ) : (
                      <span>{icon}</span>
                    )}
                    <span className="text-xs text-muted-foreground capitalize">{typeLabel}</span>
                  </div>
                </TableCell>
                <TableCell>
                  <span className="font-medium text-foreground/90">{entry.name}</span>
                  <p className="mt-0.5 font-mono text-[10px] text-muted-foreground/40">{entry.id.substring(0, 8)}...</p>
                </TableCell>
                <TableCell>
                  <Badge variant={STATUS_VARIANT[entry.status]}>{STATUS_LABEL[entry.status]}</Badge>
                </TableCell>
                <TableCell>
                  <div className="flex flex-wrap gap-1">
                    {entry.providers.map((p) => (
                      <Badge key={p} variant="secondary" className="font-mono text-[10px]">
                        {p.length > 20 ? p.substring(0, 20) + "..." : p}
                      </Badge>
                    ))}
                  </div>
                </TableCell>
                <TableCell>
                  {entry.score !== undefined && entry.score !== null ? (
                    <span className="font-mono text-sm font-bold text-emerald-500">{(entry.score * 100).toFixed(1)}%</span>
                  ) : (
                    <span className="text-muted-foreground">—</span>
                  )}
                </TableCell>
                <TableCell className="text-xs text-muted-foreground">
                  {new Date(entry.created_at).toLocaleDateString()}
                </TableCell>
                <TableCell>
                  <div className="flex items-center gap-1">
                    <Button
                      variant="outline"
                      size="sm"
                      className="h-7 gap-1 text-xs"
                      onClick={() => navigate(entry.link, { state: { runId: entry.id } })}
                    >
                      View
                      <ArrowRight className="h-3 w-3" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="sm"
                      className="h-7 w-7 p-0 text-muted-foreground hover:text-destructive"
                      onClick={() => handleDelete(entry)}
                      title="Delete"
                    >
                      <Trash2 className="h-3.5 w-3.5" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            );
          })}
        </TableBody>
      </Table>
    </ScrollArea>
  );
}
