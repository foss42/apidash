import * as React from "react";
import { ResponsiveContainer, Tooltip, type TooltipProps } from "recharts";
import { cn } from "@/lib/utils";

export type ChartConfig = Record<string, { label: string; color?: string }>;

const CHART_COLORS = [
  "oklch(0.6 0.2 240)",
  "oklch(0.65 0.2 165)",
  "oklch(0.75 0.2 60)",
  "oklch(0.65 0.2 300)",
  "oklch(0.65 0.2 25)",
];

interface ChartContainerProps extends React.HTMLAttributes<HTMLDivElement> {
  config: ChartConfig;
  children: React.ReactElement;
}

function ChartContainer({ config, className, children, ...props }: ChartContainerProps) {
  const cssVars = Object.entries(config).reduce<Record<string, string>>(
    (acc, [key, val], i) => {
      acc[`--color-${key}`] = val.color ?? CHART_COLORS[i % CHART_COLORS.length];
      return acc;
    },
    {}
  );

  return (
    <div
      className={cn("flex aspect-video justify-center text-xs", className)}
      style={cssVars as React.CSSProperties}
      {...props}
    >
      <ResponsiveContainer width="100%" height="100%">
        {children}
      </ResponsiveContainer>
    </div>
  );
}

function ChartTooltipContent({
  active,
  payload,
  label,
  labelFormatter,
  formatter,
  hideLabel = false,
  hideIndicator = false,
}: TooltipProps<number, string> & {
  labelFormatter?: (value: string) => string;
  formatter?: (value: number, name: string) => [string, string];
  hideLabel?: boolean;
  hideIndicator?: boolean;
}) {
  if (!active || !payload?.length) return null;

  return (
    <div className="rounded-lg border border-border bg-popover px-3 py-2 text-xs text-popover-foreground shadow-md">
      {!hideLabel && label && (
        <p className="mb-1.5 font-semibold text-muted-foreground">
          {labelFormatter ? labelFormatter(String(label)) : String(label)}
        </p>
      )}
      <div className="space-y-1">
        {payload.map((entry, i) => {
          const [formattedValue, formattedName] = formatter
            ? formatter(entry.value as number, entry.name as string)
            : [String(entry.value), entry.name as string];
          return (
            <div key={i} className="flex items-center gap-2">
              {!hideIndicator && (
                <span
                  className="h-2.5 w-2.5 shrink-0 rounded-sm"
                  style={{ backgroundColor: entry.color }}
                />
              )}
              <span className="text-muted-foreground">{formattedName}</span>
              <span className="ml-auto font-mono font-medium tabular-nums text-foreground">
                {formattedValue}
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

const ChartTooltip = Tooltip;

export { ChartContainer, ChartTooltip, ChartTooltipContent };
