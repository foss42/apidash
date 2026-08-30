import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';

class DropdownButtonHTTPMethod extends ConsumerWidget {
  const DropdownButtonHTTPMethod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(
      selectedRequestModelProvider.select(
        (value) => value?.httpRequestModel?.method,
      ),
    );
    return DropdownButtonHttpMethod(
      method: method,
      onChanged: (HTTPVerb? value) {
        ref
            .read(activeCollectionProvider.notifier)
            .update(method: value);
      },
    );
  }
}
