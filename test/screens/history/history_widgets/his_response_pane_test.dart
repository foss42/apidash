import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/response_widgets.dart';
import 'package:apidash/screens/history/history_widgets/his_response_pane.dart';

import '../../../models/history_models.dart';

void main() {
  group('HistoryResponsePane Widget Tests', () {
    testWidgets('displays "No Request Selected" when no request is selected',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryIdStateProvider.overrideWith((ref) => null),
            selectedHistoryRequestModelProvider.overrideWith((ref) => null),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: HistoryResponsePane(),
            ),
          ),
        ),
      );

      expect(find.text("No Request Selected"), findsOneWidget);
    });

    testWidgets(
        'displays ResponsePaneHeader and ResponseTabView when a request is selected',
        (tester) async {
      final historyRequestModel = historyRequestModel1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHistoryIdStateProvider
                .overrideWith((ref) => historyRequestModel.historyId),
            selectedHistoryRequestModelProvider
                .overrideWith((ref) => historyRequestModel),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: HistoryResponsePane(),
            ),
          ),
        ),
      );

      expect(find.byType(ResponsePaneHeader), findsOneWidget);
      expect(find.byType(ResponseTabView), findsOneWidget);
    });
  });
}
