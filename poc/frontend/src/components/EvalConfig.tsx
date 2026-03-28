import { useState, useEffect } from "react";
import type { Provider, Dataset, ProviderSelection, TaskKind, EvalConfig } from "../types";
import { useApi } from "../hooks/useApi";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { Slider } from "@/components/ui/slider";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip";
import { Play, Settings2, Plus, X, Info } from "lucide-react";

const MODALITIES: { value: TaskKind; label: string; emoji: string }[] = [
  { value: "image_understanding", label: "Image Understanding", emoji: "🖼" },
  { value: "image_generation",    label: "Image Generation",    emoji: "🎨" },
  { value: "audio_stt",           label: "Speech-to-Text",      emoji: "🎙" },
  { value: "audio_tts",           label: "Text-to-Speech",      emoji: "🔊" },
  { value: "video_understanding", label: "Video Understanding", emoji: "🎬" },
  { value: "text",                label: "Text",                emoji: "📝" },
];

interface ProviderEntry {
  providerId: string;
  model: string;
}

interface EvalConfigProps {
  onSubmit: (config: {
    name: string;
    dataset_id: string;
    modality: TaskKind;
    providers: ProviderSelection[];
    eval_config: EvalConfig;
  }) => void;
  disabled?: boolean;
  refreshKey?: number;
}

export default function EvalConfigForm({ onSubmit, disabled, refreshKey }: EvalConfigProps) {
  const [name, setName] = useState("");
  const [modality, setModality] = useState<TaskKind>("image_understanding");
  const [selectedDataset, setSelectedDataset] = useState("");
  const [entries, setEntries] = useState<ProviderEntry[]>([]);
  const [temperature, setTemperature] = useState(0.7);
  const [maxTokens, setMaxTokens] = useState(512);
  const [systemPrompt, setSystemPrompt] = useState("");

  const providersApi = useApi<{ providers: Provider[] }>();
  const datasetsApi = useApi<{ datasets: Dataset[] }>();

  useEffect(() => {
    providersApi.get("/providers");
    datasetsApi.get("/datasets");
  }, [refreshKey]);

  const providers = providersApi.data?.providers ?? [];
  const datasets = datasetsApi.data?.datasets ?? [];

  const addEntry = (providerId: string, defaultModel: string) => {
    setEntries((prev) => [...prev, { providerId, model: defaultModel }]);
  };

  const removeEntry = (index: number) => {
    setEntries((prev) => prev.filter((_, i) => i !== index));
  };

  const updateModel = (index: number, model: string) => {
    setEntries((prev) => prev.map((e, i) => (i === index ? { ...e, model } : e)));
  };

  const handleSubmit = () => {
    if (!name || !selectedDataset || entries.length === 0) return;
    onSubmit({
      name,
      dataset_id: selectedDataset,
      modality,
      providers: entries.map((e) => ({ id: e.providerId, model: e.model })),
      eval_config: {
        temperature,
        max_tokens: maxTokens,
        system_prompt: systemPrompt || undefined,
      },
    });
  };

  const canSubmit = !disabled && !!name && !!selectedDataset && entries.length > 0;

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-base font-semibold text-foreground">Configure Evaluation</h2>
        {providers.length > 0 && (
          <Badge variant="secondary">
            {providers.length} provider{providers.length !== 1 ? "s" : ""}
          </Badge>
        )}
      </div>

      {/* Job Name */}
      <Card>
        <CardContent className="pt-4">
          <div className="space-y-1.5">
            <Label htmlFor="eval-name">Job Name</Label>
            <Input
              id="eval-name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="e.g., Compare vision APIs on nature photos"
              disabled={disabled}
            />
          </div>
        </CardContent>
      </Card>

      {/* Modality + Dataset */}
      <Card>
        <CardContent className="space-y-4 pt-4">
          <div className="space-y-2">
            <Label>Modality</Label>
            <div className="grid grid-cols-3 gap-1.5">
              {MODALITIES.map((m) => (
                <button
                  key={m.value}
                  type="button"
                  onClick={() => setModality(m.value)}
                  disabled={disabled}
                  className={`flex items-center gap-1.5 rounded-lg border px-2.5 py-1.5 text-xs transition ${
                    modality === m.value
                      ? "border-primary bg-primary/10 text-primary font-medium"
                      : "border-border bg-muted/30 text-muted-foreground hover:border-border/80 hover:text-foreground"
                  } disabled:cursor-not-allowed disabled:opacity-50`}
                >
                  <span>{m.emoji}</span>
                  <span className="truncate">{m.label}</span>
                </button>
              ))}
            </div>
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="eval-dataset">Dataset</Label>
            {datasets.length === 0 ? (
              <div className="flex items-center gap-2 rounded-lg border border-dashed border-border px-3 py-2.5">
                <Info className="h-3.5 w-3.5 shrink-0 text-muted-foreground/50" />
                <p className="text-xs text-muted-foreground">No datasets yet — upload one above</p>
              </div>
            ) : (
              <Select value={selectedDataset} onValueChange={setSelectedDataset} disabled={disabled}>
                <SelectTrigger id="eval-dataset">
                  <SelectValue placeholder="Select a dataset…" />
                </SelectTrigger>
                <SelectContent>
                  {datasets.map((ds) => (
                    <SelectItem key={ds.id} value={ds.id}>
                      {ds.name} · {ds.item_count} items
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Providers */}
      <Card>
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm">Providers &amp; Models</CardTitle>
            {entries.length > 0 && (
              <Badge variant="info">{entries.length} selected</Badge>
            )}
          </div>
        </CardHeader>
        <CardContent className="space-y-3 pt-0">
          {/* Selected entries */}
          {entries.length > 0 && (
            <div className="space-y-1.5">
              {entries.map((entry, idx) => {
                const p = providers.find((pr) => pr.id === entry.providerId);
                const modelList = p?.models ?? [];
                return (
                  <div
                    key={idx}
                    className="flex items-center gap-2 rounded-lg border border-primary/30 bg-primary/5 px-3 py-2"
                  >
                    <div className="flex h-5 w-5 shrink-0 items-center justify-center rounded-md bg-primary/20">
                      <span className="text-[9px] font-bold uppercase text-primary">
                        {(p?.name ?? entry.providerId).slice(0, 2)}
                      </span>
                    </div>
                    <span className="shrink-0 text-xs font-medium text-primary">
                      {p?.name ?? entry.providerId}
                    </span>
                    {modelList.length > 0 ? (
                      <select
                        value={entry.model}
                        onChange={(e) => updateModel(idx, e.target.value)}
                        className="flex-1 rounded border border-border bg-input px-2 py-1 text-xs text-foreground focus:border-primary focus:outline-none disabled:cursor-not-allowed"
                        disabled={disabled}
                      >
                        {modelList.map((m) => (
                          <option key={m} value={m}>{m}</option>
                        ))}
                      </select>
                    ) : (
                      <Input
                        value={entry.model}
                        onChange={(e) => updateModel(idx, e.target.value)}
                        className="h-7 flex-1 text-xs"
                        placeholder="model name"
                        disabled={disabled}
                      />
                    )}
                    <button
                      onClick={() => removeEntry(idx)}
                      disabled={disabled}
                      className="shrink-0 rounded p-1 text-muted-foreground/50 transition hover:bg-destructive/10 hover:text-destructive disabled:cursor-not-allowed"
                    >
                      <X className="h-3 w-3" />
                    </button>
                  </div>
                );
              })}
            </div>
          )}

          {/* Add provider buttons */}
          <div className="flex flex-wrap gap-1.5">
            {providers.map((p) => (
              <Button
                key={p.id}
                variant="outline"
                size="sm"
                onClick={() => addEntry(p.id, p.models?.[0] ?? p.id)}
                disabled={disabled}
                className="h-7 gap-1 text-xs"
              >
                <Plus className="h-3 w-3" />
                {p.name}
              </Button>
            ))}
            {providers.length === 0 && (
              <p className="text-xs text-muted-foreground/50">Loading providers…</p>
            )}
          </div>
          <p className="text-[11px] text-muted-foreground/40">
            Add the same provider multiple times to compare different models.
          </p>
        </CardContent>
      </Card>

      {/* Request Parameters */}
      <Card>
        <CardHeader className="pb-3">
          <CardTitle className="flex items-center gap-1.5 text-sm">
            <Settings2 className="h-3.5 w-3.5" />
            Request Parameters
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4 pt-0">
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <Label>Temperature</Label>
              <span className="rounded-md bg-muted px-2 py-0.5 font-mono text-xs text-primary">
                {temperature.toFixed(1)}
              </span>
            </div>
            <Slider
              min={0} max={2} step={0.1}
              value={[temperature]}
              onValueChange={([v]) => setTemperature(v)}
              disabled={disabled}
            />
            <div className="flex justify-between text-[10px] text-muted-foreground/40">
              <span>Deterministic (0)</span>
              <span>Creative (2)</span>
            </div>
          </div>

          <div className="space-y-1.5">
            <div className="flex items-center gap-1.5">
              <Label htmlFor="max-tokens">Max Tokens</Label>
              <Tooltip>
                <TooltipTrigger asChild>
                  <Info className="h-3 w-3 text-muted-foreground/40 cursor-help" />
                </TooltipTrigger>
                <TooltipContent>Maximum number of tokens in the response</TooltipContent>
              </Tooltip>
            </div>
            <Input
              id="max-tokens"
              type="number"
              min={1} max={8192}
              value={maxTokens}
              onChange={(e) => setMaxTokens(Math.max(1, parseInt(e.target.value) || 512))}
              disabled={disabled}
            />
          </div>

          <div className="space-y-1.5">
            <Label htmlFor="system-prompt">
              System Prompt{" "}
              <span className="font-normal text-muted-foreground/50">(optional)</span>
            </Label>
            <Textarea
              id="system-prompt"
              value={systemPrompt}
              onChange={(e) => setSystemPrompt(e.target.value)}
              placeholder="e.g., Answer concisely in one sentence."
              disabled={disabled}
              maxLength={2000}
              rows={2}
            />
            <p className="text-right text-[10px] text-muted-foreground/40">
              {systemPrompt.length}/2000
            </p>
          </div>
        </CardContent>
      </Card>

      <Button
        onClick={handleSubmit}
        disabled={!canSubmit}
        className="w-full gap-2 shadow-lg shadow-primary/20"
        size="lg"
      >
        <Play className="h-4 w-4" />
        Start Evaluation
      </Button>
    </div>
  );
}
