import 'package:apidash/widgets/editor_json.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing JsonTextFieldEditor initialization and format button', (tester) async {
    String changedValue = '';
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JsonTextFieldEditor(
            fieldKey: 'test_key',
            initialValue: '{"a":1}',
            onChanged: (val) => changedValue = val,
            isDark: false,
          ),
        ),
      ),
    );

    // Tap format button
    await tester.tap(find.byType(ADIconButton));
    await tester.pumpAndSettle();

    // After formatting
    expect(changedValue, contains('{\n  "a": 1\n}'));
  });

  testWidgets('Testing JsonTextFieldEditor insertTab', (tester) async {
    String changedValue = '';
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JsonTextFieldEditor(
            fieldKey: 'test_key_tab',
            initialValue: 'a',
            onChanged: (val) => changedValue = val,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(JsonTextFieldEditor));
    await tester.pump();
    
    // Simulate tab key press
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    expect(changedValue, 'a  ');
  });

  testWidgets('Testing JsonTextFieldEditor didUpdateWidget', (tester) async {
    final ValueNotifier<String> initialValueNotifier = ValueNotifier('{"a":1}');
    final ValueNotifier<bool> isDarkNotifier = ValueNotifier(false);
    final ValueNotifier<String> fieldKeyNotifier = ValueNotifier('key1');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<String>(
            valueListenable: initialValueNotifier,
            builder: (context, value, _) {
              return ValueListenableBuilder<bool>(
                valueListenable: isDarkNotifier,
                builder: (context, isDark, _) {
                  return ValueListenableBuilder<String>(
                    valueListenable: fieldKeyNotifier,
                    builder: (context, fieldKey, _) {
                      return JsonTextFieldEditor(
                        fieldKey: fieldKey,
                        initialValue: value,
                        isDark: isDark,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    initialValueNotifier.value = '{"b":2}';
    await tester.pumpAndSettle();

    isDarkNotifier.value = true;
    await tester.pumpAndSettle();
    
    fieldKeyNotifier.value = 'key2';
    await tester.pumpAndSettle();
  });

  testWidgets('Testing JsonTextFieldEditor onTapOutside', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: JsonTextFieldEditor(
            fieldKey: 'test_key_focus',
          ),
        ),
      ),
    );

    await tester.tap(find.byType(JsonTextFieldEditor));
    await tester.pumpAndSettle();

    // Tap outside
    await tester.tapAt(const Offset(0, 0));
    await tester.pumpAndSettle();
  });
}
