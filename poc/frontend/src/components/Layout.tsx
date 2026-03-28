import { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import type { ReactNode } from "react";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";
import { Zap, History, BarChart2 } from "lucide-react";

const NAV_ITEMS = [
  { path: "/",           label: "Evaluate",   icon: Zap       },
  { path: "/history",    label: "History",    icon: History   },
  { path: "/benchmarks", label: "Benchmarks", icon: BarChart2 },
];

export default function Layout({ children }: { children: ReactNode }) {
  const location = useLocation();
  const [pinned, setPinned] = useState(false);
  const [hovered, setHovered] = useState(false);

  const expanded = pinned || hovered;

  return (
    <TooltipProvider delayDuration={200}>
      <div className="flex min-h-screen bg-background text-foreground">
        {/* Sidebar */}
        <aside
          onMouseEnter={() => setHovered(true)}
          onMouseLeave={() => setHovered(false)}
          onClick={() => !hovered && setPinned((p) => !p)}
          className={cn(
            "relative flex shrink-0 flex-col border-r border-border bg-card transition-[width] duration-200 ease-in-out overflow-hidden",
            expanded ? "w-52" : "w-[52px]"
          )}
        >
          {/* Logo */}
          <div className="flex h-14 shrink-0 items-center gap-2.5 border-b border-border px-[14px]">
            <button
              onClick={(e) => { e.stopPropagation(); setPinned((p) => !p); }}
              className="flex h-7 w-7 shrink-0 items-center justify-center rounded-lg bg-primary text-xs font-bold text-primary-foreground tracking-tight transition hover:opacity-80"
              title={pinned ? "Unpin sidebar" : "Pin sidebar"}
            >
              ME
            </button>
            <div
              className={cn(
                "whitespace-nowrap transition-[opacity,transform] duration-200",
                expanded ? "opacity-100 translate-x-0" : "opacity-0 -translate-x-2 pointer-events-none"
              )}
            >
              <p className="text-sm font-semibold leading-tight text-card-foreground">MultiEval</p>
              <p className="text-[10px] text-muted-foreground leading-tight">API Dash POC</p>
            </div>
          </div>

          {/* Nav */}
          <nav className="flex-1 space-y-0.5 p-2">
            <p
              className={cn(
                "mb-1.5 px-2 text-[10px] font-semibold uppercase tracking-widest text-muted-foreground/50 whitespace-nowrap transition-[opacity] duration-200",
                expanded ? "opacity-100" : "opacity-0"
              )}
            >
              Workspace
            </p>
            {NAV_ITEMS.map((item) => {
              const active =
                location.pathname === item.path ||
                (item.path !== "/" && location.pathname.startsWith(item.path));
              const Icon = item.icon;
              return (
                <Tooltip key={item.path}>
                  <TooltipTrigger asChild>
                    <Link
                      to={item.path}
                      onClick={(e) => e.stopPropagation()}
                      className={cn(
                        "flex items-center gap-2.5 rounded-lg px-2.5 py-2 text-sm transition-all",
                        active
                          ? "bg-primary/15 text-primary font-medium ring-1 ring-primary/20"
                          : "text-muted-foreground hover:bg-muted hover:text-foreground"
                      )}
                    >
                      <Icon className={cn("h-4 w-4 shrink-0", active ? "text-primary" : "text-muted-foreground/60")} />
                      <span
                        className={cn(
                          "whitespace-nowrap transition-[opacity,transform] duration-200",
                          expanded ? "opacity-100 translate-x-0" : "opacity-0 -translate-x-1 pointer-events-none w-0"
                        )}
                      >
                        {item.label}
                      </span>
                    </Link>
                  </TooltipTrigger>
                  {/* Only show tooltip when collapsed */}
                  {!expanded && (
                    <TooltipContent side="right">{item.label}</TooltipContent>
                  )}
                </Tooltip>
              );
            })}
          </nav>

          <Separator />

          {/* Footer */}
          <div className="p-2">
            <div
              className={cn(
                "rounded-lg border border-border/50 bg-muted/40 px-3 py-2 transition-[opacity] duration-200",
                expanded ? "opacity-100" : "opacity-0"
              )}
            >
              <p className="whitespace-nowrap text-[10px] font-medium text-muted-foreground">GSoC 2026 Application</p>
              <p className="whitespace-nowrap text-[10px] text-muted-foreground/50">foss42/apidash</p>
            </div>
          </div>
        </aside>

        {/* Content */}
        <main className="flex-1 overflow-auto">
          <div className="mx-auto max-w-6xl px-6 py-6">
            {children}
          </div>
        </main>
      </div>
    </TooltipProvider>
  );
}
