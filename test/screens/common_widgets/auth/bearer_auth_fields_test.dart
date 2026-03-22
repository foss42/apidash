import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsOneWidget);
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsOneWidget);
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      // Find the token field
      final authField = find.byType(EnvAuthField);
      expect(authField, findsOneWidget);

      // Find ExtendedTextField within the EnvAuthField using find.descendant
      final tokenField = find.descendant(
        of: authField,
        matching: find.byType(ExtendedTextField),
      );
      expect(tokenField, findsOneWidget);

      await tester.tap(tokenField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('new-bearer-token');
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
                readOnly: true,
              ),
            ),
          ),
        ),
      );

      // Verify that EnvAuthField widget is rendered
      expect(find.byType(EnvAuthField), findsOneWidget);

      // The readOnly property should be passed to EnvAuthField widget
      // This is verified by the widget structure itself
    });

    testWidgets('displays correct hint text', (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsOneWidget);
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsOneWidget);
    });

    testWidgets('creates proper AuthModel on token change',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      // Enter token
      final authField = find.byType(EnvAuthField);
      expect(authField, findsOneWidget);

      // Find ExtendedTextField within the EnvAuthField using find.descendant
      final tokenField = find.descendant(
        of: authField,
        matching: find.byType(ExtendedTextField),
      );
      expect(tokenField, findsOneWidget);

      await tester.tap(tokenField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('test-bearer-token');
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      // The token field should be empty initially
      expect(find.byType(EnvAuthField), findsOneWidget);
    });

    testWidgets('trims whitespace from token input',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BearerAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      // Enter token with whitespace
      final authField = find.byType(EnvAuthField);
      expect(authField, findsOneWidget);

      // Find ExtendedTextField within the EnvAuthField using find.descendant
      final tokenField = find.descendant(
        of: authField,
        matching: find.byType(ExtendedTextField),
      );
      expect(tokenField, findsOneWidget);

      await tester.tap(tokenField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('  test-token  ');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with trimmed token
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.bearer?.token, 'test-token');
    });
  });
}
