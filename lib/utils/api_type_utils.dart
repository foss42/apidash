import 'package:apidash_core/apidash_core.dart';

final _kAiPathPatterns = [
  RegExp(r'/v\d+/chat/completions'),
  RegExp(r'/v\d+/completions'),
  RegExp(r'/v\d+/embeddings'),
  RegExp(r'/v\d+/models'),
  RegExp(r'/v\d+/images/generations'),
  RegExp(r'/v\d+/audio/'),
  RegExp(r'/v\d+/messages'),
  RegExp(r'/v\d+beta\d*/models'),
  RegExp(r'/api/generate'),
  RegExp(r'/api/chat'),
  RegExp(r'/api/embeddings'),
  RegExp(r'/api/tags'),
  RegExp(r'/api/show'),
  RegExp(r'/api/ps'),
  RegExp(r'/api/pull'),
  RegExp(r'/api/push'),
];

const _kAiHostFragments = [
  'openai.com',
  'anthropic.com',
  'googleapis.com',
  'groq.com',
  'mistral.ai',
  'cohere.com',
  'huggingface.co',
  'azure.com',
  'deepseek.com',
  'together.ai',
  'fireworks.ai',
  'perplexity.ai',
  'deepinfra.com',
  'anyscale.com',
  'replicate.com',
];

const _kAiLocalPorts = {11434, 1234, 3000, 5001, 8080};

final _kGraphqlPathPattern = RegExp(r'/graphql', caseSensitive: false);

bool _isLocalHost(String host) {
  return host == 'localhost' ||
      host == '127.0.0.1' ||
      host == '0.0.0.0' ||
      host.startsWith('192.168.') ||
      host.startsWith('10.') ||
      host == '::1';
}

APIType? detectApiTypeFromUrl(String? url) {
  if (url == null || url.trim().isEmpty) return null;

  var normalised = url.trim();
  if (!normalised.contains('://')) {
    normalised = 'https://$normalised';
  }

  final uri = Uri.tryParse(normalised);
  if (uri == null || uri.host.isEmpty) return null;

  final path = uri.path.toLowerCase();
  final host = uri.host.toLowerCase();
  final port = uri.port;

  if (_kGraphqlPathPattern.hasMatch(path)) {
    return APIType.graphql;
  }

  for (final pattern in _kAiPathPatterns) {
    if (pattern.hasMatch(path)) {
      return APIType.ai;
    }
  }

  for (final fragment in _kAiHostFragments) {
    if (host == fragment || host.endsWith('.$fragment')) {
      return APIType.ai;
    }
  }

  if (_isLocalHost(host) && _kAiLocalPorts.contains(port)) {
    return APIType.ai;
  }

  return APIType.rest;
}
