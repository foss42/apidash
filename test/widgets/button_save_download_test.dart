import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/button_save_download.dart';

import '../test_consts.dart';

class FakeFileSelectorPlatform extends FileSelectorPlatform {
  FileSaveLocation? locationToReturn;
  String? lastSuggestedName;

  @override
  Future<XFile?> openFile({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async => null;

  @override
  Future<List<XFile>> openFiles({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? confirmButtonText,
  }) async => <XFile>[];

  @override
  Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? confirmButtonText,
  }) async => null;

  @override
  Future<List<String>> getDirectoryPaths({
    String? initialDirectory,
    String? confirmButtonText,
  }) async => <String>[];

  @override
  Future<String?> getSavePath({
    List<XTypeGroup>? acceptedTypeGroups,
    String? initialDirectory,
    String? suggestedName,
    String? confirmButtonText,
  }) async => null;

  @override
  Future<FileSaveLocation?> getSaveLocation({
    List<XTypeGroup>? acceptedTypeGroups,
    SaveDialogOptions options = const SaveDialogOptions(),
  }) async {
    lastSuggestedName = options.suggestedName;
    return locationToReturn;
  }
}

Future<bool> waitForFileToExist(
  String path, {
  Duration timeout = const Duration(seconds: 1),
  Duration pollInterval = const Duration(milliseconds: 10),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    if (await File(path).exists()) {
      return true;
    }
    await Future<void>.delayed(pollInterval);
  }
  return File(path).existsSync();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFileSelectorPlatform fakePlatform;
  late Directory tempDir;

  setUp(() {
    fakePlatform = FakeFileSelectorPlatform();
    FileSelectorPlatform.instance = fakePlatform;
    tempDir = Directory.systemTemp.createTempSync('save_download_button');
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('Testing for Save in Downloads button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Save in Downloads button',
        theme: kThemeDataLight,
        home: const Scaffold(body: SaveInDownloadsButton()),
      ),
    );

    final icon = find.byIcon(Icons.download);
    expect(icon, findsOneWidget);

    Finder button;
    expect(find.text(kLabelDownload), findsOneWidget);
    button = find.ancestor(
      of: icon,
      matching: find.byWidgetPredicate((widget) => widget is TextButton),
    );
    expect(button, findsOneWidget);
    expect(tester.widget<TextButton>(button).enabled, isFalse);
  });

  testWidgets('Testing for Save in Downloads button 2', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Save in Downloads button',
        theme: kThemeDataLight,
        home: Scaffold(
          body: SaveInDownloadsButton(
            showLabel: false,
            content: Uint8List.fromList([1]),
          ),
        ),
      ),
    );

    final icon = find.byIcon(Icons.download);
    expect(icon, findsOneWidget);

    Finder button;
    button = find.byType(IconButton);
    expect(button, findsOneWidget);
    expect(tester.widget<IconButton>(button).onPressed == null, isFalse);
  });

  testWidgets('uses selected save location when enabled', (tester) async {
    final bytes = Uint8List.fromList(<int>[1, 2, 3]);
    final path = '${tempDir.path}/response.txt';
    fakePlatform.locationToReturn = FileSaveLocation(path);

    await tester.pumpWidget(
      MaterialApp(
        title: 'Save in Downloads button',
        theme: kThemeDataLight,
        home: Scaffold(
          body: SaveInDownloadsButton(
            content: bytes,
            mimeType: 'text/plain',
            name: 'response',
            chooseSaveLocation: true,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.download));
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      expect(await waitForFileToExist(path), isTrue);
    });
    expect(fakePlatform.lastSuggestedName, 'response.txt');
  });
}
