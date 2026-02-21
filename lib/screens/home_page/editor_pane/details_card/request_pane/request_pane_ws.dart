import 'package:apidash/providers/providers.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common_widgets/common_widgets.dart';
import 'request_headers.dart';
import 'request_params.dart';

/// The request-side pane when APIType is [APIType.websocket].
///
/// Layout (from the approved sketch):
///   Tabs: Message | URL Params | Headers
///   Bottom: [message textarea] + [Send >] button
class EditWSRequestPane extends ConsumerStatefulWidget {
  const EditWSRequestPane({super.key});

  @override
  ConsumerState<EditWSRequestPane> createState() => _EditWSRequestPaneState();
}

class _EditWSRequestPaneState extends ConsumerState<EditWSRequestPane>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return kSizedBoxEmpty;

    final wsState = ref.watch(wsStateProvider(selectedId));

    return Column(
      children: [
        kVSpacer10,
        // Tab bar
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Message'),
            Tab(text: 'URL Params'),
            Tab(text: 'Headers'),
          ],
        ),
        kVSpacer8,
        // Tab content — grows to fill available space
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // ------- MESSAGE TAB -------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: wsState.messageInput)
                          ..selection = TextSelection.collapsed(
                              offset: wsState.messageInput.length),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Enter a message to send…',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(12),
                        ),
                        onChanged: (v) => ref
                            .read(wsStateProvider(selectedId).notifier)
                            .updateMessageInput(v),
                      ),
                    ),
                    kVSpacer8,
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: wsState.canSend
                            ? () =>
                                ref
                                    .read(wsStateProvider(selectedId).notifier)
                                    .send()
                            : null,
                        icon: const Icon(Icons.send, size: 16),
                        label: const Text('Send'),
                      ),
                    ),
                    kVSpacer8,
                  ],
                ),
              ),
              // ------- URL PARAMS TAB -------
              EditRequestURLParams(),
              // ------- HEADERS TAB -------
              EditRequestHeaders(),

            ],
          ),
        ),
      ],
    );
  }
}
