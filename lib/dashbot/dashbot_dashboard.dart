import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/ai/ai.dart';
import 'providers/providers.dart';
import 'routes/routes.dart';
import 'utils/utils.dart';

class DashbotWindow extends ConsumerWidget {
  final VoidCallback onClose;

  const DashbotWindow({super.key, required this.onClose});

  static final GlobalKey<NavigatorState> _dashbotNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ds = DesignSystemProvider.of(context);
    final windowState = ref.watch(dashbotWindowNotifierProvider);
    final windowNotifier = ref.read(dashbotWindowNotifierProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final activeRoute = ref.watch(dashbotActiveRouteProvider);

    // Close the overlay when the window is not popped anymore
    ref.listen(
      dashbotWindowNotifierProvider.select((s) => s.isPopped),
      (prev, next) {
        if (prev == true && next == false) {
          onClose();
        }
      },
    );

    void navigateTo(String route) {
      final nav = _dashbotNavigatorKey.currentState;
      if (nav == null) return;
      Route? top;
      nav.popUntil((r) {
        top = r;
        return true;
      });
      if (top?.settings.name == route) return;
      if (route == DashbotRoutes.dashbotDefault) {
        nav.popUntil((r) => r.isFirst);
      } else {
        nav.pushNamed(route);
      }
    }

    ref.listen<String>(dashbotActiveRouteProvider, (prev, next) {
      if (prev == next || next.isEmpty) return;
      navigateTo(next);
    });

    return Stack(
      children: [
        if (!windowState.isHidden)
          Positioned(
            right: windowState.right,
            bottom: windowState.bottom,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: windowState.width*ds.scaleFactor,
                height: windowState.height*ds.scaleFactor,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        // This is to update position
                        GestureDetector(
                          onPanUpdate: (details) {
                            windowNotifier.updatePosition(
                              details.delta.dx,
                              details.delta.dy,
                              MediaQuery.of(context).size,
                            );
                          },
                          child: Container(
                            height: 50*ds.scaleFactor,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    kHSpacer20(ds.scaleFactor),
                                    DashbotIcons.getDashbotIcon1(width: 38),
                                    kHSpacer12(ds.scaleFactor),
                                    Text(
                                      'DashBot',
                                      style: TextStyle(
                                        fontSize: 16*ds.scaleFactor,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ),
                                    kHSpacer4(ds.scaleFactor),
                                    AIModelSelectorButton(
                                      aiRequestModel: AIRequestModel.fromJson(
                                          settings.defaultAIModel ?? {}),
                                      useRootNavigator: true,
                                      onDialogOpen: () => ref
                                          .read(dashbotWindowNotifierProvider
                                              .notifier)
                                          .hide(),
                                      onDialogClose: () => ref
                                          .read(dashbotWindowNotifierProvider
                                              .notifier)
                                          .show(),
                                      onModelUpdated: (d) {
                                        ref
                                            .read(settingsProvider.notifier)
                                            .update(
                                                defaultAIModel: d.copyWith(
                                                    modelConfigs: [],
                                                    stream: null,
                                                    systemPrompt: '',
                                                    userPrompt: '').toJson());
                                      },
                                    ),
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.open_in_new,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(dashbotWindowNotifierProvider
                                            .notifier)
                                        .togglePopped();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  onPressed: onClose,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Navigator(
                            key: _dashbotNavigatorKey,
                            initialRoute: activeRoute,
                            onGenerateRoute: generateRoute,
                          ),
                        ),
                      ],
                    ),
                    // This is to update size
                    Positioned(
                      left: 0,
                      top: 0,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          windowNotifier.updateSize(
                            details.delta.dx,
                            details.delta.dy,
                            MediaQuery.of(context).size,
                          );
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.resizeUpLeft,
                          child: Container(
                            padding: EdgeInsets.only(top: 6, left: 1),
                            width: 20*ds.scaleFactor,
                            height: 20*ds.scaleFactor,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                              ),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.7),
                            ),
                            child: Icon(
                              Icons.drag_indicator_rounded,
                              size: 16,
                              color:
                                  Theme.of(context).colorScheme.surfaceBright,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
