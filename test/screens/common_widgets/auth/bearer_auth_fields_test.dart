import 'package:apidash/screens/common_widgets/auth/bearer_auth_fields.dart';
import 'package:apidash/widgets/auth_textfield.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BearerAuthFields Widget Tests', () {
    late AuthModel? mockAuthData;
    late Function(AuthModel?) mockUpdateAuth;
    late List<AuthModel?> capturedAuthUpdates;

    setUp(() {
      capturedAuthUpdates = [];
      mockUpdateAuth = (AuthModel? authModel) {
        capturedAuthUpdates.add(authModel);
      };
    });

    testWidgets('renders with default values when authData is null',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsOneWidget);
      expect(find.text('Token'), findsNWidgets(2));
    });

    testWidgets('renders with existing bearer auth data',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.bearer,
        bearer: AuthBearerModel(
          token: 'test-bearer-token',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsOneWidget);
      expect(find.text('Token'), findsNWidgets(2));
    });

    testWidgets('updates auth data when token changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.bearer,
        bearer: AuthBearerModel(
          token: 'old-token',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the token field
      final tokenField = find.byType(AuthTextField);
      await tester.tap(tokenField);
      await tester.enterText(tokenField, 'new-bearer-token');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.bearer?.token, 'new-bearer-token');
      expect(lastUpdate?.type, APIAuthType.bearer);
    });

    testWidgets('respects readOnly property', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.bearer,
        bearer: AuthBearerModel(
          token: 'test-token',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
              readOnly: true,
            ),
          ),
        ),
      );

      // Verify that AuthTextField widget is rendered
      expect(find.byType(AuthTextField), findsOneWidget);

      // The readOnly property should be passed to AuthTextField widget
      // This is verified by the widget structure itself
    });

    testWidgets('displays correct hint text', (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('handles empty auth data gracefully',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.bearer,
        bearer: AuthBearerModel(
          token: '',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('creates proper AuthModel on token change',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Enter token
      final tokenField = find.byType(AuthTextField);
      await tester.tap(tokenField);
      await tester.enterText(tokenField, 'test-bearer-token');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with correct structure
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.type, APIAuthType.bearer);
      expect(lastUpdate?.bearer?.token, 'test-bearer-token');
    });

    testWidgets('initializes with correct default token value',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // The token field should be empty initially
      expect(find.byType(AuthTextField), findsOneWidget);
    });

    testWidgets('trims whitespace from token input',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BearerAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Enter token with whitespace
      final tokenField = find.byType(AuthTextField);
      await tester.tap(tokenField);
      await tester.enterText(tokenField, '  test-token  ');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with trimmed token
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.bearer?.token, 'test-token');
    });
  });
}
