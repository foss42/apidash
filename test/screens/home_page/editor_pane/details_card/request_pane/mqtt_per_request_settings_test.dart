import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/env_trigger_field.dart';
import 'package:apidash/screens/common_widgets/envfield_auth.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/details_card.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card/url_card.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../providers/helpers.dart';

/// Regression tests for: "the MQTT Client ID is the same for every request
/// tab — changing it in one tab changes it in ALL tabs".
///
/// Root causes fixed:
/// 1. EnvAuthField seeds its text once in initState, and its inner
///    EnvironmentTriggerField refuses to re-sync when the new initialValue is
///    null (clientId/username/password are nullable). The MQTT tab subtrees
///    are now keyed by selectedId so every request gets fresh fields.
/// 2. URLTextField.onChanged wrote a build-time-captured (stale)
///    mqttRequestModel back wholesale on broker-URL keystrokes, clobbering
///    fields edited since the URL card's last rebuild (clientId, live
///    messageHistory, ...). It now re-reads the latest model in the callback.
///
/// Uses the REAL CollectionStateNotifier (no mocks), same harness as
/// ws_url_edit_state_test.dart.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  Future<(ProviderContainer, String)> pumpEditor(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Portal(
            child: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final selectedId = ref.watch(selectedIdStateProvider);
                  if (selectedId == null) return const SizedBox.shrink();
                  return const Column(
                    children: [
                      EditorPaneRequestURLCard(),
                      Expanded(child: EditorPaneRequestDetailsCard()),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Consumer).first),
    );
    // The notifier is lazy — instantiate it so its constructor selects an id.
    container.read(collectionStateNotifierProvider.notifier);
    await tester.pumpAndSettle();
    final notifier = container.read(collectionStateNotifierProvider.notifier);
    final id = container.read(selectedIdStateProvider)!;

    notifier.update(id: id, apiType: APIType.mqtt);
    notifier.update(
      id: id,
      mqttRequestModel: const MQTTRequestModel(
        brokerUrl: 'broker-a.example.com',
      ),
    );
    await tester.pumpAndSettle();
    return (container, id);
  }

  /// Creates a SECOND MQTT request and selects it. Returns its id.
  Future<String> addMqttRequest(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    final notifier = container.read(collectionStateNotifierProvider.notifier);
    notifier.add();
    final id = container.read(selectedIdStateProvider)!;
    notifier.update(id: id, apiType: APIType.mqtt);
    notifier.update(
      id: id,
      mqttRequestModel: const MQTTRequestModel(
        brokerUrl: 'broker-b.example.com',
      ),
    );
    await tester.pumpAndSettle();
    return id;
  }

  /// The EnvironmentTriggerField inside the EnvAuthField titled [title].
  Finder authField(String title) => find.descendant(
    of: find.byWidgetPredicate(
      (w) => w is EnvAuthField && (w.title ?? w.hintText) == title,
    ),
    matching: find.byType(EnvironmentTriggerField),
  );

  String fieldText(WidgetTester tester, Finder f) =>
      tester.state<EnvironmentTriggerFieldState>(f).controller.text;

  /// Drives the field exactly like typing does: set the controller text and
  /// fire the field's onChanged (the inner editable of ExtendedTextField is
  /// not a plain EditableText, so tester.enterText can't reach it).
  Future<void> typeInto(WidgetTester tester, Finder f, String text) async {
    final st = tester.state<EnvironmentTriggerFieldState>(f);
    final w = tester.widget<EnvironmentTriggerField>(f);
    st.controller.text = text;
    w.onChanged?.call(text);
    await tester.pump();
  }

  MQTTRequestModel mqttOf(ProviderContainer container, String id) => container
      .read(collectionStateNotifierProvider.notifier)
      .getRequestModel(id)!
      .mqttRequestModel!;

  testWidgets(
    'Client ID is per-request: each tab keeps its own value in the model '
    'AND in the rendered field',
    (tester) async {
      final (container, idA) = await pumpEditor(tester);

      // Request A: set a Client ID on the Settings tab.
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(authField('Client ID'), findsOneWidget);
      await typeInto(tester, authField('Client ID'), 'client-A');
      expect(mqttOf(container, idA).clientId, 'client-A');

      // Request B (fresh MQTT request, clientId null).
      final idB = await addMqttRequest(tester, container);
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // B's field must NOT show A's Client ID.
      expect(
        fieldText(tester, authField('Client ID')),
        isEmpty,
        reason: "Request B's Client ID field showed request A's value",
      );
      expect(mqttOf(container, idB).clientId, isNull);

      // Give B its own Client ID; A must be untouched.
      await typeInto(tester, authField('Client ID'), 'client-B');
      expect(mqttOf(container, idB).clientId, 'client-B');
      expect(
        mqttOf(container, idA).clientId,
        'client-A',
        reason: "Editing B's Client ID leaked into request A's model",
      );

      // Switch back to A: field must show A's own value again.
      container.read(selectedIdStateProvider.notifier).state = idA;
      await tester.pumpAndSettle();
      expect(
        fieldText(tester, authField('Client ID')),
        'client-A',
        reason: "Request A's Client ID field showed request B's value",
      );
      expect(mqttOf(container, idA).clientId, 'client-A');
      expect(mqttOf(container, idB).clientId, 'client-B');
    },
  );

  testWidgets('Username/Password (Auth tab) are per-request', (tester) async {
    final (container, idA) = await pumpEditor(tester);

    await tester.tap(find.text('Auth'));
    await tester.pumpAndSettle();
    await typeInto(tester, authField('Username'), 'user-A');
    await typeInto(tester, authField('Password'), 'secret-A');
    expect(mqttOf(container, idA).username, 'user-A');
    expect(mqttOf(container, idA).password, 'secret-A');

    final idB = await addMqttRequest(tester, container);
    await tester.tap(find.text('Auth'));
    await tester.pumpAndSettle();

    expect(
      fieldText(tester, authField('Username')),
      isEmpty,
      reason: "Request B's Username field showed request A's value",
    );
    expect(
      fieldText(tester, authField('Password')),
      isEmpty,
      reason: "Request B's Password field showed request A's value",
    );
    expect(mqttOf(container, idB).username, isNull);
    expect(mqttOf(container, idB).password, isNull);

    await typeInto(tester, authField('Username'), 'user-B');
    expect(mqttOf(container, idB).username, 'user-B');
    expect(mqttOf(container, idA).username, 'user-A');

    container.read(selectedIdStateProvider.notifier).state = idA;
    await tester.pumpAndSettle();
    expect(fieldText(tester, authField('Username')), 'user-A');
    expect(fieldText(tester, authField('Password')), 'secret-A');
  });

  testWidgets(
    'broker URL keystrokes do not clobber MQTT settings edited after the '
    'URL card last rebuilt (stale-closure regression)',
    (tester) async {
      final (container, idA) = await pumpEditor(tester);
      final notifier = container.read(collectionStateNotifierProvider.notifier);

      // Change clientId + grow messageHistory WITHOUT touching brokerUrl, so
      // the URL card does not rebuild and its build-time model goes stale —
      // exactly what editing Settings or a live broker connection does.
      final m = mqttOf(container, idA);
      notifier.update(
        id: idA,
        mqttRequestModel: m.copyWith(
          clientId: 'my-client',
          messageHistory: [
            WebSocketMessage(
              payload: 'Connected to broker',
              timestamp: DateTime(2026, 1, 1, 10, 0, 0),
              outgoing: false,
              messageType: WebSocketMessageType.connected,
            ),
          ],
        ),
      );
      await tester.pump();

      // Now the user edits the broker URL (real URLTextField.onChanged path).
      final urlField = find.descendant(
        of: find.byType(EditorPaneRequestURLCard),
        matching: find.byType(EnvironmentTriggerField),
      );
      expect(urlField, findsOneWidget);
      for (final text in ['broker-a.example.co', 'broker-a.example.c']) {
        final st = tester.state<EnvironmentTriggerFieldState>(urlField);
        final w = tester.widget<EnvironmentTriggerField>(urlField);
        st.controller.text = text;
        w.onChanged?.call(text);
        await tester.pump();
      }
      await tester.pumpAndSettle();

      final after = mqttOf(container, idA);
      expect(after.brokerUrl, 'broker-a.example.c');
      expect(
        after.clientId,
        'my-client',
        reason: 'URL keystroke wiped clientId (stale model written back)',
      );
      expect(
        after.messageHistory.length,
        1,
        reason: 'URL keystroke wiped messageHistory (stale model written back)',
      );
    },
  );
}
