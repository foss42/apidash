import 'package:apidash/consts.dart';
import 'package:apidash/models/environments_list_model.dart';
import 'package:apidash/providers/environment_collection_providers.dart';
import 'package:apidash/widgets/checkbox.dart';
import 'package:apidash/widgets/textfields.dart';
import 'package:davi/davi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class EnvironmentsEditorPane extends ConsumerStatefulWidget {
  final EnvironmentModel environmentModel;
  const EnvironmentsEditorPane({
    super.key,
    required this.environmentModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EnvironmentsCollectionsPaneState();
}

class _EnvironmentsCollectionsPaneState
    extends ConsumerState<EnvironmentsEditorPane> {
  @override
  Widget build(BuildContext context) {
    EnvironmentsStateNotifier environmentStateNotifier =
        ref.read(environmentsStateNotifierProvider.notifier);

    var rows = widget.environmentModel.getEnvironmentVariables;
    DaviModel<EnvironmentVariableModel> environmentVariableDeviModel =
        DaviModel<EnvironmentVariableModel>(
      rows: rows,
      columns: [
        DaviColumn(
          name: '',
          width: 30,
          cellBuilder: (_, row) {
            int idx = row.index;
            return CheckBox(
              keyId: row.data.id,
              value: rows[idx].isActive,
              onChanged: (value) {
                environmentStateNotifier.updateEnvironmentVariable(
                  rows[idx].id,
                  isActive: value,
                );
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
        ),
        DaviColumn(
          name: 'Variable',
          width: 70,
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return EnvironmentEditField(
              keyId: row.data.id,
              initialValue: row.data.variable,
              hintText: "Add new Variable",
              onChanged: (value) {
                environmentStateNotifier.updateEnvironmentVariable(
                  rows[idx].id,
                  variable: value,
                );
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
          sortable: false,
        ),
        DaviColumn(
          name: 'Value',
          grow: 1,
          cellBuilder: (_, row) {
            int idx = row.index;
            return EnvironmentEditField(
              keyId: row.data.id,
              initialValue: rows[idx].value,
              hintText: " Add new Value",
              onChanged: (value) {
                environmentStateNotifier.updateEnvironmentVariable(
                  rows[idx].id,
                  value: value,
                );
              },
              colorScheme: Theme.of(context).colorScheme,
            );
          },
          sortable: false,
        ),
        DaviColumn(
          pinStatus: PinStatus.none,
          width: 30,
          cellBuilder: (_, row) {
            int idx = row.index;
            return InkWell(
              child: Theme.of(context).brightness == Brightness.dark
                  ? kIconRemoveDark
                  : kIconRemoveLight,
              onTap: () {
                environmentStateNotifier.removeVariable(
                  environmentVariableIndexId: rows[idx].id,
                );
              },
            );
          },
        ),
      ],
    );
    String? selectedEnv = ref.watch(selectedEnvironmentIdProvider);
    return Padding(
      key: ValueKey(selectedEnv),
      padding: kIsMacOS || kIsWindows ? kPt24o8 : kP8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Environments',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          kVSpacer10,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.environmentModel.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              widget.environmentModel.name == "Globals"
                  ? Text(
                      "Global variables for your API requests that are available in all requests in all environments.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : const IgnorePointer(),
            ],
          ),
          kVSpacer10,
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: kBorderRadius12,
                  ),
                  margin: kP10,
                  child: Column(
                    children: [
                      Expanded(
                        child: environmentVariableDeviModel.isRowsEmpty
                            ? const IgnorePointer()
                            : DaviTheme(
                                data: kTableEnvironmentThemeData,
                                child: Davi<EnvironmentVariableModel>(
                                  environmentVariableDeviModel,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: environmentVariableDeviModel.isRowsEmpty
                      ? Alignment.center
                      : Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(environmentsStateNotifierProvider.notifier)
                            .addVariable();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Add Environment Variable",
                        style: kTextStyleButton,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
