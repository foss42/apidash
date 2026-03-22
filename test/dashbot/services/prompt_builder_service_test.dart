import 'package:apidash/dashbot/constants.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/services/services.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:test/test.dart';

void main() {
  group('PromptBuilder', () {
    late PromptBuilder builder;
    late RequestModel request;

    setUp(() {
      builder = PromptBuilder();
      final http = const HttpRequestModel(
        method: HTTPVerb.get,
        url: 'https://api.apidash.dev/users?size=2',
        headers: [NameValueModel(name: 'Accept', value: 'application/json')],
        isHeaderEnabledList: [true],
        bodyContentType: ContentType.json,
        body: '{"query":"q"}',
      );
      final resp = const HttpResponseModel(
        body: '{"status":"ok"}',
        statusCode: 200,
      );
      request = RequestModel(
        id: 'r1',
        name: 'Get Users',
        httpRequestModel: http,
        httpResponseModel: resp,
        responseStatus: 200,
      );
    });

    test('buildSystemPrompt includes url & method & body', () {
      final prompt = builder.buildSystemPrompt(
        request,
        ChatMessageType.explainResponse,
        history: const [],
      );
      expect(prompt, contains('https://api.apidash.dev/users'));
      expect(prompt.toUpperCase(), contains('GET'));
    });

    test('generateCode with override language uses language', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.generateCode,
        overrideLanguage: 'Python',
      );
      expect(p, isNotNull);
      expect(p!.toLowerCase(), contains('python'));
    });

    test('generateCode without override uses intro prompt', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.generateCode,
      );
      expect(p, isNotNull);
      // Should contain URL and method.
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
      // Should list available languages including python (requests) option.
      expect(p.toLowerCase(), contains('python (requests)'));
    });

    test('debugError task prompt', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.debugError,
      );
      expect(p, isNotNull);
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
    });

    test('generateDoc task prompt', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.generateDoc,
      );
      expect(p, isNotNull);
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
    });

    test('generateTest task prompt', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.generateTest,
      );
      expect(p, isNotNull);
      expect(p!, contains('https://api.apidash.dev/users'));
      expect(p.toUpperCase(), contains('GET'));
    });

    test('importCurl returns null', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.importCurl,
      );
      expect(p, isNull);
    });

    test('importOpenApi returns null', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.importOpenApi,
      );
      expect(p, isNull);
    });

    test('general task prompt', () {
      final p = builder.buildTaskPrompt(
        request,
        ChatMessageType.general,
      );
      expect(p, isNotNull);
      // General prompt likely generic; just ensure it's non-empty and does not lose context building.
      expect(p!.trim(), isNotEmpty);
    });

    group('history block', () {
      test('empty history returns empty string', () {
        expect(builder.buildHistoryBlock(const []), isEmpty);
      });

      test('non-empty history includes roles and content', () {
        final now = DateTime.now();
        final history = [
          ChatMessage(
            id: 'h1',
            role: MessageRole.user,
            content: 'Hello',
            timestamp: now,
          ),
          ChatMessage(
            id: 'h2',
            role: MessageRole.system,
            content: 'Hi there',
            timestamp: now.add(const Duration(seconds: 1)),
          ),
        ];
        final block = builder.buildHistoryBlock(history);
        expect(block, contains('<conversation_context>'));
        expect(block, contains('- user: Hello'));
        // system role still treated as assistant in output (non-user branch)
        expect(block, contains('- assistant: Hi there'));
        expect(block, contains('</conversation_context>'));
      });

      test('history truncation uses most recent maxTurns', () {
        final base = DateTime.now();
        final msgs = List.generate(10, (i) {
          return ChatMessage(
            id: 'm$i',
            role: i % 2 == 0 ? MessageRole.user : MessageRole.system,
            content: 'm$i',
            timestamp: base.add(Duration(seconds: i)),
          );
        });
        final block = builder.buildHistoryBlock(msgs); // default maxTurns = 8
        // Oldest two (m0, m1) should not appear.
        expect(block, isNot(contains('m0')));
        expect(block, isNot(contains('m1')));
        // Last message should appear.
        expect(block, contains('m9'));
        // Count of lines with '- ' should be 8.
        final lineCount = '- '.allMatches(block).length;
        expect(lineCount, 8);
      });

      test('custom maxTurns respected', () {
        final base = DateTime.now();
        final msgs = List.generate(5, (i) {
          return ChatMessage(
            id: 'c$i',
            role: MessageRole.user,
            content: 'c$i',
            timestamp: base.add(Duration(seconds: i)),
          );
        });
        final block = builder.buildHistoryBlock(msgs, maxTurns: 2);
        expect(block, isNot(contains('c0')));
        expect(block, isNot(contains('c1')));
        expect(block, contains('c3'));
        expect(block, contains('c4'));
        final lineCount = '- '.allMatches(block).length;
        expect(lineCount, 2);
      });
    });

    test('detectLanguage extended heuristics', () {
      expect(builder.detectLanguage('Please show Go example'), 'Go (net/http)');
      expect(builder.detectLanguage('Some Dart snippet'), 'Dart (http)');
      expect(builder.detectLanguage('Use fetch to call this endpoint'),
          'JavaScript (fetch)');
    });

    test('detectLanguage heuristic', () {
      expect(builder.detectLanguage('Write this in Python please'),
          contains('Python'));
      expect(builder.detectLanguage('Show me curl'), 'cURL');
      expect(builder.detectLanguage('random text'), isNull);
    });
  });
}
