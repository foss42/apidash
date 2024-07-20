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
    final selectedHistoryRequest =
        ref.watch(selectedHistoryRequestModelProvider);
    final metaData = selectedHistoryRequest?.metaData;

    final codePaneVisible = ref.watch(historyCodePaneVisibleStateProvider);

    final TabController controller =
        useTabController(initialLength: 2, vsync: this);

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
                        method: metaData!.method,
                        url: metaData.url,
                      )),
                  kVSpacer10,
                  if (isCompact) ...[
                    RequestResponseTabbar(
                      controller: controller,
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
                      ],
                    ))
                  ] else ...[
                    Expanded(
                      child: Padding(
                        padding: kPh4,
                        child: RequestDetailsCard(
                          child: EqualSplitView(
                            leftWidget: HistoryRequestPane(
                              isCompact: isCompact,
                            ),
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
