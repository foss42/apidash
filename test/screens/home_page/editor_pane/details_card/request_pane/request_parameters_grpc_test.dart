import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_parameters_grpc.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/providers/providers.dart';

void main() {
  testWidgets('EditGrpcRequestParameters renders correctly for empty params', (tester) async {
    const grpcModel = GrpcRequestModel(parameters: []);
    final requestModel = RequestModel(id: '1', grpcRequestModel: grpcModel);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: EditGrpcRequestParameters(),
          ),
        ),
      ),
    );

    expect(find.text("No parameters defined for this method."), findsOneWidget);
  });

  testWidgets('EditGrpcRequestParameters renders input fields based on type', (tester) async {
    const grpcModel = GrpcRequestModel(
      parameters: [
        GrpcParameterModel(name: 'stringParam', type: 'string', value: 'hello'),
        GrpcParameterModel(name: 'boolParam', type: 'bool', value: 'true'),
        GrpcParameterModel(name: 'enumParam', type: 'enum', value: 'VAL1', enumValues: ['VAL1', 'VAL2']),
      ],
    );
    final requestModel = RequestModel(id: '1', grpcRequestModel: grpcModel);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          selectedRequestModelProvider.overrideWith((ref) => requestModel),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: EditGrpcRequestParameters(),
          ),
        ),
      ),
    );

    expect(find.text('stringParam'), findsOneWidget);
    expect(find.text('boolParam'), findsOneWidget);
    expect(find.text('enumParam'), findsOneWidget);

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(ADDropdownButton<String>), findsOneWidget);
  });
}
