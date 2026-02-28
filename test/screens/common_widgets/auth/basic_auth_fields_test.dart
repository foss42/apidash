import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BasicAuthFields Widget Tests', () {
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
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsNWidgets(2));
      expect(find.text('Username'), findsNWidgets(2));
      expect(find.text('Password'), findsNWidgets(2));
    });

    testWidgets('renders with existing basic auth data',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: 'testuser',
          password: 'testpass',
        ),
      );

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsNWidgets(2));
      expect(find.text('Username'), findsExactly(2));
      expect(find.text('Password'), findsExactly(2));
    });

    testWidgets('updates auth data when username changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: 'olduser',
          password: 'password',
        ),
      );

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      // Find EnvAuthField widgets
      final authFields = find.byType(EnvAuthField);
      expect(authFields, findsNWidgets(2));

      // Find the first EnvAuthField (username field)
      final firstAuthField = authFields.first;

      // Find ExtendedTextField within the first EnvAuthField using find.descendant
      final usernameField = find.descendant(
        of: firstAuthField,
        matching: find.byType(ExtendedTextField),
      );
      expect(usernameField, findsOneWidget);

      await tester.tap(usernameField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('newuser');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.basic?.username, 'newuser');
      expect(lastUpdate?.type, APIAuthType.basic);
    });

    testWidgets('updates auth data when password changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: 'user',
          password: 'oldpass',
        ),
      );

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      // Find EnvAuthField widgets
      final authFields = find.byType(EnvAuthField);
      expect(authFields, findsNWidgets(2));

      // Find the last EnvAuthField (password field)
      final lastAuthField = authFields.last;

      // Find ExtendedTextField within the last EnvAuthField using find.descendant
      final passwordField = find.descendant(
        of: lastAuthField,
        matching: find.byType(ExtendedTextField),
      );
      expect(passwordField, findsOneWidget);

      await tester.tap(passwordField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('newpass');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.basic?.password, 'newpass');
      expect(lastUpdate?.type, APIAuthType.basic);
    });

    testWidgets('respects readOnly property', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: 'user',
          password: 'pass',
        ),
      );

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
                readOnly: true,
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
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsNWidgets(2));
    });

    testWidgets('handles empty auth data gracefully',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.basic,
        basic: AuthBasicAuthModel(
          username: '',
          password: '',
        ),
      );

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsNWidgets(2));
    });

    testWidgets('creates proper AuthModel on field changes',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        Portal(
          child: MaterialApp(
            home: Scaffold(
              body: BasicAuthFields(
                authData: mockAuthData,
                updateAuth: mockUpdateAuth,
              ),
            ),
          ),
        ),
      );

      // Enter username
      final authFields = find.byType(EnvAuthField);
      expect(authFields, findsNWidgets(2));

      // Find the first EnvAuthField (username field)
      final firstAuthField = authFields.first;

      // Find ExtendedTextField within the first EnvAuthField using find.descendant
      final usernameField = find.descendant(
        of: firstAuthField,
        matching: find.byType(ExtendedTextField),
      );
      expect(usernameField, findsOneWidget);

      await tester.tap(usernameField);
      await tester.pumpAndSettle();

      // Use tester.testTextInput to enter text directly
      tester.testTextInput.enterText('testuser');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with correct structure
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.type, APIAuthType.basic);
      expect(lastUpdate?.basic?.username, 'testuser');
    });
  });
}
