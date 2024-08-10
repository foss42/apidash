import 'package:apidash/providers/providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/envvar_span.dart';

import '../../models/environment_models.dart';
import '../../services/hive_services_mock.mocks.dart';

void main() {
  late MockHiveHandler mockHiveHandler;
  late ProviderContainer container;
  setUp(() {
    mockHiveHandler = MockHiveHandler();

    when(mockHiveHandler.getEnvironmentIds())
        .thenReturn([kGlobalEnvironmentId, environmentModel1.id]);
    when(mockHiveHandler.getEnvironment(kGlobalEnvironmentId))
        .thenReturn(globalEnvironment.toJson());
    when(mockHiveHandler.getEnvironment(environmentModel1.id))
        .thenReturn(environmentModel1Json);

    container = ProviderContainer(
      overrides: [
        environmentsStateNotifierProvider.overrideWith(
          (ref) => EnvironmentsStateNotifier(ref, mockHiveHandler),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  /// To test the EnvVarSpan widget, we need to provide the required providers
  /// with values and one of the providers is a StateNotifierProvider. Hence it
  /// calls hive services which we attempt to mock with mockHiveHandler.

  group("Testing EnvVarSpan widget", () {
    testWidgets("", (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            environmentsStateNotifierProvider.overrideWith(
                (ref) => EnvironmentsStateNotifier(ref, mockHiveHandler)),
            activeEnvironmentIdStateProvider
                .overrideWith((ref) => environmentModel1.id),
          ],
          child: const Portal(
            child: MaterialApp(
              home: Scaffold(
                body: EnvVarSpan(variableKey: 'key1'),
              ),
            ),
          ),
        ),
      );

      /// On hovering over the EnvVarSpan widget, the EnvVarPopover widget appears
      /// which we can test by checking if the text 'value1' is displayed.

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);
      await tester.pump();
      await gesture.moveTo(tester.getCenter(find.byType(EnvVarSpan)));
      await tester.pumpAndSettle();

      expect(find.text('value1'), findsOneWidget);
    });
  });
}
