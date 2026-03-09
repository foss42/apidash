import 'package:apidash_core/apidash_core.dart' show APIType;
import 'package:test/test.dart';
import 'package:apidash/utils/api_type_utils.dart';

void main() {
  group('detectApiTypeFromUrl - null and empty', () {
    test('returns null for null', () {
      expect(detectApiTypeFromUrl(null), isNull);
    });

    test('returns null for empty string', () {
      expect(detectApiTypeFromUrl(''), isNull);
    });

    test('returns null for whitespace only', () {
      expect(detectApiTypeFromUrl('   '), isNull);
    });
  });

  group('detectApiTypeFromUrl - GraphQL', () {
    test('detects /graphql path', () {
      expect(
        detectApiTypeFromUrl('https://api.example.com/graphql'),
        APIType.graphql,
      );
    });

    test('detects /graphql with trailing path', () {
      expect(
        detectApiTypeFromUrl('https://api.example.com/graphql/v2'),
        APIType.graphql,
      );
    });

    test('detects /graphql case-insensitive', () {
      expect(
        detectApiTypeFromUrl('https://api.example.com/GraphQL'),
        APIType.graphql,
      );
    });

    test('detects /graphql without scheme', () {
      expect(detectApiTypeFromUrl('api.example.com/graphql'), APIType.graphql);
    });

    test('GraphQL takes priority over AI host', () {
      expect(
        detectApiTypeFromUrl('https://api.openai.com/graphql'),
        APIType.graphql,
      );
    });
  });

  group('detectApiTypeFromUrl - AI cloud providers', () {
    test('detects OpenAI', () {
      expect(
        detectApiTypeFromUrl('https://api.openai.com/v1/chat/completions'),
        APIType.ai,
      );
    });

    test('detects Anthropic', () {
      expect(
        detectApiTypeFromUrl('https://api.anthropic.com/v1/messages'),
        APIType.ai,
      );
    });

    test('detects Google Gemini', () {
      expect(
        detectApiTypeFromUrl(
          'https://generativelanguage.googleapis.com/v1beta/models',
        ),
        APIType.ai,
      );
    });

    test('detects Groq', () {
      expect(
        detectApiTypeFromUrl('https://api.groq.com/openai/v1/chat/completions'),
        APIType.ai,
      );
    });

    test('detects Mistral', () {
      expect(
        detectApiTypeFromUrl('https://api.mistral.ai/v1/chat/completions'),
        APIType.ai,
      );
    });

    test('detects DeepSeek', () {
      expect(
        detectApiTypeFromUrl('https://api.deepseek.com/v1/chat/completions'),
        APIType.ai,
      );
    });
  });

  group('detectApiTypeFromUrl - AI path patterns', () {
    test('detects /v1/chat/completions on custom host', () {
      expect(
        detectApiTypeFromUrl('https://my-proxy.com/v1/chat/completions'),
        APIType.ai,
      );
    });

    test('detects /v2/completions', () {
      expect(
        detectApiTypeFromUrl('https://example.com/v2/completions'),
        APIType.ai,
      );
    });

    test('detects /v1/embeddings', () {
      expect(
        detectApiTypeFromUrl('https://example.com/v1/embeddings'),
        APIType.ai,
      );
    });

    test('detects /v1/images/generations', () {
      expect(
        detectApiTypeFromUrl('https://example.com/v1/images/generations'),
        APIType.ai,
      );
    });

    test('detects /v1/models', () {
      expect(detectApiTypeFromUrl('https://example.com/v1/models'), APIType.ai);
    });
  });

  group('detectApiTypeFromUrl - Ollama and local AI', () {
    test('detects Ollama native /api/chat', () {
      expect(
        detectApiTypeFromUrl('http://localhost:11434/api/chat'),
        APIType.ai,
      );
    });

    test('detects Ollama native /api/generate', () {
      expect(
        detectApiTypeFromUrl('http://localhost:11434/api/generate'),
        APIType.ai,
      );
    });

    test('detects Ollama OpenAI-compat path', () {
      expect(
        detectApiTypeFromUrl('http://localhost:11434/v1/chat/completions'),
        APIType.ai,
      );
    });

    test('detects LM Studio by port', () {
      expect(detectApiTypeFromUrl('http://localhost:1234'), APIType.ai);
    });

    test('detects localhost on port 8080 (vLLM)', () {
      expect(detectApiTypeFromUrl('http://localhost:8080'), APIType.ai);
    });

    test('detects 127.0.0.1 as localhost', () {
      expect(
        detectApiTypeFromUrl('http://127.0.0.1:11434/api/tags'),
        APIType.ai,
      );
    });

    test('detects local network IP with AI path', () {
      expect(
        detectApiTypeFromUrl('http://192.168.1.100/v1/chat/completions'),
        APIType.ai,
      );
    });
  });

  group('detectApiTypeFromUrl - REST (default)', () {
    test('regular REST API', () {
      expect(
        detectApiTypeFromUrl('https://jsonplaceholder.typicode.com/posts'),
        APIType.rest,
      );
    });

    test('REST API without scheme', () {
      expect(detectApiTypeFromUrl('api.example.com/users/123'), APIType.rest);
    });

    test('localhost without AI port or path', () {
      expect(
        detectApiTypeFromUrl('http://localhost:4000/api/users'),
        APIType.rest,
      );
    });

    test('plain domain', () {
      expect(detectApiTypeFromUrl('https://example.com'), APIType.rest);
    });
  });
}
