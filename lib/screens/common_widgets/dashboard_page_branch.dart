import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mobile/requests_page/requests_page.dart';
import '../envvar/environment_page.dart';
import '../history/history_page.dart';
import '../settings_page.dart';
import '../mobile/widgets/page_base.dart';
import '../home_page/home_page.dart';

class PageBranch extends ConsumerWidget {
  const PageBranch({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isMediumWindow) {
      switch (pageIndex) {
        case 1:
          return const EnvironmentPage();
        case 2:
          return const HistoryPage();
        case 3:
          return const PageBase(
            title: 'Settings',
            scaffoldBody: SettingsPage(),
          );
        default:
          return const RequestResponsePage();
      }
    } else {
      switch (pageIndex) {
        case 0:
          return const HomePage();
        case 1:
          return const EnvironmentPage();
        case 2:
          return const HistoryPage();
        case 3:
          return const SettingsPage();
        default:
          return const HomePage();
      }

    }
  }
}
