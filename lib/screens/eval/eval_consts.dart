import 'package:flutter/material.dart';

enum BenchmarkType {
  lmHarness("LM Evaluation Harness", "lm_harness"),
  lightEval("LightEval", "lighteval"),
  humanEval("HumanEval", "human_eval"),
  mmlu("MMLU", "mmlu"),
  stressTest("API Stress Test", "stress_test"),
  agenticWorkflow("Agentic Workflow Eval", "agentic_workflow");

  const BenchmarkType(this.label, this.cmd);
  final String label;
  final String cmd;
}

enum DatasetSource {
  huggingFace("Hugging Face", Icons.cloud_download_outlined),
  localFile("Local File", Icons.file_upload_outlined),
  manualEntry("Manual Entry", Icons.edit_note_outlined);

  const DatasetSource(this.label, this.icon);
  final String label;
  final IconData icon;
}

enum MultimodalTaskType {
  imageCaptioning("Image Captioning", Icons.image_outlined),
  visualQA("Visual Q&A", Icons.question_answer_outlined),
  voiceToText("Voice to Text", Icons.keyboard_voice_outlined),
  textToVoice("Text to Voice", Icons.record_voice_over_outlined);

  const MultimodalTaskType(this.label, this.icon);
  final String label;
  final IconData icon;
}
