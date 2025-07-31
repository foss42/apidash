import 'package:apidash/screens/common_widgets/auth/jwt_auth_fields.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JwtAuthFields Widget Tests', () {
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
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Add JWT token to'), findsOneWidget);
      expect(find.text('Algorithm'), findsOneWidget);
      expect(find.text('Payload (JSON format)'), findsOneWidget);
      expect(find.byType(ADPopupMenu<String>), findsNWidgets(2));
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('HS256'), findsOneWidget);
    });

    testWidgets('renders with existing JWT auth data',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: 'test-secret',
          privateKey: '',
          payload: '{"sub": "1234567890"}',
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Add JWT token to'), findsOneWidget);
      expect(find.text('Algorithm'), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('HS256'), findsOneWidget);
    });

    testWidgets('shows secret field for HMAC algorithms',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: 'test-secret',
          privateKey: '',
          payload: '{}',
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Secret Key'), findsExactly(2));
      expect(find.text('Secret is Base64 encoded'), findsOneWidget);
      expect(find.byType(AuthTextField), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsOneWidget);
    });

    testWidgets('shows private key field for RSA algorithms',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: '',
          privateKey: 'test-private-key',
          payload: '{}',
          addTokenTo: 'header',
          algorithm: 'RS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      expect(find.text('Private Key'), findsOneWidget);
      expect(find.text('Secret Key'), findsNothing);
      expect(find.byType(TextField), findsNWidgets(2)); // Private key + payload
    });

    testWidgets('updates auth data when add token to dropdown changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: 'secret',
          privateKey: '',
          payload: '{}',
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find and tap the first dropdown (add token to)
      await tester.tap(find.byType(ADPopupMenu<String>).first);
      await tester.pumpAndSettle();

      // Select Query Parameters option
      await tester.tap(find.text('Query Params').last);
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.jwt?.addTokenTo, 'query');
    });

    testWidgets('updates auth data when algorithm dropdown changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: 'secret',
          privateKey: '',
          payload: '{}',
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find and tap the second dropdown (algorithm)
      await tester.tap(find.byType(ADPopupMenu<String>).last);
      await tester.pumpAndSettle();

      // Select RS256 option
      await tester.tap(find.text('RS256').last);
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.jwt?.algorithm, 'RS256');
    });

    testWidgets('updates auth data when secret changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: 'old-secret',
          privateKey: '',
          payload: '{}',
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the secret field
      final secretField = find.byType(AuthTextField).first;
      await tester.tap(secretField);
      await tester.enterText(secretField, 'new-secret');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.jwt?.secret, 'new-secret');
    });

    testWidgets('updates auth data when payload changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: 'secret',
          privateKey: '',
          payload: '{}',
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find the payload field (TextField)
      final payloadField = find.byType(TextField).last;
      await tester.tap(payloadField);
      await tester.enterText(payloadField, '{"sub": "1234567890"}');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.jwt?.payload, '{"sub": "1234567890"}');
    });

    testWidgets('updates auth data when Base64 checkbox changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.jwt,
        jwt: AuthJwtModel(
          secret: 'secret',
          privateKey: '',
          payload: '{}',
          addTokenTo: 'header',
          algorithm: 'HS256',
          isSecretBase64Encoded: false,
          headerPrefix: 'Bearer',
          queryParamKey: 'token',
          header: 'Authorization',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Find and tap the checkbox
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.jwt?.isSecretBase64Encoded, true);
    });

    testWidgets('initializes with correct default values',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JwtAuthFields(
              authData: mockAuthData,
              updateAuth: mockUpdateAuth,
            ),
          ),
        ),
      );

      // Default token location should be header
      expect(find.text('Header'), findsOneWidget);

      // Default algorithm should be HS256
      expect(find.text('HS256'), findsOneWidget);

      // Default Base64 encoded should be false
      expect(find.byType(CheckboxListTile), findsOneWidget);
    });
  });
}
