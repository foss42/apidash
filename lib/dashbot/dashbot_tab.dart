import 'package:apidash/providers/providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'core/routes/dashbot_router.dart';
import 'core/routes/dashbot_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/dashbot_window_notifier.dart';
import 'core/utils/show_dashbot.dart';
import 'package:apidash/consts.dart';
import 'features/chat/viewmodel/chat_viewmodel.dart';

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
    final chatState = ref.watch(chatViewmodelProvider);

    void maybeNavigate() {
      final req = ref.read(selectedRequestModelProvider);
      final hasResponse = (req?.httpResponseModel?.statusCode != null) ||
          (req?.responseStatus != null);
      final requestId = req?.id ?? 'global';
      final messages = chatState.chatSessions[requestId] ?? const [];
      final isChatActive = messages.isNotEmpty;
      final navigator = _navKey.currentState;
      if (navigator == null) return;
      final canPop = navigator.canPop();

      final desired = isChatActive
          ? DashbotRoutes.dashbotChat
          : hasResponse
              ? DashbotRoutes.dashbotHome
              : DashbotRoutes.dashbotDefault;

      bool isOn(String r) {
        Route? top;
        navigator.popUntil((route) {
          top = route;
          return true;
        });
        return top?.settings.name == r;
      }

      if (isOn(desired)) return;
      if (desired == DashbotRoutes.dashbotDefault && canPop) {
        navigator.popUntil((route) => route.isFirst);
        return;
      }
      if (desired != DashbotRoutes.dashbotDefault) {
        navigator.pushNamed(desired);
      }
    }

    ref.listen(chatViewmodelProvider, (_, __) => maybeNavigate());
    ref.listen(selectedRequestModelProvider, (_, __) => maybeNavigate());

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
                  initialRoute: (chatState
                              .chatSessions[(currentRequest?.id ?? 'global')]
                              ?.isNotEmpty ??
                          false)
                      ? DashbotRoutes.dashbotChat
                      : (currentRequest?.httpResponseModel?.statusCode !=
                                  null ||
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
