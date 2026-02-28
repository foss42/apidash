import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apidash/screens/common_widgets/url_suggestions.dart';
import 'package:apidash/services/hive_services.dart';
import 'package:apidash/providers/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MockHiveHandler {
  final List<Map<String, dynamic>> mockData;

  MockHiveHandler(this.mockData);

  List<Map<String, dynamic>> getUrlHistory() {
    return mockData;
  }
}

// Test Helpers
Widget _wrapper(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void _noop(String _, String __) {}

List<Map<String, dynamic>> mockUrlHistory = [];

void main() {
  setUp(() {
    mockUrlHistory = [];
  });

  testWidgets('shows "No URL" when history is empty',
      (WidgetTester tester) async {
    mockUrlHistory = [];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          urlHistoryProvider.overrideWith(
            (ref) => UrlHistoryNotifier(MockHiveHandler(mockUrlHistory)),
          ),
          availableEnvironmentVariablesStateProvider.overrideWith(
            (ref) => {},
          ),
        ],
        child: _wrapper(
          const URLSuggestions(
            query: '',
            onSuggestionTap: _noop,
          ),
        ),
      ),
    );

    expect(find.text('No URL'), findsOneWidget);
  });

  testWidgets('shows resolved URL as primary text',
      (WidgetTester tester) async {
    mockUrlHistory = [
      {
        kUrlHistoryKeyRaw: '{{baseUrl}}/users',
        kUrlHistoryKeyResolved: 'https://api.dev.com/users',
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          urlHistoryProvider.overrideWith(
            (ref) => UrlHistoryNotifier(MockHiveHandler(mockUrlHistory)),
          ),
          availableEnvironmentVariablesStateProvider.overrideWith(
            (ref) => {},
          ),
        ],
        child: _wrapper(
          const URLSuggestions(
            query: '',
            onSuggestionTap: _noop,
          ),
        ),
      ),
    );

    expect(find.text('https://api.dev.com/users'), findsOneWidget);
  });

  testWidgets('shows variable when raw URL contains env variable',
      (WidgetTester tester) async {
    mockUrlHistory = [
      {
        kUrlHistoryKeyRaw: '{{baseUrl}}/users',
        kUrlHistoryKeyResolved: 'https://api.dev.com/users',
        'method': 'GET',
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          urlHistoryProvider.overrideWith(
            (ref) => UrlHistoryNotifier(MockHiveHandler(mockUrlHistory)),
          ),
          availableEnvironmentVariablesStateProvider.overrideWith(
            (ref) => {},
          ),
        ],
        child: _wrapper(
          const URLSuggestions(
            query: '',
            onSuggestionTap: _noop,
          ),
        ),
      ),
    );

    // show the raw URL in subtitle when variables are missing.
    expect(find.text('Variable - Missing'), findsOneWidget);
    expect(find.text('https://api.dev.com/users'), findsOneWidget);
  });

  testWidgets('shows "Variable - Not available" when no env variable exists',
      (WidgetTester tester) async {
    mockUrlHistory = [
      {
        kUrlHistoryKeyRaw: 'https://api.example.com/users',
        kUrlHistoryKeyResolved: 'https://api.example.com/users',
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          urlHistoryProvider.overrideWith(
            (ref) => UrlHistoryNotifier(MockHiveHandler(mockUrlHistory)),
          ),
          availableEnvironmentVariablesStateProvider.overrideWith(
            (ref) => {},
          ),
        ],
        child: _wrapper(
          const URLSuggestions(
            query: '',
            onSuggestionTap: _noop,
          ),
        ),
      ),
    );

    expect(find.text('Variable - Not available'), findsOneWidget);
  });

  testWidgets('filters suggestions based on query',
      (WidgetTester tester) async {
    mockUrlHistory = [
      {
        kUrlHistoryKeyRaw: '{{baseUrl}}/users',
        kUrlHistoryKeyResolved: 'https://api.dev.com/users',
      },
      {
        kUrlHistoryKeyRaw: '{{baseUrl}}/posts',
        kUrlHistoryKeyResolved: 'https://api.dev.com/posts',
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          urlHistoryProvider.overrideWith(
            (ref) => UrlHistoryNotifier(MockHiveHandler(mockUrlHistory)),
          ),
          availableEnvironmentVariablesStateProvider.overrideWith(
            (ref) => {},
          ),
        ],
        child: _wrapper(
          const URLSuggestions(
            query: 'posts',
            onSuggestionTap: _noop,
          ),
        ),
      ),
    );

    expect(find.textContaining('posts'), findsOneWidget);
    expect(find.textContaining('users'), findsNothing);
  });

  testWidgets('calls onSuggestionTap when suggestion is tapped',
      (WidgetTester tester) async {
    String? tappedValue;
    String? tappedMethod;

    mockUrlHistory = [
      {
        kUrlHistoryKeyRaw: '{{baseUrl}}/users',
        kUrlHistoryKeyResolved: 'https://api.dev.com/users',
        'method': 'post',
      },
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          urlHistoryProvider.overrideWith(
            (ref) => UrlHistoryNotifier(MockHiveHandler(mockUrlHistory)),
          ),
          availableEnvironmentVariablesStateProvider.overrideWith(
            (ref) => {},
          ),
        ],
        child: _wrapper(
          URLSuggestions(
            query: '',
            onSuggestionTap: (value, method) {
              tappedValue = value;
              tappedMethod = method;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();

    expect(tappedValue, isNotNull);
    expect(tappedMethod, equals('post'));
  });

  testWidgets(
    'falls back to resolved URL when env variable is missing',
    (WidgetTester tester) async {
      String? tappedValue;
      String? tappedMethod;

      mockUrlHistory = [
        {
          kUrlHistoryKeyRaw: '{{baseUrl}}/users',
          kUrlHistoryKeyResolved: 'https://api.dev.com/users',
          'method': 'put',
        },
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            urlHistoryProvider.overrideWith(
              (ref) => UrlHistoryNotifier(MockHiveHandler(mockUrlHistory)),
            ),
            availableEnvironmentVariablesStateProvider.overrideWith(
              (ref) => {},
            ),
          ],
          child: _wrapper(
            URLSuggestions(
              query: '',
              onSuggestionTap: (value, method) {
                tappedValue = value;
                tappedMethod = method;
              },
            ),
          ),
        ),
      );

      // Primary resolved URL is visible
      expect(find.text('https://api.dev.com/users'), findsOneWidget);

      // Variable missing is shown
      expect(find.text('Variable - Missing'), findsOneWidget);

      // Tap suggestion
      await tester.tap(find.byType(InkWell).first);
      await tester.pump();

      // tap pass resolved URL since variables are missing
      expect(tappedValue, equals('https://api.dev.com/users'));
      expect(tappedMethod, equals('put'));
    },
  );
}
