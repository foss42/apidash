import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/history_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  test('selected request group updates when history meta state changes', () async {
    final container = createContainer();
    final notifier = container.read(historyMetaStateNotifier.notifier);

    final historyId = getNewUuid();
    container.read(selectedHistoryIdStateProvider.notifier).state = historyId;

    expect(container.read(selectedRequestGroupIdStateProvider), isNull);

    final meta = HistoryMetaModel(
      historyId: historyId,
      requestId: getNewUuid(),
      apiType: APIType.rest,
      name: 'History item',
      url: 'https://api.apidash.dev/todos',
      method: HTTPVerb.get,
      responseStatus: 200,
      timeStamp: DateTime.now(),
    );

    final model = HistoryRequestModel(
      historyId: historyId,
      metaData: meta,
      httpResponseModel: const HttpResponseModel(),
    );
    notifier.addHistoryRequest(model);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(
      container.read(selectedRequestGroupIdStateProvider),
      getHistoryRequestKey(meta),
    );
  });
}
