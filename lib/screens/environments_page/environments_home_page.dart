import 'package:apidash/models/environments_list_model.dart';
import 'package:apidash/providers/environment_collection_providers.dart';
import 'package:apidash/screens/environments_page/environments_collections_pane.dart';
import 'package:apidash/screens/environments_page/environments_editor_pane.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnvironmentsPage extends ConsumerStatefulWidget {
  const EnvironmentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnvironmentsPageState();
}

class _EnvironmentsPageState extends ConsumerState<EnvironmentsPage> {
  @override
  Widget build(BuildContext context) {
    String? selectedEnvironmentId = ref.watch(selectedEnvironmentIdProvider);
    EnvironmentModel? selectedEnvironment =
        ref.watch(environmentsStateNotifierProvider)[selectedEnvironmentId];
    return Column(
      children: [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: const EnvironmentsCollectionsPane(),
            mainWidget: selectedEnvironment != null
                ? EnvironmentsEditorPane(
                    environmentModel: selectedEnvironment,
                  )
                : Center(
                    child: Text(
                      "No Active Environment",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
