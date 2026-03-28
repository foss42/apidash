import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";
import type { CostSummary } from "../types";

interface CostTrackerProps {
  costSummary: Record<string, CostSummary>;
}

const COLORS = ["#3b82f6", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6"];

export default function CostTracker({ costSummary }: CostTrackerProps) {
  const providers = Object.keys(costSummary);
  if (providers.length === 0) return null;

  const chartData = providers.map((p, i) => ({
    provider: p,
    cost: costSummary[p].total_cost,
    tokens: costSummary[p].total_tokens,
    latency: costSummary[p].avg_latency_ms,
    fill: COLORS[i % COLORS.length],
  }));

  return (
    <div className="space-y-4 rounded-lg border border-gray-800 bg-gray-900 p-6">
      <h3 className="text-lg font-semibold">Cost & Performance</h3>

      <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
        {/* Cost chart */}
        <div>
          <p className="mb-2 text-sm text-gray-400">Estimated Cost (USD)</p>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
              <XAxis dataKey="provider" stroke="#9ca3af" fontSize={12} />
              <YAxis stroke="#9ca3af" fontSize={12} tickFormatter={(v) => `$${v}`} />
              <Tooltip
                contentStyle={{
                  backgroundColor: "#1f2937",
                  border: "1px solid #374151",
                  borderRadius: "8px",
                }}
                formatter={(value: number) => [`$${value.toFixed(4)}`, "Cost"]}
              />
              <Bar dataKey="cost" radius={[4, 4, 0, 0]}>
                {chartData.map((entry, i) => (
                  <rect key={i} fill={entry.fill} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>

        {/* Latency chart */}
        <div>
          <p className="mb-2 text-sm text-gray-400">Average Latency (ms)</p>
          <ResponsiveContainer width="100%" height={200}>
            <BarChart data={chartData}>
              <CartesianGrid strokeDasharray="3 3" stroke="#374151" />
              <XAxis dataKey="provider" stroke="#9ca3af" fontSize={12} />
              <YAxis stroke="#9ca3af" fontSize={12} />
              <Tooltip
                contentStyle={{
                  backgroundColor: "#1f2937",
                  border: "1px solid #374151",
                  borderRadius: "8px",
                }}
                formatter={(value: number) => [`${value.toFixed(0)}ms`, "Latency"]}
              />
              <Bar dataKey="latency" radius={[4, 4, 0, 0]}>
                {chartData.map((entry, i) => (
                  <rect key={i} fill={entry.fill} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Summary table */}
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b border-gray-800 text-left text-gray-400">
            <th className="px-3 py-2">Provider</th>
            <th className="px-3 py-2">Total Cost</th>
            <th className="px-3 py-2">Total Tokens</th>
            <th className="px-3 py-2">Avg Latency</th>
            <th className="px-3 py-2">Cost/Token</th>
          </tr>
        </thead>
        <tbody>
          {providers.map((p) => {
            const s = costSummary[p];
            const costPerToken = s.total_tokens > 0 ? s.total_cost / s.total_tokens : 0;
            return (
              <tr key={p} className="border-b border-gray-900">
                <td className="px-3 py-2 font-medium">{p}</td>
                <td className="px-3 py-2">${s.total_cost.toFixed(4)}</td>
                <td className="px-3 py-2">{s.total_tokens.toLocaleString()}</td>
                <td className="px-3 py-2">{s.avg_latency_ms.toFixed(0)}ms</td>
                <td className="px-3 py-2">${costPerToken.toFixed(6)}</td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
