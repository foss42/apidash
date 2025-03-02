import 'package:apidash/services/ollama_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Add this to your existing providers
final ollamaServiceProvider = Provider<OllamaService>((ref) {
  return OllamaService();
});
