import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/window_caption.dart';

void main() {
  testWidgets('Testing for Window caption', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Window caption',
        home: Scaffold(
          body: WindowCaption(),
        ),
      ),
    );

    final wd = find.byType(GestureDetector);
    expect(wd, findsAny);
  });
}
