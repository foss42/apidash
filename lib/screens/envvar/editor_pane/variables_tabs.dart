import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/utils/utils.dart';
import 'variables_pane.dart';
import 'secrets_pane.dart';
import 'auth_pane.dart';

class VariablesTabs extends StatefulHookConsumerWidget {
  const VariablesTabs({super.key});

  @override
  ConsumerState<VariablesTabs> createState() => _VariablesTabsState();
}

class _VariablesTabsState extends ConsumerState<VariablesTabs>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 3, vsync: this);
    final selectedEnvironment = ref.watch(selectedEnvironmentModelProvider);
    final variablesLength =
        getEnvironmentVariables(selectedEnvironment, removeEmptyModels: true)
            .length;
    final secretsLength =
        getEnvironmentSecrets(selectedEnvironment, removeEmptyModels: true)
            .length;
    final hasAuth = selectedEnvironment?.authModel != null &&
        selectedEnvironment?.authModel?.type != APIAuthType.none;
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
            TabLabel(
              text: 'Authentication',
              showIndicator: hasAuth,
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
              EditEnvironmentAuth(),
            ],
          ),
        ),
      ],
    );
  }
}
