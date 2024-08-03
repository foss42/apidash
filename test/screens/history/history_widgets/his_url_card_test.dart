import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/history/history_widgets/his_url_card.dart';

import '../../../models/history_models.dart';

void main() {
  group('Testing HistoryURLCard', () {
    final historyRequestModel = historyRequestModel1;

    testWidgets('Testing with given HistoryRequestModel', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryURLCard(historyRequestModel: historyRequestModel),
          ),
        ),
      );

      expect(find.byType(HistoryURLCard), findsOneWidget);
    });

    testWidgets('Testing if displays correct request method', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryURLCard(historyRequestModel: historyRequestModel),
          ),
        ),
      );

      expect(
          find.text(
              historyRequestModel.httpRequestModel.method.name.toUpperCase()),
          findsOneWidget);
    });

    testWidgets('Testing if displays correct URL', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryURLCard(historyRequestModel: historyRequestModel),
          ),
        ),
      );

      expect(
          find.text(historyRequestModel.httpRequestModel.url), findsOneWidget);
    });
  });
}
