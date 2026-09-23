import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/services/agentic_services/agents/stac_to_flutter.dart';

void main() {
  group('StacToFlutterBot.validator', () {
    final bot = StacToFlutterBot();

    test('rejects empty response', () async {
      expect(await bot.validator(''), isFalse);
    });

    test('rejects whitespace-only response', () async {
      expect(await bot.validator('   \n\t  '), isFalse);
    });

    test(
      'accepts valid-looking Dart/Flutter response (bare widget tree)',
      () async {
        const code = '''
```dart
SingleChildScrollView(
  child: Column(
    children: [
      Text("Hello"),
      SizedBox(height: 12.0),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Sample"),
        ),
      ),
    ],
  ),
)
```
''';
        expect(await bot.validator(code), isTrue);
      },
    );

    test(
      'accepts valid-looking Dart/Flutter response without code fence',
      () async {
        const code = 'Container(child: Text("hello world"))';
        expect(await bot.validator(code), isTrue);
      },
    );

    test('rejects clearly non-code response', () async {
      expect(
        await bot.validator(
          'This is just a plain text response with no code at all here.',
        ),
        isFalse,
      );
    });

    test(
      'rejects prose containing a capitalized parenthetical (false-positive guard)',
      () async {
        expect(
          await bot.validator(
            'Please check the Widget (see the documentation) before proceeding.',
          ),
          isFalse,
        );
      },
    );
    test('rejects response that is only empty code fences', () async {
      expect(await bot.validator('```dart\n```'), isFalse);
    });
  });
}
