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
  });

  test('addHistoryRequest persists unique history ids only', () async {
    final container = createContainer();
    final notifier = container.read(historyMetaStateNotifier.notifier);

    final historyId = getNewUuid();
    final model = HistoryRequestModel(
      historyId: historyId,
      metaData: HistoryMetaModel(
        historyId: historyId,
        requestId: getNewUuid(),
        apiType: APIType.rest,
        url: 'https://api.apidash.dev',
        method: HTTPVerb.get,
        responseStatus: 200,
        timeStamp: DateTime.now(),
      ),
      httpResponseModel: const HttpResponseModel(),
    );

    notifier.addHistoryRequest(model);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final historyIds = hiveHandler.getHistoryIds() as List<String>?;
    expect(historyIds, isNotNull);
    expect(historyIds, [historyId]);
  });
}
