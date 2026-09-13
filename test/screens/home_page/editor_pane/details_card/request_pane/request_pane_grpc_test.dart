import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_pane_grpc.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/providers/providers.dart';

void main() {
  testWidgets('EditGrpcRequestPane renders all tabs and dropdowns', (
    tester,
  ) async {
    // A selected service/method is required for the invocation dropdowns to
    // display their current value (DropdownButton keeps unselected items
    // offstage), so seed both alongside the available lists.
    const grpcModel = GrpcRequestModel(
      url: 'localhost:50051',
      availableServices: ['TestService'],
      availableMethods: ['TestMethod'],
      service: 'TestService',
      method: 'TestMethod',
    );
    final requestModel = RequestModel(id: '1', grpcRequestModel: grpcModel);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
        ],
        // Portal is required by the env-aware metadata fields (ExtendedTextField
        // autocomplete) that build when the Metadata tab is materialised.
        child: const Portal(
          child: MaterialApp(home: Scaffold(body: EditGrpcRequestPane())),
        ),
      ),
    );

    // Verify tabs
    expect(find.text('Invocation'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Metadata'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify dropdowns in Invocation tab
    expect(find.text('TestService'), findsOneWidget);
    expect(find.text('TestMethod'), findsOneWidget);

    // Navigate to Body tab
    await tester.tap(find.text('Body'));
    await tester.pumpAndSettle();
    expect(find.text('Request Body (JSON)'), findsOneWidget);

    // Navigate to Settings tab
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Port: '), findsOneWidget);
    expect(find.text('Use TLS'), findsOneWidget);
    // Discovery in Settings is now the proto-only path: "Select .proto" +
    // "Fetch services". The old "Use Reflection" toggle was removed (reflection
    // now lives on the URL-bar "Reflect" button).
    expect(find.text('Use Reflection'), findsNothing);
    expect(find.text('Select .proto'), findsOneWidget);
    expect(find.text('Fetch services'), findsOneWidget);
  });
}
