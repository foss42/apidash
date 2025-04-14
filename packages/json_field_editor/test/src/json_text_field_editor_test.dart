import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_field_editor/json_field_editor.dart';

void main() {
  testWidgets('JsonTextField Widget Test. Formatting a valid json', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    final controller = JsonTextFieldController();
    controller.value = const TextEditingValue(
      text: '{"key": "value"}',
      selection: TextSelection.collapsed(offset: 0),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 300,
            width: 300,
            child: JsonField(
              key: ValueKey("1"),
              isFormatting: true,
              doInitFormatting: true,
              controller: controller,
            ),
          ),
        ),
      ),
    );

    // Verify that JsonField is present.
    expect(find.byKey(ValueKey("1")), findsOneWidget);
    expect(controller.text, equals('{\n  "key": "value"\n}'));
  });

  testWidgets(
    'JsonField Widget Test. Formatting a valid json using controller',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      final controller = JsonTextFieldController();
      controller.value = const TextEditingValue(
        text: '{"key": "value"}',
        selection: TextSelection.collapsed(offset: 0),
      );
      controller.formatJson(sortJson: false);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 300,
              width: 300,
              child: JsonField(
                key: ValueKey("2"),
                isFormatting: true,
                controller: controller,
              ),
            ),
          ),
        ),
      );

      // Verify that JsonField is present.
      expect(find.byKey(ValueKey("2")), findsOneWidget);
      expect(controller.text, equals('{\n  "key": "value"\n}'));
    },
  );

  testWidgets('JsonField Widget Test, invalid Json', (
    WidgetTester tester,
  ) async {
    final controller = JsonTextFieldController();
    controller.value = const TextEditingValue(
      text: '{"key": "value"',
      selection: TextSelection.collapsed(offset: 0),
    );

    controller.formatJson(sortJson: false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JsonField(
            key: ValueKey("3"),
            isFormatting: true,
            controller: controller,
          ),
        ),
      ),
    );

    // Verify that JsonField is present.
    expect(find.byKey(ValueKey("3")), findsOneWidget);
    expect(controller.text, equals('{"key": "value"'));
  });

  testWidgets('JsonField Widget Test, in a valid Json', (
    WidgetTester tester,
  ) async {
    final controller = JsonTextFieldController();
    controller.value = const TextEditingValue(
      text: '{"key": "value","anotherKey": "anotherValue","list": [3,2,1]}',
      selection: TextSelection.collapsed(offset: 0),
    );

    // Build our app and trigger a frame.
    controller.formatJson(sortJson: true);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JsonField(
            key: ValueKey("4"),
            isFormatting: true,
            controller: controller,
          ),
        ),
      ),
    );

    // Verify that JsonField is present.
    expect(find.byKey(ValueKey("4")), findsOneWidget);
    expect(
      controller.text,
      equals(
        '{\n  "anotherKey": "anotherValue",\n  "key": "value",\n  "list": [\n    3,\n    2,\n    1\n  ]\n}',
      ),
    );
  });
}
