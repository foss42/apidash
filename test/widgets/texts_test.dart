import 'package:apidash/consts.dart';
import 'package:apidash/utils/utils.dart' show getDarkModeColor;
import 'package:apidash/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Testing when method is GET', (tester) async {
    var methodGet = HTTPVerb.get;
    await tester.pumpWidget(
      MaterialApp(
        title: 'Texts',
        theme: ThemeData(brightness: Brightness.light),
        home: Scaffold(
          body: MethodBox(
            method: methodGet,
            protocol: Protocol.http,
          ),
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
          body: MethodBox(
            method: methodDel,
            protocol: Protocol.http,
          ),
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
}
