import 'package:apidash/dashbot/core/providers/dashbot_window_notifier.dart';
import 'package:apidash/dashbot/core/routes/dashbot_router.dart';
import 'package:apidash/dashbot/core/routes/dashbot_routes.dart'
    show DashbotRoutes;
import 'package:apidash/models/request_model.dart' show RequestModel;
import 'package:apidash/providers/collection_providers.dart'
    show selectedRequestModelProvider;
import 'package:apidash_design_system/tokens/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashbotWindow extends ConsumerWidget {
  final VoidCallback onClose;

  const DashbotWindow({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final windowState = ref.watch(dashbotWindowNotifierProvider);
    final windowNotifier = ref.read(dashbotWindowNotifierProvider.notifier);
    final RequestModel? currentRequest =
        ref.watch(selectedRequestModelProvider);

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
                          windowNotifier.updatePosition(details.delta.dx,
                              details.delta.dy, MediaQuery.of(context).size);
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
                                  Image.asset(
                                    'assets/dashbot_icon_2.png',
                                    width: 38,
                                  ),
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
                                ],
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
