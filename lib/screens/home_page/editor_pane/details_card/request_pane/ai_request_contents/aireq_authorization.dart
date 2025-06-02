import 'package:apidash/providers/collection_providers.dart';
import 'package:apidash/widgets/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AIRequestAuthorizationSection extends ConsumerWidget {
  const AIRequestAuthorizationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final reqDetails = ref
        .watch(collectionStateNotifierProvider
            .select((value) => value![ref.read(selectedIdStateProvider)!]))!
        .extraDetails;
    final iV = reqDetails['authorization_credential'];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldEditor(
                key: Key("$selectedId-aireq-authvalue-body"),
                fieldKey: "$selectedId-aireq-authvalue-body",
                initialValue: iV,
                onChanged: (String value) {
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    extraDetails: {
                      ...reqDetails,
                      'authorization_credential': value
                    },
                  );
                },
                hintText: 'Enter API key or Authorization Credentials',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
