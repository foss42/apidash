import 'package:apidash/screens/mobile/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inner_drawer/inner_drawer.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/providers/ui_providers.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DashboardSplitView extends StatefulWidget {
  const DashboardSplitView({
    super.key,
    required this.sidebarWidget,
    required this.mainWidget,
  });

  final Widget sidebarWidget;
  final Widget mainWidget;

  @override
  DashboardSplitViewState createState() => DashboardSplitViewState();
}

class DashboardSplitViewState extends State<DashboardSplitView> {
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(size: 250, minimalSize: 200),
      Area(minimalWeight: 0.7),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceVariant,
          highlightedColor: Theme.of(context).colorScheme.outline.withOpacity(
                kHintOpacity,
              ),
          animationEnabled: false,
        ),
      ),
      child: MultiSplitView(
        controller: _controller,
        children: [
          widget.sidebarWidget,
          widget.mainWidget,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class EqualSplitView extends StatefulWidget {
  const EqualSplitView({
    super.key,
    required this.leftWidget,
    required this.rightWidget,
  });

  final Widget leftWidget;
  final Widget rightWidget;

  @override
  State<EqualSplitView> createState() => _EqualSplitViewState();
}

class _EqualSplitViewState extends State<EqualSplitView> {
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(minimalSize: kMinRequestEditorDetailsCardPaneSize),
      Area(minimalSize: kMinRequestEditorDetailsCardPaneSize),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiSplitViewTheme(
      data: MultiSplitViewThemeData(
        dividerThickness: 3,
        dividerPainter: DividerPainters.background(
          color: Theme.of(context).colorScheme.surfaceVariant,
          highlightedColor: Theme.of(context).colorScheme.outline.withOpacity(
                kHintOpacity,
              ),
          animationEnabled: false,
        ),
      ),
      child: MultiSplitView(
        controller: _controller,
        children: [
          widget.leftWidget,
          widget.rightWidget,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class TwoDrawerSplitView extends HookConsumerWidget {
  const TwoDrawerSplitView({
    super.key,
    required this.innerDrawerKey,
    required this.offset,
    required this.mainContent,
    required this.leftDrawerContent,
    this.rightDrawerContent,
  });

  final GlobalKey<InnerDrawerState> innerDrawerKey;
  final IDOffset offset;
  final Widget mainContent;
  final Widget leftDrawerContent;
  final Widget? rightDrawerContent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ValueNotifier<double> dragPosition = useState(0.0);
    ValueNotifier<InnerDrawerDirection?> drawerDirection =
        ValueNotifier(InnerDrawerDirection.start);

    Color calculateBackgroundColor(double dragPosition) {
      Color start = Theme.of(context).colorScheme.surface;
      Color end = Theme.of(context).colorScheme.onInverseSurface;
      return dragPosition == 0 ? start : end;
    }

    return InnerDrawer(
      key: innerDrawerKey,
      swipe: true,
      swipeChild: true,
      onTapClose: true,
      offset: offset,
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
          BoxDecoration(color: Theme.of(context).colorScheme.onInverseSurface),
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
          ref.read(leftDrawerStateProvider.notifier).state = isOpened;
        }
      },
      leftChild: LeftDrawer(drawerContent: leftDrawerContent),
      rightChild: rightDrawerContent,
      scaffold: ValueListenableBuilder<double>(
        valueListenable: dragPosition,
        builder: (context, value, child) {
          return Container(
            color: calculateBackgroundColor(value),
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
          child: SafeArea(
            minimum: kIsWindows || kIsMacOS ? kPt28 : EdgeInsets.zero,
            bottom: false,
            child: mainContent,
          ),
        ),
      ),
    );
  }
}
