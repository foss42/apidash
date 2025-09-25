import 'package:apidash/providers/providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'core/routes/dashbot_router.dart';
import 'core/routes/dashbot_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/dashbot_window_notifier.dart';
import 'core/utils/show_dashbot.dart';
import 'package:apidash/consts.dart';

class DashbotTab extends ConsumerStatefulWidget {
  const DashbotTab({super.key});

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
    final currentRequest = ref.watch(selectedRequestModelProvider);

    // Listen to changes in response status and navigate accordingly
    ref.listen(
      selectedRequestModelProvider.select((request) =>
          request?.httpResponseModel?.statusCode != null ||
          request?.responseStatus != null),
      (prev, hasResponse) {
        if (prev == hasResponse) return;

        final currentRoute = _navKey.currentState?.widget.initialRoute;
        final canPop = _navKey.currentState?.canPop() ?? false;

        if (hasResponse) {
          // Response available - navigate to home if not already there
          if (currentRoute == DashbotRoutes.dashbotDefault && !canPop) {
            _navKey.currentState?.pushNamed(DashbotRoutes.dashbotHome);
          }
        } else {
          // No response - navigate back to default if we're in home
          if (canPop) {
            _navKey.currentState?.popUntil((route) => route.isFirst);
          }
        }
      },
    );

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
                                  .read(dashbotWindowNotifierProvider.notifier)
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
                  initialRoute:
                      (currentRequest?.httpResponseModel?.statusCode != null ||
                              currentRequest?.responseStatus != null)
                          ? DashbotRoutes.dashbotHome
                          : DashbotRoutes.dashbotDefault,
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
