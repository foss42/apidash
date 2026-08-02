import 'dart:io';

import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Seeds [activeCollectionProvider] without loading from disk.
class MockActiveCollectionNotifier extends ActiveCollectionNotifier {
  MockActiveCollectionNotifier(
    Ref ref, [
    Map<String, RequestModel>? initial,
  ])  : _initial = Map<String, RequestModel>.from(initial ?? const {}),
        super(ref, workspaceStorage) {
    state = Map<String, RequestModel>.from(_initial);
  }

  final Map<String, RequestModel> _initial;

  @override
  void activateCollection(String? collectionId) {
    state = Map<String, RequestModel>.from(_initial);
  }

  @override
  RequestModel? getRequestModel(String id) => state?[id];

  @override
  void duplicateFromHistory(HistoryRequestModel historyModel) {}
}

/// Overrides needed so widget tests never touch on-disk workspace storage.
List<Override> mockActiveCollectionOverrides([
  Map<String, RequestModel>? initial,
]) {
  return [
    // Avoid selectedCollectionIdStateProvider reading workspaceStorage.
    selectedCollectionIdStateProvider.overrideWith((ref) => null),
    activeCollectionProvider.overrideWith(
      (ref) => MockActiveCollectionNotifier(ref, initial),
    ),
  ];
}
/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  addTearDown(container.dispose);

  return container;
}

Future<void> _mockSecureStorage() async {
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final store = <String, String>{};
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'read':
        return store[methodCall.arguments['key'] as String];
      case 'write':
        store[methodCall.arguments['key'] as String] =
            methodCall.arguments['value'] as String;
        return null;
      case 'delete':
        store.remove(methodCall.arguments['key'] as String);
        return null;
      case 'deleteAll':
        store.clear();
        return null;
      case 'readAll':
        return Map<String, String>.from(store);
      default:
        return null;
    }
  });
}

/// Initializes an isolated filesystem workspace for unit/widget tests.
///
/// Uses an explicit temp path so storage does not depend on path_provider
/// returning a desktop workspace root.
Future<void> testSetUpWorkspaceStorage() async {
  await _mockSecureStorage();
  final tempDir =
      await Directory.systemTemp.createTemp('apidash_test_workspace_');
  addTearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });
  final opened = await initWorkspaceStorage(
    true,
    tempDir.path,
    createIfMissing: true,
  );
  if (!opened) {
    throw StateError('Failed to init workspace at ${tempDir.path}');
  }
}

/// Waits until collection providers finish their async bootstrap microtask.
Future<void> ensureCollectionReady(
  ProviderContainer container, [
  WidgetTester? tester,
]) async {
  if (tester != null) {
    await tester.pump();
  } else {
    await Future<void>.delayed(Duration.zero);
  }
  for (var i = 0; i < 100; i++) {
    final state = container.read(activeCollectionProvider);
    if (state != null) {
      if (state.isEmpty) {
        final ids = container.read(requestSequenceProvider);
        final notifier = container.read(activeCollectionProvider.notifier);
        for (final id in ids) {
          notifier.loadRequest(id);
        }
      }
      if (container.read(activeCollectionProvider)!.isNotEmpty ||
          container.read(requestSequenceProvider).isEmpty) {
        return;
      }
    }
    if (tester != null) {
      await tester.pump(const Duration(milliseconds: 10));
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }
  throw StateError('activeCollectionProvider did not initialize');
}
