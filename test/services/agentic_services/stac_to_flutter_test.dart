import 'package:apidash/services/agentic_services/agents/stac_to_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StacToFlutterBot', () {
    final agent = StacToFlutterBot();

    test('agentName is correct', () {
      expect(agent.agentName, 'STAC_TO_FLUTTER');
    });

    test('getSystemPrompt returns non-empty string', () {
      expect(agent.getSystemPrompt(), isNotEmpty);
    });

    group('validator', () {
      test('rejects empty response', () async {
        expect(await agent.validator(''), isFalse);
      });

      test('rejects whitespace-only response', () async {
        expect(await agent.validator('   \n\t  '), isFalse);
        expect(await agent.validator('\n\n\n'), isFalse);
      });

      test('rejects empty code fences', () async {
        expect(await agent.validator('```dart\n```'), isFalse);
        expect(await agent.validator('```dart\n   \n```'), isFalse);
        expect(await agent.validator('```\n```'), isFalse);
      });

      test('rejects obvious refusal responses', () async {
        expect(
          await agent.validator(
            "I'm sorry, but I cannot fulfill this request.",
          ),
          isFalse,
        );
        expect(
          await agent.validator(
            'Sorry, I am unable to generate Flutter code for this SDUI.',
          ),
          isFalse,
        );
        expect(
          await agent.validator(
            'I cannot convert the provided SDUI to Flutter.',
          ),
          isFalse,
        );
        expect(
          await agent.validator(
            'As an AI language model, I cannot assist with that request.',
          ),
          isFalse,
        );
        expect(
          await agent.validator(
            'Unfortunately, I am unable to convert this SDUI component.',
          ),
          isFalse,
        );
        expect(
          await agent.validator(
            "```dart\nI'm sorry, I cannot generate Flutter code.\n```",
          ),
          isFalse,
        );
      });

      test('rejects plain-text / non-code responses', () async {
        expect(
          await agent.validator('Here is the Flutter code you requested:'),
          isFalse,
        );
        expect(
          await agent.validator('Invalid SDUI representation provided.'),
          isFalse,
        );
        expect(
          await agent.validator(
            'SDUI (Server-Driven UI) allows dynamic rendering of Flutter widgets.',
          ),
          isFalse,
        );
        expect(
          await agent.validator(
            'Error: Failed to parse SDUI (invalid JSON structure).',
          ),
          isFalse,
        );
        expect(await agent.validator('// I cannot convert this SDUI'), isFalse);
        expect(
          await agent.validator('/* Unable to process this request */'),
          isFalse,
        );
      });

      test('accepts representative valid Flutter widget snippets', () async {
        const snippet = '''
Container(
  padding: const EdgeInsets.all(8.0),
  child: const Text('Hello World'),
)
''';
        expect(await agent.validator(snippet), isTrue);
      });

      test('accepts full Flutter widget classes', () async {
        const fullWidget = '''
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('Hello'),
    );
  }
}
''';
        expect(await agent.validator(fullWidget), isTrue);
      });

      test('accepts single widget expression with semicolon', () async {
        expect(await agent.validator("const Text('Simple Text');"), isTrue);
      });

      test(
        'accepts valid code with text containing refusal keywords in string literals',
        () async {
          const codeWithApologyText = '''
Center(
  child: Text("Sorry, unable to load data"),
)
''';
          expect(await agent.validator(codeWithApologyText), isTrue);

          const codeWithErrorText = '''
Column(
  children: [
    Icon(Icons.error),
    Text('I cannot connect to the server'),
  ],
)
''';
          expect(await agent.validator(codeWithErrorText), isTrue);
        },
      );

      test('accepts valid code with comments', () async {
        const codeWithComments = '''
// Converted from SDUI representation
Container(
  child: Text('Hello'),
)
''';
        expect(await agent.validator(codeWithComments), isTrue);
      });

      test('handles code fences correctly', () async {
        const fencedDart = '''
```dart
Container(
  child: Text('Hello'),
)
```
''';
        expect(await agent.validator(fencedDart), isTrue);

        const fencedFlutter = '''
```flutter
Center(
  child: Text('Hello'),
)
```
''';
        expect(await agent.validator(fencedFlutter), isTrue);

        const genericFence = '''
```
Scaffold(
  body: Center(
    child: Text('Hello'),
  ),
)
```
''';
        expect(await agent.validator(genericFence), isTrue);
      });
    });

    test('outputFormatter strips code fences and returns CODE map', () async {
      const input = '''
```dart
Container(
  child: Text('Test'),
)
```
''';
      final result = await agent.outputFormatter(input);
      expect(result, isA<Map>());
      expect(result['CODE'], contains("Container(\n  child: Text('Test'),\n)"));
      expect(result['CODE'], isNot(contains('```')));
    });
  });
}
