import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/settings_providers.dart';
import '../../home_page/editor_pane/details_card/response_pane.dart';
import '../../home_page/editor_pane/editor_request.dart';
import '../../home_page/editor_pane/url_card.dart';

class RequestTabs extends ConsumerWidget {
  const RequestTabs({super.key, required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;

    return Column(
      children: [
        SizedBox(height: 5 * scaleFactor), // Scale vertical spacing
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4 * scaleFactor), // Scale padding
          child: const EditorPaneRequestURLCard(),
        ),
        SizedBox(height: 10 * scaleFactor), // Scale vertical spacing
        SegmentedTabbar(
          controller: controller,
          tabs: [
            Tab(text: kLabelRequest),
            Tab(text: kLabelResponse),
            Tab(text: kLabelCode),
          ].map((tab) => Tab(text: tab.text)).toList(),
        ),
        Expanded(child: RequestTabviews(controller: controller, scaleFactor: scaleFactor))
      ],
    );
  }
}

class RequestTabviews extends StatelessWidget {
  const RequestTabviews({super.key, required this.controller, required this.scaleFactor});
  final TabController controller;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: [
        RequestEditor(),
        Padding(
          padding: EdgeInsets.only(top: 8 * scaleFactor), // Scale padding
          child: ResponsePane(),
        ),
        CodePane(),
      ],
    );
  }
}
