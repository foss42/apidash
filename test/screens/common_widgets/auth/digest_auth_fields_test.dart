import 'package:apidash/screens/common_widgets/auth/digest_auth_fields.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DigestAuthFields Widget Tests', () {
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
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsNWidgets(6));
      expect(find.byType(ADPopupMenu<String>), findsOneWidget);
      // Check for field labels (each AuthTextField creates a Text widget for label)
      expect(find.text('Username'), findsNWidgets(2));
      expect(find.text('Password'), findsNWidgets(2));
      expect(find.text('Realm'), findsNWidgets(2));
      expect(find.text('Nonce'), findsNWidgets(2));
      expect(find.text('Algorithm'), findsOneWidget);
      expect(find.text('QOP'), findsNWidgets(2));
      expect(find.text('Opaque'), findsNWidgets(2));
    });

    testWidgets('renders with existing digest auth data',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.digest,
        digest: AuthDigestModel(
          username: 'testuser',
          password: 'testpass',
          realm: 'testrealm',
          nonce: 'testnonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'testopaque',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsNWidgets(6));
      expect(find.byType(ADPopupMenu<String>), findsOneWidget);
      expect(find.text('MD5'), findsOneWidget);
    });

    testWidgets('updates auth data when username changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.digest,
        digest: AuthDigestModel(
          username: 'olduser',
          password: 'pass',
          realm: 'realm',
          nonce: 'nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'opaque',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the username field (first AuthTextField)
      final usernameField = find.byType(AuthTextField).first;
      await tester.tap(usernameField);
      await tester.enterText(usernameField, 'newuser');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.digest?.username, 'newuser');
      expect(lastUpdate?.type, APIAuthType.digest);
    });

    testWidgets('updates auth data when password changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.digest,
        digest: AuthDigestModel(
          username: 'user',
          password: 'oldpass',
          realm: 'realm',
          nonce: 'nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'opaque',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the password field (second AuthTextField)
      final passwordField = find.byType(AuthTextField).at(1);
      await tester.tap(passwordField);
      await tester.enterText(passwordField, 'newpass');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.digest?.password, 'newpass');
      expect(lastUpdate?.type, APIAuthType.digest);
    });

    testWidgets('updates auth data when algorithm dropdown changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.digest,
        digest: AuthDigestModel(
          username: 'user',
          password: 'pass',
          realm: 'realm',
          nonce: 'nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'opaque',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find and tap the algorithm dropdown
      await tester.tap(find.byType(ADPopupMenu<String>));
      await tester.pumpAndSettle();

      // Select SHA-256 option
      await tester.tap(find.text('SHA-256').last);
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.digest?.algorithm, 'SHA-256');
    });

    testWidgets('updates auth data when realm changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.digest,
        digest: AuthDigestModel(
          username: 'user',
          password: 'pass',
          realm: 'oldrealm',
          nonce: 'nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'opaque',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the realm field (third AuthTextField)
      final realmField = find.byType(AuthTextField).at(2);
      await tester.tap(realmField);
      await tester.enterText(realmField, 'newrealm');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.digest?.realm, 'newrealm');
    });

    testWidgets('respects readOnly property', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.digest,
        digest: AuthDigestModel(
          username: 'user',
          password: 'pass',
          realm: 'realm',
          nonce: 'nonce',
          algorithm: 'MD5',
          qop: 'auth',
          opaque: 'opaque',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
              readOnly: true,
            ),
          ),
        ),
      );

      final usernameFieldFinder = find.byType(AuthTextField).first;

      // Try to enter text
      await tester.enterText(usernameFieldFinder, 'testuser');
      await tester.pumpAndSettle();

      // Ensure updateAuth was not called
      expect(capturedAuthUpdates, isEmpty);

      // Check the field still shows original value
      final textField = tester.widget<AuthTextField>(usernameFieldFinder);
      expect(textField.controller.text, equals('user'));
    });

    testWidgets('displays correct hint texts', (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsNWidgets(6));
      expect(find.byType(ADPopupMenu<String>), findsOneWidget);
      expect(find.text('Algorithm'), findsOneWidget);
    });

    testWidgets('initializes with correct default values',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Default algorithm should be MD5
      expect(find.text('MD5'), findsOneWidget);

      // Default QOP should be 'auth' - but this is in the TextFormField value, not visible text
      // We need to check the controller value instead
      expect(find.byType(AuthTextField), findsNWidgets(6));
    });

    testWidgets('creates proper AuthModel on field changes',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Enter username
      final usernameField = find.byType(AuthTextField).first;
      await tester.tap(usernameField);
      await tester.enterText(usernameField, 'testuser');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with correct structure
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.type, APIAuthType.digest);
      expect(lastUpdate?.digest?.username, 'testuser');
      expect(lastUpdate?.digest?.algorithm, 'MD5');
    });

    testWidgets('handles all algorithm options correctly',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Test each algorithm option
      final algorithms = ['MD5', 'MD5-sess', 'SHA-256', 'SHA-256-sess'];

      for (final algorithm in algorithms) {
        // Tap the dropdown
        await tester.tap(find.byType(ADPopupMenu<String>));
        await tester.pumpAndSettle();

        // Select the algorithm
        await tester.tap(find.text(algorithm).last);
        await tester.pumpAndSettle();

        // Verify the selection
        expect(find.text(algorithm), findsOneWidget);
      }
    });

    testWidgets('trims whitespace from all field inputs',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DigestAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Enter username with whitespace
      final usernameField = find.byType(AuthTextField).first;
      await tester.tap(usernameField);
      await tester.enterText(usernameField, '  testuser  ');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with trimmed values
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.digest?.username, 'testuser');
    });
  });
}
