import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class APITypeDropdown extends ConsumerWidget {
  const APITypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    return APITypePopupMenu(
      apiType: apiType,
      onChanged: (type) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(apiType: type);
      },
    );
  }
}
