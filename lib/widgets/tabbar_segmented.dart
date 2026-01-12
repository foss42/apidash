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
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate available width and adjust tab width if needed
          final totalWidth = tabWidth * tabs.length;
          final availableWidth = constraints.maxWidth - 8; // Account for margin
          final adjustedTabWidth = totalWidth > availableWidth
              ? availableWidth / tabs.length
              : tabWidth;

          return Container(
            margin: kPh4,
            width: adjustedTabWidth * tabs.length,
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
                tabs: tabs.map((tab) {
                  // Wrap each tab in a flexible container to handle text overflow
                  return SizedBox(
                    width: adjustedTabWidth,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: tab,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
