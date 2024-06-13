import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'environments_pane.dart';

class EnvironmentPage extends ConsumerWidget {
  const EnvironmentPage({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isMediumWindow) {
      return TwoDrawerScaffold(
        scaffoldKey: scaffoldKey,
        mainContent: const SizedBox(), // TODO: replace placeholder
        title: const Text("Environments"), // TODO: replace placeholder
        leftDrawerContent: const EnvironmentsPane(),
        onDrawerChanged: (value) =>
            ref.read(leftDrawerStateProvider.notifier).state = value,
      );
    }
    return const Column(
      children: [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: EnvironmentsPane(),
            mainWidget: SizedBox(),
          ),
        ),
      ],
    );
  }
}
