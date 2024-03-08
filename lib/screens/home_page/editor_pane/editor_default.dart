import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestEditorDefault extends ConsumerWidget {
  const RequestEditorDefault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
                  child: Text(
                    l10n!.kLabelPlusNew,
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
