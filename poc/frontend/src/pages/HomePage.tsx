import { useNavigate } from "react-router-dom";
import ProviderStatus from "../components/ProviderStatus";
import { Card, CardContent } from "@/components/ui/card";
import { FileUp, BarChart2, Zap } from "lucide-react";

export default function HomePage() {
  const navigate = useNavigate();

  return (
    <div className="space-y-8">
      <div className="space-y-2">
        <h1 className="text-2xl font-bold text-foreground">
          Evaluate AI models across text, image, audio, and video
        </h1>
        <p className="text-sm text-muted-foreground">
          Upload a dataset and run it across multiple AI providers to compare performance.
        </p>
      </div>

      <ProviderStatus />

      <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
        <Card className="border-dashed hover:border-primary/50 transition cursor-pointer" onClick={() => navigate("/evaluate")}>
          <CardContent className="flex flex-col items-center justify-center p-6 text-center">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-primary/10">
              <FileUp className="h-5 w-5 text-primary" />
            </div>
            <h3 className="text-sm font-medium text-foreground">Custom Dataset</h3>
            <p className="mt-1 text-xs text-muted-foreground">
              Upload your own dataset and configure providers
            </p>
          </CardContent>
        </Card>

        <Card className="border-dashed hover:border-primary/50 transition cursor-pointer" onClick={() => navigate("/benchmarks")}>
          <CardContent className="flex flex-col items-center justify-center p-6 text-center">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-purple-500/10">
              <BarChart2 className="h-5 w-5 text-purple-400" />
            </div>
            <h3 className="text-sm font-medium text-foreground">Benchmarks</h3>
            <p className="mt-1 text-xs text-muted-foreground">
              Run lm-eval standard benchmarks (MMLU, GSM8K, etc.)
            </p>
          </CardContent>
        </Card>

        <Card className="border-dashed hover:border-primary/50 transition cursor-pointer" onClick={() => navigate("/history")}>
          <CardContent className="flex flex-col items-center justify-center p-6 text-center">
            <div className="mb-3 flex h-12 w-12 items-center justify-center rounded-full bg-emerald-500/10">
              <Zap className="h-5 w-5 text-emerald-400" />
            </div>
            <h3 className="text-sm font-medium text-foreground">History</h3>
            <p className="mt-1 text-xs text-muted-foreground">
              View past evaluations and benchmarks
            </p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}