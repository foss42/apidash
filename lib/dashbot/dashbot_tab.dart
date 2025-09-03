import 'package:apidash/providers/providers.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'core/routes/dashbot_router.dart';
import 'core/routes/dashbot_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        if (next?.responseStatus != null) {
          _navKey.currentState?.pushNamed(DashbotRoutes.dashbotHome);
        }
      },
    );

    return WillPopScope(
      onWillPop: () async {
        final canPop = _navKey.currentState?.canPop() ?? false;
        if (canPop) {
          _navKey.currentState?.pop();
          return false;
        }
        return true;
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
