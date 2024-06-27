import 'package:flutter/material.dart';
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

class RequestResponseTabbar extends StatelessWidget {
  const RequestResponseTabbar({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: kReqResTabWidth,
        height: kReqResTabHeight,
        decoration: BoxDecoration(
          borderRadius: kBorderRadius20,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ClipRRect(
          borderRadius: kBorderRadius20,
          child: TabBar(
            dividerColor: Colors.transparent,
            indicatorWeight: 0.0,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            labelStyle: kTextStyleTab.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            unselectedLabelStyle: kTextStyleTab,
            splashBorderRadius: kBorderRadius20,
            indicator: BoxDecoration(
              borderRadius: kBorderRadius20,
              color: Theme.of(context).colorScheme.primary,
            ),
            controller: controller,
            tabs: const <Widget>[
              Tab(
                text: kLabelRequest,
              ),
              Tab(
                text: kLabelResponse,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequestResponseTabviews extends StatelessWidget {
  const RequestResponseTabviews({super.key, required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBarView(controller: controller, children: const [
      RequestEditor(),
      Padding(
        padding: kPt8,
        child: ResponsePane(),
      ),
    ]);
  }
}
