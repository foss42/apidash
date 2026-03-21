import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String? clipboardText;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform,
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'Clipboard.getData':
          return <String, dynamic>{'text': clipboardText};
        case 'Clipboard.setData':
          clipboardText =
              (methodCall.arguments as Map<Object?, Object?>?)?['text']
                  as String?;
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    clipboardText = null;
  });

  testWidgets('Testing EnvironmentTriggerField updates the controller text',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'initial';
    const updatedValue = 'updated';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    Finder field = find.byType(ExtendedTextField);
    expect(field, findsOneWidget);
    expect(fieldKey.currentState!.controller.text, initialValue);

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: updatedValue,
            ),
          ),
        ),
      ),
    );

    expect(fieldKey.currentState!.controller.text, updatedValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField with empty initialValue clears the controller text',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'initial';
    const emptyValue = '';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    Finder field = find.byType(ExtendedTextField);
    expect(field, findsOneWidget);
    expect(fieldKey.currentState!.controller.text, initialValue);

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: emptyValue,
            ),
          ),
        ),
      ),
    );

    expect(fieldKey.currentState!.controller.text, emptyValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField preserves cursor position on text update',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'hello world';
    const updatedValue = 'hello world!';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    // Set cursor to position 5 (middle of text)
    fieldKey.currentState!.controller.selection =
        TextSelection.collapsed(offset: 5);

    // Update the text value
    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: updatedValue,
            ),
          ),
        ),
      ),
    );

    // Verify cursor is still at position 5
    expect(fieldKey.currentState!.controller.selection.baseOffset, 5);
    expect(fieldKey.currentState!.controller.text, updatedValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField preserves text selection on text update',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'hello world';
    const updatedValue = 'hello world!';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    // Set text selection from position 0 to 5 (highlighted text)
    fieldKey.currentState!.controller.selection =
        TextSelection(baseOffset: 0, extentOffset: 5);

    // Update the text value
    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: updatedValue,
            ),
          ),
        ),
      ),
    );

    // Verify selection is preserved (both base and extent offsets)
    expect(fieldKey.currentState!.controller.selection.baseOffset, 0);
    expect(fieldKey.currentState!.controller.selection.extentOffset, 5);
    expect(fieldKey.currentState!.controller.text, updatedValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField resets cursor when keyId changes',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    const initialValue = 'hello world';
    const newValue = 'new request';

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey1',
              initialValue: initialValue,
            ),
          ),
        ),
      ),
    );

    // Set cursor to position 5
    fieldKey.currentState!.controller.selection =
        TextSelection.collapsed(offset: 5);

    // Change keyId (different request selected)
    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey2',
              initialValue: newValue,
            ),
          ),
        ),
      ),
    );

    // Verify cursor is reset to end of new text (different request)
    expect(fieldKey.currentState!.controller.selection.baseOffset,
        newValue.length);
    expect(fieldKey.currentState!.controller.text, newValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField clears text when keyId changes with null initialValue',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey1',
              initialValue: 'hello world',
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey2',
            ),
          ),
        ),
      ),
    );

    expect(fieldKey.currentState!.controller.text, isEmpty);
    expect(fieldKey.currentState!.controller.selection.baseOffset, 0);
  });

  testWidgets(
      'Testing EnvironmentTriggerField detects pasted curl text and restores previous value',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    String? interceptedText;
    final changes = <String>[];

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: 'https://api.apidash.dev',
              onChanged: changes.add,
              onPastedText: (text) async {
                interceptedText = text;
                return true;
              },
            ),
          ),
        ),
      ),
    );

    const curlCommand = 'curl -X GET https://api.apidash.dev/users';
    await Clipboard.setData(const ClipboardData(text: curlCommand));
    final field = tester.widget<ExtendedTextField>(find.byType(ExtendedTextField));
    fieldKey.currentState!.controller.value = const TextEditingValue(
      text: curlCommand,
      selection: TextSelection.collapsed(offset: curlCommand.length),
    );
    field.onChanged!(curlCommand);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(interceptedText, curlCommand);
    expect(changes, ['https://api.apidash.dev']);
    expect(fieldKey.currentState!.controller.text, 'https://api.apidash.dev');
  });

  testWidgets(
      'Testing EnvironmentTriggerField does not treat normal typing as pasted curl text',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    String? interceptedText;

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              onPastedText: (text) async {
                interceptedText = text;
                return true;
              },
            ),
          ),
        ),
      ),
    );

    const typedValue = 'https://api.apidash.dev/users';
    await Clipboard.setData(const ClipboardData(text: 'different clipboard'));
    final field = tester.widget<ExtendedTextField>(find.byType(ExtendedTextField));
    fieldKey.currentState!.controller.value = const TextEditingValue(
      text: typedValue,
      selection: TextSelection.collapsed(offset: typedValue.length),
    );
    field.onChanged!(typedValue);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(interceptedText, isNull);
    expect(fieldKey.currentState!.controller.text, typedValue);
  });

  testWidgets(
      'Testing EnvironmentTriggerField ignores stale async paste results after a newer edit',
      (WidgetTester tester) async {
    final fieldKey = GlobalKey<EnvironmentTriggerFieldState>();
    final completer = Completer<bool>();
    final changes = <String>[];

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              key: fieldKey,
              keyId: 'testKey',
              initialValue: 'https://api.apidash.dev',
              onChanged: changes.add,
              onPastedText: (_) => completer.future,
            ),
          ),
        ),
      ),
    );

    const curlCommand = 'curl -X GET https://api.apidash.dev/users';
    await Clipboard.setData(const ClipboardData(text: curlCommand));
    final field = tester.widget<ExtendedTextField>(find.byType(ExtendedTextField));
    fieldKey.currentState!.controller.value = const TextEditingValue(
      text: curlCommand,
      selection: TextSelection.collapsed(offset: curlCommand.length),
    );
    field.onChanged!(curlCommand);

    const newerValue = 'https://api.apidash.dev/profile';
    fieldKey.currentState!.controller.value = const TextEditingValue(
      text: newerValue,
      selection: TextSelection.collapsed(offset: newerValue.length),
    );
    field.onChanged!(newerValue);

    completer.complete(true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(changes, [newerValue]);
    expect(fieldKey.currentState!.controller.text, newerValue);
  });
}
