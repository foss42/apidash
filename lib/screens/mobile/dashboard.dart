import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import '../settings_page.dart';
import 'navbar.dart';
import 'requests_page/requests_page.dart';
import '../envvar/environment_page.dart';
import 'widgets/page_base.dart';

class MobileDashboard extends ConsumerStatefulWidget {
  const MobileDashboard({super.key});

  @override
  ConsumerState<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends ConsumerState<MobileDashboard> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final railIdx = ref.watch(navRailIndexStateProvider);
    final isLeftDrawerOpen = ref.watch(leftDrawerStateProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        opacity: 0,
        noAppBar: true,
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          PageBranch(
            pageIndex: railIdx,
          ),
          if (context.isMediumWindow)
            AnimatedPositioned(
              bottom: railIdx > 1
                  ? 0
                  : isLeftDrawerOpen
                      ? 0
                      : -(72 + MediaQuery.paddingOf(context).bottom),
              left: 0,
              right: 0,
              height: 70 + MediaQuery.paddingOf(context).bottom,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: const BottomNavBar(),
            ),
        ],
      ),
    );
  }
}

class PageBranch extends ConsumerWidget {
  const PageBranch({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = ref.watch(mobileScaffoldKeyStateProvider);
    switch (pageIndex) {
      case 1:
        return EnvironmentPage(
          scaffoldKey: scaffoldKey,
        );
      // case 2:
      //   // TODO: Implement history page
      //   return const PageBase(
      //     title: 'History',
      //     scaffoldBody: SizedBox(),
      //   );
      case 2:
        return const PageBase(
          title: 'Settings',
          scaffoldBody: SettingsPage(),
        );
      default:
        return RequestResponsePage(
          scaffoldKey: scaffoldKey,
        );
    }
  }
}
