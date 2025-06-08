import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'editor_default.dart';
import 'editor_request.dart';
import 'global_status_bar.dart';

class RequestEditorPane extends ConsumerWidget {
  const RequestEditorPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);

    return Column(
      children: [
        Expanded(
          child: selectedId == null
              ? const RequestEditorDefault()
              : const RequestEditor(),
        ),
        const GlobalStatusBar(),
      ],
    );
  }
}
