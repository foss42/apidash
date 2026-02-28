import 'dart:io';
import 'package:apidash/services/hive_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

Future<void> testSetUpForHive() async {
  // override path_provider methodCall to point
  // path to temporary location for all unit tests
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return './test-hive-storage/';
  });

  await initHiveBoxes(false, null);
  // await deleteHiveBoxes();
  // await openHiveBoxes();
}

Future<void> testSetUpTempDirForHive() async {
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      // Create a mock app doc directory for testing
      Directory tempDir =
          await Directory.systemTemp.createTemp('mock_app_doc_dir');
      return tempDir.path; // Return the path to the mock directory
    }
    return null;
  });
  await initHiveBoxes(false, null);
}
