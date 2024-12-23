import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditGraphqlQuery extends ConsumerWidget {
  const EditGraphqlQuery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!);

    return Padding(
                padding: kPt5o10,
                child: TextFieldEditor(
                  key: Key("$selectedId-json-body"),
                  fieldKey: "$selectedId-json-body-editor",
                  initialValue: requestModel?.httpRequestModel?.body,
                  onChanged: (String value) {
                    // changeToPostMethod();
                    ref
                        .read(collectionStateNotifierProvider.notifier)
                        .update(selectedId, body: value);
                  },
                ),
              );
           
          }
}
        
     
