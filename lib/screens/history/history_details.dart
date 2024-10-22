import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'history_widgets/history_widgets.dart';

class HistoryDetails extends StatefulHookConsumerWidget {
  const HistoryDetails({super.key});

  @override
  ConsumerState<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends ConsumerState<HistoryDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ref.watch(historySequenceProvider);
    final selectedHistoryRequest =
        ref.watch(selectedHistoryRequestModelProvider);
    final codePaneVisible = ref.watch(historyCodePaneVisibleStateProvider);
    final TabController controller =
        useTabController(initialLength: 3, vsync: this);

    return selectedHistoryRequest != null
        ? LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < kMediumWindowWidth;
              return Column(
                children: [
                  kVSpacer5,
                  Padding(
                      padding: kPh4,
                      child: HistoryURLCard(
                        historyRequestModel: selectedHistoryRequest,
                      )),
                  kVSpacer10,
                  if (isCompact) ...[
                    SegmentedTabbar(
                      controller: controller,
                      tabs: const [
                        Tab(text: kLabelRequest),
                        Tab(text: kLabelResponse),
                        Tab(text: kLabelCode),
                      ],
                    ),
                    kVSpacer10,
                    Expanded(
                      child: TabBarView(
                        controller: controller,
                        children: [
                          HistoryRequestPane(
                            isCompact: isCompact,
                          ),
                          const HistoryResponsePane(),
                          const CodePane(
                            isHistoryRequest: true,
                          ),
                        ],
                      ),
                    ),
                    const HistoryPageBottombar()
                  ] else ...[
                    Expanded(
                      child: Padding(
                        padding: kPh4,
                        child: RequestDetailsCard(
                          child: EqualSplitView(
                            leftWidget:
                                HistoryRequestPane(isCompact: isCompact),
                            rightWidget: codePaneVisible
                                ? const CodePane(isHistoryRequest: true)
                                : const HistoryResponsePane(),
                          ),
                        ),
                      ),
                    ),
                    kVSpacer8,
                  ]
                ],
              );
            },
          )
        : const SizedBox.shrink();
  }
}
