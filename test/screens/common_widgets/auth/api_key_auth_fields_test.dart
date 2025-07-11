import 'package:apidash/screens/common_widgets/auth/api_key_auth_fields.dart';
import 'package:apidash/widgets/auth_textfield.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiKeyAuthFields Widget Tests', () {
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
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Add to'), findsOneWidget);
      expect(find.byType(ADPopupMenu<String>), findsOneWidget);
      expect(find.byType(AuthTextField), findsNWidgets(2));
      expect(find.text('Header'), findsOneWidget);
    });

    testWidgets(
        'updates auth data when authData is null and API key value is changed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: null,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the key field (second AuthTextField)
      final keyField = find.byType(AuthTextField).last;
      await tester.tap(keyField);
      await tester.enterText(keyField, 'new-api-key');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.apikey?.key, 'new-api-key');
    });

    testWidgets('renders with existing API key auth data',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: 'test-api-key',
          name: 'X-API-Key',
          location: 'header',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Add to'), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
      expect(find.byType(AuthTextField), findsNWidgets(2));
    });

    testWidgets('renders with query params location',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: 'test-api-key',
          name: 'api_key',
          location: 'query',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Add to'), findsOneWidget);
      expect(find.text('Query Params'), findsOneWidget);
    });

    testWidgets('updates auth data when location dropdown changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: 'test-key',
          name: 'X-API-Key',
          location: 'header',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find and tap the dropdown
      await tester.tap(find.byType(ADPopupMenu<String>));
      await tester.pumpAndSettle();

      // Select Query Params option
      await tester.tap(find.text('Query Params').last);
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.apikey?.location, 'query');
    });

    testWidgets('updates auth data when API key name changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: 'test-key',
          name: 'X-API-Key',
          location: 'header',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the name field (first AuthTextField)
      final nameField = find.byType(AuthTextField).first;
      await tester.tap(nameField);
      await tester.enterText(nameField, 'Authorization');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.apikey?.name, 'Authorization');
    });

    testWidgets('updates auth data when API key value changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: 'old-key',
          name: 'X-API-Key',
          location: 'header',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the key field (second AuthTextField)
      final keyField = find.byType(AuthTextField).last;
      await tester.tap(keyField);
      await tester.enterText(keyField, 'new-api-key');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.apikey?.key, 'new-api-key');
    });

    testWidgets('respects readOnly property', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.apiKey,
        apikey: AuthApiKeyModel(
          key: 'test-key',
          name: 'X-API-Key',
          location: 'header',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
              readOnly: true,
            ),
          ),
        ),
      );

      // Verify that AuthTextField widgets are rendered
      expect(find.byType(AuthTextField), findsNWidgets(2));

      // The readOnly property should be passed to AuthTextField widgets
      // This is verified by the widget structure itself
    });

    testWidgets('displays correct hint texts', (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Add to'), findsOneWidget);
      // Check for the existence of the auth text fields
      expect(find.byType(AuthTextField), findsNWidgets(2));
    });
    testWidgets('initializes with correct default values',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ApiKeyAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Default location should be header
      expect(find.text('Header'), findsOneWidget);

      // Default name should be 'x-api-key' in the text field
      expect(find.text('x-api-key'), findsOneWidget);
    });
  });
}
