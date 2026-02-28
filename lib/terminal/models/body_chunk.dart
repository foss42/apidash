class BodyChunk {
  BodyChunk({required this.ts, required this.text, required this.sizeBytes});

  final DateTime ts;
  final String text; // preview text (could be partial)
  final int sizeBytes;
}
