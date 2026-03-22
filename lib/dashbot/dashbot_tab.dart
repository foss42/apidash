import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'providers/providers.dart';
import 'routes/routes.dart';
import 'utils/utils.dart';

class DashbotTab extends ConsumerStatefulWidget {
  const DashbotTab({
    super.key,
    this.showTopBar = true,
  });
  final bool showTopBar;

  @override
  ConsumerState<DashbotTab> createState() => _DashbotTabState();
}

class _DashbotTabState extends ConsumerState<DashbotTab>
    with AutomaticKeepAliveClientMixin {
  static final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final activeRoute = ref.watch(dashbotActiveRouteProvider);

    void navigateTo(String route) {
      final navigator = _navKey.currentState;
      if (navigator == null) return;
      // Determine current top
      Route? top;
      navigator.popUntil((r) {
        top = r;
        return true;
      });
      final topName = top?.settings.name;
      if (topName == route) return; // already there
      if (route == DashbotRoutes.dashbotDefault) {
        navigator.popUntil((r) => r.isFirst);
      } else {
        navigator.pushNamed(route);
      }
    }

    // React to route provider changes.
    ref.listen<String>(dashbotActiveRouteProvider, (prev, next) {
      if (prev == next || next.isEmpty) return;
      navigateTo(next);
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final canPop = _navKey.currentState?.canPop() ?? false;
        if (canPop) {
          _navKey.currentState?.pop();
        }
      },
      child: Padding(
        padding: kP10,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            border: Border.all(
                color: Theme.of(context).colorScheme.surfaceContainerHighest),
            borderRadius: kBorderRadius8,
          ),
          child: Column(
            children: [
              if (widget.showTopBar)
                Padding(
                  padding: kP8,
                  child: Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!kIsMobile) ...[
                          ADIconButton(
                            icon: Icons.close_fullscreen,
                            onPressed: () {
                              ref
                                  .read(dashbotWindowNotifierProvider.notifier)
                                  .togglePopped();

                              final newState =
                                  ref.read(dashbotWindowNotifierProvider);
                              if (newState.isPopped) {
                                showDashbotWindow(context, ref);
                              }
                            },
                          ),
                          ADIconButton(
                            onPressed: () {
                              final isActive = ref
                                  .read(dashbotWindowNotifierProvider)
                                  .isActive;

                              ref
                                  .read(dashbotWindowNotifierProvider.notifier)
                                  .togglePopped();
                              if (isActive) {
                                ref
                                    .read(
                                        dashbotWindowNotifierProvider.notifier)
                                    .toggleActive();
                              }
                            },
                            icon: Icons.close,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Navigator(
                  key: _navKey,
                  initialRoute: activeRoute,
                  onGenerateRoute: generateRoute,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
