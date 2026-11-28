import 'package:apidash/services/agentic_services/agents/stac_to_flutter.dart';
import 'package:apidash/templates/templates.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StacToFlutterBot', () {
    final agent = StacToFlutterBot();

    test('agentName is correct', () {
      expect(agent.agentName, 'STAC_TO_FLUTTER');
    });

    test('getSystemPrompt returns the Stac to Flutter prompt', () {
      expect(agent.getSystemPrompt(), kPromptStacToFlutter);
      expect(agent.getSystemPrompt(), isNotEmpty);
    });

    test('validator always returns true', () async {
      expect(await agent.validator('any response'), isTrue);
      expect(await agent.validator(''), isTrue);
    });

    test('outputFormatter strips dart code fences', () async {
      const input = '```dart\nvoid main() {}\n```';
      final result = await agent.outputFormatter(input);
      expect(result, isA<Map>());
      expect(result['CODE'], '\nvoid main() {}\n');
    });

    test('outputFormatter keeps unfenced code unchanged', () async {
      final result = await agent.outputFormatter('void main() {}');
      expect(result['CODE'], 'void main() {}');
    });
  });
}
