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

    // If a response arrives while user is on default, navigate to home.
    ref.listen(
      selectedRequestModelProvider,
      (prev, next) {
        if (prev?.id == next?.id) return;
        final initial = _navKey.currentState?.widget.initialRoute;
        final atRoot = _navKey.currentState?.canPop() == false;
        if (initial == DashbotRoutes.dashbotDefault && atRoot) {
          _navKey.currentState?.pushNamed(DashbotRoutes.dashbotHome);
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ADIconButton(
                        icon: Icons.arrow_back_rounded,
                        onPressed: () {
                          final navState = _navKey.currentState;
                          if (navState?.canPop() ?? false) {
                            navState!.maybePop();
                          } else {
                            Navigator.maybePop(context);
                          }
                        },
                      ),
                      Spacer(),
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
                  initialRoute: currentRequest?.responseStatus == null
                      ? DashbotRoutes.dashbotDefault
                      : DashbotRoutes.dashbotHome,
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
