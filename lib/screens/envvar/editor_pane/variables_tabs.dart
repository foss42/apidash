import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'variables_pane.dart';
import 'secrets_pane.dart';

class VariablesTabs extends StatefulHookConsumerWidget {
  const VariablesTabs({super.key});

  @override
  ConsumerState<VariablesTabs> createState() => _VariablesTabsState();
}

class _VariablesTabsState extends ConsumerState<VariablesTabs>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2, vsync: this);
    final selectedEnvironment = ref.watch(selectedEnvironmentModelProvider);
    final variablesLength =
        getEnvironmentVariables(selectedEnvironment, removeEmptyModels: true)
            .length;
    final secretsLength =
        getEnvironmentSecrets(selectedEnvironment, removeEmptyModels: true)
            .length;
    return Column(
      children: [
        !context.isMediumWindow ? kVSpacer10 : const SizedBox.shrink(),
        TabBar(
          controller: tabController,
          overlayColor: kColorTransparentState,
          labelPadding: kPh2,
          tabs: [
            TabLabel(
              text: 'Variables',
              showIndicator: variablesLength > 0,
            ),
            TabLabel(
              text: 'Secrets',
              showIndicator: secretsLength > 0,
            ),
          ],
        ),
        kVSpacer5,
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              EditEnvironmentVariables(),
              EditEnvironmentSecrets(),
            ],
          ),
        ),
      ],
    );
  }
}
