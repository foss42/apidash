import 'package:apidash/consts.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'editor_default.dart';
import 'editor_request.dart';

class RequestEditorPane extends ConsumerWidget {
  const RequestEditorPane({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) {
      return const RequestEditorDefault();
    } else {
      return Padding(
        padding: kIsMacOS || kIsWindows ? kPt24 : kPt8,
        child: const Column(
          children: [
            RequestTabView(),
            Expanded(
              child: Padding(
                padding: kP8,
                child: RequestEditor(),
              ),
            ),
          ],
        ),
      );
    }
  }
}
