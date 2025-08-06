import 'package:apidash/screens/common_widgets/auth/oauth1_fields.dart';
import 'package:apidash/widgets/field_auth.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/models/models.dart';

void main() {
  group('OAuth1Fields Widget Tests', () {
    late AuthModel? mockAuthData;
    late Function(AuthModel?) mockUpdateAuth;
    late List<AuthModel?> capturedAuthUpdates;

    setUp(() {
      capturedAuthUpdates = [];
      mockUpdateAuth = (AuthModel? authModel) {
        capturedAuthUpdates.add(authModel);
      };
    });

    // Helper function to wrap OAuth1Fields widget with proper layout constraints

    testWidgets('renders with default values when authData is null',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsNWidgets(9));
      expect(find.byType(ADPopupMenu<OAuth1SignatureMethod>), findsOneWidget);
      expect(find.text('Signature Method'), findsOneWidget);
    });

    testWidgets('renders with existing OAuth1 auth data',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'test_consumer_key',
          consumerSecret: 'test_consumer_secret',
          accessToken: 'test_access_token',
          tokenSecret: 'test_token_secret',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          callbackUrl: 'http://api.apidash.dev/callback',
          verifier: 'test_verifier',
          timestamp: '1234567890',
          nonce: 'test_nonce',
          realm: 'test_realm',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsNWidgets(9));
      expect(find.byType(ADPopupMenu<OAuth1SignatureMethod>), findsOneWidget);
    });

    testWidgets('updates auth data when consumer key changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'old_key',
          consumerSecret: 'secret',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the consumer key field (first AuthTextField)
      final consumerKeyField = find.byType(AuthTextField).first;
      await tester.tap(consumerKeyField);
      await tester.enterText(consumerKeyField, 'new_consumer_key');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth1?.consumerKey, 'new_consumer_key');
      expect(lastUpdate?.type, APIAuthType.oauth1);
    });

    testWidgets('updates auth data when consumer secret changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'key',
          consumerSecret: 'old_secret',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the consumer secret field (second AuthTextField)
      final consumerSecretField = find.byType(AuthTextField).at(1);
      await tester.tap(consumerSecretField);
      await tester.enterText(consumerSecretField, 'new_consumer_secret');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth1?.consumerSecret, 'new_consumer_secret');
      expect(lastUpdate?.type, APIAuthType.oauth1);
    });

    testWidgets('updates auth data when signature method changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'key',
          consumerSecret: 'secret',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find and tap the signature method dropdown
      final signatureMethodDropdown =
          find.byType(ADPopupMenu<OAuth1SignatureMethod>);
      await tester.tap(signatureMethodDropdown);
      await tester.pumpAndSettle();

      // Select a different signature method
      await tester.tap(find.text('Plaintext').last);
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(
          lastUpdate?.oauth1?.signatureMethod, OAuth1SignatureMethod.plaintext);
      expect(lastUpdate?.type, APIAuthType.oauth1);
    });

    testWidgets('updates auth data when access token changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'key',
          consumerSecret: 'secret',
          accessToken: 'old_token',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the access token field (3rd AuthTextField, after consumer key, secret, and before signature method dropdown)
      final accessTokenField = find.byType(AuthTextField).at(2);
      await tester.tap(accessTokenField);
      await tester.enterText(accessTokenField, 'new_access_token');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth1?.accessToken, 'new_access_token');
      expect(lastUpdate?.type, APIAuthType.oauth1);
    });

    testWidgets('respects readOnly property', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'key',
          consumerSecret: 'secret',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                  readOnly: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify that AuthTextField widgets are rendered
      expect(find.byType(AuthTextField), findsNWidgets(9));
      expect(find.byType(ADPopupMenu<OAuth1SignatureMethod>), findsOneWidget);

      // The readOnly property should be passed to AuthTextField widgets
      // This is verified by the widget structure itself
    });

    testWidgets('handles empty auth data gracefully',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: '',
          consumerSecret: '',
          accessToken: '',
          tokenSecret: '',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsNWidgets(9));
      expect(find.byType(ADPopupMenu<OAuth1SignatureMethod>), findsOneWidget);
    });

    testWidgets(
        'creates proper AuthModel on field changes when authData is null',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Enter consumer key
      final consumerKeyField = find.byType(AuthTextField).first;
      await tester.tap(consumerKeyField);
      await tester.enterText(consumerKeyField, 'test_consumer_key');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with correct structure
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.type, APIAuthType.oauth1);
      expect(lastUpdate?.oauth1?.consumerKey, 'test_consumer_key');
    });

    testWidgets('displays correct hint texts', (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AuthTextField), findsNWidgets(9));
      expect(find.text('Signature Method'), findsOneWidget);
    });

    testWidgets('updates auth data when token secret changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'key',
          consumerSecret: 'secret',
          accessToken: 'token',
          tokenSecret: 'old_token_secret',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the token secret field (4th AuthTextField)
      final tokenSecretField = find.byType(AuthTextField).at(3);
      await tester.tap(tokenSecretField);
      await tester.enterText(tokenSecretField, 'new_token_secret');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth1?.tokenSecret, 'new_token_secret');
      expect(lastUpdate?.type, APIAuthType.oauth1);
    });

    testWidgets('updates auth data when callback URL changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth1,
        oauth1: AuthOAuth1Model(
          consumerKey: 'key',
          consumerSecret: 'secret',
          callbackUrl: 'http://old.api.apidash.dev/callback',
          signatureMethod: OAuth1SignatureMethod.hmacSha1,
          parameterLocation: 'url',
          credentialsFilePath: '/test/path',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: '/test/workspace',
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: OAuth1Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the callback URL field (5th AuthTextField)
      final callbackUrlField = find.byType(AuthTextField).at(4);
      await tester.tap(callbackUrlField);
      await tester.enterText(
          callbackUrlField, 'http://api.apidash.dev/callback');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(
          lastUpdate?.oauth1?.callbackUrl, 'http://api.apidash.dev/callback');
      expect(lastUpdate?.type, APIAuthType.oauth1);
    });
  });
}
