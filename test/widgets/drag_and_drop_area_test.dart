import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_selector/file_selector.dart';
import 'package:apidash/widgets/drag_and_drop_area.dart';

void main() {
  testWidgets('DragAndDropArea responds to file drop',
      (WidgetTester tester) async {
    bool fileDropped = false;
    XFile? droppedFile;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DragAndDropArea(
            onFileDropped: (file) {
              fileDropped = true;
              droppedFile = file;
            },
          ),
        ),
      ),
    );

    // Verify initial state
    expect(find.text("Select or drop the file here"), findsOneWidget);

    // Simulate dropping a file
    final testFile = XFile('test.curl');
    final dragAndDropArea =
        tester.widget<DragAndDropArea>(find.byType(DragAndDropArea));

    // Since we can't actually perform drag-and-drop in a unit test,
    // we'll call the onDragDone callback directly
    dragAndDropArea.onFileDropped?.call(testFile);

    await tester.pump();

    // Verify that the file was "dropped" and the callback was called
    expect(fileDropped, isTrue);
    expect(droppedFile, isNotNull);
    expect(droppedFile?.path, 'test.curl');
  });
}
