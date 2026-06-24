import 'dart:io';

import 'package:apidash/providers/providers.dart';
import 'package:apidash/services/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

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

Future<void> _mockPathProvider(
  Future<Directory> Function() createTempDir,
) async {
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      final tempDir = await createTempDir();
      return tempDir.path;
    }
    return null;
  });
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
Future<void> testSetUpWorkspaceStorage() async {
  await _mockSecureStorage();
  await _mockPathProvider(
    () => Directory.systemTemp.createTemp('apidash_test_workspace_'),
  );
  await initWorkspaceStorage(false, null);
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
    final state = container.read(collectionStateNotifierProvider);
    if (state != null) {
      if (state.isEmpty) {
        final ids = container.read(requestSequenceProvider);
        final notifier = container.read(collectionStateNotifierProvider.notifier);
        for (final id in ids) {
          notifier.loadRequest(id);
        }
      }
      if (container.read(collectionStateNotifierProvider)!.isNotEmpty ||
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
  throw StateError('collectionStateNotifierProvider did not initialize');
}
