import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../../home_page/editor_pane/details_card/response_pane.dart';
import '../../home_page/editor_pane/editor_request.dart';
import '../../home_page/editor_pane/url_card.dart';

class RequestResponseTabs extends StatelessWidget {
  const RequestResponseTabs({super.key, required this.controller});
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
        RequestResponseTabbar(
          controller: controller,
        ),
        Expanded(
            child: RequestResponseTabviews(
          controller: controller,
        ))
      ],
    );
  }
}

class RequestResponseTabviews extends StatelessWidget {
  const RequestResponseTabviews({super.key, required this.controller});
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
      ],
    );
  }
}
