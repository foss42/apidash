import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/window_caption.dart';
import 'package:window_manager/window_manager.dart' hide WindowCaption;

void main() {
  testWidgets('Testing for Window caption full coverage', (tester) async {
    bool isMaximized = false;
    bool isMinimized = false;

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('window_manager'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'isMaximized') return isMaximized;
        if (methodCall.method == 'isMinimized') return isMinimized;
        if (methodCall.method == 'maximize') {
          isMaximized = true;
          return true;
        }
        if (methodCall.method == 'unmaximize') {
          isMaximized = false;
          return true;
        }
        if (methodCall.method == 'minimize') {
          isMinimized = true;
          return true;
        }
        if (methodCall.method == 'restore') {
          isMinimized = false;
          return true;
        }
        if (methodCall.method == 'close') return true;
        if (methodCall.method == 'startDragging') return true;
        return null;
      },
    );

    // Initial pump (isMaximized = false)
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Window caption',
        home: Scaffold(body: WindowCaption()),
      ),
    );
    await tester.pumpAndSettle();

    final wd = find.byType(GestureDetector);
    expect(wd, findsAny);

    // Test dragging
    await tester.drag(find.byType(GestureDetector).first, const Offset(10, 10));
    await tester.pumpAndSettle();

    // Test maximize
    final maximizeButton = find.byType(WindowCaptionButton).at(1);
    await tester.tap(maximizeButton);
    await tester.pumpAndSettle();

    // Test unmaximize by simulating windowManager maximize state changing
    isMaximized = true;
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WindowCaption())),
    );
    await tester.pumpAndSettle();

    // Test unmaximize click
    await tester.tap(find.byType(WindowCaptionButton).at(1));
    await tester.pumpAndSettle();

    // Test minimize
    final minimizeButton = find.byType(WindowCaptionButton).at(0);
    await tester.tap(minimizeButton);
    await tester.pumpAndSettle();

    // Test restore (isMinimized = true)
    isMinimized = true;
    await tester.tap(minimizeButton);
    await tester.pumpAndSettle();

    // Test close
    final closeButton = find.byType(WindowCaptionButton).at(2);
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    // Test onWindowMaximize and onWindowUnmaximize via WindowListener
    final state = tester.state(find.byType(WindowCaption));
    (state as dynamic).onWindowMaximize();
    await tester.pumpAndSettle();
    (state as dynamic).onWindowUnmaximize();
    await tester.pumpAndSettle();

    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('window_manager'),
      null,
    );
  });
}
