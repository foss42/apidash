import 'package:apidash/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inner_drawer/inner_drawer.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'navbar.dart';
import 'widgets/left_drawer.dart';
import 'requests_page.dart';
import 'response_drawer.dart';
import '../home_page/collection_pane.dart';

class MobileDashboard extends ConsumerStatefulWidget {
  const MobileDashboard({super.key});

  @override
  ConsumerState<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends ConsumerState<MobileDashboard> {
  late Color backgroundColor;
  bool isLeftDrawerOpen = false;
  ValueNotifier<double> dragPosition = ValueNotifier(0);
  ValueNotifier<InnerDrawerDirection?> drawerDirection =
      ValueNotifier(InnerDrawerDirection.start);

  Color calculateBackgroundColor(double dragPosition) {
    Color start = Theme.of(context).colorScheme.surface;
    Color end = Theme.of(context).colorScheme.onInverseSurface;
    return dragPosition == 0 ? start : end;
  }

  @override
  void dispose() {
    super.dispose();
    dragPosition.dispose();
    drawerDirection.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final GlobalKey<InnerDrawerState> innerDrawerKey =
        ref.watch(mobileDrawerKeyProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        opacity: 0,
        noAppBar: true,
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          InnerDrawer(
            key: innerDrawerKey,
            swipe: true,
            swipeChild: true,
            onTapClose: true,
            offset: !context.isCompactWindow
                ? const IDOffset.only(left: 0.1, right: 1)
                : const IDOffset.only(left: 0.7, right: 1),
            boxShadow: [
              BoxShadow(
                offset: const Offset(1, 0),
                color: Theme.of(context).colorScheme.onInverseSurface,
                blurRadius: 0,
              ),
            ],
            colorTransitionChild: Colors.transparent,
            colorTransitionScaffold: Colors.transparent,
            rightAnimationType: InnerDrawerAnimation.linear,
            backgroundDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface),
            onDragUpdate: (value, direction) {
              drawerDirection.value = direction;
              if (value > 0.98 && direction == InnerDrawerDirection.start) {
                dragPosition.value = 1;
              } else {
                dragPosition.value = 0;
              }
            },
            innerDrawerCallback: (isOpened) {
              if (drawerDirection.value == InnerDrawerDirection.start) {
                setState(() {
                  isLeftDrawerOpen = isOpened;
                });
              }
            },
            leftChild: const LeftDrawer(
              drawerContent: CollectionPane(),
            ),
            rightChild: const ResponseDrawer(),
            scaffold: ValueListenableBuilder<double>(
              valueListenable: dragPosition,
              builder: (context, value, child) {
                return Container(
                  color: calculateBackgroundColor(value),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(8)),
                child: SafeArea(
                  minimum: kIsWindows || kIsMacOS ? kPt28 : EdgeInsets.zero,
                  bottom: false,
                  child: RequestsPage(
                    innerDrawerKey: innerDrawerKey,
                  ),
                ),
              ),
            ),
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
