import 'package:apidash/models/environments_list_model.dart';
import 'package:apidash/providers/environment_collection_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';

class EnvironmentAutoSuggestionWidget extends ConsumerWidget {
  const EnvironmentAutoSuggestionWidget({
    super.key,
    required this.builder,
    required this.onEnvironmentVariableTap,
    this.initialValue = '',
  });

  final Widget Function(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
  ) builder;

  final void Function(String)? onEnvironmentVariableTap;

  final String initialValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? activeEnvironmentId = ref.watch(activeEnvironmentIdProvider);
    Map<String, EnvironmentModel>? environments =
        ref.watch(environmentsStateNotifierProvider);

    List<EnvironmentVariableModel> activeEnvironmentVariables =
        environments?.keys.first == activeEnvironmentId
            ? []
            : (environments?[activeEnvironmentId]?.variables.values ?? [])
                .toList();
    List<EnvironmentVariableModel> globalEnvironment =
        (environments?.values.first.variables.values ?? []).toList();
    return MultiTriggerAutocomplete(
      initialValue: TextEditingValue(
        text: initialValue,
      ),
      autocompleteTriggers: [
        AutocompleteTrigger(
          trigger: '{{',
          optionsViewBuilder: (context, autocompleteQuery, controller) {
            List<EnvironmentVariableModel> environmentVariableNames = ([
              ...globalEnvironment,
              ...activeEnvironmentVariables
            ]
                .where((EnvironmentVariableModel environmentVariable) =>
                    environmentVariable.variable
                        .contains(autocompleteQuery.query))
                .toList());
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: environmentVariableNames.isEmpty
                    ? const IgnorePointer()
                    : ListView.builder(
                        itemCount: environmentVariableNames.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              controller.selection =
                                  autocompleteQuery.selection;
                              String inserted =
                                  '${environmentVariableNames[index].variable}}}';
                              final text = controller.text;
                              final selection = controller.selection;
                              final newText = text.replaceRange(
                                selection.start,
                                selection.end,
                                inserted,
                              );
                              controller.text = newText;
                              controller.selection = TextSelection.collapsed(
                                offset: selection.baseOffset + inserted.length,
                              );
                              if (onEnvironmentVariableTap != null) {
                                onEnvironmentVariableTap!(newText);
                              }
                            },
                            child: Text(
                              environmentVariableNames[index].variable,
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ],
      fieldViewBuilder: builder,
    );
  }
}
