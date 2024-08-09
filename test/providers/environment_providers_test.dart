import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

import '../models/environment_models.dart';
import '../services/hive_services_mock.mocks.dart';

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
        activeEnvironmentIdStateProvider
            .overrideWith((ref) => environmentModel1.id),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  /// The availableEnvironmentVariablesStateProvider watches the
  /// environmentsStateNotifierProvider and activeEnvironmentIdStateProvider
  /// providers. We attempt to test the availableEnvironmentVariablesStateProvider
  /// provider by providing the required values to the providers it watches.
  test("Testing availableEnvironmentVariablesStateProvider", () {
    final envMap = container.read(availableEnvironmentVariablesStateProvider);
    expect(envMap, {
      kGlobalEnvironmentId: [globalEnvironment.values],
      environmentModel1.id: [environmentModel1.values],
    });
  });
}
