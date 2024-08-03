import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/widgets/table_map.dart';

void main() {
  Map<String, String> mapInput = {
    "day1": "Sunday",
    "day2": "Monday",
    "day3": "Tuesday",
    "day4": "Wednesday",
    "day5": "thursday"
  };
  List<String> colNames = ["dayNo.", "day"];

  testWidgets('Testing tables', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'tables',
        home: Scaffold(
          body: MapTable(
            colNames: colNames,
            map: mapInput,
          ),
        ),
      ),
    );

    expect(find.byType(Table), findsOneWidget);
    expect(find.text('Wednesday'), findsOneWidget);
    expect(find.text('day2'), findsOneWidget);
    expect(find.text('dayNo.'), findsOneWidget);
  });

  testWidgets('Testing tables with firstColumnHeaderCase is true',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        title: 'tables',
        home: Scaffold(
          body: MapTable(
            colNames: colNames,
            map: mapInput,
            firstColumnHeaderCase: true,
          ),
        ),
      ),
    );

    expect(find.byType(Table), findsOneWidget);
    expect(find.text('thursday'), findsOneWidget);
    expect(find.text('Day2'), findsOneWidget);
    expect(find.text('day2'), findsNothing);
    expect(find.text('dayNo.'), findsOneWidget);
  });
}
