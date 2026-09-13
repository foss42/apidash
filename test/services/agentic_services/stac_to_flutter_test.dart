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
      // 1. Empty response -> rejected
      test('rejects empty response', () async {
        expect(await agent.validator(''), isFalse);
      });

      // 2. Whitespace-only response -> rejected
      test('rejects whitespace-only response', () async {
        expect(await agent.validator('   \n\t  '), isFalse);
      });

      // 3. Valid-looking Dart/Flutter response -> accepted
      group('accepts valid-looking Dart/Flutter responses', () {
        test('accepts widget with import and class definition', () async {
          const input =
              "import 'package:flutter/material.dart';\nclass MyWidget extends StatelessWidget { ... }";
          expect(await agent.validator(input), isTrue);
        });

        test('accepts plain class without flutter imports', () async {
          const input = "class Foo { String bar() => 'baz'; }";
          expect(await agent.validator(input), isTrue);
        });

        test('accepts realistic Flutter widget class with build method', () async {
          const input = '''
class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}
''';
          expect(await agent.validator(input), isTrue);
        });

        test('accepts code wrapped in markdown dart code fence', () async {
          const input = '''
```dart
import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Card(child: Text('Card Content'));
}
```
''';
          expect(await agent.validator(input), isTrue);
        });

        test('accepts code wrapped in generic markdown code fence', () async {
          const input = '''
```
class SampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}
```
''';
          expect(await agent.validator(input), isTrue);
        });

        test('accepts standalone widget tree expression', () async {
          const input = '''
Container(
  padding: const EdgeInsets.all(8.0),
  child: const Text('Hello'),
)
''';
          expect(await agent.validator(input), isTrue);
        });

        test('accepts valid code containing refusal-like words inside string literals', () async {
          const input = '''
class ErrorDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text("Sorry, I cannot help with this");
  }
}
''';
          expect(await agent.validator(input), isTrue);
        });

        test('accepts valid code with comments', () async {
          const input = '''
// This converts the SDUI representation into Flutter
/* Multi-line comment here */
class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(height: 10);
}
''';
          expect(await agent.validator(input), isTrue);
        });
      });

      // 4. Clearly non-code/plain-text response -> rejected
      group('rejects clearly non-code and refusal responses', () {
        test('rejects refusal: "I can\'t help with this"', () async {
          expect(await agent.validator("I can't help with this"), isFalse);
        });

        test('rejects refusal: "I cannot help with this"', () async {
          expect(await agent.validator("I cannot help with this"), isFalse);
        });

        test('rejects conversational: "Here is the answer..."', () async {
          expect(await agent.validator("Here is the answer..."), isFalse);
        });

        test('rejects AI refusal message', () async {
          const input =
              'I am sorry, but I cannot convert this SDUI representation into Flutter code.';
          expect(await agent.validator(input), isFalse);
        });

        test('rejects "As an AI..." response', () async {
          const input =
              'As an AI model, I am unable to generate code for the provided input.';
          expect(await agent.validator(input), isFalse);
        });

        test('rejects arbitrary plain English commentary', () async {
          const input =
              'This is a plain text response explaining that Flutter uses widgets.';
          expect(await agent.validator(input), isFalse);
        });

        test('rejects markdown code block with conversational preamble', () async {
          const input = '''
Here is the code you requested:
```dart
class MyWidget extends StatelessWidget {}
```
''';
          expect(await agent.validator(input), isFalse);
        });

        test('rejects markdown code block with conversational postamble', () async {
          const input = '''
```dart
class MyWidget extends StatelessWidget {}
```
Hope this helps! Let me know if you need anything else.
''';
          expect(await agent.validator(input), isFalse);
        });

        test('rejects empty markdown code fence', () async {
          expect(await agent.validator('```dart\n```'), isFalse);
          expect(await agent.validator('```dart\n   \n```'), isFalse);
          expect(await agent.validator('```\n```'), isFalse);
        });

        test('rejects unclosed markdown code fence', () async {
          const input = '```dart\nclass MyWidget extends StatelessWidget {}';
          expect(await agent.validator(input), isFalse);
        });
      });
    });

    group('outputFormatter', () {
      test('strips markdown code block tags', () async {
        const input = '```dart\nclass Foo {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result['CODE'], '\nclass Foo {}\n');
      });

      test('strips generic markdown code block tags', () async {
        const input = '```\nclass Bar {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result['CODE'], '\nclass Bar {}\n');
      });

      test('preserves clean code as-is', () async {
        const input = 'class Foo {}';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result['CODE'], 'class Foo {}');
      });
    });
  });
}
