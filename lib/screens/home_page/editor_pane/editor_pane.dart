import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'details_card/details_card.dart';
import 'url_card.dart';

class RequestEditorPane extends ConsumerStatefulWidget {
  const RequestEditorPane({
    super.key,
  });

  @override
  ConsumerState<RequestEditorPane> createState() => _RequestEditorPaneState();
}

class _RequestEditorPaneState extends ConsumerState<RequestEditorPane> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    if (activeId == null) {
      return const RequestEditorDefault();
    } else {
      return Padding(
        padding: kIsMacOS || kIsWindows ? kPt24o8 : kP8,
        child: const Column(
          children: [
            EditorPaneRequestURLCard(),
            kVSpacer10,
            Expanded(
              child: EditorPaneRequestDetailsCard(),
            ),
          ],
        ),
      );
    }
  }
}

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
