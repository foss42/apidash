import 'dart:io';
import 'dart:typed_data';
import 'package:apidash/utils/save_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  final String tempPath;
  FakePathProviderPlatform(this.tempPath);

  @override
  Future<String?> getDownloadsPath() async {
    return tempPath;
  }

  @override
  Future<String?> getApplicationSupportPath() async {
    return tempPath;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('apidash_test_dir');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('Save Utils', () {
    testWidgets('saveCollection executes without throwing', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: Scaffold(body: Container()),
        ),
      );

      final sm = scaffoldKey.currentState!;

      // I/O operations must be wrapped in runAsync to avoid hanging in testWidgets
      await tester.runAsync(() async {
        await saveCollection({'key': 'value'}, sm);
      });

      // Wait for snackbar to appear
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('saveToDownloads executes without throwing', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: Scaffold(body: Container()),
        ),
      );

      final sm = scaffoldKey.currentState!;

      await tester.runAsync(() async {
        await saveToDownloads(
          sm,
          content: Uint8List.fromList([1, 2, 3]),
          mimeType: 'text/plain',
        );
      });

      // Wait for snackbar to appear
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('saveToDownloads catches exception and shows error snackbar', (
      tester,
    ) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: Scaffold(body: Container()),
        ),
      );

      final sm = scaffoldKey.currentState!;

      // Temporarily change the path provider to return a path that is actually a file
      // to force a FileSystemException when saveToDownloads tries to write a file there.
      final badPathFile = File('${tempDir.path}/bad_dir');
      badPathFile.createSync();
      PathProviderPlatform.instance = FakePathProviderPlatform(
        badPathFile.path,
      );

      await tester.runAsync(() async {
        await saveToDownloads(
          sm,
          content: Uint8List.fromList([1, 2, 3]),
          mimeType: 'text/plain',
        );
      });

      // Restore path provider
      PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
      badPathFile.deleteSync();

      // Wait for snackbar to appear
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('saveToDownloads handles null content without crashing', (
      tester,
    ) async {
      final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: scaffoldKey,
          home: Scaffold(body: Container()),
        ),
      );

      final sm = scaffoldKey.currentState!;

      await tester.runAsync(() async {
        await saveToDownloads(sm, content: null, mimeType: 'text/plain');
      });

      // Wait for snackbar to appear
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('saveAndShowDialog executes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Builder(builder: (context) => Container())),
        ),
      );

      final context = tester.element(find.byType(Container));
      bool called = false;

      await tester.runAsync(() async {
        await saveAndShowDialog(
          context,
          onSave: () async {
            called = true;
          },
        );
      });

      expect(called, isTrue);
    });
  });
}
