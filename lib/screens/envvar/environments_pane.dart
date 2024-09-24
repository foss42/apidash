import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:apidash/extensions/extensions.dart';
import 'package:apidash/models/environment_model.dart';
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
    final settings = ref.watch(settingsProvider);
    final scaleFactor = settings.scaleFactor;

    return Padding(
      padding: (!context.isMediumWindow && kIsMacOS
          ? kP24CollectionPane * scaleFactor
          : kP8CollectionPane * scaleFactor) +
          (context.isMediumWindow ? EdgeInsets.only(bottom: 70 * scaleFactor) : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SidebarHeader(
            onAddNew: () {
              ref
                  .read(environmentsStateNotifierProvider.notifier)
                  .addEnvironment();
            },
          ),
          SizedBox(height: 10 * scaleFactor), // Scaling vertical spacing
          SidebarFilter(
            filterHintText: "Filter by name",
            onFilterFieldChanged: (value) {
              ref.read(environmentSearchQueryProvider.notifier).state =
                  value.toLowerCase();
            },
          ),
          SizedBox(height: 10 * scaleFactor), // Scaling vertical spacing
          const Expanded(child: EnvironmentsList()),
          SizedBox(height: 5 * scaleFactor), // Scaling vertical spacing
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
    final settings = ref.watch(settingsProvider);
    final scaleFactor = settings.scaleFactor;

    final environmentSequence = ref.watch(environmentSequenceProvider);
    final environmentItems = ref.watch(environmentsStateNotifierProvider)!;
    final alwaysShowEnvironmentsPaneScrollbar = ref.watch(settingsProvider
        .select((value) => value.alwaysShowCollectionPaneScrollbar));
    final filterQuery = ref.watch(environmentSearchQueryProvider).trim();

    ScrollController scrollController = useScrollController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(1 * scaleFactor) + EdgeInsets.symmetric(horizontal: 1 * scaleFactor),
          child: EnvironmentItem(
            id: kGlobalEnvironmentId,
            environmentModel: environmentItems[kGlobalEnvironmentId]!,
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: alwaysShowEnvironmentsPaneScrollbar,
            radius: Radius.circular(12 * scaleFactor),
            child: filterQuery.isEmpty
                ? ReorderableListView.builder(
              padding: context.isMediumWindow
                  ? EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
                right: 8 * scaleFactor,
              )
                  : EdgeInsets.symmetric(horizontal: 8 * scaleFactor),
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
                return ReorderableDragStartListener(
                  key: ValueKey(id),
                  index: index,
                  child: Padding(
                    padding: EdgeInsets.all(1 * scaleFactor),
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
                right: 8 * scaleFactor,
              )
                  : EdgeInsets.symmetric(horizontal: 8 * scaleFactor),
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
                    padding: EdgeInsets.all(1 * scaleFactor),
                    child: EnvironmentItem(
                      id: id,
                      environmentModel: item,
                    ),
                  );
                }
                return const SizedBox();
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
      selectedId: selectedId,
      editRequestId: editRequestId,
      setActive: (value) {
        ref.read(activeEnvironmentIdStateProvider.notifier).state = id;
      },
      onTap: () {
        ref.read(selectedEnvironmentIdStateProvider.notifier).state = id;
        kEnvScaffoldKey.currentState?.closeDrawer();
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
      },
    );
  }
}
