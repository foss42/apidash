import { useState } from "react";
import type { ProviderStatusData } from "./ProviderStatus";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Eye, EyeOff, Check, AlertCircle, X, Loader2 } from "lucide-react";

interface ProviderConfigModalProps {
  providers: ProviderStatusData[];
  onClose: () => void;
  onRefresh: () => void;
}

export default function ProviderConfigModal({ providers, onClose, onRefresh }: ProviderConfigModalProps) {
  const [keys, setKeys] = useState<Record<string, string>>({});
  const [showKeys, setShowKeys] = useState<Record<string, boolean>>({});
  const [saving, setSaving] = useState<string | null>(null);
  const [saved, setSaved] = useState<Record<string, boolean>>({});
  const [errors, setErrors] = useState<Record<string, string>>({});

  const handleKeyChange = (providerId: string, value: string) => {
    setKeys((prev) => ({ ...prev, [providerId]: value }));
    setSaved((prev) => ({ ...prev, [providerId]: false }));
    if (errors[providerId]) {
      setErrors((prev) => {
        const copy = { ...prev };
        delete copy[providerId];
        return copy;
      });
    }
  };

  const toggleShowKey = (providerId: string) => {
    setShowKeys((prev) => ({ ...prev, [providerId]: !prev[providerId] }));
  };

  const saveKey = async (providerId: string) => {
    setSaving(providerId);
    setErrors((prev) => {
      const copy = { ...prev };
      delete copy[providerId];
      return copy;
    });

    try {
      const res = await fetch(`/api/providers/${providerId}/key`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ api_key: keys[providerId] || "" }),
      });

      if (!res.ok) {
        const body = await res.text();
        throw new Error(body || "Failed to save key");
      }

      setSaved((prev) => ({ ...prev, [providerId]: true }));
      onRefresh();
    } catch (err) {
      setErrors((prev) => ({
        ...prev,
        [providerId]: err instanceof Error ? err.message : "Unknown error",
      }));
    } finally {
      setSaving(null);
    }
  };

  const cloudProviders = providers.filter((p) => p.id !== "ollama");
  const ollamaProvider = providers.find((p) => p.id === "ollama");

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4">
      <Card className="w-full max-w-2xl max-h-[90vh] overflow-auto">
        <CardHeader className="flex flex-row items-center justify-between pb-4">
          <CardTitle className="text-lg">Provider Settings</CardTitle>
          <button
            onClick={onClose}
            className="rounded-lg p-1.5 text-muted-foreground hover:bg-muted hover:text-foreground transition"
          >
            <X className="h-4 w-4" />
          </button>
        </CardHeader>

        <CardContent className="space-y-6">
          {ollamaProvider && (
            <Card className="border-border/50">
              <CardContent className="pt-4">
                <div className="flex items-center gap-3">
                  <div className={`flex h-8 w-8 items-center justify-center rounded-lg ${ollamaProvider.available ? "bg-emerald-500/20" : "bg-muted"}`}>
                    {ollamaProvider.available ? (
                      <Check className="h-4 w-4 text-emerald-400" />
                    ) : (
                      <AlertCircle className="h-4 w-4 text-muted-foreground" />
                    )}
                  </div>
                  <div className="flex-1">
                    <p className="text-sm font-medium text-foreground">Ollama (Local)</p>
                    <p className="text-xs text-muted-foreground">
                      {ollamaProvider.available
                        ? `${ollamaProvider.models?.length ?? 0} models available`
                        : "Not running — start with: ollama serve"}
                    </p>
                  </div>
                  {ollamaProvider.available ? (
                    <span className="rounded-full bg-emerald-500/15 px-2 py-0.5 text-[10px] font-medium text-emerald-400">
                      Running
                    </span>
                  ) : (
                    <span className="rounded-full bg-amber-500/15 px-2 py-0.5 text-[10px] font-medium text-amber-400">
                      Not Running
                    </span>
                  )}
                </div>
                {!ollamaProvider.available && (
                  <div className="mt-3 rounded-lg border border-border/50 bg-muted/30 p-3">
                    <p className="text-xs text-muted-foreground mb-2">Start Ollama in a terminal:</p>
                    <code className="text-xs font-mono text-primary bg-primary/10 px-2 py-1 rounded">
                      ollama serve
                    </code>
                  </div>
                )}
                {ollamaProvider.available && ollamaProvider.models && ollamaProvider.models.length > 0 && (
                  <div className="mt-3 flex flex-wrap gap-1.5">
                    {ollamaProvider.models.slice(0, 5).map((m) => (
                      <span key={m} className="rounded-full border border-border/50 px-2 py-0.5 text-[10px] text-muted-foreground">
                        {m}
                      </span>
                    ))}
                    {ollamaProvider.models.length > 5 && (
                      <span className="text-[10px] text-muted-foreground/50">
                        +{ollamaProvider.models.length - 5} more
                      </span>
                    )}
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          <div className="space-y-4">
            <h3 className="text-sm font-medium text-foreground">Cloud Providers</h3>
            <p className="text-xs text-muted-foreground">
              Enter your API keys to enable cloud providers. Keys are stored in memory and not persisted to disk.
            </p>

            {cloudProviders.map((p) => (
              <div key={p.id} className="space-y-2">
                <div className="flex items-center justify-between">
                  <Label htmlFor={`key-${p.id}`} className="text-sm">
                    {p.name}
                  </Label>
                  <div className="flex items-center gap-2">
                    {p.api_key_set && !keys[p.id] && (
                      <span className="flex items-center gap-1 text-[10px] text-emerald-400">
                        <Check className="h-3 w-3" />
                        Key configured
                      </span>
                    )}
                    {saved[p.id] && (
                      <span className="text-[10px] text-emerald-400">Saved</span>
                    )}
                  </div>
                </div>

                <div className="flex gap-2">
                  <div className="relative flex-1">
                    <Input
                      id={`key-${p.id}`}
                      type={showKeys[p.id] ? "text" : "password"}
                      value={keys[p.id] ?? ""}
                      onChange={(e) => handleKeyChange(p.id, e.target.value)}
                      placeholder={p.api_key_set ? "•••••••••••••••••••••••••••••••" : `Enter your ${p.name} API key`}
                      disabled={saving === p.id}
                    />
                    <button
                      type="button"
                      onClick={() => toggleShowKey(p.id)}
                      className="absolute right-2 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                    >
                      {showKeys[p.id] ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </button>
                  </div>
                  <Button
                    onClick={() => saveKey(p.id)}
                    disabled={saving === p.id}
                    size="sm"
                    variant={keys[p.id] || !p.api_key_set ? "default" : "outline"}
                  >
                    {saving === p.id ? (
                      <Loader2 className="h-4 w-4 animate-spin" />
                    ) : (
                      "Save"
                    )}
                  </Button>
                </div>

                {errors[p.id] && (
                  <p className="text-xs text-destructive">{errors[p.id]}</p>
                )}

                {p.available && p.models && p.models.length > 0 && (
                  <div className="flex flex-wrap gap-1.5">
                    {p.models.slice(0, 3).map((m) => (
                      <span key={m} className="rounded-full border border-border/50 px-2 py-0.5 text-[10px] text-muted-foreground">
                        {m}
                      </span>
                    ))}
                    {p.models.length > 3 && (
                      <span className="text-[10px] text-muted-foreground/50">
                        +{p.models.length - 3} more
                      </span>
                    )}
                  </div>
                )}

                {!p.available && p.api_key_set && (
                  <p className="text-xs text-amber-400 flex items-center gap-1">
                    <AlertCircle className="h-3 w-3" />
                    Key set, but provider is unavailable. Check your key.
                  </p>
                )}
              </div>
            ))}
          </div>

          <div className="flex justify-end gap-2 pt-4 border-t border-border">
            <Button variant="outline" onClick={onClose}>
              Done
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}