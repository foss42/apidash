import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/models/models.dart';

/// MQTT protocol-version selector shown inline in the URL card, in the slot
/// otherwise used by the HTTP method dropdown. One click switches the whole
/// request between MQTT 3.1.1 and MQTT 5.0 (which gates the v5-only fields in
/// the request pane via progressive disclosure).
class DropdownButtonMQTTVersion extends ConsumerWidget {
  const DropdownButtonMQTTVersion({super.key});

  static const _options = <MQTTVersion, String>{
    MQTTVersion.v3_1_1: 'MQTT 3.1.1',
    MQTTVersion.v5: 'MQTT 5.0',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.mqttRequestModel?.version,
      ),
    );
    // The model also allows a legacy `v3`; collapse it onto `v3_1_1` for the
    // selector (we only surface the two first-class choices to the user).
    final effective =
        version == MQTTVersion.v5 ? MQTTVersion.v5 : MQTTVersion.v3_1_1;
    // Use the same design-system dropdown as the HTTP method (GET/POST) selector
    // so it looks identical and sits in the same URL-card slot.
    return ADDropdownButton<MQTTVersion>(
      value: effective,
      values: _options.entries.map((e) => (e.key, e.value)),
      dropdownMenuItemPadding: EdgeInsets.only(
        left: context.isMediumWindow ? 8 : 16,
      ),
      onChanged: (value) {
        if (value == null) return;
        final mqttModel =
            ref.read(selectedRequestModelProvider)?.mqttRequestModel;
        if (mqttModel == null) return;
        ref.read(collectionStateNotifierProvider.notifier).update(
              mqttRequestModel: mqttModel.copyWith(version: value),
            );
      },
    );
  }
}
