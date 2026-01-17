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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the ideal width for all tabs
        final idealWidth = tabWidth * tabs.length;

        // Account for padding and margins (8px on each side = 16px total)
        final availableWidth = constraints.maxWidth - 16;

        // Determine if we need scrolling
        final needsScrolling = idealWidth > availableWidth;

        // Use ideal width if scrolling, otherwise fit to available width
        final containerWidth = needsScrolling ? idealWidth : availableWidth;

        return Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: needsScrolling
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Container(
              margin: kPh4,
              width: containerWidth,
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
                  unselectedLabelColor: Theme.of(context).colorScheme.outline,
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
          ),
        );
      },
    );
  }
}
