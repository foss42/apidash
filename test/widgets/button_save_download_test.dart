import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/button_save_download.dart';

import '../test_consts.dart';

void main() {
  testWidgets('Testing for Save in Downloads button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'Save in Downloads button',
        theme: kThemeDataLight,
        home: const Scaffold(
          body: SaveInDownloadsButton(),
        ),
      ),
    );

    final icon = find.byIcon(Icons.download);
    expect(icon, findsOneWidget);

    Finder button;
    expect(find.text(kLabelDownload), findsOneWidget);
    button = find.ancestor(
        of: icon,
        matching: find.byWidgetPredicate((widget) => widget is TextButton));
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
}
