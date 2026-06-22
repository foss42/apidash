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
}
