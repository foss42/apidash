import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
    await clearHiveBoxes();
  });

  test(
    'clearData removes a persisted environment variable from active '
    'in-memory state, not just from disk (#1770)',
    () async {
      const globalEnvironment = EnvironmentModel(
        id: kGlobalEnvironmentId,
        name: 'Global',
        values: [
          EnvironmentVariableModel(
            key: 'baseUrl',
            value: 'https://httpbin.org',
            enabled: true,
          ),
        ],
      );

      await hiveHandler.setEnvironmentIds([kGlobalEnvironmentId]);
      await hiveHandler.setEnvironment(
        kGlobalEnvironmentId,
        globalEnvironment.toJson(),
      );

      final container = createContainer();
      // Force the notifier to load the persisted environment above into
      // memory, mirroring app startup.
      container.read(environmentsStateNotifierProvider.notifier);

      expect(
        container
            .read(availableEnvironmentVariablesStateProvider)[kGlobalEnvironmentId]
            ?.map((v) => v.key),
        contains('baseUrl'),
      );

      final notifier = container.read(collectionStateNotifierProvider.notifier);
      await notifier.clearData();

      // Persisted copy is gone.
      expect(hiveHandler.getEnvironmentIds(), isNull);

      // In-memory copy must be gone too, immediately -- previously this
      // stayed populated until the app was restarted, so a deleted variable
      // kept resolving in outgoing requests.
      expect(
        container
            .read(availableEnvironmentVariablesStateProvider)[kGlobalEnvironmentId],
        isEmpty,
      );
      expect(
        container.read(environmentsStateNotifierProvider)?[kGlobalEnvironmentId]?.values,
        isEmpty,
      );
    },
  );
}
