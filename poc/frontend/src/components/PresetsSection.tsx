import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Play, Check, AlertCircle, Brain, Eye, Mic, Code2 } from "lucide-react";
import type { Preset } from "../types/presets";
import { cn } from "@/lib/utils";

const PRESET_ICONS: Record<string, React.ElementType> = {
  "text-reasoning":   Brain,
  "vision-quality":   Eye,
  "audio-transcribe": Mic,
  "code-generation":  Code2,
};

const PRESET_COLORS: Record<string, { icon: string; ring: string; bg: string }> = {
  "text-reasoning":   { icon: "text-blue-400",   ring: "ring-blue-500/20",   bg: "bg-blue-500/10"   },
  "vision-quality":   { icon: "text-violet-400", ring: "ring-violet-500/20", bg: "bg-violet-500/10" },
  "audio-transcribe": { icon: "text-emerald-400",ring: "ring-emerald-500/20",bg: "bg-emerald-500/10"},
  "code-generation":  { icon: "text-amber-400",  ring: "ring-amber-500/20",  bg: "bg-amber-500/10"  },
};

const DEFAULT_PRESETS: Preset[] = [
  {
    id: "text-reasoning",
    name: "Text Reasoning",
    description: "Quick test of logical reasoning across models",
    emoji: "🧠",
    modality: "text",
    tasks: ["gsm8k"],
    cloudModel: { providerId: "openai", modelId: "gpt-4o-mini", requiresAuth: true },
    localModel: { providerId: "ollama", modelId: "qwen2.5:0.5b", requiresAuth: false },
    sampleCount: 5,
  },
  {
    id: "vision-quality",
    name: "Vision Quality",
    description: "Compare image understanding accuracy",
    emoji: "🖼️",
    modality: "image",
    tasks: ["vqa-v2-sample"],
    cloudModel: { providerId: "openai", modelId: "gpt-4o", requiresAuth: true },
    localModel: { providerId: "ollama", modelId: "llava-phi3", requiresAuth: false },
    sampleCount: 5,
  },
  {
    id: "audio-transcribe",
    name: "Audio Transcribe",
    description: "WER scoring on speech recognition",
    emoji: "🎙️",
    modality: "audio",
    tasks: ["librispeech-sample"],
    cloudModel: { providerId: "openai", modelId: "whisper-1", requiresAuth: true },
    localModel: { providerId: "ollama", modelId: "whisper-tiny", requiresAuth: false },
    sampleCount: 5,
  },
  {
    id: "code-generation",
    name: "Code Generation",
    description: "Evaluate code quality with HumanEval",
    emoji: "💻",
    modality: "code",
    tasks: ["humaneval-sample"],
    cloudModel: { providerId: "openai", modelId: "gpt-4o-mini", requiresAuth: true },
    localModel: { providerId: "ollama", modelId: "qwen2.5:0.5b", requiresAuth: false },
    sampleCount: 5,
  },
];

interface PresetsSectionProps {
  onRunPreset?: (preset: Preset) => void;
}

export default function PresetsSection({ onRunPreset }: PresetsSectionProps) {
  const navigate = useNavigate();
  const [runningPreset, setRunningPreset] = useState<string | null>(null);
  const [ollamaAvailable, setOllamaAvailable] = useState(false);
  const [cloudKeySet, setCloudKeySet] = useState<Record<string, boolean>>({});

  useEffect(() => {
    fetch("/api/providers")
      .then((r) => r.json())
      .then((data) => {
        const providers = data.providers ?? [];
        providers.forEach((p: { id: string; available?: boolean; api_key_set?: boolean }) => {
          if (p.id === "ollama" && p.available) setOllamaAvailable(true);
          if (p.api_key_set) setCloudKeySet((prev) => ({ ...prev, [p.id]: true }));
        });
      })
      .catch(() => {});
  }, []);

  const handleRunPreset = async (preset: Preset) => {
    setRunningPreset(preset.id);
    try {
      if (onRunPreset) { onRunPreset(preset); return; }
      navigate("/benchmarks", {
        state: { task: preset.tasks[0], cloudModel: preset.cloudModel, localModel: preset.localModel, sampleCount: preset.sampleCount },
      });
    } finally {
      setRunningPreset(null);
    }
  };

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="text-base font-semibold text-foreground">Quick Start Presets</h2>
        <Badge variant="secondary">One-click comparison</Badge>
      </div>

      <div className="grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-4">
        {DEFAULT_PRESETS.map((preset) => {
          const cloudReady = !!cloudKeySet[preset.cloudModel.providerId];
          const isRunning = runningPreset === preset.id;
          const Icon = PRESET_ICONS[preset.id] ?? Brain;
          const colors = PRESET_COLORS[preset.id] ?? PRESET_COLORS["text-reasoning"];

          return (
            <Card
              key={preset.id}
              className="group relative overflow-hidden transition-all hover:border-primary/50 hover:shadow-lg"
            >
              {/* Full-height flex column so button is always flush to the bottom */}
              <CardContent className="flex h-full flex-col p-4">

                {/* Icon + title */}
                <div className="flex items-start gap-3">
                  <div className={cn("flex h-10 w-10 shrink-0 items-center justify-center rounded-xl ring-1", colors.bg, colors.ring)}>
                    <Icon className={cn("h-5 w-5", colors.icon)} />
                  </div>
                  <div>
                    <h3 className="text-sm font-semibold text-foreground">{preset.name}</h3>
                    <p className="mt-0.5 text-xs text-muted-foreground leading-snug">{preset.description}</p>
                  </div>
                </div>

                {/* Model badges — flex-1 pushes the button to the bottom */}
                <div className="mt-3 flex flex-1 flex-col justify-between gap-3">
                  <div className="flex flex-wrap gap-1.5">
                    <Badge variant="outline" className="text-[10px]">
                      {preset.cloudModel.providerId} · {preset.cloudModel.modelId}
                    </Badge>
                    {preset.localModel && (
                      <Badge variant="outline" className="text-[10px]">
                        {preset.localModel.providerId} · {preset.localModel.modelId}
                      </Badge>
                    )}
                  </div>

                  {/* Warning row */}
                  <div className="min-h-[18px]">
                    {!cloudReady && (
                      <div className="flex items-center gap-1 text-[10px] text-amber-400">
                        <AlertCircle className="h-3 w-3" />
                        <span>API key required</span>
                      </div>
                    )}
                    {preset.localModel && !ollamaAvailable && (
                      <div className="text-[10px] text-muted-foreground/50">Ollama not running</div>
                    )}
                  </div>

                  {/* Button always at the bottom */}
                  <Button
                    onClick={() => handleRunPreset(preset)}
                    disabled={isRunning}
                    className="w-full gap-2"
                    size="sm"
                  >
                    {isRunning ? (
                      <>
                        <span className="h-3.5 w-3.5 animate-spin rounded-full border-2 border-white border-t-transparent" />
                        Running…
                      </>
                    ) : (
                      <>
                        <Play className="h-3.5 w-3.5" />
                        Run {preset.sampleCount} Samples
                      </>
                    )}
                  </Button>
                </div>

                {/* Ready checkmark badge */}
                {cloudReady && (
                  <div className="absolute right-2 top-2 flex h-5 w-5 items-center justify-center rounded-full bg-emerald-500/20">
                    <Check className="h-3 w-3 text-emerald-400" />
                  </div>
                )}
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
