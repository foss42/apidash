import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';
import './editor_pane/variables_pane.dart';
import './editor_pane/environment_auth_pane.dart';

class EnvironmentEditor extends ConsumerStatefulWidget {
  const EnvironmentEditor({super.key});

  @override
  ConsumerState<EnvironmentEditor> createState() => _EnvironmentEditorState();
}

class _EnvironmentEditorState extends ConsumerState<EnvironmentEditor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          // Tab Bar
          Container(
            margin: context.isMediumWindow
                ? null
                : const EdgeInsets.symmetric(horizontal: 4),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Variables'),
                Tab(text: 'Authentication'),
              ],
            ),
          ),
          kVSpacer10,
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Variables Tab
                Container(
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
                    child: const Padding(
                      padding: kPv6,
                      child: Column(
                        children: [
                          kHSpacer40,
                          Row(
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
                          Divider(),
                          Expanded(child: EditEnvironmentVariables())
                        ],
                      ),
                    ),
                  ),
                ),
                // Authentication Tab
                Container(
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
                    child: const EnvironmentAuthPane(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
