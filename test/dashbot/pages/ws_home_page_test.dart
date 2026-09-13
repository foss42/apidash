import 'package:apidash/dashbot/pages/dashbot_home_page.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/ws_request_model.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders home page ws buttons', (tester) async {
    final requestModel = RequestModel(
      id: 'req-2',
      apiType: APIType.websocket,
      wsRequestModel: const WebSocketRequestModel(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
        ],
        child: const MaterialApp(home: Scaffold(body: DashbotHomePage())),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('🔌 Explain this connection'), findsOneWidget);
  });
}
