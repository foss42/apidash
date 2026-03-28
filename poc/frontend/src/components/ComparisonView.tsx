import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Legend,
} from "recharts";
import type { ItemResult, CostSummary } from "../types";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { ChartContainer, ChartTooltip, ChartTooltipContent, type ChartConfig } from "@/components/ui/chart";

interface ComparisonViewProps {
  results: ItemResult[];
  providers: string[];
  costSummary: Record<string, CostSummary>;
}

const PROVIDER_COLORS = [
  "oklch(0.6 0.2 240)",   // blue
  "oklch(0.65 0.2 165)",  // emerald
  "oklch(0.75 0.2 60)",   // amber
  "oklch(0.65 0.2 300)",  // purple
  "oklch(0.65 0.2 25)",   // red
];

const StatRow = ({ label, value }: { label: string; value: string }) => (
  <div className="flex items-center justify-between py-1.5">
    <span className="text-xs text-muted-foreground">{label}</span>
    <span className="font-mono text-xs font-medium text-foreground">{value}</span>
  </div>
);

export default function ComparisonView({ results, providers, costSummary }: ComparisonViewProps) {
  if (results.length === 0) return null;

  const metricNames = new Set<string>();
  for (const item of results)
    for (const pr of Object.values(item.providers))
      for (const key of Object.keys(pr.metrics)) metricNames.add(key);

  const avgScores: Record<string, Record<string, number>> = {};
  for (const p of providers) {
    avgScores[p] = {};
    for (const m of metricNames) {
      const scores = results
        .map((r) => r.providers[p]?.metrics[m])
        .filter((s): s is number => s !== undefined);
      avgScores[p][m] = scores.length > 0 ? scores.reduce((a, b) => a + b, 0) / scores.length : 0;
    }
  }

  const chartData = Array.from(metricNames).map((metric) => {
    const row: Record<string, string | number> = { metric };
    for (const p of providers) row[p] = Number(avgScores[p][metric]?.toFixed(3) ?? 0);
    return row;
  });

  const costData = providers
    .filter((p) => costSummary[p])
    .map((p) => ({
      provider: p,
      cost: costSummary[p].total_cost,
      latency: costSummary[p].avg_latency_ms,
      tokens: costSummary[p].total_tokens,
    }));

  // Build chart config for shadcn chart
  const chartConfig: ChartConfig = Object.fromEntries(
    providers.map((p, i) => [p, { label: p, color: PROVIDER_COLORS[i % PROVIDER_COLORS.length] }])
  );

  return (
    <div className="space-y-4">
      {/* Score chart */}
      <Card>
        <CardHeader className="pb-3">
          <CardTitle className="text-sm">Score Comparison</CardTitle>
        </CardHeader>
        <CardContent>
          <ChartContainer config={chartConfig} className="h-[280px] w-full">
            <BarChart data={chartData} margin={{ top: 4, right: 8, left: -16, bottom: 0 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="oklch(0.25 0.01 260)" vertical={false} />
              <XAxis
                dataKey="metric"
                fontSize={11}
                tick={{ fill: "oklch(0.5 0.01 260)" }}
                axisLine={false}
                tickLine={false}
              />
              <YAxis
                fontSize={11}
                tick={{ fill: "oklch(0.5 0.01 260)" }}
                domain={[0, 1]}
                axisLine={false}
                tickLine={false}
                tickFormatter={(v) => v.toFixed(1)}
              />
              <ChartTooltip
                content={
                  <ChartTooltipContent
                    formatter={(value) => [(value as number).toFixed(3), ""]}
                  />
                }
                cursor={{ fill: "rgba(255,255,255,0.04)" }}
              />
              <Legend wrapperStyle={{ fontSize: "12px", paddingTop: "12px" }} />
              {providers.map((p, i) => (
                <Bar
                  key={p}
                  dataKey={p}
                  fill={PROVIDER_COLORS[i % PROVIDER_COLORS.length]}
                  radius={[4, 4, 0, 0]}
                  maxBarSize={48}
                />
              ))}
            </BarChart>
          </ChartContainer>
        </CardContent>
      </Card>

      {/* Provider summary cards */}
      <div className="grid gap-3" style={{ gridTemplateColumns: `repeat(${Math.min(providers.length, 3)}, 1fr)` }}>
        {providers.map((p, i) => (
          <Card key={p} className="overflow-hidden">
            <div
              className="flex items-center gap-2 border-b border-border px-4 py-2.5"
              style={{ borderTop: `3px solid ${PROVIDER_COLORS[i % PROVIDER_COLORS.length]}` }}
            >
              <div
                className="h-2.5 w-2.5 rounded-full"
                style={{ backgroundColor: PROVIDER_COLORS[i % PROVIDER_COLORS.length] }}
              />
              <h4 className="text-sm font-semibold text-foreground">{p}</h4>
            </div>
            <CardContent className="px-4 py-0">
              <div className="divide-y divide-border/50">
                {Array.from(metricNames).map((m) => (
                  <StatRow key={m} label={m} value={avgScores[p][m]?.toFixed(3) ?? "—"} />
                ))}
                {costSummary[p] && (
                  <>
                    <StatRow label="Total cost" value={`$${costSummary[p].total_cost.toFixed(4)}`} />
                    <StatRow label="Avg latency" value={`${costSummary[p].avg_latency_ms.toFixed(0)}ms`} />
                    <StatRow label="Total tokens" value={String(costSummary[p].total_tokens)} />
                  </>
                )}
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Cost breakdown table */}
      {costData.length > 0 && (
        <Card>
          <CardHeader className="pb-3">
            <CardTitle className="text-sm">Cost Breakdown</CardTitle>
          </CardHeader>
          <Separator />
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Provider</TableHead>
                <TableHead className="text-right">Total Cost</TableHead>
                <TableHead className="text-right">Tokens</TableHead>
                <TableHead className="text-right">Avg Latency</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {costData.map((row, i) => (
                <TableRow key={row.provider}>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <div
                        className="h-2 w-2 rounded-full"
                        style={{ backgroundColor: PROVIDER_COLORS[i % PROVIDER_COLORS.length] }}
                      />
                      <span className="text-sm text-foreground/80">{row.provider}</span>
                    </div>
                  </TableCell>
                  <TableCell className="text-right font-mono text-sm">${row.cost.toFixed(4)}</TableCell>
                  <TableCell className="text-right font-mono text-sm">{row.tokens.toLocaleString()}</TableCell>
                  <TableCell className="text-right font-mono text-sm">{row.latency.toFixed(0)}ms</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </Card>
      )}
    </div>
  );
}
