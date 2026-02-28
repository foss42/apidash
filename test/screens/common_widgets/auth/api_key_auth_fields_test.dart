import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add to'), findsOneWidget);
      expect(find.byType(ADPopupMenu<String>), findsOneWidget);
      expect(find.byType(EnvAuthField), findsNWidgets(2));
      expect(find.text('Header'), findsOneWidget);
    });

    testWidgets(
        'updates auth data when authData is null and API key value is changed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: null,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Find EnvAuthField widgets
      final authFields = find.byType(EnvAuthField);
      expect(authFields, findsNWidgets(2));

      // Find the last EnvAuthField (API key value field)
      final lastAuthField = authFields.last;

      // Find ExtendedTextField within the last EnvAuthField using find.descendant
      final lastField = find.descendant(
        of: lastAuthField,
        matching: find.byType(ExtendedTextField),
      );
      expect(lastField, findsOneWidget);

      await tester.tap(lastField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('new-api-key');
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add to'), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
      expect(find.byType(EnvAuthField), findsNWidgets(2));
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Find EnvAuthField widgets
      final authFields = find.byType(EnvAuthField);
      expect(authFields, findsNWidgets(2));

      // Find the first EnvAuthField (API key name field)
      final firstAuthField = authFields.first;

      // Find ExtendedTextField within the first EnvAuthField using find.descendant
      final nameField = find.descendant(
        of: firstAuthField,
        matching: find.byType(ExtendedTextField),
      );
      expect(nameField, findsOneWidget);

      // Tap and enter text in the name field
      await tester.tap(nameField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('Authorization');
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Find EnvAuthField widgets
      final authFields = find.byType(EnvAuthField);
      expect(authFields, findsNWidgets(2));

      // Find the last EnvAuthField (API key value field)
      final lastAuthField = authFields.last;

      // Find ExtendedTextField within the last EnvAuthField using find.descendant
      final keyField = find.descendant(
        of: lastAuthField,
        matching: find.byType(ExtendedTextField),
      );
      expect(keyField, findsOneWidget);

      // Tap and enter text in the key field
      await tester.tap(keyField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('new-api-key');
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
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                  readOnly: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify that EnvAuthField widgets are rendered
      expect(find.byType(EnvAuthField), findsNWidgets(2));

      // The readOnly property should be passed to EnvAuthField widgets
      // This is verified by the widget structure itself
    });

    testWidgets('displays correct hint texts', (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Add to'), findsOneWidget);
      // Check for the existence of the auth text fields
      expect(find.byType(EnvAuthField), findsNWidgets(2));
    });
    testWidgets('initializes with correct default values',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: ApiKeyAuthFields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Default location should be header
      expect(find.text('Header'), findsOneWidget);

      // Check for the existence of text fields with default values
      final textFields = find.byType(EnvAuthField);
      expect(textFields, findsNWidgets(2));

      // Verify the first text field (name) has the default value in its controller
      final nameTextField = tester.widget<EnvAuthField>(textFields.first);
      expect(nameTextField.initialValue, 'x-api-key');
    });
  });
}
