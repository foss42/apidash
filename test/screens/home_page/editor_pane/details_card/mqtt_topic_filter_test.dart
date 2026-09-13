import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/realtime_event_stream_view.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../providers/helpers.dart';

/// Tests for the MQTT topic filter in [RealtimeEventStreamView]:
///
/// 1. Enter only applies the topic filter when the text is an actual topic
///    seen in the request's message history. A mistyped Enter must not filter
///    everything out; it shows a "No such topic" SnackBar and keeps focus.
/// 2. An empty field shows ALL deduped topics in the dropdown so users can
///    browse and pick a topic instead of typing it; typing narrows the list
///    with substring matching, and selecting an entry applies the filter.
/// 3. While the dropdown is open, Enter selects the HIGHLIGHTED option (the
///    first one by default, or the one reached with arrow keys) — same as
///    tapping it. The validated-Enter path (exact/wildcard match or
///    "No such topic") only fires when no options are visible.
///
/// Uses the REAL CollectionStateNotifier (no mocks), same as
/// ws_url_edit_state_test.dart.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  // 4 messages over 3 deduped topics; every payload contains "msg" so the
  // live payload-substring filter (onChanged) keeps them all visible while
  // "msg" is typed — isolating the Enter/topic behavior under test.
  final messages = [
    WebSocketMessage(
      payload: 'temp msg 1',
      timestamp: DateTime(2026, 1, 1, 10, 0, 0),
      outgoing: false,
      metadata: 'sensors/temp',
    ),
    WebSocketMessage(
      payload: 'humidity msg 2',
      timestamp: DateTime(2026, 1, 1, 10, 0, 1),
      outgoing: false,
      metadata: 'sensors/humidity',
    ),
    WebSocketMessage(
      payload: 'alerts msg 3',
      timestamp: DateTime(2026, 1, 1, 10, 0, 2),
      outgoing: false,
      metadata: 'alerts/fire',
    ),
    WebSocketMessage(
      payload: 'temp msg 4',
      timestamp: DateTime(2026, 1, 1, 10, 0, 3),
      outgoing: false,
      metadata: 'sensors/temp', // duplicate topic — must be deduped
    ),
  ];

  Future<(ProviderContainer, String)> pumpMqttStream(
      WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            // Same keying as _WsResponsePanel in response_pane.dart.
            body: Consumer(
              builder: (context, ref, _) {
                final selectedId = ref.watch(selectedIdStateProvider);
                if (selectedId == null) return const SizedBox.shrink();
                return RealtimeEventStreamView(key: ValueKey(selectedId));
              },
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
      mqttRequestModel: MQTTRequestModel(
        brokerUrl: 'test.mosquitto.org',
        messageHistory: messages,
      ),
    );
    await tester.pumpAndSettle();
    return (container, id);
  }

  Finder filterField() => find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            w.decoration?.hintText == 'Select a topic to filter...',
      );

  testWidgets('Enter with non-topic text does NOT filter and shows feedback',
      (tester) async {
    await pumpMqttStream(tester);

    final field = filterField();
    expect(field, findsOneWidget);

    // "msg" is a payload substring of every message but NOT a topic.
    await tester.enterText(field, 'msg');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Feedback shown, no topic filter applied, nothing filtered out.
    expect(find.text('No such topic'), findsOneWidget,
        reason: 'Mistyped Enter must show the "No such topic" SnackBar');
    expect(find.byType(InputChip), findsNothing,
        reason: 'Non-topic text must not become a topic filter chip');
    expect(find.text('temp msg 1'), findsOneWidget);
    expect(find.text('humidity msg 2'), findsOneWidget);
    expect(find.text('alerts msg 3'), findsOneWidget);
    expect(find.text('temp msg 4'), findsOneWidget);

    // Text is kept and the field stays focused so the user can correct it.
    final tf = tester.widget<TextField>(field);
    expect(tf.controller?.text, 'msg',
        reason: 'Field text must be kept on a rejected Enter');
    expect(tf.focusNode?.hasFocus, isTrue,
        reason: 'Field must keep focus on a rejected Enter');
  });

  testWidgets('Enter with an exact topic applies the filter', (tester) async {
    await pumpMqttStream(tester);

    final field = filterField();
    await tester.enterText(field, 'sensors/temp');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Chip added, field cleared, only sensors/temp messages remain.
    expect(find.widgetWithText(InputChip, 'sensors/temp'), findsOneWidget);
    expect(tester.widget<TextField>(field).controller?.text, isEmpty);
    expect(find.text('temp msg 1'), findsOneWidget);
    expect(find.text('temp msg 4'), findsOneWidget);
    expect(find.text('humidity msg 2'), findsNothing);
    expect(find.text('alerts msg 3'), findsNothing);
    expect(find.text('No such topic'), findsNothing);
  });

  testWidgets(
      'empty field shows ALL deduped topics in the dropdown and narrows while typing',
      (tester) async {
    await pumpMqttStream(tester);

    // Tap the empty field: the dropdown must list every deduped topic.
    await tester.tap(filterField());
    await tester.pumpAndSettle();
    expect(find.text('sensors/temp'), findsOneWidget,
        reason: 'Duplicate topics must appear only once in the dropdown');
    expect(find.text('sensors/humidity'), findsOneWidget);
    expect(find.text('alerts/fire'), findsOneWidget);

    // Typing narrows the options with substring matching.
    await tester.enterText(filterField(), 'sensors');
    await tester.pumpAndSettle();
    expect(find.text('sensors/temp'), findsOneWidget);
    expect(find.text('sensors/humidity'), findsOneWidget);
    expect(find.text('alerts/fire'), findsNothing,
        reason: 'Non-matching topics must be filtered out of the dropdown');
  });

  testWidgets('selecting a dropdown entry applies the topic filter',
      (tester) async {
    await pumpMqttStream(tester);

    // Open the dropdown from the empty field and pick a topic.
    await tester.tap(filterField());
    await tester.pumpAndSettle();
    await tester.tap(find.text('sensors/humidity'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(InputChip, 'sensors/humidity'), findsOneWidget,
        reason: 'Selecting a dropdown entry must add the topic filter chip');
    expect(find.text('humidity msg 2'), findsOneWidget);
    expect(find.text('temp msg 1'), findsNothing);
    expect(find.text('temp msg 4'), findsNothing);
    expect(find.text('alerts msg 3'), findsNothing);
    // The field is cleared after selection, ready for the next pick.
    expect(tester.widget<TextField>(filterField()).controller?.text, isEmpty);
  });

  testWidgets(
      'Enter with the dropdown open selects the highlighted (first) option',
      (tester) async {
    await pumpMqttStream(tester);

    // "humid" is NOT a topic (the old validation path would reject it), but
    // it narrows the dropdown to exactly one option: sensors/humidity.
    await tester.enterText(filterField(), 'humid');
    await tester.pumpAndSettle();
    expect(find.text('sensors/humidity'), findsOneWidget,
        reason: 'The dropdown must be open with the narrowed option');

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Enter picked the highlighted option — same as tapping it.
    expect(find.widgetWithText(InputChip, 'sensors/humidity'), findsOneWidget,
        reason: 'Enter must select the highlighted dropdown option');
    expect(find.text('No such topic'), findsNothing,
        reason: 'The validation path must not fire while options are shown');
    expect(tester.widget<TextField>(filterField()).controller?.text, isEmpty,
        reason: 'The field is cleared after selection, ready for more picks');
    expect(find.text('humidity msg 2'), findsOneWidget);
    expect(find.text('temp msg 1'), findsNothing);
    expect(find.text('temp msg 4'), findsNothing);
    expect(find.text('alerts msg 3'), findsNothing);
  });

  testWidgets('arrow-down moves the highlight and Enter picks that option',
      (tester) async {
    await pumpMqttStream(tester);

    // Open the dropdown from the empty field: all 3 topics, first highlighted.
    await tester.tap(filterField());
    await tester.pumpAndSettle();
    expect(find.text('sensors/temp'), findsOneWidget);
    expect(find.text('sensors/humidity'), findsOneWidget);

    // Arrow-down: highlight moves from sensors/temp to sensors/humidity.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(InputChip, 'sensors/humidity'), findsOneWidget,
        reason: 'Enter must pick the arrow-key-highlighted option, not the first');
    expect(find.widgetWithText(InputChip, 'sensors/temp'), findsNothing);
    expect(find.text('humidity msg 2'), findsOneWidget);
    expect(find.text('temp msg 1'), findsNothing);
    expect(find.text('temp msg 4'), findsNothing);
    expect(find.text('alerts msg 3'), findsNothing);
  });

  testWidgets(
      'wildcard Enter still works via the validation path when no options match',
      (tester) async {
    await pumpMqttStream(tester);

    // "sensors/+" is not a substring of any topic, so the dropdown is empty
    // and hidden — Enter must fall through to the validated (wildcard) path.
    await tester.enterText(filterField(), 'sensors/+');
    await tester.pumpAndSettle();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(InputChip, 'sensors/+'), findsOneWidget,
        reason: 'A wildcard matching known topics must be accepted on Enter');
    expect(find.text('No such topic'), findsNothing);
    expect(find.text('temp msg 1'), findsOneWidget);
    expect(find.text('humidity msg 2'), findsOneWidget);
    expect(find.text('temp msg 4'), findsOneWidget);
    expect(find.text('alerts msg 3'), findsNothing,
        reason: 'sensors/+ must not match alerts/fire');
  });
}
