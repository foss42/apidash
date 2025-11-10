import 'dart:math';

import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import '../common_widgets/common_widgets.dart';

class EnvironmentsPane extends ConsumerWidget {
  const EnvironmentsPane({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: (!context.isMediumWindow && kIsMacOS ? kPt24l4 : kPt8l4) +
          (context.isMediumWindow ? kPb70 : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SidebarHeader(
            onAddNew: () {
              Color newColor = kEnvColors[Random().nextInt(kEnvColors.length)];
              ref
                  .read(environmentsStateNotifierProvider.notifier)
                  .addEnvironment(color: newColor);
            },
          ),
          kVSpacer10,
          SidebarFilter(
            filterHintText: "Filter by name",
            onFilterFieldChanged: (value) {
              ref.read(environmentSearchQueryProvider.notifier).state =
                  value.toLowerCase();
            },
          ),
          kVSpacer10,
          const Expanded(child: EnvironmentsList()),
          kVSpacer5
        ],
      ),
    );
  }
}

class EnvironmentsList extends HookConsumerWidget {
  const EnvironmentsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environmentSequence = ref.watch(environmentSequenceProvider);
    final environmentItems = ref.watch(environmentsStateNotifierProvider)!;
    final alwaysShowEnvironmentsPaneScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));
    final filterQuery = ref.watch(environmentSearchQueryProvider).trim();

    ScrollController scrollController = useScrollController();
    return Column(
      children: [
        Padding(
          padding: kP1 + kPe8,
          child: EnvironmentItem(
            id: kGlobalEnvironmentId,
            environmentModel: environmentItems[kGlobalEnvironmentId]!,
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: alwaysShowEnvironmentsPaneScrollbar,
            radius: const Radius.circular(12),
            child: filterQuery.isEmpty
                ? ReorderableListView.builder(
                    padding: context.isMediumWindow
                        ? EdgeInsets.only(
                            bottom: MediaQuery.paddingOf(context).bottom,
                            right: 8,
                          )
                        : kPe8,
                    scrollController: scrollController,
                    buildDefaultDragHandles: false,
                    itemCount: environmentSequence.length,
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      if (oldIndex != newIndex) {
                        ref
                            .read(environmentsStateNotifierProvider.notifier)
                            .reorder(oldIndex, newIndex);
                      }
                    },
                    itemBuilder: (context, index) {
                      var id = environmentSequence[index];
                      if (id == kGlobalEnvironmentId) {
                        return SizedBox.shrink(
                          key: ValueKey(id),
                        );
                      }
                      if (kIsMobile) {
                        return ReorderableDelayedDragStartListener(
                          key: ValueKey(id),
                          index: index,
                          child: Padding(
                            padding: kP1,
                            child: EnvironmentItem(
                              id: id,
                              environmentModel: environmentItems[id]!,
                            ),
                          ),
                        );
                      }
                      return ReorderableDragStartListener(
                        key: ValueKey(id),
                        index: index,
                        child: Padding(
                          padding: kP1,
                          child: EnvironmentItem(
                            id: id,
                            environmentModel: environmentItems[id]!,
                          ),
                        ),
                      );
                    },
                  )
                : ListView(
                    padding: context.isMediumWindow
                        ? EdgeInsets.only(
                            bottom: MediaQuery.paddingOf(context).bottom,
                            right: 8,
                          )
                        : kPe8,
                    controller: scrollController,
                    children: environmentSequence.map((id) {
                      var item = environmentItems[id]!;
                      if (id == kGlobalEnvironmentId) {
                        return SizedBox.shrink(
                          key: ValueKey(id),
                        );
                      }
                      if (item.name.toLowerCase().contains(filterQuery)) {
                        return Padding(
                          padding: kP1,
                          child: EnvironmentItem(
                            id: id,
                            environmentModel: item,
                          ),
                        );
                      }
                      return kSizedBoxEmpty;
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}

class EnvironmentItem extends ConsumerWidget {
  const EnvironmentItem({
    super.key,
    required this.id,
    required this.environmentModel,
  });

  final String id;
  final EnvironmentModel environmentModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedEnvironmentIdStateProvider);
    final activeEnvironmentId = ref.watch(activeEnvironmentIdStateProvider);
    final editRequestId = ref.watch(selectedIdEditStateProvider);

    return SidebarEnvironmentCard(
      id: id,
      isActive: id == activeEnvironmentId,
      isGlobal: id == kGlobalEnvironmentId,
      name: environmentModel.name,
      color: environmentModel.color,
      selectedId: selectedId,
      editRequestId: editRequestId,
      setActive: (value) {
        ref.read(activeEnvironmentIdStateProvider.notifier).state = id;
      },
      onTap: () {
        ref.read(selectedEnvironmentIdStateProvider.notifier).state = id;
        kEnvScaffoldKey.currentState?.closeDrawer();
      },
      onSecondaryTap: () {
        ref.read(selectedEnvironmentIdStateProvider.notifier).state = id;
      },
      focusNode: ref.watch(nameTextFieldFocusNodeProvider),
      onChangedNameEditor: (value) {
        value = value.trim();
        ref
            .read(environmentsStateNotifierProvider.notifier)
            .updateEnvironment(editRequestId!, name: value);
      },
      onTapOutsideNameEditor: () {
        ref.read(selectedIdEditStateProvider.notifier).state = null;
      },
      onMenuSelected: (ItemMenuOption item) {
        if (item == ItemMenuOption.edit) {
          ref.read(selectedIdEditStateProvider.notifier).state = id;
          Future.delayed(
            const Duration(milliseconds: 150),
            () => ref
                .read(nameTextFieldFocusNodeProvider.notifier)
                .state
                .requestFocus(),
          );
        }
        if (item == ItemMenuOption.delete) {
          ref
              .read(environmentsStateNotifierProvider.notifier)
              .removeEnvironment(id);
        }
        if (item == ItemMenuOption.duplicate) {
          ref
              .read(environmentsStateNotifierProvider.notifier)
              .duplicateEnvironment(id);
        }
        if (item == ItemMenuOption.editColor) {
          showEnvColorPickerDialog(
            context,
            ref.read(environmentsStateNotifierProvider.notifier),
            id,
          );
        }
      },
    );
  }
}

void showEnvColorPickerDialog(
  BuildContext context,
  EnvironmentsStateNotifier notifier,
  String id,
) {
  showDialog(
    context: context,
    builder: (context) {
      Color? hoveredColor;

      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Pick a color'),
          content: SizedBox(
            width: 250,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: kEnvColors.map((color) {
                final isHovered = color == hoveredColor;

                final displayColor = isHovered
                    ? Color.alphaBlend(
                        Colors.black.withValues(alpha: 0.25), color)
                    : color;

                return MouseRegion(
                  onEnter: (_) => setState(() => hoveredColor = color),
                  onExit: (_) => setState(() => hoveredColor = null),
                  child: GestureDetector(
                    onTap: () {
                      notifier.updateEnvironment(id, color: color);
                      Navigator.of(context).pop();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: displayColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    },
  );
}
