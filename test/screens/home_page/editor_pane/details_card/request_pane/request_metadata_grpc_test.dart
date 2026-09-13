import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_metadata_grpc.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/providers/providers.dart';

void main() {
  testWidgets('EditGrpcRequestMetadata renders table and add button', (
    tester,
  ) async {
    const grpcModel = GrpcRequestModel(url: 'localhost:50051');
    final requestModel = RequestModel(id: '1', grpcRequestModel: grpcModel);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
        ],
        // Portal is required by the env-aware metadata fields
        // (EnvHeaderField/EnvCellField use ExtendedTextField autocomplete).
        child: const Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 800,
                height: 600,
                child: EditGrpcRequestMetadata(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(DataTable2), findsOneWidget);
    expect(find.text('Add Metadata'), findsOneWidget);
  });
}
