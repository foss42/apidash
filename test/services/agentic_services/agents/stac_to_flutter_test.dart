import 'package:apidash/services/agentic_services/agents/stac_to_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('StacToFlutterBot', () {
    late StacToFlutterBot agent;

    setUp(() {
      agent = StacToFlutterBot();
    });

    test('agent name is correct', () {
      expect(agent.agentName, 'STAC_TO_FLUTTER');
    });

    group('validator', () {
      test('returns true for any string input', () async {
        const input = 'Widget build(BuildContext context) {}';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for empty string', () async {
        const input = '';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for dart code', () async {
        const input = '''
        class MyWidget extends StatelessWidget {
          @override
          Widget build(BuildContext context) {
            return Container();
          }
        }
        ''';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });

      test('returns true for flutter widget code', () async {
        const input = 'return Text("Hello World");';
        final result = await agent.validator(input);
        expect(result, isTrue);
      });
    });

    group('outputFormatter', () {
      test('removes dart code blocks', () async {
        const input = '```dart\nWidget build() {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['CODE'].trim(), 'Widget build() {}');
      });

      test('removes dart code blocks with newline in marker', () async {
        const input = '```dart\nclass MyClass {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['CODE'].trim(), 'class MyClass {}');
        expect(result['CODE'], isNot(contains('dart')));
      });

      test('handles input without code blocks', () async {
        const input = 'return Container();';
        final result = await agent.outputFormatter(input);
        expect(result['CODE'], 'return Container();');
      });

      test('returns map with CODE key', () async {
        const input = 'some flutter code';
        final result = await agent.outputFormatter(input);
        expect(result, isA<Map>());
        expect(result.containsKey('CODE'), isTrue);
      });

      test('removes all code block markers', () async {
        const input = '```dart\ncode here\n```\nmore```';
        final result = await agent.outputFormatter(input);
        expect(result['CODE'], isNot(contains('```')));
      });

      test('preserves code formatting and indentation', () async {
        const input = '''Widget build(BuildContext context) {
  return Column(
    children: [
      Text("test"),
    ],
  );
}''';
        final result = await agent.outputFormatter(input);
        expect(result['CODE'], contains('  '));
        expect(result['CODE'], contains('\n'));
      });

      test('handles multiple code block variations', () async {
        const input = '```dart```dart\nWidget test() {}\n```';
        final result = await agent.outputFormatter(input);
        expect(result['CODE'].trim(), 'Widget test() {}');
      });
    });
  });
}
