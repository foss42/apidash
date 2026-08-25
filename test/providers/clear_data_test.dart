import 'package:apidash/consts.dart';
import 'package:apidash/models/models.dart';
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

  test('clearData only clears request collection data', () async {
    const request = RequestModel(
      id: 'request-id',
      httpRequestModel: HttpRequestModel(),
    );
    const globalEnvironment = EnvironmentModel(
      id: kGlobalEnvironmentId,
      name: 'Global',
      values: [
        EnvironmentVariableModel(
          key: 'baseUrl',
          value: 'https://example.com',
          enabled: true,
        ),
      ],
    );

    await hiveHandler.setIds(['request-id']);
    await hiveHandler.setRequestModel('request-id', request.toJson());
    await hiveHandler.setEnvironmentIds([kGlobalEnvironmentId]);
    await hiveHandler.setEnvironment(
      kGlobalEnvironmentId,
      globalEnvironment.toJson(),
    );
    await hiveHandler.setHistoryIds(['history-id']);
    await hiveHandler.setHistoryMeta('history-id', {'id': 'history-id'});
    await hiveHandler.setHistoryRequest('history-id', {'id': 'history-id'});
    await hiveHandler.saveDashbotMessages('saved messages');

    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);
    container.read(environmentsStateNotifierProvider.notifier);

    await notifier.clearData();

    expect(hiveHandler.getIds(), isNull);
    expect(hiveHandler.getRequestModel('request-id'), isNull);
    expect(hiveHandler.getEnvironmentIds(), [kGlobalEnvironmentId]);
    expect(hiveHandler.getEnvironment(kGlobalEnvironmentId), isNotNull);
    expect(hiveHandler.getHistoryIds(), ['history-id']);
    expect(hiveHandler.getHistoryMeta('history-id'), isNotNull);
    expect(await hiveHandler.getHistoryRequest('history-id'), isNotNull);
    expect(await hiveHandler.getDashbotMessages(), 'saved messages');
    expect(container.read(requestSequenceProvider), isEmpty);
    expect(container.read(selectedIdStateProvider), isNull);
    expect(container.read(collectionStateNotifierProvider), isEmpty);
    expect(
      container
          .read(
            availableEnvironmentVariablesStateProvider,
          )[kGlobalEnvironmentId]
          ?.single
          .key,
      'baseUrl',
    );
  });
}
