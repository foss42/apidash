import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/widgets/texts.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/widgets/card_history_request.dart';

void main() {
  testWidgets(
      'HistoryRequestCard displays correct information and handles onTap',
      (WidgetTester tester) async {
    final mockModel = HistoryMetaModel(
      historyId: 'historyId',
      requestId: 'requestId',
      url: 'https://api.apidash.dev',
      method: HTTPVerb.get,
      timeStamp: DateTime.now(),
      responseStatus: 200,
    );

    bool wasTapped = false;
    void mockOnTap() {
      wasTapped = true;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HistoryRequestCard(
            id: '1',
            model: mockModel,
            isSelected: true,
            onTap: mockOnTap,
          ),
        ),
      ),
    );

    expect(find.text(humanizeTime(mockModel.timeStamp)), findsOneWidget);

    expect(find.byType(StatusCode), findsOneWidget);

    await tester.tap(find.byType(InkWell));
    expect(wasTapped, isTrue);
  });
}
