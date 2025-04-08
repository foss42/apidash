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
            child: JsonField(isFormatting: true, controller: controller),
          ),
        ),
      ),
    );

    // Verify that JsonTextField is present.
    expect(find.byType(JsonField), findsOneWidget);
    expect(controller.text, equals('{\n  "key": "value"\n}'));
  });

  testWidgets(
    'JsonTextField Widget Test. Formatting a valid json using controller',
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
              child: JsonField(isFormatting: true, controller: controller),
            ),
          ),
        ),
      );

      // Verify that JsonTextField is present.
      expect(find.byType(JsonField), findsOneWidget);
      expect(controller.text, equals('{\n  "key": "value"\n}'));
    },
  );

  testWidgets('JsonTextField Widget Test, invalid Json', (
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
          body: JsonField(isFormatting: true, controller: controller),
        ),
      ),
    );

    // Verify that JsonTextField is present.
    expect(find.byType(JsonField), findsOneWidget);
    expect(controller.text, equals('\n{"key": "value"'));
  });
  testWidgets('JsonTextField Widget Test, in a valid Json', (
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
          body: JsonField(isFormatting: true, controller: controller),
        ),
      ),
    );

    // Verify that JsonTextField is present.
    expect(find.byType(JsonField), findsOneWidget);
    expect(
      controller.text,
      equals(
        '{\n  "anotherKey": "anotherValue",\n  "key": "value",\n  "list": [\n    3,\n    2,\n    1\n  ]\n}',
      ),
    );
  });
}
