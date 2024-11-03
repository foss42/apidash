import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class SegmentedTabbar extends StatelessWidget {
  const SegmentedTabbar({
    super.key,
    required this.controller,
    required this.tabs,
    this.tabWidth = kSegmentedTabWidth,
    this.tabHeight = kSegmentedTabHeight,
  });

  final TabController controller;
  final List<Widget> tabs;
  final double tabWidth;
  final double tabHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: kPh4,
        width: tabWidth * tabs.length,
        height: tabHeight,
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
            tabs: tabs,
          ),
        ),
      ),
    );
  }
}
