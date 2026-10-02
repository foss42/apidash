import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/home_page/editor_pane/details_card/request_pane/mqtt/mqtt_request_topics.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../providers/helpers.dart';

/// Tests for the per-topic QoS selector rendered by [EditMQTTTopics]:
///
/// Each subscribed topic ([NameValueModel] in `mqttModel.subscribedTopics`)
/// stores its QoS in `.value` (int 0/1/2). An empty/absent `.value` falls back
/// to the model's Default QoS (`mqttModel.qos`). Each real topic row renders an
/// `ADDropdownButton<int>` ("QoS 0/1/2"); the trailing placeholder add-row does
/// not. Changing a row's dropdown writes the new QoS into
/// `subscribedTopics[i].value`.
///
/// Uses the REAL CollectionStateNotifier (no mocks) + in-memory Hive, same
/// harness as mqtt_topic_filter_test.dart / mqtt_per_request_settings_test.dart.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await testSetUpTempDirForHive();
  });

  /// Pumps [EditMQTTTopics] for a freshly-seeded MQTT request whose
  /// mqttRequestModel has Default QoS 0 and two topics:
  ///   - sensors/a with a stored per-topic QoS of 1
  ///   - sensors/b with an empty QoS (must fall back to Default QoS 0)
  /// Returns the container + the selected request id.
  Future<(ProviderContainer, String)> pumpTopics(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // The QoS dropdown lives in a 76px fixed DataColumn2. Under the widget-test
    // font every glyph is 1em wide, so "QoS N" measures wider than in the real
    // app and DropdownButton's Row reports a harmless horizontal overflow. That
    // layout artifact is not what these tests exercise, so swallow only it and
    // let every other error through.
    final bindingOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('A RenderFlex overflowed')) {
        return;
      }
      bindingOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = bindingOnError);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Portal(
            child: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final selectedId = ref.watch(selectedIdStateProvider);
                  if (selectedId == null) return const SizedBox.shrink();
                  return EditMQTTTopics(key: ValueKey(selectedId));
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
        brokerUrl: 'test.mosquitto.org',
        qos: 0, // Default QoS
        subscribedTopics: [
          NameValueModel(name: 'sensors/a', value: 1), // stored per-topic QoS
          NameValueModel(name: 'sensors/b', value: ''), // empty -> fallback
        ],
        isTopicEnabledList: [true, true],
      ),
    );
    await tester.pumpAndSettle();
    return (container, id);
  }

  MQTTRequestModel mqttOf(ProviderContainer container, String id) => container
      .read(collectionStateNotifierProvider.notifier)
      .getRequestModel(id)!
      .mqttRequestModel!;

  List<ADDropdownButton<int>> qosDropdowns(WidgetTester tester) => tester
      .widgetList<ADDropdownButton<int>>(find.byType(ADDropdownButton<int>))
      .toList();

  testWidgets(
    'renders one QoS dropdown per real topic row (not the placeholder), '
    'each showing its effective QoS',
    (tester) async {
      final (container, _) = await pumpTopics(tester);

      // (a) Exactly two dropdowns: one for sensors/a and one for sensors/b.
      //     The trailing add-row renders SizedBox.shrink() in the QoS cell.
      expect(
        find.byType(ADDropdownButton<int>),
        findsNWidgets(2),
        reason: 'One QoS dropdown per real topic; none for the placeholder row',
      );

      // (b) Effective QoS per row: dropdowns are in row order.
      final dropdowns = qosDropdowns(tester);
      expect(
        dropdowns[0].value,
        1,
        reason: "sensors/a must show its stored per-topic QoS (1)",
      );
      expect(
        dropdowns[1].value,
        0,
        reason: "sensors/b has an empty value -> fall back to Default QoS (0)",
      );

      // The visible selected labels back this up.
      expect(find.text('QoS 1'), findsWidgets);
      expect(find.text('QoS 0'), findsWidgets);

      // Sanity: nothing has mutated the seeded model yet.
      final m = mqttOf(container, container.read(selectedIdStateProvider)!);
      expect(m.subscribedTopics[0].value, 1);
      expect(m.subscribedTopics[1].value, '');
    },
  );

  testWidgets(
    "changing sensors/b's dropdown to QoS 2 writes value 2 into the model",
    (tester) async {
      final (container, id) = await pumpTopics(tester);

      // Open the second (sensors/b) dropdown and pick "QoS 2".
      await tester.tap(find.byType(ADDropdownButton<int>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('QoS 2').last);
      await tester.pumpAndSettle();

      // The model's second topic now carries the chosen int QoS.
      final m = mqttOf(container, id);
      expect(m.subscribedTopics.length, 2);
      expect(m.subscribedTopics[1].name, 'sensors/b');
      expect(
        m.subscribedTopics[1].value,
        2,
        reason: "picking QoS 2 must persist subscribedTopics[1].value == 2",
      );
      // sensors/a is untouched.
      expect(m.subscribedTopics[0].value, 1);

      // The dropdown reflects the new selection.
      expect(qosDropdowns(tester)[1].value, 2);
    },
  );
}
