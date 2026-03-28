import { useSSE } from "../hooks/useSSE";
import type { SSEProgressEvent } from "../types";
import { Card, CardContent, CardHeader } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { ScrollArea } from "@/components/ui/scroll-area";
import { CheckCircle2, Radio } from "lucide-react";

interface LiveProgressProps {
  streamUrl: string | null;
  onComplete?: (summary: Record<string, unknown>) => void;
}

export default function LiveProgress({ streamUrl, onComplete }: LiveProgressProps) {
  const { events, connected, error } = useSSE({
    url: streamUrl,
    onEvent: (event) => {
      if (event.type === "complete") {
        const data = event.data as { summary: Record<string, unknown> };
        onComplete?.(data.summary);
      }
    },
  });

  const backendError = events.find((e) => e.type === "error")?.data as
    | { error: string; type: string }
    | undefined;

  const latestProgress = [...events]
    .reverse()
    .find((e) => e.type === "progress")?.data as SSEProgressEvent | undefined;

  const logs = events.filter((e) => e.type === "item_result" || e.type === "provider_done");
  const isComplete = events.some((e) => e.type === "complete" || e.type === "error");

  if (!streamUrl) return null;

  return (
    <Card>
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            {isComplete ? (
              <CheckCircle2 className="h-5 w-5 text-emerald-400" />
            ) : (
              <span className="relative flex h-5 w-5 items-center justify-center">
                <span className="absolute h-4 w-4 animate-ping rounded-full bg-primary/30" />
                <Radio className="h-4 w-4 text-primary" />
              </span>
            )}
            <span className="text-sm font-semibold">
              {isComplete ? "Evaluation Complete" : "Evaluation Running"}
            </span>
          </div>
          {connected && !isComplete && (
            <Badge variant="success">Live</Badge>
          )}
        </div>
      </CardHeader>

      <CardContent className="space-y-3">
        {/* Progress bar */}
        {latestProgress && (
          <div className="space-y-1.5">
            <div className="flex items-center justify-between text-xs">
              <span className="text-muted-foreground">
                {latestProgress.completed} / {latestProgress.total} items
              </span>
              <span className="font-mono font-medium text-primary">{latestProgress.pct}%</span>
            </div>
            <Progress value={latestProgress.pct} className="h-1.5" />
            {latestProgress.current_provider && (
              <p className="text-[11px] text-muted-foreground/50">
                {latestProgress.current_provider} → item {latestProgress.current_item}
              </p>
            )}
          </div>
        )}

        {/* Errors */}
        {(error || backendError) && (
          <div className="rounded-lg border border-destructive/20 bg-destructive/10 px-3 py-2">
            <p className="text-xs text-destructive">
              {error ? `Connection error: ${error}` : `${backendError!.type}: ${backendError!.error}`}
            </p>
          </div>
        )}

        {/* Event log */}
        <ScrollArea className="h-48 rounded-lg border border-border bg-background p-3">
          {logs.length === 0 ? (
            <p className="font-mono text-xs text-muted-foreground/40">Waiting for events…</p>
          ) : (
            <div className="space-y-0.5">
              {logs.map((log, i) => {
                const data = log.data as Record<string, unknown>;
                if (log.type === "item_result") {
                  const err = data.error as string | undefined;
                  return (
                    <div key={i} className={`font-mono text-[11px] ${err ? "text-destructive" : "text-muted-foreground"}`}>
                      <span className="text-muted-foreground/40">[{data.provider as string}]</span>{" "}
                      <span className="text-muted-foreground/60">item {data.item_index as number}</span>
                      {err ? (
                        <span className="text-destructive"> ✕ {err}</span>
                      ) : (
                        <span>
                          {" "}— {Object.entries(data.metrics as Record<string, number>)
                            .map(([k, v]) => `${k}: ${v.toFixed(2)}`)
                            .join("  ")}
                        </span>
                      )}
                    </div>
                  );
                }
                if (log.type === "provider_done") {
                  return (
                    <div key={i} className="font-mono text-[11px] text-emerald-400">
                      <span className="text-muted-foreground/40">[{data.provider as string}]</span>{" "}
                      done — avg: {(data.avg_score as number).toFixed(3)}  cost: ${(data.cost as number).toFixed(4)}
                    </div>
                  );
                }
                return null;
              })}
            </div>
          )}
        </ScrollArea>
      </CardContent>
    </Card>
  );
}
