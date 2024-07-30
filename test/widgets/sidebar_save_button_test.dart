import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/common_widgets/sidebar_save_button.dart';
import '../test_consts.dart';

void main() {
  testWidgets('Testing for Save button', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          title: 'Save button',
          theme: kThemeDataLight,
          home: const Scaffold(
            body: SaveButton(),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.save), findsOneWidget);
    expect(find.text("Save"), findsOneWidget);
  });
}
