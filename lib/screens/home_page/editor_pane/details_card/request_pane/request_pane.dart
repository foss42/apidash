import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'request_pane_graphql.dart';
import 'request_pane_rest.dart';

class EditRequestPane extends ConsumerWidget {
  const EditRequestPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    return switch (apiType) {
      APIType.rest => const EditRestRequestPane(),
      APIType.graphql => const EditGraphQLRequestPane(),
      _ => kSizedBoxEmpty,
    };
  }
}
