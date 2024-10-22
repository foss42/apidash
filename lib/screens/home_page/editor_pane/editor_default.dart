import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class RequestEditorDefault extends ConsumerWidget {
  const RequestEditorDefault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Click  ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(collectionStateNotifierProvider.notifier).add();
                  },
                  child: const Text(
                    kLabelPlusNew,
                    style: kTextStyleButton,
                  ),
                ),
              ),
              TextSpan(
                text: "  to start drafting a new API request.",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
