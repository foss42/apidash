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
        width: 280,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
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
            splashBorderRadius: BorderRadius.circular(50),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).colorScheme.primary,
            ),
            controller: controller,
            tabs: const <Widget>[
              Tab(
                text: "Request",
              ),
              Tab(
                text: "Response",
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
