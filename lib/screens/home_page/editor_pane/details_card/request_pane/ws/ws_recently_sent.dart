import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/providers.dart';

/// "Recently Sent" strip below the message composer. Extracted into its own
/// widget so the `messageHistory` watch (which changes on every incoming WS
/// frame) lives here instead of in the composer — keeping the composer from
/// rebuilding (and reseeding `TextFieldEditor`) while the user is typing.
class WsRecentlySent extends ConsumerWidget {
  final List<Map<String, String>> templates;
  final void Function(String payload) onReuse;
  final void Function(String name, String payload) onSaveTemplate;

  const WsRecentlySent({
    super.key,
    required this.templates,
    required this.onReuse,
    required this.onSaveTemplate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Narrow watch: only the message history. Its list identity is preserved
    // by copyWith on URL edits, so typing in the URL field does not rebuild
    // this widget.
    final messageHistory = ref.watch(selectedRequestModelProvider
            .select((value) => value?.wsRequestModel?.messageHistory)) ??
        const <WebSocketMessage>[];

    final sentHistory = messageHistory
        .where(
          (m) =>
              m.outgoing &&
              !m.isAutomatic &&
              m.messageType == WebSocketMessageType.sent,
        )
        .map((m) => m.payload)
        .toList()
        .reversed
        .take(10)
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Recently Sent", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        kVSpacer5,
        if (sentHistory.isEmpty)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("No recently sent messages", style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic)),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sentHistory.length,
              separatorBuilder: (_, __) => kHSpacer10,
              itemBuilder: (context, index) {
                final payload = sentHistory[index];

                Map<String, String>? matchingTemplate;
                try {
                  matchingTemplate = templates.firstWhere((t) => t["data"] == payload);
                } catch (_) {}

                final title = matchingTemplate?["name"];

                return Tooltip(
                  message: payload,
                  waitDuration: const Duration(milliseconds: 600),
                  textStyle: kCodeStyle.copyWith(fontSize: 11),
                  child: Material(
                    type: MaterialType.transparency,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      onReuse(payload);
                    },
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: title != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 2.0),
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : SizedBox(
                                      height: 24,
                                      child: TextField(
                                        style: const TextStyle(fontSize: 12),
                                        decoration: InputDecoration(
                                          hintText: "Name & Enter to save",
                                          hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                                          isDense: true,
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.3),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.3),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 0.5),
                                          ),
                                        ),
                                        onSubmitted: (val) {
                                          onSaveTemplate(val.trim(), payload);
                                        },
                                      ),
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              payload,
                              style: kCodeStyle.copyWith(fontSize: 11, color: Colors.grey),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
