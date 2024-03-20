import 'package:apidash/consts.dart';
import 'package:apidash/widgets/overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';

void main() {
  testWidgets('OverlayWidgetTemplate Test', (WidgetTester tester) async {
    late OverlayWidgetTemplate overlayWidget;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            overlayWidget = OverlayWidgetTemplate(context: context);
            return Container(); // Return any widget here, as OverlayWidgetTemplate doesn't return a widget
          },
        ),
      ),
    );

    overlayWidget.show(widget: const Text('Test'));
    await tester.pump();
    expect(find.text('Test'), findsOneWidget);

    overlayWidget.hide();
    await tester.pump();
    expect(find.text('Test'), findsNothing);
  });

  testWidgets('SavingOverlay Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SavingOverlay(
            saveCompleted: false,
          ),
        ),
      ),
    );
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Lottie), findsOneWidget);
    expect(find.text(kLabelSaving), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SavingOverlay(
            saveCompleted: true,
          ),
        ),
      ),
    );
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Lottie), findsOneWidget);
    expect(find.text(kLabelSaved), findsOneWidget);
  });
}
