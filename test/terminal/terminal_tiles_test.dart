import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash/terminal/enums.dart';
import 'package:apidash/terminal/models/models.dart';
import 'package:apidash/terminal/widgets/widgets.dart';

void main() {
  testWidgets('SystemLogTile renders message and optional stack',
      (tester) async {
    final entry = TerminalEntry(
      id: 's1',
      source: TerminalSource.system,
      level: TerminalLevel.warn,
      system: SystemLogData(category: 'ui', message: 'Updated', stack: 'trace'),
    );

    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: SystemLogTile(entry: entry))));
    expect(find.textContaining('[ui] Updated'), findsOneWidget);
    // Stack is rendered using HighlightedSelectableText which internally uses SelectableText
    final stackSelectable =
        tester.widget<SelectableText>(find.byType(SelectableText).last);
    expect(stackSelectable.data, 'trace');
  });

  testWidgets('SystemLogTile renders with search highlighting', (tester) async {
    final entry = TerminalEntry(
      id: 's1',
      source: TerminalSource.system,
      level: TerminalLevel.info,
      system:
          SystemLogData(category: 'networking', message: 'Request completed'),
    );

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SystemLogTile(entry: entry, searchQuery: 'network'))));

    // Should find the highlighted text
    expect(
        find.textContaining('[networking] Request completed'), findsOneWidget);
  });

  testWidgets('JsLogTile composes body text with context and requestName',
      (tester) async {
    final entry = TerminalEntry(
      id: 'j1',
      source: TerminalSource.js,
      level: TerminalLevel.warn,
      js: JsLogData(
          level: 'warn', args: ['Hello', 'World'], context: 'preRequest'),
    );
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: JsLogTile(entry: entry, requestName: 'TestReq'))));
    final selectable =
        tester.widget<SelectableText>(find.byType(SelectableText).first);
    expect(selectable.data, '[TestReq] (preRequest) Hello World');
    // Background color for warn renders but we only assert presence of text
  });

  testWidgets('JsLogTile highlights search query in body text', (tester) async {
    final entry = TerminalEntry(
      id: 'j1',
      source: TerminalSource.js,
      level: TerminalLevel.info,
      js: JsLogData(
          level: 'info',
          args: ['API', 'response', 'success'],
          context: 'postRequest'),
    );
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JsLogTile(
                entry: entry, requestName: 'TestAPI', searchQuery: 'API'))));

    // Should find the text containing API in SelectableText widgets
    // When highlighting is applied, the content is in textSpan
    final selectables =
        tester.widgetList<SelectableText>(find.byType(SelectableText)).toList();
    final hasAPIText = selectables.any((s) =>
        (s.data != null && s.data!.contains('API')) ||
        (s.textSpan != null && s.textSpan!.toPlainText().contains('API')));
    expect(hasAPIText, isTrue);
  });

  testWidgets('NetworkLogTile expands to show details and status/duration',
      (tester) async {
    final n = NetworkLogData(
      phase: NetworkPhase.completed,
      apiType: APIType.rest,
      method: HTTPVerb.get,
      url: 'https://example.com/users',
      responseStatus: 200,
      duration: const Duration(milliseconds: 150),
      requestHeaders: const {'A': '1'},
      responseHeaders: const {'B': '2'},
      requestBodyPreview: '{q}',
      responseBodyPreview: '[1]',
    );
    final entry = TerminalEntry(
        id: 'n1',
        source: TerminalSource.network,
        level: TerminalLevel.info,
        network: n);

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: NetworkLogTile(entry: entry, requestName: 'Users'))));
    // Leading row content is a RichText; check combined plain text
    final rich = tester.widget<RichText>(find.byType(RichText).first);
    expect(rich.text.toPlainText(),
        contains('[Users] GET https://example.com/users'));
    expect(find.text('200'), findsOneWidget);
    expect(find.text('150 ms'), findsOneWidget);

    // Expand
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('Network'), findsOneWidget);
    expect(find.text('Request Headers'), findsOneWidget);
    expect(find.text('Response Headers'), findsOneWidget);
    expect(find.text('Request Body'), findsOneWidget);
    expect(find.text('Response Body'), findsOneWidget);
    // Open the 'Network' section to reveal key-value body
    await tester.tap(find.text('Network'));
    await tester.pumpAndSettle();
    final selectables =
        tester.widgetList<SelectableText>(find.byType(SelectableText)).toList();
    expect(
        selectables.any((w) => (w.data ?? '').contains('Method: GET')), isTrue);
    expect(
        selectables.any((w) => (w.data ?? '').contains('Status: 200')), isTrue);
  });

  testWidgets('NetworkLogTile shows search query in URL', (tester) async {
    final n = NetworkLogData(
      phase: NetworkPhase.completed,
      apiType: APIType.rest,
      method: HTTPVerb.post,
      url: 'https://api.example.com/data',
      responseStatus: 201,
      duration: const Duration(milliseconds: 200),
      requestHeaders: const {'Content-Type': 'application/json'},
      responseHeaders: const {'Server': 'nginx'},
      requestBodyPreview: '{"name": "test"}',
      responseBodyPreview: '{"id": 123}',
    );
    final entry = TerminalEntry(
        id: 'n1',
        source: TerminalSource.network,
        level: TerminalLevel.info,
        network: n);

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: NetworkLogTile(
                entry: entry,
                requestName: 'TestAPI',
                searchQuery: 'example'))));

    await tester.pumpAndSettle();

    // The RichText should contain the search query "example" in the URL
    final richTexts = tester.widgetList<RichText>(find.byType(RichText));
    final hasExampleText =
        richTexts.any((rt) => rt.text.toPlainText().contains('example'));
    expect(hasExampleText, isTrue);
  });
}
