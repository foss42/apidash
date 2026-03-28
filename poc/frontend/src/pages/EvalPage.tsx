import { useState } from "react";
import { useNavigate } from "react-router-dom";
import EvalConfigForm from "../components/EvalConfig";
import FileUpload from "../components/FileUpload";
import LiveProgress from "../components/LiveProgress";
import { useApi } from "../hooks/useApi";
import type { EvalStartResponse, ProviderSelection, TaskKind, EvalConfig } from "../types";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { AlertCircle, Zap, ExternalLink } from "lucide-react";

export default function EvalPage() {
  const navigate = useNavigate();
  const [streamUrl, setStreamUrl] = useState<string | null>(null);
  const [jobId, setJobId] = useState<string | null>(null);
  const [isRunning, setIsRunning] = useState(false);
  const [datasetRefreshKey, setDatasetRefreshKey] = useState(0);
  const evalApi = useApi<EvalStartResponse>();

  const handleStartEval = async (config: {
    name: string;
    dataset_id: string;
    modality: TaskKind;
    providers: ProviderSelection[];
    eval_config: EvalConfig;
  }) => {
    try {
      const result = await evalApi.post("/eval", config);
      if (result) {
        setJobId(result.job_id);
        setStreamUrl(result.stream_url);
        setIsRunning(true);
      }
    } catch { /* error in evalApi.error */ }
  };

  const handleComplete = () => {
    setIsRunning(false);
    if (jobId) navigate(`/results/${jobId}`);
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-xl font-bold text-foreground">Multimodal Evaluation</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          Upload a dataset and run it across multiple AI providers to compare performance.
        </p>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Left: upload + config */}
        <div className="space-y-6">
          <FileUpload onUploadComplete={() => setDatasetRefreshKey((k) => k + 1)} />
          <EvalConfigForm onSubmit={handleStartEval} disabled={isRunning} refreshKey={datasetRefreshKey} />
        </div>

        {/* Right: status + progress */}
        <div className="space-y-4">
          {evalApi.error && (
            <Card className="border-destructive/20 bg-destructive/10">
              <CardContent className="flex items-start gap-3 pt-4">
                <AlertCircle className="mt-0.5 h-4 w-4 shrink-0 text-destructive" />
                <div>
                  <p className="text-sm font-medium text-destructive">Evaluation failed to start</p>
                  <p className="mt-0.5 text-xs text-destructive/70">{evalApi.error}</p>
                </div>
              </CardContent>
            </Card>
          )}

          {isRunning && jobId && (
            <Card className="border-primary/20 bg-primary/5">
              <CardContent className="flex items-center justify-between pt-4">
                <div className="flex items-center gap-2">
                  <span className="relative flex h-2 w-2">
                    <span className="absolute h-2 w-2 animate-ping rounded-full bg-primary/50" />
                    <span className="h-2 w-2 rounded-full bg-primary" />
                  </span>
                  <p className="text-sm text-primary">Evaluation running</p>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => navigate(`/results/${jobId}`)}
                  className="h-7 gap-1 text-xs text-primary hover:text-primary"
                >
                  View live results
                  <ExternalLink className="h-3 w-3" />
                </Button>
              </CardContent>
            </Card>
          )}

          <LiveProgress streamUrl={streamUrl} onComplete={handleComplete} />

          {!streamUrl && !isRunning && (
            <Card className="border-dashed">
              <CardContent className="flex flex-col items-center justify-center p-12 text-center">
                <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-muted">
                  <Zap className="h-5 w-5 text-muted-foreground/50" />
                </div>
                <p className="text-sm font-medium text-muted-foreground">Ready to evaluate</p>
                <p className="mt-1 text-xs text-muted-foreground/50">
                  Upload a dataset and configure an evaluation to get started.
                </p>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
