import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../../home_page/editor_pane/details_card/response_pane.dart';
import '../../home_page/editor_pane/editor_request.dart';
import '../../home_page/editor_pane/url_card.dart';

class RequestTabs extends StatelessWidget {
  const RequestTabs({super.key, required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kVSpacer5,
        const Padding(
          padding: kPh4,
          child: EditorPaneRequestURLCard(),
        ),
        kVSpacer10,
        SegmentedTabbar(
          controller: controller,
          tabs: const [
            Tab(text: kLabelRequest),
            Tab(text: kLabelResponse),
            Tab(text: kLabelCode),
          ],
        ),
        Expanded(child: RequestTabviews(controller: controller))
      ],
    );
  }
}

class RequestTabviews extends StatelessWidget {
  const RequestTabviews({super.key, required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: const [
        RequestEditor(),
        Padding(
          padding: kPt8,
          child: ResponsePane(),
        ),
        CodePane(),
      ],
    );
  }
}
