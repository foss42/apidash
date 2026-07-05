import 'package:apidash/widgets/menu_header_suggestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HeaderSuggestions Widget Tests', () {
    testWidgets('HeaderSuggestions displays suggestions correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HeaderSuggestions(
            query: "header",
            suggestionsCallback: (query) async => ["header1", "header2"],
            onSuggestionTap: (suggestion) {
              expect(suggestion, "header1");
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text("header1"), findsOneWidget);
      expect(find.text("header2"), findsOneWidget);
    });

    testWidgets('HeaderSuggestions calls onSuggestionTap when tapped', (
      tester,
    ) async {
      String? selectedSuggestion;
      await tester.pumpWidget(
        MaterialApp(
          home: HeaderSuggestions(
            query: "header",
            suggestionsCallback: (query) async => ["header1"],
            onSuggestionTap: (suggestion) => selectedSuggestion = suggestion,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text("header1"));
      expect(selectedSuggestion, "header1");
    });

    testWidgets('HeaderSuggestions shows no suggestions when list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HeaderSuggestions(
            query: "test",
            suggestionsCallback: (query) async => [],
            onSuggestionTap: (suggestion) {},
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('HeaderSuggestions triggers didUpdateWidget on query change', (
      tester,
    ) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return HeaderSuggestions(
                key: key,
                query: "first",
                suggestionsCallback: (query) async => [query],
                onSuggestionTap: (suggestion) {},
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("first"), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return HeaderSuggestions(
                key: key,
                query: "second",
                suggestionsCallback: (query) async => [query],
                onSuggestionTap: (suggestion) {},
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text("second"), findsOneWidget);
    });
  });
}
