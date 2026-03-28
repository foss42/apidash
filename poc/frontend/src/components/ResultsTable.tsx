import React from "react";
import type { ItemResult } from "../types";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { AlertTriangle } from "lucide-react";
import { cn } from "@/lib/utils";

interface ResultsTableProps {
  results: ItemResult[];
  providers: string[];
}

const scoreColor = (v: number) =>
  v >= 0.7 ? "text-emerald-400" : v >= 0.4 ? "text-amber-400" : "text-red-400";

export default function ResultsTable({ results, providers }: ResultsTableProps) {
  if (results.length === 0) {
    return <p className="text-sm text-muted-foreground">No results yet.</p>;
  }

  const metricNames = new Set<string>();
  for (const item of results)
    for (const pResult of Object.values(item.providers))
      for (const key of Object.keys(pResult.metrics)) metricNames.add(key);
  const metrics = Array.from(metricNames);

  return (
    <div className="overflow-x-auto rounded-xl border border-border">
      <Table>
        <TableHeader>
          {/* Provider-level header */}
          <TableRow className="bg-muted/40">
            <TableHead className="w-10">#</TableHead>
            <TableHead className="min-w-48">Prompt</TableHead>
            <TableHead className="min-w-32">Expected</TableHead>
            {providers.map((p) => (
              <TableHead key={p} colSpan={metrics.length + 2}>{p}</TableHead>
            ))}
          </TableRow>
          {/* Sub-column header */}
          <TableRow className="bg-muted/20 text-[10px] text-muted-foreground/50">
            <th /><th /><th />
            {providers.map((p) => (
              <React.Fragment key={p}>
                <th className="px-3 py-1.5 text-left font-medium">Response</th>
                {metrics.map((m) => (
                  <th key={m} className="px-3 py-1.5 text-center font-medium">{m}</th>
                ))}
                <th className="px-3 py-1.5 text-right font-medium">Latency</th>
              </React.Fragment>
            ))}
          </TableRow>
        </TableHeader>
        <TableBody>
          {results.map((item, rowIdx) => (
            <TableRow
              key={item.item_index}
              className={cn("align-top", rowIdx % 2 === 0 ? "bg-muted/10" : "bg-muted/20")}
            >
              <TableCell className="font-mono text-xs text-muted-foreground/50">{item.item_index}</TableCell>
              <TableCell className="min-w-48 text-xs leading-relaxed text-foreground/80 whitespace-pre-wrap">
                {item.prompt}
              </TableCell>
              <TableCell className="min-w-32 text-xs leading-relaxed text-muted-foreground whitespace-pre-wrap">
                {item.expected || <span className="text-muted-foreground/30">—</span>}
              </TableCell>
              {providers.map((p) => {
                const pr = item.providers[p];
                if (!pr) {
                  return (
                    <TableCell key={p} colSpan={metrics.length + 2}>
                      <Badge variant="secondary" className="text-[10px]">pending</Badge>
                    </TableCell>
                  );
                }
                const hasError = !!pr.error;
                return (
                  <React.Fragment key={p}>
                    <TableCell className="min-w-48 text-xs whitespace-pre-wrap">
                      {hasError ? (
                        <span
                          className="inline-flex items-center gap-1 rounded-md border border-destructive/20 bg-destructive/10 px-2 py-1 text-[11px] text-destructive"
                          title={pr.error}
                        >
                          <AlertTriangle className="h-2.5 w-2.5" />
                          {pr.error!.length > 60 ? pr.error!.slice(0, 60) + "…" : pr.error}
                        </span>
                      ) : (
                        <span className="text-foreground/70">
                          {pr.response || <span className="text-muted-foreground/30">no response</span>}
                        </span>
                      )}
                    </TableCell>
                    {metrics.map((m) => (
                      <TableCell key={m} className="text-center font-mono text-xs">
                        {hasError ? (
                          <span className="text-muted-foreground/30">—</span>
                        ) : (
                          <span className={scoreColor(pr.metrics[m] ?? 0)}>
                            {pr.metrics[m]?.toFixed(2) ?? "—"}
                          </span>
                        )}
                      </TableCell>
                    ))}
                    <TableCell className="text-right font-mono text-xs text-muted-foreground">
                      {pr.latency_ms.toFixed(0)}ms
                    </TableCell>
                  </React.Fragment>
                );
              })}
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </div>
  );
}
