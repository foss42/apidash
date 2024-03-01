import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inner_drawer/inner_drawer.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'bottom_navbar.dart';
import 'left_drawer.dart';
import 'requestspage/requests_page.dart';
import 'requestspage/response_drawer.dart';
import '../home_page/collection_pane.dart';

class MobileDashboard extends ConsumerStatefulWidget {
  const MobileDashboard(
      {required this.scaffoldBody, required this.title, super.key});

  final Widget scaffoldBody;
  final String title;

  @override
  ConsumerState<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends ConsumerState<MobileDashboard> {
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
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
  void didChangeDependencies() {
    backgroundColor = Theme.of(context).colorScheme.surface;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
            key: _innerDrawerKey,
            swipe: true,
            swipeChild: true,
            onTapClose: true,
            offset: const IDOffset.only(left: 0.7, right: 1),
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
            backgroundDecoration:
                BoxDecoration(color: Theme.of(context).colorScheme.surface),
            onDragUpdate: (value, direction) {
              drawerDirection.value = direction;
              if (value > 0.98) {
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
                    const BorderRadius.vertical(top: Radius.circular(8)),
                child: SafeArea(
                  bottom: false,
                  child: RequestsPage(
                    innerDrawerKey: _innerDrawerKey,
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            bottom: isLeftDrawerOpen
                ? 0
                : -(72 + MediaQuery.of(context).padding.bottom),
            left: 0,
            right: 0,
            height: 70 + MediaQuery.of(context).padding.bottom,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: const BottomNavBar(),
          ),
        ],
      ),
    );
  }
}
