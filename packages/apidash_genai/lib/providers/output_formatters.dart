class LLMOutputFormatters {
  // Generic OLLAMA Format
  static String? genericOllamaOutputFormatter(Map x) {
    return x['choices']?[0]['message']?['content'];
  }
}
