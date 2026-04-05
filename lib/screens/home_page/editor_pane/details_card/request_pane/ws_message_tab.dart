import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

/// Message compose tab for WebSocket requests.
///
/// Mirrors [MqttMessageTab] — JSON/Text content-type toggle at the top,
/// reusable [JsonTextFieldEditor] or [TextFieldEditor] as the body editor.
class WsMessageTab extends ConsumerWidget {
  const WsMessageTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final contentType = ref.watch(wsMessageContentTypeProvider(selectedId));
    final darkMode = ref.watch(settingsProvider.select(
      (value) => value.isDark,
    ));

    return Column(
      children: [
        // Content-type selector row — mirrors MqttMessageTab
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Content Type:"),
              kHSpacer10,
              ADPopupMenu<ContentType>(
                tooltip: "Select Content Type",
                width: 120,
                value: contentType == ContentType.json ? "JSON" : "Text",
                values: const [
                  (ContentType.json, "JSON"),
                  (ContentType.text, "Text"),
                ],
                onChanged: (ContentType? value) {
                  if (value != null) {
                    ref
                        .read(
                          wsMessageContentTypeProvider(selectedId).notifier,
                        )
                        .state = value;
                  }
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
        // Body editor
        Expanded(
          child: Padding(
            padding: kPt5o10,
            child: contentType == ContentType.json
                ? JsonTextFieldEditor(
                    key: Key("$selectedId-ws-json-body"),
                    fieldKey: "$selectedId-ws-json-body-editor-$darkMode",
                    isDark: darkMode,
                    initialValue: ref.read(
                      wsStateProvider(selectedId).select((s) => s.messageInput),
                    ),
                    onChanged: (String value) {
                      ref
                          .read(wsStateProvider(selectedId).notifier)
                          .updateMessageInput(value);
                    },
                    hintText: kHintWsMessage,
                  )
                : TextFieldEditor(
                    key: Key("$selectedId-ws-body"),
                    fieldKey: "$selectedId-ws-body-editor",
                    initialValue: ref.read(
                      wsStateProvider(selectedId).select((s) => s.messageInput),
                    ),
                    onChanged: (String value) {
                      ref
                          .read(wsStateProvider(selectedId).notifier)
                          .updateMessageInput(value);
                    },
                    hintText: kHintWsMessage,
                  ),
          ),
        ),
      ],
    );
  }
}
