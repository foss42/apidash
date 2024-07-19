import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import './details_pane/url_card.dart';

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

    final TabController controller =
        useTabController(initialLength: 2, vsync: this);

    return selectedHistoryRequest != null
        ? Column(
            children: [
              Padding(
                  padding: kP4,
                  child: HistoryURLCard(
                      method: metaData!.method, url: metaData.url)),
              kVSpacer10,
              RequestResponseTabbar(
                controller: controller,
              ),
            ],
          )
        : const Text("No Request Selected");
  }
}
