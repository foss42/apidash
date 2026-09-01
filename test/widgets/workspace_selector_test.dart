import 'package:apidash/consts.dart';
import 'package:apidash/widgets/workspace_selector.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

class _FakeFileSelector extends FileSelectorPlatform {
  _FakeFileSelector(this.directoryPath);

  final String? directoryPath;

  @override
  Future<String?> getDirectoryPath({
    String? initialDirectory,
    String? confirmButtonText,
  }) async {
    return directoryPath;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FileSelectorPlatform previous;

  setUp(() {
    previous = FileSelectorPlatform.instance;
  });

  tearDown(() {
    FileSelectorPlatform.instance = previous;
  });

  testWidgets('shows create-workspace copy and keeps Continue disabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: WorkspaceSelector(
          onContinue: (_) async {},
        ),
      ),
    );

    expect(find.text(kMsgSelectWorkspace), findsOneWidget);
    expect(find.text(kLabelSelect), findsOneWidget);
    expect(find.text(kLabelContinue), findsOneWidget);
    expect(find.text(kLabelCancel), findsOneWidget);

    final continueButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, kLabelContinue),
    );
    expect(continueButton.onPressed, isNull);
  });

  testWidgets('Cancel invokes onCancel', (tester) async {
    var cancelled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: WorkspaceSelector(
          onContinue: (_) async {},
          onCancel: () async {
            cancelled = true;
          },
        ),
      ),
    );

    await tester.tap(find.text(kLabelCancel));
    await tester.pump();
    expect(cancelled, isTrue);
  });

  testWidgets('Select + Continue returns chosen directory path', (
    tester,
  ) async {
    FileSelectorPlatform.instance = _FakeFileSelector('/tmp/ws-root');
    String? continuedPath;

    await tester.pumpWidget(
      MaterialApp(
        home: WorkspaceSelector(
          onContinue: (path) async {
            continuedPath = path;
          },
        ),
      ),
    );

    await tester.tap(find.text(kLabelSelect));
    await tester.pump();

    final continueButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, kLabelContinue),
    );
    expect(continueButton.onPressed, isNotNull);

    await tester.tap(find.text(kLabelContinue));
    await tester.pump();
    expect(continuedPath, '/tmp/ws-root');
  });

  testWidgets('optional workspace name is appended under selected directory',
      (tester) async {
    FileSelectorPlatform.instance = _FakeFileSelector('/tmp/parent');
    String? continuedPath;

    await tester.pumpWidget(
      MaterialApp(
        home: WorkspaceSelector(
          onContinue: (path) async {
            continuedPath = path;
          },
        ),
      ),
    );

    await tester.tap(find.text(kLabelSelect));
    await tester.pump();

    await tester.enterText(find.byType(TextField).last, 'My Workspace');
    await tester.pump();

    await tester.tap(find.text(kLabelContinue));
    await tester.pump();
    expect(continuedPath, p.join('/tmp/parent', 'My Workspace'));
  });
}
