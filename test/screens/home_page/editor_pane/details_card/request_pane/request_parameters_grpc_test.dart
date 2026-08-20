import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/request_parameters_grpc.dart';
import 'package:apidash/models/request_model.dart';
import 'package:apidash/models/grpc_request_model.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';

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
        // Portal is required by the env-aware value field (EnvCellField uses
        // ExtendedTextField autocomplete) rendered for the string parameter.
        child: const Portal(
          child: MaterialApp(
            home: Scaffold(
              body: EditGrpcRequestParameters(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('stringParam'), findsOneWidget);
    expect(find.text('boolParam'), findsOneWidget);
    expect(find.text('enumParam'), findsOneWidget);

    // String param now uses the env-aware EnvCellField (was a raw
    // TextFormField); bool param now uses ADCheckBox (was a Switch).
    expect(find.byType(EnvCellField), findsOneWidget);
    expect(find.byType(ADCheckBox), findsOneWidget);
    expect(find.byType(ADDropdownButton<String>), findsOneWidget);
  });
}
