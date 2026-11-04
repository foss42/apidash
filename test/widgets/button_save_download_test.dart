import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/button_save_download.dart';

import '../test_consts.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  FakePathProviderPlatform(this.downloadsPath);

  final String downloadsPath;

  @override
  Future<String?> getDownloadsPath() async => downloadsPath;
}

void main() {
  late Directory downloadsDir;

  setUp(() {
    downloadsDir = Directory.systemTemp.createTempSync('apidash_downloads');
    PathProviderPlatform.instance = FakePathProviderPlatform(downloadsDir.path);
  });

  tearDown(() {
    if (downloadsDir.existsSync()) {
      downloadsDir.deleteSync(recursive: true);
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

    await tester.tap(button);

    // Saving does real file I/O, which only progresses outside the fake clock.
    final savedMessage = find.textContaining('Saved to');
    for (var i = 0; i < 250 && savedMessage.evaluate().isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump();
    }
    expect(savedMessage, findsOneWidget);

    final saved = downloadsDir.listSync().whereType<File>().toList();
    expect(saved, hasLength(1));
    expect(saved.single.readAsBytesSync(), [1]);

    // Let the snackbar time out so no timer is left pending.
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
  });
}
