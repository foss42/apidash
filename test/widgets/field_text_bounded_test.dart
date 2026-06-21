import 'package:apidash/widgets/field_text_bounded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing BoundedTextField initialization and input', (tester) async {
    String changedValue = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BoundedTextField(
            value: 'Initial',
            onChanged: (val) => changedValue = val,
          ),
        ),
      ),
    );

    expect(find.text('Initial'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'New Value');
    await tester.pumpAndSettle();

    expect(changedValue, 'New Value');
  });

  testWidgets('Testing BoundedTextField didUpdateWidget resets on empty string', (tester) async {
    final ValueNotifier<String> valueNotifier = ValueNotifier('Initial');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<String>(
            valueListenable: valueNotifier,
            builder: (context, value, child) {
              return BoundedTextField(
                value: value,
                onChanged: (_) {},
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Initial'), findsOneWidget);

    // Enter a new value in UI without updating the widget's 'value' prop directly.
    await tester.enterText(find.byType(TextField), 'Typed Value');
    await tester.pumpAndSettle();

    expect(find.text('Typed Value'), findsOneWidget);

    // Update parent to pass empty string
    valueNotifier.value = '';
    await tester.pumpAndSettle();

    // Controller should have been reset to empty string
    expect(find.text('Typed Value'), findsNothing);
    
    // Now test a non-empty string update
    valueNotifier.value = 'Not Empty';
    await tester.pumpAndSettle();
    
    // Controller is NOT updated to 'Not Empty' because the logic in didUpdateWidget is:
    // if (widget.value == '') { controller.text = widget.value; }
    // So it should still be empty string.
    expect(find.text('Not Empty'), findsNothing);
  });
}
