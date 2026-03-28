import { useState, useEffect } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { Check, AlertCircle, X, Loader2, Settings } from "lucide-react";
import ProviderConfigModal from "./ProviderConfigModal";

export interface ProviderStatusData {
  id: string;
  name: string;
  available?: boolean;
  api_key_set?: boolean;
  models?: string[];
}

interface ProviderStatusProps {
  showConfig?: boolean;
}

export default function ProviderStatus({ showConfig = true }: ProviderStatusProps) {
  const [providers, setProviders] = useState<ProviderStatusData[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);

  const fetchProviders = () => {
    fetch("/api/providers")
      .then((res) => res.json())
      .then((data) => {
        setProviders(data.providers ?? []);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  };

  useEffect(() => {
    fetchProviders();
  }, []);

  const getStatusIcon = (p: ProviderStatusData) => {
    if (!p.available) {
      return <X className="h-3 w-3 text-muted-foreground" />;
    }
    if (p.id !== "ollama" && !p.api_key_set) {
      return <AlertCircle className="h-3 w-3 text-amber-400" />;
    }
    return <Check className="h-3 w-3 text-emerald-400" />;
  };

  const getStatusText = (p: ProviderStatusData) => {
    if (!p.available) {
      return p.id === "ollama" ? "Not running" : "Unavailable";
    }
    if (p.id !== "ollama" && !p.api_key_set) {
      return "Configure key";
    }
    const modelCount = p.models?.length ?? 0;
    return modelCount > 0 ? `${modelCount} models` : "Ready";
  };

  if (loading) {
    return (
      <Card>
        <CardContent className="flex items-center justify-center py-6">
          <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
        </CardContent>
      </Card>
    );
  }

  return (
    <>
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <h2 className="text-base font-semibold text-foreground">Your Providers</h2>
          {showConfig && (
            <button
              onClick={() => setShowModal(true)}
              className="flex items-center gap-1.5 text-xs text-muted-foreground hover:text-foreground transition"
            >
              <Settings className="h-3.5 w-3.5" />
              Configure
            </button>
          )}
        </div>

        <div className="grid grid-cols-2 gap-3 md:grid-cols-4">
          {providers.map((p) => (
            <Tooltip key={p.id}>
              <TooltipTrigger asChild>
                <Card
                  className="cursor-pointer transition hover:border-primary/50"
                  onClick={() => showConfig && setShowModal(true)}
                >
                  <CardContent className="flex items-center gap-3 p-3">
                    <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-muted">
                      {getStatusIcon(p)}
                    </div>
                    <div className="min-w-0 flex-1">
                      <p className="text-xs font-medium text-foreground truncate">{p.name}</p>
                      <p className="text-[10px] text-muted-foreground truncate">
                        {getStatusText(p)}
                      </p>
                    </div>
                  </CardContent>
                </Card>
              </TooltipTrigger>
              <TooltipContent>
                {!p.available
                  ? `${p.name} is not available. ${p.id === "ollama" ? "Start it with: ollama serve" : "Check your configuration."}`
                  : p.id !== "ollama" && !p.api_key_set
                  ? `Click to configure your ${p.name} API key`
                  : `${p.name} is ready. ${p.models?.length ?? 0} models available.`}
              </TooltipContent>
            </Tooltip>
          ))}

          {providers.length === 0 && (
            <div className="col-span-2 md:col-span-4 rounded-lg border border-dashed border-border p-6 text-center">
              <p className="text-sm text-muted-foreground">No providers configured</p>
              <p className="text-xs text-muted-foreground/50 mt-1">
                Add API keys to start evaluating models
              </p>
            </div>
          )}
        </div>
      </div>

      {showModal && (
        <ProviderConfigModal
          providers={providers}
          onClose={() => setShowModal(false)}
          onRefresh={fetchProviders}
        />
      )}
    </>
  );
}