import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';
import './editor_pane/variables_pane.dart';
import './editor_pane/fake_data_pane.dart';

final environmentEditorTabProvider = StateProvider<int>((ref) => 0);

class EnvironmentEditor extends ConsumerWidget {
  const EnvironmentEditor({super.key});

  Widget _buildTabBar(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(environmentEditorTabProvider);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton(
          context, 
          'Environment Variables', 
          0, 
          selectedTab == 0,
          () => ref.read(environmentEditorTabProvider.notifier).state = 0,
        ),
        const SizedBox(width: 16),
        _buildTabButton(
          context, 
          'Fake Data Providers', 
          1, 
          selectedTab == 1,
          () => ref.read(environmentEditorTabProvider.notifier).state = 1,
        ),
      ],
    );
  }
  
  Widget _buildTabButton(BuildContext context, String title, int index, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
            ? Theme.of(context).colorScheme.primaryContainer 
            : Theme.of(context).colorScheme.surfaceContainerLow,
        foregroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(title),
    );
  }
  
  Widget _buildTabContent(WidgetRef ref) {
    final selectedTab = ref.watch(environmentEditorTabProvider);
    
    if (selectedTab == 0) {
      return Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 30),
              Text("Variable"),
              SizedBox(width: 30),
              Text("Value"),
              SizedBox(width: 40),
            ],
          ),
          kHSpacer40,
          const Divider(),
          const Expanded(child: EditEnvironmentVariables()),
        ],
      );
    } else {
      return const FakeDataProvidersPane();
    }
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedEnvironmentIdStateProvider);
    final name = ref
        .watch(selectedEnvironmentModelProvider.select((value) => value?.name));
    return Padding(
      padding: context.isMediumWindow
          ? kPb10
          : (kIsMacOS || kIsWindows)
              ? kPt28o8
              : kP8,
      child: Column(
        children: [
          kVSpacer5,
          !context.isMediumWindow
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    kHSpacer10,
                    Expanded(
                      child: Text(
                        name ?? "",
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    EditorTitleActions(
                      onRenamePressed: () {
                        showRenameDialog(context, "Rename Environment", name,
                            (val) {
                          ref
                              .read(environmentsStateNotifierProvider.notifier)
                              .updateEnvironment(id!, name: val);
                        });
                      },
                      onDuplicatePressed: () => ref
                          .read(environmentsStateNotifierProvider.notifier)
                          .duplicateEnvironment(id!),
                      onDeletePressed: id == kGlobalEnvironmentId
                          ? null
                          : () {
                              ref
                                  .read(environmentsStateNotifierProvider
                                      .notifier)
                                  .removeEnvironment(id!);
                            },
                    ),
                    kHSpacer4,
                  ],
                )
              : const SizedBox.shrink(),
          kVSpacer5,
          Expanded(
            child: Container(
              margin: context.isMediumWindow ? null : kP4,
              child: Card(
                margin: EdgeInsets.zero,
                color: kColorTransparent,
                surfaceTintColor: kColorTransparent,
                shape: context.isMediumWindow
                    ? null
                    : RoundedRectangleBorder(
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                        ),
                        borderRadius: kBorderRadius12,
                      ),
                elevation: 0,
                child: Padding(
                  padding: kPv6,
                  child: Column(
                    children: [
                      _buildTabBar(context, ref),
                      kHSpacer20,
                      Expanded(child: _buildTabContent(ref))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
