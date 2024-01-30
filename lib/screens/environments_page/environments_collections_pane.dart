import 'package:apidash/consts.dart';
import 'package:apidash/models/environments_list_model.dart';
import 'package:apidash/providers/environment_collection_providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class EnvironmentsCollectionsPane extends ConsumerStatefulWidget {
  const EnvironmentsCollectionsPane({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnvironmentsCollectionsPaneState();
}

class _EnvironmentsCollectionsPaneState
    extends ConsumerState<EnvironmentsCollectionsPane> {
  @override
  Widget build(BuildContext context) {
    String activeKey = ref.read(activeEnvironmentIdProvider) ?? '';
    Key collectionKey = ValueKey(activeKey);
    return Padding(
      key: collectionKey,
      padding: kIsMacOS ? kP24CollectionPane : kP8CollectionPane,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: kPr8CollectionPane,
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                //const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(
                            environmentCollectionStateNotifierProvider.notifier)
                        .createNewEnvironment();
                    setState(() {});
                  },
                  child: const Text(
                    kLabelPlusNew,
                    style: kTextStyleButton,
                  ),
                ),
              ],
            ),
          ),
          kVSpacer8,
          const Expanded(
            child: EnvironmentsCollectionsList(),
          ),
        ],
      ),
    );
  }
}

class EnvironmentsCollectionsList extends ConsumerWidget {
  const EnvironmentsCollectionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<EnvironmentModel> environments = ref
        .watch(environmentCollectionStateNotifierProvider.notifier)
        .environmentModels;

    return ListView.builder(
      padding: kPr8CollectionPane,
      itemCount: environments.length,
      itemBuilder: (context, index) {
        return EnvironmentsListCard(
          environmentModel: environments[index],
        );
      },
    );
  }
}
