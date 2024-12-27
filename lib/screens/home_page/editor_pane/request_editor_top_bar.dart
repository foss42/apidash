import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../common_widgets/common_widgets.dart';

class RequestEditorTopBar extends ConsumerWidget {
  const RequestEditorTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(selectedIdStateProvider);
    final name =
        ref.watch(selectedRequestModelProvider.select((value) => value?.name));
    final apiType = ref.watch(selectedRequestModelProvider.select((value) => value?.apiType));;
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        top: 4.0,
        right: 4.0,
        bottom: 4.0,
      ),
      child: Row(
        children: [
          
          DropdownButtonAPIType(
            apiType: apiType,
            onChanged: (newapiType) {
              ref.read(selectedAPITypeProvider.notifier).state = newapiType;
            ref.read(collectionStateNotifierProvider.notifier)
            .update(id!,apiType: newapiType);
            if(apiType == APIType.graphql){
              print("graphql ready on dropdownbutton"); //for testing
            }
            },
          ),
          kHSpacer10,
          Expanded(
            child: Text(
              name ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          kHSpacer10,
          EditorTitleActions(
            onRenamePressed: () {
              showRenameDialog(context, "Rename Request", name, (val) {
                ref
                    .read(collectionStateNotifierProvider.notifier)
                    .update(id!, name: val);
              });
            },
            onDuplicatePressed: () => ref
                .read(collectionStateNotifierProvider.notifier)
                .duplicate(id!),
            onDeletePressed: () =>
                ref.read(collectionStateNotifierProvider.notifier).remove(id!),
          ),
          kHSpacer10,
          const EnvironmentDropdown(),
        ],
      ),
    );
  }
}
