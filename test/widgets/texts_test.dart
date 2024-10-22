import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/utils/utils.dart' show getDarkModeColor;
import 'package:apidash/widgets/texts.dart';

void main() {
  testWidgets('Testing when method is GET', (tester) async {
    var methodGet = HTTPVerb.get;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Texts',
        theme: ThemeData(brightness: Brightness.light),
        home: Scaffold(
          body: MethodBox(method: methodGet),
        ),
      ),
    );

    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.text('GET'), findsOneWidget);
    expect(find.text('DEL'), findsNothing);
    final getTextWithColor = find.byWidgetPredicate((widget) =>
        widget is Text && widget.style!.color == kColorHttpMethodGet);
    expect(getTextWithColor, findsOneWidget);
  });

  testWidgets('Testing when method is DELETE', (tester) async {
    var methodDel = HTTPVerb.delete;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Texts',
        theme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(
          body: MethodBox(method: methodDel),
        ),
      ),
    );

    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.text('DEL'), findsOneWidget);
    expect(find.text('GET'), findsNothing);
    Color colDelDarkMode = getDarkModeColor(kColorHttpMethodDelete);
    final delTextWithColor = find.byWidgetPredicate(
        (widget) => widget is Text && widget.style!.color == colDelDarkMode);
    expect(delTextWithColor, findsOneWidget);
  });

  testWidgets('Testing StatusCode', (WidgetTester tester) async {
    const int testStatusCode = 200;
    const TextStyle testStyle = TextStyle(fontSize: 20);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusCode(
            statusCode: testStatusCode,
            style: testStyle,
          ),
        ),
      ),
    );

    Finder code = find.text(testStatusCode.toString());
    expect(code, findsOneWidget);
    final Text textWidget = tester.widget(code);
    expect(textWidget.style?.fontSize, testStyle.fontSize);
  });
}
