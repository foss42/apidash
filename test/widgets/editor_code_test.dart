import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/json.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash/widgets/editor_code.dart';
import '../test_consts.dart';

void main() {
  group('CodeEditor Widget Tests', () {
    late CodeController testController;

    setUp(() {
      testController = CodeController(
        text: 'print("Hello World")',
        language: javascript,
      );
    });

    testWidgets('renders CodeEditor with default parameters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      expect(find.byType(CodeEditor), findsOneWidget);
      expect(find.byType(CodeField), findsOneWidget);
      expect(find.byType(CodeTheme), findsOneWidget);
    });

    testWidgets('renders CodeEditor in read-only mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor ReadOnly Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
              readOnly: true,
            ),
          ),
        ),
      );

      expect(find.byType(CodeEditor), findsOneWidget);

      // Verify the CodeField is in read-only mode
      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      expect(codeField.readOnly, isTrue);
    });

    testWidgets('renders CodeEditor in editable mode by default',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Editable Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      expect(find.byType(CodeEditor), findsOneWidget);

      // Verify the CodeField is editable by default
      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      expect(codeField.readOnly, isFalse);
    });

    testWidgets('CodeEditor has correct decoration properties', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Decoration Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      final decoration = codeField.decoration as BoxDecoration;

      // Check border radius
      expect(decoration.borderRadius, equals(kBorderRadius8));

      // Check that decoration has a border and color
      expect(decoration.border, isNotNull);
      expect(decoration.color, isNotNull);
    });

    testWidgets('CodeEditor has correct gutter style properties',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Gutter Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      final gutterStyle = codeField.gutterStyle;

      expect(gutterStyle.width, equals(0));
      expect(gutterStyle.margin, equals(2));
      expect(gutterStyle.textAlign, equals(TextAlign.left));
      expect(gutterStyle.showFoldingHandles, isFalse);
      expect(gutterStyle.showLineNumbers, isFalse);
    });

    testWidgets('CodeEditor has correct smart typing settings', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Smart Typing Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      final codeField = tester.widget<CodeField>(find.byType(CodeField));

      expect(codeField.smartDashesType, equals(SmartDashesType.enabled));
      expect(codeField.smartQuotesType, equals(SmartQuotesType.enabled));
    });

    testWidgets('CodeEditor expands to fill available space', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Expand Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      expect(codeField.expands, isTrue);
    });

    testWidgets('CodeEditor uses correct text style with theme font size',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Text Style Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      final textStyle = codeField.textStyle;

      // Verify that text style is based on kCodeStyle
      expect(textStyle?.fontFamily, equals(kCodeStyle.fontFamily));

      // Verify that font size is taken from theme
      final themeContext = tester.element(find.byType(CodeEditor));
      final expectedFontSize =
          Theme.of(themeContext).textTheme.bodyMedium?.fontSize;
      expect(textStyle?.fontSize, equals(expectedFontSize));
    });

    testWidgets('CodeEditor uses theme colors for background and cursor',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Colors Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
            ),
          ),
        ),
      );

      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      final themeContext = tester.element(find.byType(CodeEditor));
      final colorScheme = Theme.of(themeContext).colorScheme;

      // Verify background color
      expect(codeField.background, equals(colorScheme.surfaceContainerLowest));

      // Verify cursor color
      expect(codeField.cursorColor, equals(colorScheme.primary));

      // Verify decoration background color
      final decoration = codeField.decoration as BoxDecoration;
      expect(decoration.color, equals(colorScheme.surfaceContainerLowest));
    });

    testWidgets('CodeEditor with custom controller content', (tester) async {
      final customController = CodeController(
        text: '{\n  "key": "value",\n  "number": 42\n}',
        language: json,
      );

      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Custom Content Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: customController,
            ),
          ),
        ),
      );

      expect(find.byType(CodeEditor), findsOneWidget);

      // Verify the controller is properly set
      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      expect(codeField.controller, equals(customController));
      expect(codeField.controller.text, contains('"key": "value"'));
    });

    testWidgets('CodeEditor with all parameters set', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor All Parameters Test',
          theme: kThemeDataDark,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
              readOnly: true,
              isDark: true,
            ),
          ),
        ),
      );

      expect(find.byType(CodeEditor), findsOneWidget);

      final codeField = tester.widget<CodeField>(find.byType(CodeField));
      final codeTheme = tester.widget<CodeTheme>(find.byType(CodeTheme));

      // Verify all parameters are applied
      expect(codeField.readOnly, isTrue);
      expect(codeTheme.data?.styles, equals(monokaiTheme));
      expect(codeField.controller, equals(testController));
    });

    testWidgets('CodeEditor widget key is properly set', (tester) async {
      const testKey = Key('test-code-editor');

      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Key Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              key: testKey,
              controller: testController,
            ),
          ),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
      expect(find.byType(CodeEditor), findsOneWidget);
    });

    testWidgets('renders CodeEditor with light theme (isDark: false)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Light Theme Test',
          theme: kThemeDataLight,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
              isDark: false,
            ),
          ),
        ),
      );

      expect(find.byType(CodeEditor), findsOneWidget);
      expect(find.byType(CodeField), findsOneWidget);

      // Verify the CodeTheme is using light theme (xcode)
      final codeTheme = tester.widget<CodeTheme>(find.byType(CodeTheme));
      expect(codeTheme.data?.styles, equals(xcodeTheme));
    });

    testWidgets('renders CodeEditor with dark theme (isDark: true)',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          title: 'CodeEditor Dark Theme Test',
          theme: kThemeDataDark,
          home: Scaffold(
            body: CodeEditor(
              controller: testController,
              isDark: true,
            ),
          ),
        ),
      );

      expect(find.byType(CodeEditor), findsOneWidget);
      expect(find.byType(CodeField), findsOneWidget);

      // Verify the CodeTheme is using dark theme (monokai)
      final codeTheme = tester.widget<CodeTheme>(find.byType(CodeTheme));
      expect(codeTheme.data?.styles, equals(monokaiTheme));
    });
  });
}
