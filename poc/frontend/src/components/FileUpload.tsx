import { useCallback, useState } from "react";
import { useDropzone } from "react-dropzone";
import { useApi } from "../hooks/useApi";
import type { Dataset } from "../types";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Upload, CheckCircle2, AlertCircle } from "lucide-react";
import { cn } from "@/lib/utils";

interface FileUploadProps {
  onUploadComplete?: (dataset: Dataset) => void;
}

const MODALITY_OPTIONS = [
  { value: "image_understanding", label: "Image Understanding" },
  { value: "image_generation",    label: "Image Generation"    },
  { value: "audio_stt",           label: "Speech-to-Text"      },
  { value: "audio_tts",           label: "Text-to-Speech"      },
  { value: "video_understanding", label: "Video Understanding" },
  { value: "text",                label: "Text"                },
];

export default function FileUpload({ onUploadComplete }: FileUploadProps) {
  const [name, setName] = useState("");
  const [modality, setModality] = useState("image_understanding");
  const [metadataFile, setMetadataFile] = useState<File | null>(null);
  const [mediaFiles, setMediaFiles] = useState<File[]>([]);
  const api = useApi<Dataset>();

  const onDropMetadata = useCallback((files: File[]) => {
    if (files.length > 0) setMetadataFile(files[0]);
  }, []);

  const onDropMedia = useCallback((files: File[]) => {
    setMediaFiles((prev) => [...prev, ...files]);
  }, []);

  const { getRootProps: getMetaProps, getInputProps: getMetaInput, isDragActive: metaDrag } =
    useDropzone({
      onDrop: onDropMetadata,
      accept: { "text/csv": [".csv"], "application/json": [".json", ".jsonl"] },
      maxFiles: 1,
    });

  const { getRootProps: getMediaProps, getInputProps: getMediaInput, isDragActive: mediaDrag } =
    useDropzone({
      onDrop: onDropMedia,
      accept: {
        "image/*": [".png", ".jpg", ".jpeg", ".gif", ".webp"],
        "audio/*": [".wav", ".mp3", ".flac", ".ogg"],
        "video/*": [".mp4", ".avi", ".mov", ".webm"],
      },
    });

  const handleUpload = async () => {
    if (!metadataFile || !name) return;
    const formData = new FormData();
    formData.append("name", name);
    formData.append("modality", modality);
    formData.append("metadata", metadataFile);
    for (const f of mediaFiles) formData.append("files", f);
    try {
      const result = await api.upload("/datasets", formData);
      if (result) {
        onUploadComplete?.(result);
        setName("");
        setMetadataFile(null);
        setMediaFiles([]);
      }
    } catch { /* error in api.error */ }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-base font-semibold text-foreground">Upload Dataset</h2>

      <Card>
        <CardContent className="space-y-4 pt-4">
          <div className="space-y-1.5">
            <Label htmlFor="dataset-name">Dataset Name</Label>
            <Input
              id="dataset-name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              placeholder="My Image Dataset"
            />
          </div>

          <div className="space-y-1.5">
            <Label>Modality</Label>
            <Select value={modality} onValueChange={setModality}>
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {MODALITY_OPTIONS.map((o) => (
                  <SelectItem key={o.value} value={o.value}>{o.label}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Metadata dropzone */}
          <div className="space-y-1.5">
            <Label>
              Metadata File{" "}
              <span className="font-normal text-muted-foreground/50">(CSV / JSON)</span>
            </Label>
            <div
              {...getMetaProps()}
              className={cn(
                "cursor-pointer rounded-lg border-2 border-dashed p-4 text-center transition",
                metaDrag
                  ? "border-primary bg-primary/5"
                  : metadataFile
                  ? "border-emerald-500/40 bg-emerald-500/5"
                  : "border-border hover:border-border/80 hover:bg-muted/20"
              )}
            >
              <input {...getMetaInput()} />
              {metadataFile ? (
                <div className="flex items-center justify-center gap-2">
                  <CheckCircle2 className="h-4 w-4 text-emerald-400" />
                  <span className="text-sm font-medium text-emerald-300">{metadataFile.name}</span>
                  <span className="text-xs text-muted-foreground">
                    ({(metadataFile.size / 1024).toFixed(1)} KB)
                  </span>
                </div>
              ) : (
                <div>
                  <p className="text-sm text-muted-foreground">
                    {metaDrag ? "Drop it here" : "Drop CSV/JSON here or click to browse"}
                  </p>
                  <p className="mt-0.5 text-xs text-muted-foreground/40">.csv · .json · .jsonl</p>
                </div>
              )}
            </div>
          </div>

          {/* Media dropzone */}
          <div className="space-y-1.5">
            <div className="flex items-center justify-between">
              <Label>
                Media Files{" "}
                <span className="font-normal text-muted-foreground/50">(optional)</span>
              </Label>
              {mediaFiles.length > 0 && (
                <Badge variant="secondary">{mediaFiles.length} file{mediaFiles.length !== 1 ? "s" : ""}</Badge>
              )}
            </div>
            <div
              {...getMediaProps()}
              className={cn(
                "cursor-pointer rounded-lg border-2 border-dashed p-4 text-center transition",
                mediaDrag
                  ? "border-primary bg-primary/5"
                  : "border-border hover:border-border/80 hover:bg-muted/20"
              )}
            >
              <input {...getMediaInput()} />
              <p className="text-sm text-muted-foreground">
                {mediaDrag ? "Drop files here" : "Drop image / audio / video files"}
              </p>
              <p className="mt-0.5 text-xs text-muted-foreground/40">
                .png · .jpg · .mp3 · .wav · .mp4 · …
              </p>
            </div>
            {mediaFiles.length > 0 && (
              <div className="max-h-20 overflow-y-auto rounded-lg bg-muted/30 px-3 py-2">
                {mediaFiles.map((f, i) => (
                  <p key={i} className="font-mono text-[11px] text-muted-foreground">{f.name}</p>
                ))}
              </div>
            )}
          </div>

          {api.error && (
            <div className="flex items-center gap-2 rounded-lg border border-destructive/20 bg-destructive/10 px-3 py-2">
              <AlertCircle className="h-3.5 w-3.5 shrink-0 text-destructive" />
              <p className="text-sm text-destructive">{api.error}</p>
            </div>
          )}

          <Button
            onClick={handleUpload}
            disabled={!metadataFile || !name || api.loading}
            variant="outline"
            className="w-full gap-2 border-emerald-600/30 bg-emerald-600/10 text-emerald-300 hover:bg-emerald-600/20 hover:text-emerald-200"
          >
            {api.loading ? (
              <>
                <span className="h-3.5 w-3.5 animate-spin rounded-full border-2 border-emerald-400 border-t-transparent" />
                Uploading…
              </>
            ) : (
              <>
                <Upload className="h-3.5 w-3.5" />
                Upload Dataset
              </>
            )}
          </Button>
        </CardContent>
      </Card>
    </div>
  );
}
