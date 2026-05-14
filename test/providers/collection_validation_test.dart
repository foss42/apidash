import 'package:apidash/providers/providers.dart';
import 'package:apidash/terminal/terminal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  test('sendRequest stops early when validation fails', () async {
    final container = createContainer();
    final notifier = container.read(collectionStateNotifierProvider.notifier);

    final requestId = container.read(selectedIdStateProvider);
    expect(requestId, isNotNull);

    await notifier.sendRequest();

    final requestModel = notifier.getRequestModel(requestId!);
    expect(requestModel?.isWorking, isFalse);
    expect(requestModel?.responseStatus, isNull);

    final terminalEntries = container.read(terminalStateProvider).entries;
    expect(terminalEntries, isNotEmpty);
    expect(terminalEntries.first.source, TerminalSource.system);
    expect(terminalEntries.first.level, TerminalLevel.error);
    expect(terminalEntries.first.system?.category, 'validation');
  });
}
