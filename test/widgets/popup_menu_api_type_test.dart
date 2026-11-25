import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_core/apidash_core.dart';

void main() {
  testWidgets('APITypePopupMenu displays initial value', (
    WidgetTester tester,
  ) async {
    const apiType = APIType.rest;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: APITypePopupMenu(apiType: apiType)),
      ),
    );

    expect(find.text(apiType.label), findsOneWidget);
    expect(find.byIcon(Icons.unfold_more), findsOneWidget);
  });

  testWidgets('APITypePopupMenu displays popup menu items', (
    WidgetTester tester,
  ) async {
    const apiType = APIType.rest;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: APITypePopupMenu(apiType: apiType)),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    // The selected item appears twice (once on the button, once in the opened popup list)
    expect(find.text(apiType.label), findsExactly(2));
    expect(find.text(APIType.websocket.label), findsOneWidget);
    expect(find.text(APIType.mqtt.label), findsOneWidget);
    expect(find.text(APIType.graphql.label), findsOneWidget);
    expect(find.text(APIType.grpc.label), findsOneWidget);
  });

  testWidgets('APITypePopupMenu calls onChanged when an item is selected', (
    WidgetTester tester,
  ) async {
    const apiType = APIType.rest;
    APIType? selectedType;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: APITypePopupMenu(
            apiType: apiType,
            onChanged: (value) {
              selectedType = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.unfold_more));
    await tester.pumpAndSettle();

    await tester.tap(find.text(APIType.websocket.label).last);
    await tester.pumpAndSettle();

    expect(selectedType, APIType.websocket);
  });
}
