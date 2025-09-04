import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/ai/ai.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'core/utils/dashbot_icons.dart';

import 'core/providers/dashbot_window_notifier.dart';
import 'core/routes/dashbot_router.dart';
import 'core/routes/dashbot_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashbotWindow extends ConsumerWidget {
  final VoidCallback onClose;

  const DashbotWindow({super.key, required this.onClose});

  static final GlobalKey<NavigatorState> _dashbotNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowState = ref.watch(dashbotWindowNotifierProvider);
    final windowNotifier = ref.read(dashbotWindowNotifierProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final currentRequest = ref.watch(selectedRequestModelProvider);

    // Close the overlay when the window is not popped anymore
    ref.listen(
      dashbotWindowNotifierProvider.select((s) => s.isPopped),
      (prev, next) {
        if (prev == true && next == false) {
          onClose();
        }
      },
    );

    ref.listen(
      selectedRequestModelProvider,
      (current, next) {
        if (next?.responseStatus != null) {
          _dashbotNavigatorKey.currentState?.pushNamed(
            DashbotRoutes.dashbotHome,
          );
        }
      },
    );

    return Stack(
      children: [
        Positioned(
          right: windowState.right,
          bottom: windowState.bottom,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: windowState.width,
              height: windowState.height,
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
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  kHSpacer20,
                                  DashbotIcons.getDashbotIcon1(width: 38),
                                  // TODO: remove the show active request name/model in prod
                                  kHSpacer12,
                                  Text(
                                    'DashBot',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                  kHSpacer4,
                                  AIModelSelectorButton(
                                    aiRequestModel: AIRequestModel.fromJson(
                                        settings.defaultAIModel ?? {}),
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
                          initialRoute: currentRequest?.responseStatus == null
                              ? DashbotRoutes.dashbotDefault
                              : DashbotRoutes.dashbotHome,
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
                          width: 20,
                          height: 20,
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
                            color: Theme.of(context).colorScheme.surfaceBright,
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
