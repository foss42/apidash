import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import '../../mobile/widgets/request_onboarding_panel.dart';

class RequestEditorDefault extends ConsumerWidget {
  const RequestEditorDefault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const RequestOnboardingPanel(),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(collectionStateNotifierProvider.notifier).add();
            },
            child: const Text(
              kLabelPlusNew,
              style: kTextStyleButton,
            ),
          ),
        ],
      ),
    );
  }
}
