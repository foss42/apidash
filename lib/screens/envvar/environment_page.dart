import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';
import 'environments_pane.dart';
import 'environment_editor.dart';

class EnvironmentPage extends ConsumerWidget {
  const EnvironmentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedEnvironmentIdStateProvider);
    final name = getEnvironmentTitle(ref.watch(
        selectedEnvironmentModelProvider.select((value) => value?.name)));
    if (context.isMediumWindow) {
      return DrawerSplitView(
        scaffoldKey: kEnvScaffoldKey,
        mainContent: const EnvironmentEditor(),
        title: EditorTitle(
          title: name,
          showMenu: id != kGlobalEnvironmentId,
          onSelected: (ItemMenuOption item) {
            if (item == ItemMenuOption.edit) {
              showRenameDialog(context, "Rename Environment", name, (val) {
                ref
                    .read(environmentsStateNotifierProvider.notifier)
                    .updateEnvironment(id!, name: val);
              });
            }
            if (item == ItemMenuOption.delete) {
              ref
                  .read(environmentsStateNotifierProvider.notifier)
                  .removeEnvironment(id!);
            }
            if (item == ItemMenuOption.duplicate) {
              ref
                  .read(environmentsStateNotifierProvider.notifier)
                  .duplicateEnvironment(id!);
            }
          },
        ),
        leftDrawerContent: const EnvironmentsPane(),
        actions: const [SizedBox(width: 16)],
        onDrawerChanged: (value) =>
            ref.read(leftDrawerStateProvider.notifier).state = value,
      );
    }
    return const Column(
      children: [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: EnvironmentsPane(),
            mainWidget: EnvironmentEditor(),
          ),
        ),
      ],
    );
  }
}
