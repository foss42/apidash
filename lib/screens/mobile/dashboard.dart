import 'package:apidash/screens/envvar/environments_pane.dart';
import 'package:apidash/widgets/splitviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inner_drawer/inner_drawer.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import '../intro_page.dart';
import '../settings_page.dart';
import 'navbar.dart';
import 'requests_page.dart';
import 'response_drawer.dart';
import '../home_page/collection_pane.dart';
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
    final GlobalKey<InnerDrawerState> innerDrawerKey =
        ref.watch(mobileDrawerKeyProvider);
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
            innerDrawerKey: innerDrawerKey,
          ),
          if (context.isCompactWindow)
            AnimatedPositioned(
              bottom: isLeftDrawerOpen
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

class PageBranch extends StatelessWidget {
  const PageBranch({
    super.key,
    required this.pageIndex,
    required this.innerDrawerKey,
  });

  final int pageIndex;
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  @override
  Widget build(BuildContext context) {
    switch (pageIndex) {
      case 1:
        return TwoDrawerSplitView(
          key: const ValueKey('env'),
          innerDrawerKey: innerDrawerKey,
          offset: !context.isCompactWindow
              ? const IDOffset.only(left: 0.1)
              : const IDOffset.only(left: 0.7),
          leftDrawerContent: const EnvironmentsPane(),
          mainContent: const SizedBox(),
        );
      case 2:
        return const PageBase(
          title: 'About',
          scaffoldBody: IntroPage(),
        );
      case 3:
        return const PageBase(
          title: 'Settings',
          scaffoldBody: SettingsPage(),
        );
      default:
        return TwoDrawerSplitView(
          key: const ValueKey('home'),
          innerDrawerKey: innerDrawerKey,
          offset: !context.isCompactWindow
              ? const IDOffset.only(left: 0.1, right: 1)
              : const IDOffset.only(left: 0.7, right: 1),
          leftDrawerContent: const CollectionPane(),
          rightDrawerContent: const ResponseDrawer(),
          mainContent: RequestsPage(
            innerDrawerKey: innerDrawerKey,
          ),
        );
    }
  }
}
