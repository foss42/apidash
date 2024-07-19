import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

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
