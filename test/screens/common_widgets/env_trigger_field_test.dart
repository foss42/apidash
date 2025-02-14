import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';

void main() {
  testWidgets(
      'EnvironmentTriggerField renders and displays MultiTriggerAutocomplete with triggers',
      (tester) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();

    await tester.pumpWidget(
      Portal(
        child: MaterialApp(
          home: Scaffold(
            body: EnvironmentTriggerField(
              keyId: 'testKey',
              controller: controller,
              focusNode: focusNode,
            ),
          ),
        ),
      ),
    );

    final multiTriggerAutocomplete = find.byType(MultiTriggerAutocomplete);
    expect(multiTriggerAutocomplete, findsOneWidget);
    final triggers = tester
        .widget<MultiTriggerAutocomplete>(multiTriggerAutocomplete)
        .autocompleteTriggers;
    expect(triggers.length, 2);
    expect(triggers.first.trigger, '{');
    expect(triggers.elementAt(1).trigger, '{{');
  });
}
