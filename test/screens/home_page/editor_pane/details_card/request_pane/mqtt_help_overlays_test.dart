import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/envfield_auth.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/details_card.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_help_icon.dart';
import 'package:apidash/screens/home_page/editor_pane/url_card/url_card.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../providers/helpers.dart';

/// Tests for the plain-language hover/tap help overlays added to the MQTT
/// request pane.
///
/// The affordance is the same idiom the app already uses for auth-field help:
/// a subtle `help_outline` icon next to a control's LABEL (via
/// `EnvAuthField.infoText`) or as a small ADJACENT icon (`MqttHelpIcon`) for
/// switches / dropdowns / the publish-topic field. Both render a [Tooltip]
/// (hover on desktop, tap on touch) — never wrapping the interactive control,
/// so the control's own typing/toggling gesture is never swallowed.
///
/// Uses the REAL CollectionStateNotifier (no mocks), same harness as
/// mqtt_per_request_settings_test.dart.
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
    container.read(collectionStateNotifierProvider.notifier);
    await tester.pumpAndSettle();
    final notifier = container.read(collectionStateNotifierProvider.notifier);
    final id = container.read(selectedIdStateProvider)!;

    notifier.update(id: id, apiType: APIType.mqtt);
    notifier.update(
      id: id,
      mqttRequestModel: const MQTTRequestModel(brokerUrl: 'broker.example.com'),
    );
    await tester.pumpAndSettle();
    return (container, id);
  }

  /// The EnvAuthField titled [title].
  Finder envAuth(String title) => find.byWidgetPredicate(
    (w) => w is EnvAuthField && (w.title ?? w.hintText) == title,
  );

  String? infoTextOf(WidgetTester tester, String title) =>
      tester.widget<EnvAuthField>(envAuth(title)).infoText;

  /// A MqttHelpIcon whose help copy contains [phrase].
  Finder helpIconWith(String phrase) => find.byWidgetPredicate(
    (w) => w is MqttHelpIcon && w.message.contains(phrase),
  );

  MQTTRequestModel mqttOf(ProviderContainer container, String id) => container
      .read(collectionStateNotifierProvider.notifier)
      .getRequestModel(id)!
      .mqttRequestModel!;

  testWidgets(
    'Settings-tab controls carry plain-language help: label help on '
    'EnvAuthField controls, adjacent info icons on switches/dropdowns',
    (tester) async {
      await pumpEditor(tester);
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Label help (EnvAuthField.infoText) — jargon-free, non-empty.
      expect(infoTextOf(tester, 'Client ID'), contains('identify itself'));
      expect(infoTextOf(tester, 'Port'), contains('door on the service'));
      expect(infoTextOf(tester, 'Keep Alive (s)'), contains('still here'));

      // Adjacent info icons on the non-EnvAuthField controls.
      expect(
        helpIconWith('deliver a message'),
        findsOneWidget,
        reason: 'Default QoS dropdown must have an adjacent help icon',
      );
      expect(
        helpIconWith('Start fresh'),
        findsOneWidget,
        reason: 'Clean Session/Start switch must have an adjacent help icon',
      );

      // Every help icon is tap-triggered (also hover on desktop) — a small
      // adjacent icon, so it never swallows the control's own gesture.
      for (final e in tester.widgetList<MqttHelpIcon>(find.byType(MqttHelpIcon))) {
        expect(e.message, isNotEmpty);
      }
      for (final t in tester.widgetList<Tooltip>(
        find.descendant(
          of: find.byType(MqttHelpIcon),
          matching: find.byType(Tooltip),
        ),
      )) {
        expect(t.triggerMode, TooltipTriggerMode.tap);
      }
    },
  );

  testWidgets('Message tab: publish-topic field has adjacent help', (
    tester,
  ) async {
    await pumpEditor(tester);
    // Message is the default (first) tab.
    expect(
      helpIconWith('subject line'),
      findsOneWidget,
      reason: 'The "Send to topic" field must carry publish-topic help',
    );
  });

  testWidgets('Auth tab: username/password carry sign-in help', (tester) async {
    await pumpEditor(tester);
    await tester.tap(find.text('Auth'));
    await tester.pumpAndSettle();
    expect(infoTextOf(tester, 'Username'), contains('sign-in name'));
    expect(infoTextOf(tester, 'Password'), contains('sign-in password'));
  });

  testWidgets(
    'tapping a help icon surfaces its overlay and does NOT alter the control '
    'it explains (gesture is not swallowed)',
    (tester) async {
      final (container, id) = await pumpEditor(tester);
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      final qosBefore = mqttOf(container, id).qos;
      final iconFinder = helpIconWith('deliver a message');
      final message = tester.widget<MqttHelpIcon>(iconFinder).message;
      // The help copy is not painted anywhere until the overlay is shown.
      expect(find.text(message), findsNothing);

      await tester.tap(iconFinder);
      await tester.pump(); // insert + start the tooltip overlay
      await tester.pump(const Duration(milliseconds: 200));

      // Overlay is visible (touch surfaces the help via tap) ...
      expect(find.text(message), findsOneWidget);
      // ... and the dropdown it sits beside did not change.
      expect(mqttOf(container, id).qos, qosBefore);

      // Let the tooltip's auto-dismiss timer elapse so none is left pending.
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
    },
  );
}
