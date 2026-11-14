import 'dart:async';
import 'dart:io';

import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class _ControlledEnvironmentHiveHandler extends HiveHandler {
  final started = Completer<void>();
  final release = Completer<void>();
  bool failWrites = false;

  @override
  Future<void> setEnvironment(
    String id,
    Map<String, dynamic>? environmentJson,
  ) async {
    if (!started.isCompleted) started.complete();
    await release.future;
    if (failWrites) throw StateError('Environment write failed');
    await super.setEnvironment(id, environmentJson);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory storage;
  late HiveHandler handler;
  late ProviderContainer container;

  ProviderContainer createContainer({HiveHandler? environmentHandler}) {
    return ProviderContainer(
      overrides: [
        collectionStateNotifierProvider.overrideWith(
          (ref) => CollectionStateNotifier(ref, handler),
        ),
        environmentsStateNotifierProvider.overrideWith(
          (ref) => EnvironmentsStateNotifier(ref, environmentHandler ?? handler),
        ),
        requestSequenceProvider.overrideWith((ref) => handler.getIds() ?? []),
        environmentSequenceProvider.overrideWith(
          (ref) => handler.getEnvironmentIds() ?? [kGlobalEnvironmentId],
        ),
      ],
    );
  }

  Future<void> initializeNotifiers() async {
    container.read(collectionStateNotifierProvider);
    container.read(environmentsStateNotifierProvider);
    // Let the notifiers initialize selection and sequence providers.
    await Future<void>.delayed(Duration.zero);
  }

  setUp(() async {
    storage = await Directory.systemTemp.createTemp('apidash-workspace-save-');
    expect(await initHiveBoxes(true, storage.path), isTrue);
    handler = HiveHandler();
    container = createContainer();
    await initializeNotifiers();
  });

  tearDown(() async {
    container.dispose();
    await Hive.close();
    await storage.delete(recursive: true);
  });

  test(
    'workspace save persists request and environment edits after reopening',
    () async {
      final collection = container.read(collectionStateNotifierProvider.notifier);
      final environments = container.read(
        environmentsStateNotifierProvider.notifier,
      );
      final requestId = container.read(selectedIdStateProvider)!;
      collection.update(id: requestId, name: 'Saved request');
      environments.updateEnvironment(
        kGlobalEnvironmentId,
        values: const [
          EnvironmentVariableModel(
            key: 'baseUrl',
            value: 'https://example.com',
            type: EnvironmentVariableType.variable,
            enabled: true,
          ),
        ],
      );
      environments.addEnvironment();
      final environmentId = container.read(selectedEnvironmentIdStateProvider)!;
      environments.updateEnvironment(environmentId, name: 'Saved environment');

      await collection.saveWorkspace();

      expect(container.read(hasUnsavedChangesProvider), isFalse);
      expect(container.read(saveDataStateProvider), isFalse);
      await Hive.close();
      expect(await openHiveBoxes(), isTrue);
      final reopened = HiveHandler();
      expect(reopened.getRequestModel(requestId)['name'], 'Saved request');
      expect(reopened.getEnvironmentIds(), contains(environmentId));
      expect(reopened.getEnvironment(environmentId)['name'], 'Saved environment');
      final global = EnvironmentModel.fromJson(
        Map<String, Object?>.from(reopened.getEnvironment(kGlobalEnvironmentId)),
      );
      expect(global.values.single.key, 'baseUrl');
      expect(global.values.single.value, 'https://example.com');
    },
  );

  test(
    'workspace save preserves templates while removing orphan records',
    () async {
      final collection = container.read(collectionStateNotifierProvider.notifier);
      final requestId = container.read(selectedIdStateProvider)!;
      const templates = [
        {'name': 'Subscribe', 'data': '{"action":"subscribe"}'},
      ];
      await handler.setWsTemplates(templates);
      await handler.setRequestModel('orphan-request', {'name': 'Orphan'});
      await handler.setEnvironment('orphan-environment', {'name': 'Orphan'});

      await collection.saveWorkspace();

      await Hive.close();
      expect(await openHiveBoxes(), isTrue);
      final reopened = HiveHandler();
      expect(reopened.getWsTemplates(), templates);
      expect(reopened.getIds(), contains(requestId));
      expect(reopened.getRequestModel(requestId), isNotNull);
      expect(reopened.getRequestModel('orphan-request'), isNull);
      expect(reopened.getEnvironment('orphan-environment'), isNull);
    },
  );

  test(
    'cleanup preserves templates when the saved request list is empty',
    () async {
      const templates = [
        {'name': 'Empty workspace template', 'data': 'hello'},
      ];
      await handler.setIds([]);
      await handler.setWsTemplates(templates);
      await handler.setRequestModel('orphan-request', {'name': 'Orphan'});

      await handler.removeUnused();

      expect(handler.getIds(), isEmpty);
      expect(handler.getWsTemplates(), templates);
      expect(handler.getRequestModel('orphan-request'), isNull);
    },
  );

  test(
    'workspace save waits for environment writes before completing',
    () async {
      final controlled = _ControlledEnvironmentHiveHandler();
      container.dispose();
      container = createContainer(environmentHandler: controlled);
      await initializeNotifiers();
      addTearDown(() {
        if (!controlled.release.isCompleted) controlled.release.complete();
      });
      final collection = container.read(collectionStateNotifierProvider.notifier);
      var completed = false;
      final save = collection.saveWorkspace().then((_) => completed = true);

      await controlled.started.future;
      expect(completed, isFalse);
      expect(handler.getEnvironment(kGlobalEnvironmentId), isNull);
      controlled.release.complete();
      await save;

      expect(completed, isTrue);
      expect(handler.getEnvironment(kGlobalEnvironmentId), isNotNull);
    },
  );

  test('failed environment save stays dirty and can be retried', () async {
    final controlled = _ControlledEnvironmentHiveHandler()..failWrites = true;
    controlled.release.complete();
    container.dispose();
    container = createContainer(environmentHandler: controlled);
    await initializeNotifiers();
    final collection = container.read(collectionStateNotifierProvider.notifier);

    await expectLater(collection.saveWorkspace(), throwsStateError);

    expect(container.read(hasUnsavedChangesProvider), isTrue);
    expect(container.read(saveDataStateProvider), isFalse);
    expect(handler.getEnvironment(kGlobalEnvironmentId), isNull);

    controlled.failWrites = false;
    await collection.saveWorkspace();

    expect(handler.getEnvironment(kGlobalEnvironmentId), isNotNull);
    expect(container.read(hasUnsavedChangesProvider), isFalse);
    expect(container.read(saveDataStateProvider), isFalse);
  });
}
