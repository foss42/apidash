import 'package:apidash/dashbot/prompts/dashbot_prompts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dashbot Prompts Tests', () {
    late DashbotPrompts prompts;

    setUp(() {
      prompts = DashbotPrompts();
    });

    test('generalInteractionPrompt returns non-empty string', () {
      final prompt = prompts.generalInteractionPrompt();
      expect(prompt, isNotEmpty);
    });

    test('explainApiResponsePrompt returns non-empty string', () {
      final prompt = prompts.explainApiResponsePrompt(
        url: 'https://example.com',
        method: 'GET',
        responseStatus: 200,
      );
      expect(prompt, isNotEmpty);
      expect(prompt.contains('https://example.com'), isTrue);
    });

    test('debugApiErrorPrompt returns non-empty string', () {
      final prompt = prompts.debugApiErrorPrompt(
        url: 'https://example.com',
        method: 'GET',
        responseStatus: 500,
      );
      expect(prompt, isNotEmpty);
      expect(prompt.contains('500'), isTrue);
    });

    test('generateTestCasesPrompt returns non-empty string', () {
      final prompt = prompts.generateTestCasesPrompt(
        url: 'https://example.com',
        method: 'POST',
      );
      expect(prompt, isNotEmpty);
      expect(prompt.contains('POST'), isTrue);
    });

    test('generateDocumentationPrompt returns non-empty string', () {
      final prompt = prompts.generateDocumentationPrompt(
        url: 'https://example.com',
        method: 'GET',
        responseStatus: 200,
      );
      expect(prompt, isNotEmpty);
      expect(prompt.contains('200'), isTrue);
    });

    test('codeGenerationIntroPrompt returns non-empty string', () {
      final prompt = prompts.codeGenerationIntroPrompt(
        url: 'https://example.com',
        method: 'GET',
      );
      expect(prompt, isNotEmpty);
    });

    test('generateCodePrompt returns non-empty string', () {
      final prompt = prompts.generateCodePrompt(
        url: 'https://example.com',
        method: 'GET',
        language: 'Dart',
      );
      expect(prompt, isNotEmpty);
      expect(prompt.contains('Dart'), isTrue);
    });

    test('openApiInsightsPrompt returns non-empty string', () {
      final prompt = prompts.openApiInsightsPrompt(specSummary: 'Test Summary');
      expect(prompt, isNotEmpty);
      expect(prompt.contains('Test Summary'), isTrue);
    });

    test('curlInsightsPrompt returns non-empty string', () {
      final prompt = prompts.curlInsightsPrompt(diff: 'Test Diff');
      expect(prompt, isNotEmpty);
      expect(prompt.contains('Test Diff'), isTrue);
    });
  });

  group('Dashbot WebSocket Prompts', () {
    late DashbotPrompts prompts;

    const url = 'wss://api.apidash.dev/ws/echo';
    const status = 'Currently connected';
    const headers = {'Authorization': 'Bearer token123'};
    const params = {'room': 'lobby'};
    const settings = 'Heartbeat: off; Auto Reconnect: off';
    const log = '[2026-01-01T12:00:00.000] SENT: hello';

    setUp(() {
      prompts = DashbotPrompts();
    });

    // Every action name Dashbot understands, plus both action targets.
    // Explanation-only prompts must not mention ANY of these.
    const actionVocabulary = [
      'update_field',
      'add_header',
      'update_header',
      'delete_header',
      'update_body',
      'update_url',
      'update_method',
      'show_languages',
      'apply_curl',
      'apply_openapi',
      'download_doc',
      'no_action',
      'upload_asset',
      'wsRequestModel',
      'httpRequestModel',
    ];

    Map<String, String> explanationOnlyPrompts() => {
      'explainWsConnection': prompts.explainWsConnectionPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        messageLog: log,
      ),
      'findInWsMessages': prompts.findInWsMessagesPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        messageLog: log,
      ),
      'summarizeWsMessages': prompts.summarizeWsMessagesPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        messageLog: log,
      ),
      'explainWsMessage': prompts.explainWsMessagePrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        messageLog: log,
      ),
      'debugWsMessage': prompts.debugWsMessagePrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        messageLog: log,
      ),
      'wsConnectionHealth': prompts.wsConnectionHealthPrompt(
        url: url,
        connectionStatus: status,
        healthStats:
            'Connection health stats:\n- Sessions: 1 (1 completed, 0 ongoing)',
        messageLog: log,
      ),
    };

    Map<String, String> allWsPrompts() => {
      ...explanationOnlyPrompts(),
      'debugWsConnection': prompts.debugWsConnectionPrompt(
        url: url,
        connectionStatus: 'Last attempt failed',
        headersMap: headers,
        messageLog: log,
      ),
      'wsCodeGenIntro': prompts.wsCodeGenIntroPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
      ),
      'generateWsCode': prompts.generateWsCodePrompt(
        url: url,
        headersMap: headers,
        paramsMap: params,
        settingsSummary: settings,
        messageLog: log,
        language: 'Python (websockets)',
      ),
      'generateWsDocumentation': prompts.generateWsDocumentationPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        paramsMap: params,
        settingsSummary: settings,
        messageLog: log,
      ),
      'generateWsTests': prompts.generateWsTestsPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        paramsMap: params,
        settingsSummary: settings,
        messageLog: log,
      ),
    };

    test('every WS prompt enforces the strict-JSON contract + refusal', () {
      allWsPrompts().forEach((name, prompt) {
        expect(prompt, contains('"explanation"'), reason: name);
        expect(prompt, contains('"actions"'), reason: name);
        expect(prompt, contains('RETURN THE JSON ONLY.'), reason: name);
        expect(
          prompt,
          contains(
            'I am Dashbot, an AI assistant focused specifically on '
            'API development tasks within API Dash.',
          ),
          reason: name,
        );
        expect(prompt, contains(url), reason: name);
      });
    });

    test('explanation-only WS prompts carry zero action vocabulary', () {
      explanationOnlyPrompts().forEach((name, prompt) {
        expect(prompt, contains('"actions": []'), reason: name);
        for (final word in actionVocabulary) {
          expect(
            prompt,
            isNot(contains(word)),
            reason: '$name must not mention "$word"',
          );
        }
      });
    });

    test('debugWsConnection whitelists exactly update_url + add_header '
        'on wsRequestModel with exactly 2 few-shots', () {
      final prompt = prompts.debugWsConnectionPrompt(
        url: url,
        connectionStatus: 'Last attempt failed',
        headersMap: headers,
        messageLog: log,
      );
      expect(
        prompt,
        contains('"action":"update_url","target":"wsRequestModel"'),
      );
      expect(
        prompt,
        contains('"action":"add_header","target":"wsRequestModel"'),
      );
      const forbidden = [
        'update_field',
        'update_header',
        'delete_header',
        'update_body',
        'update_method',
        'show_languages',
        'apply_curl',
        'apply_openapi',
        'download_doc',
        'no_action',
        'upload_asset',
        'httpRequestModel',
      ];
      for (final word in forbidden) {
        expect(
          prompt,
          isNot(contains(word)),
          reason: 'debugWsConnection must not mention "$word"',
        );
      }
      // Exactly two few-shot examples.
      expect('Example 1'.allMatches(prompt).length, 1);
      expect('Example 2'.allMatches(prompt).length, 1);
      expect(prompt, isNot(contains('Example 3')));
      // Required Markdown heading layout.
      expect(prompt, contains("## What's happening"));
      expect(prompt, contains('## Why'));
      expect(prompt, contains('## How to fix it'));
    });

    test('generateWsTests emits a code action, never an Add Test action', () {
      final prompt = prompts.generateWsTestsPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        paramsMap: params,
        settingsSummary: settings,
        messageLog: log,
      );
      expect(prompt, contains('"action":"other"'));
      expect(prompt, contains('"target":"code"'));
      expect(prompt, contains('JavaScript (Node.js ws)'));
      // target:"test" would render the HTTP "Add Test" button — forbidden.
      expect(prompt, isNot(contains('"target":"test"')));
      expect(prompt, isNot(contains('target: "test"')));
      expect(prompt, contains('# WebSocket Test Plan'));
      // Async-correctness contract: no sleeps, awaited promises w/ timeouts.
      expect(prompt, contains('NEVER wait for a message with a fixed sleep'));
      expect(prompt, contains('nextMessage(ws, timeoutMs)'));
    });

    test('wsCodeGenIntro emits show_languages with the websocket path', () {
      final prompt = prompts.wsCodeGenIntroPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
      );
      expect(prompt, contains('"action":"show_languages"'));
      expect(prompt, contains('"target":"codegen"'));
      expect(prompt, contains('"path":"websocket"'));
      for (final lib in [
        'JavaScript (WebSocket)',
        'Node.js (ws)',
        'Python (websockets)',
        'Dart (web_socket_channel)',
        'Go (gorilla/websocket)',
      ]) {
        expect(prompt, contains(lib));
      }
      expect(prompt, contains('Do not generate code yet.'));
    });

    test('generateWsCode carries the language into the code action', () {
      final prompt = prompts.generateWsCodePrompt(
        url: url,
        headersMap: headers,
        paramsMap: params,
        settingsSummary: settings,
        messageLog: log,
        language: 'Python (websockets)',
      );
      expect(prompt, contains('Requested Language: Python (websockets)'));
      expect(
        prompt,
        contains(
          '"action":"other","target":"code","path":"Python (websockets)"',
        ),
      );
      expect(prompt, isNot(contains('show_languages')));
      // Platform honesty note about browser header limits.
      expect(prompt, contains('cannot send custom headers'));
    });

    test('generateWsDocumentation uses the download_doc contract', () {
      final prompt = prompts.generateWsDocumentationPrompt(
        url: url,
        connectionStatus: status,
        headersMap: headers,
        paramsMap: params,
        settingsSummary: settings,
        messageLog: log,
      );
      expect(prompt, contains('"action": "download_doc"'));
      expect(prompt, contains('"target": "documentation"'));
      expect(prompt, contains('"path": "websocket-api-documentation"'));
      expect(prompt, contains('Connection Settings: $settings'));
      expect(prompt, contains('Markdown'));
    });
  });
}
