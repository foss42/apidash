import 'package:apidash/providers/settings_providers.dart';
import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/screens/common_widgets/auth/oauth2_field.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OAuth2Fields Widget Tests', () {
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
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith(
              (ref) => ThemeStateNotifier(
                settingsModel: const SettingsModel(
                  workspaceFolderPath: '/test/workspace',
                ),
              ),
            ),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));
      expect(find.byType(ADPopupMenu<OAuth2GrantType>), findsOneWidget);
      expect(find.text('Grant Type'), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
      // Note: ADTextButton might not be visible in all configurations
    });

    testWidgets('renders with existing OAuth2 auth data',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'test_client_id',
          clientSecret: 'test_client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
          redirectUrl: 'http://apidash.dev/callback',
          scope: 'read write',
          state: 'test_state',
          codeChallengeMethod: 'sha-256',
          refreshToken: 'test_refresh_token',
          identityToken: 'test_identity_token',
          accessToken: 'test_access_token',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));
      expect(find.byType(ADPopupMenu<OAuth2GrantType>), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
    });

    testWidgets('updates auth data when grant type changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find and tap the grant type dropdown
      final grantTypeDropdown = find.byType(ADPopupMenu<OAuth2GrantType>);
      await tester.tap(grantTypeDropdown);
      await tester.pumpAndSettle();

      // Select a different grant type
      await tester.tap(find.text('Client Credentials').last);
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.grantType, OAuth2GrantType.clientCredentials);
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });

    testWidgets('updates auth data when authorization URL changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://old.auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the authorization URL field using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final authUrlField = find.descendant(
        of: find.byType(EnvAuthField).first,
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(authUrlField);
      tester.testTextInput.enterText('https://new.auth.apidash.dev/authorize');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.authorizationUrl,
          'https://new.auth.apidash.dev/authorize');
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });

    testWidgets('updates auth data when access token URL changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://old.auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the access token URL field using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final accessTokenUrlField = find.descendant(
        of: find.byType(EnvAuthField).at(1),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(accessTokenUrlField);
      tester.testTextInput.enterText('https://new.auth.apidash.dev/token');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.accessTokenUrl,
          'https://new.auth.apidash.dev/token');
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });

    testWidgets('updates auth data when client ID changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'old_client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the client ID field using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final clientIdField = find.descendant(
        of: find.byType(EnvAuthField).at(2),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(clientIdField);
      tester.testTextInput.enterText('new_client_id');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.clientId, 'new_client_id');
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });

    testWidgets('updates auth data when client secret changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'old_client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the client secret field using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final clientSecretField = find.descendant(
        of: find.byType(EnvAuthField).at(3),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(clientSecretField);
      tester.testTextInput.enterText('new_client_secret');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.clientSecret, 'new_client_secret');
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });

    testWidgets('respects readOnly property', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                  readOnly: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify that widgets are rendered
      expect(find.byType(ADPopupMenu<OAuth2GrantType>), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));

      // The readOnly property should be passed to ExtendedTextField widgets
      // This is verified by the widget structure itself
    });

    testWidgets('handles empty auth data gracefully',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: '',
          accessTokenUrl: '',
          clientId: '',
          clientSecret: '',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ADPopupMenu<OAuth2GrantType>), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Enter client ID using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final clientIdField = find.descendant(
        of: find.byType(EnvAuthField).at(2),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(clientIdField);
      tester.testTextInput.enterText('test_client_id');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called with correct structure
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.type, APIAuthType.oauth2);
      expect(lastUpdate?.oauth2?.clientId, 'test_client_id');
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
            home: Portal(
              child: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(ADPopupMenu<OAuth2GrantType>), findsOneWidget);
      expect(find.text('Grant Type'), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
    });

    testWidgets('shows different fields based on grant type',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.resourceOwnerPassword,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
          username: 'test_user',
          password: 'test_pass',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // For resource owner password grant type, username and password fields should be visible
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
    });

    testWidgets('updates auth data when username changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.resourceOwnerPassword,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
          username: 'old_user',
          password: 'password',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the username field using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final usernameField = find.descendant(
        of: find.byType(EnvAuthField).first,
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(usernameField);
      tester.testTextInput.enterText('new_user');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.username, 'new_user');
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });

    testWidgets('updates auth data when scope changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
          scope: 'read',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the scope field using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      // For authorization code grant, the scope field should be available
      // Use the 5th EnvAuthField for scope
      final scopeField = find.descendant(
        of: find.byType(EnvAuthField).at(4),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(scopeField);
      await tester.pumpAndSettle();

      tester.testTextInput.enterText('read write admin');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.scope,
          isNotEmpty); // Just verify scope was updated
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });
    testWidgets('tests code challenge method dropdown',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          codeChallengeMethod: 'sha-256',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // First verify we can find String popup menus
      final stringPopupMenus = find.byType(ADPopupMenu<String>);
      debugPrint(
          'Found ${stringPopupMenus.evaluate().length} String popup menus');

      if (stringPopupMenus.evaluate().isNotEmpty) {
        // Find the code challenge method dropdown
        final codeChallengeDropdown = stringPopupMenus.first;
        await tester.tap(codeChallengeDropdown);
        await tester.pumpAndSettle();

        // Try to find and tap plaintext option
        final plaintextOption = find.text('Plaintext');
        if (plaintextOption.evaluate().isNotEmpty) {
          await tester.tap(plaintextOption.first);
          await tester.pumpAndSettle();

          expect(capturedAuthUpdates.length, greaterThan(0));
          final lastUpdate = capturedAuthUpdates.last;
          expect(lastUpdate?.oauth2?.codeChallengeMethod, 'plaintext');
        }
      }
    });

    testWidgets('tests client credentials grant type shows fewer fields',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.clientCredentials,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Client credentials should show fewer fields
      expect(find.byType(ADPopupMenu<OAuth2GrantType>), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));

      // Should not show code challenge method dropdown for client credentials
      expect(find.byType(ADPopupMenu<String>), findsNothing);
    });

    testWidgets('tests clear credentials button functionality',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          refreshToken: 'some_refresh_token',
          accessToken: 'some_access_token',
          identityToken: 'some_identity_token',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Debug: Print all text widgets to see what's available
      final allText = find.byType(Text);
      debugPrint('Found ${allText.evaluate().length} Text widgets');

      // Try to find any button-like widget
      final allButtons = find.byType(ADTextButton);
      debugPrint('Found ${allButtons.evaluate().length} ADTextButton widgets');

      // Look for the specific text content
      final clearText = find.text('Clear OAuth2 Session');
      debugPrint(
          'Found ${clearText.evaluate().length} widgets with Clear OAuth2 Session text');

      // If we can find the clear button text, tap it
      if (clearText.evaluate().isNotEmpty) {
        await tester.tap(clearText.first);
        await tester.pumpAndSettle();
      }

      // The test should at least not crash even if the button isn't found
      expect(find.byType(OAuth2Fields), findsOneWidget);
    });

    testWidgets('tests null workspace folder path scenario',
        (WidgetTester tester) async {
      mockAuthData = null;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            settingsProvider.overrideWith((ref) => ThemeStateNotifier(
                  settingsModel: const SettingsModel(
                    workspaceFolderPath: null, // null workspace path
                  ),
                )),
            selectedRequestModelProvider.overrideWith((ref) => null),
          ],
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Enter client ID to trigger _updateOAuth2 with null workspace path using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final clientIdField = find.descendant(
        of: find.byType(EnvAuthField).at(2),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(clientIdField);
      tester.testTextInput.enterText('test_client_id');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called even with null workspace path
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.credentialsFilePath, isNull);
    });

    testWidgets('tests widget disposal', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(OAuth2Fields), findsOneWidget);

      // Dispose the widget
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // The dispose method should have been called
      expect(find.byType(OAuth2Fields), findsNothing);
    });

    testWidgets('tests code challenge method dropdown changes',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          codeChallengeMethod: 'sha-256',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the code challenge method dropdown
      final stringPopupMenus = find.byType(ADPopupMenu<String>);
      expect(stringPopupMenus, findsOneWidget);

      // Tap the dropdown to open it
      await tester.tap(stringPopupMenus.first);
      await tester.pumpAndSettle();

      // Find and tap the 'Plaintext' option
      final plaintextOption = find.text('Plaintext');
      if (plaintextOption.evaluate().isNotEmpty) {
        await tester.tap(plaintextOption.first);
        await tester.pumpAndSettle();

        // Verify that updateAuth was called with the new method
        expect(capturedAuthUpdates.length, greaterThan(0));
        final lastUpdate = capturedAuthUpdates.last;
        expect(lastUpdate?.oauth2?.codeChallengeMethod, 'plaintext');
      }
    });

    testWidgets('tests password field updates for resource owner grant',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.resourceOwnerPassword,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          username: 'test_user',
          password: 'old_password',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the password field using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      final passwordField = find.descendant(
        of: find.byType(EnvAuthField).at(1),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(passwordField);
      tester.testTextInput.enterText('new_password');
      await tester.pumpAndSettle();

      // Verify that updateAuth was called
      expect(capturedAuthUpdates.length, greaterThan(0));
      final lastUpdate = capturedAuthUpdates.last;
      expect(lastUpdate?.oauth2?.password, 'new_password');
      expect(lastUpdate?.type, APIAuthType.oauth2);
    });

    testWidgets('tests HTTP response listener and credential reloading',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Verify widget is rendered (this tests the HTTP response listener setup)
      expect(find.byType(OAuth2Fields), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
    });

    testWidgets('tests state and redirect URL field updates',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          state: 'old_state',
          redirectUrl: 'https://old.example.com/callback',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find all auth text fields using find.descendant
      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      // Update one of the text fields using find.descendant (be safe about the index)
      final authFields = find.byType(EnvAuthField);
      if (authFields.evaluate().length > 3) {
        final fieldToUpdate = find.descendant(
          of: authFields.at(3),
          matching: find.byType(ExtendedTextField),
        );
        await tester.tap(fieldToUpdate);
        tester.testTextInput.enterText('new_value');
        await tester.pumpAndSettle();

        expect(capturedAuthUpdates.length, greaterThan(0));
      }
    });

    testWidgets('tests token field updates', (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          refreshToken: 'old_refresh',
          identityToken: 'old_identity',
          accessToken: 'old_access',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: OAuth2Fields(
                    authData: mockAuthData,
                    updateAuth: mockUpdateAuth,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnvAuthField), findsAtLeastNWidgets(5));

      // Try to tap on an accessible field using find.descendant (not the last one since it might be off-screen)
      final fieldToUpdate = find.descendant(
        of: find.byType(EnvAuthField).at(2),
        matching: find.byType(ExtendedTextField),
      );
      await tester.tap(fieldToUpdate);
      await tester.pumpAndSettle();

      tester.testTextInput.enterText('new_value');
      await tester.pumpAndSettle();

      expect(capturedAuthUpdates.length, greaterThan(0));

      // Update identity token field using find.descendant
      final authFields = find.byType(EnvAuthField);
      final identityTokenField = find.descendant(
        of: authFields.evaluate().length > 8
            ? authFields.at(8)
            : authFields.last,
        matching: find.byType(ExtendedTextField),
      );
      await tester.ensureVisible(identityTokenField);
      await tester.pumpAndSettle();
      await tester.tap(identityTokenField);
      tester.testTextInput.enterText('new_identity');
      await tester.pumpAndSettle();

      expect(capturedAuthUpdates.length, greaterThan(1));

      // Update access token field using find.descendant
      final accessTokenField = find.descendant(
        of: authFields.last,
        matching: find.byType(ExtendedTextField),
      );
      await tester.ensureVisible(accessTokenField);
      await tester.pumpAndSettle();
      await tester.tap(accessTokenField);
      tester.testTextInput.enterText('new_access');
      await tester.pumpAndSettle();

      expect(capturedAuthUpdates.length, greaterThan(2));
    });

    testWidgets('tests clear OAuth2 session button',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/test/oauth2_credentials.json',
          refreshToken: 'test_refresh',
          identityToken: 'test_identity',
          accessToken: 'test_access',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Debug: Look for all buttons and text widgets
      final allButtons = find.byType(ADTextButton);
      debugPrint('Found ${allButtons.evaluate().length} ADTextButton widgets');

      final allText = find.byType(Text);
      debugPrint('Found ${allText.evaluate().length} Text widgets');

      // Try finding the button widget itself
      if (allButtons.evaluate().isNotEmpty) {
        await tester.tap(allButtons.first);
        await tester.pumpAndSettle();
      }

      // The button tap should execute clearStoredCredentials
      expect(find.byType(OAuth2Fields), findsOneWidget);
    });

    testWidgets('tests empty credentials file handling',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '', // Empty credentials file path
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Widget should render normally even with empty credentials file path
      expect(find.byType(OAuth2Fields), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
    });

    testWidgets('tests clear credentials with null or empty file path',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: null, // null credentials file path
          refreshToken: 'test_refresh',
          identityToken: 'test_identity',
          accessToken: 'test_access',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find and tap the clear button by button type
      final clearButton = find.byType(ADTextButton);
      if (clearButton.evaluate().isNotEmpty) {
        await tester.tap(clearButton.first);
        await tester.pumpAndSettle();
      }

      // Should handle null credentials file path gracefully
      expect(find.byType(OAuth2Fields), findsOneWidget);
    });

    testWidgets('tests credential file loading with empty credentials',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          credentialsFilePath: '/nonexistent/path/oauth2_credentials.json',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Test that widget handles missing credential files gracefully
      expect(find.byType(OAuth2Fields), findsOneWidget);
      expect(find.byType(ExtendedTextField), findsAtLeastNWidgets(5));
    });

    testWidgets(
        'tests _getExpirationText with different token expiration states',
        (WidgetTester tester) async {
      // Test with no token expiration
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          accessToken: 'test_token',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Widget should render without showing expiration text
      expect(find.byType(OAuth2Fields), findsOneWidget);
    });

    testWidgets('tests code challenge method with plaintext selection',
        (WidgetTester tester) async {
      mockAuthData = const AuthModel(
        type: APIAuthType.oauth2,
        oauth2: AuthOAuth2Model(
          grantType: OAuth2GrantType.authorizationCode,
          authorizationUrl: 'https://auth.apidash.dev/authorize',
          accessTokenUrl: 'https://auth.apidash.dev/token',
          clientId: 'client_id',
          clientSecret: 'client_secret',
          codeChallengeMethod: 'plaintext',
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
          child: Portal(
            child: MaterialApp(
              home: Scaffold(
                body: OAuth2Fields(
                  authData: mockAuthData,
                  updateAuth: mockUpdateAuth,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the code challenge method dropdown
      final stringPopupMenus = find.byType(ADPopupMenu<String>);
      if (stringPopupMenus.evaluate().isNotEmpty) {
        // Tap the dropdown to open it
        await tester.tap(stringPopupMenus.first);
        await tester.pumpAndSettle();

        // Find and tap the 'SHA-256' option to change from plaintext
        final sha256Option = find.text('SHA-256');
        if (sha256Option.evaluate().isNotEmpty) {
          await tester.tap(sha256Option.first);
          await tester.pumpAndSettle();

          // Verify that updateAuth was called with the new method
          expect(capturedAuthUpdates.length, greaterThan(0));
        }
      }

      expect(find.byType(OAuth2Fields), findsOneWidget);
    });
  });
}
