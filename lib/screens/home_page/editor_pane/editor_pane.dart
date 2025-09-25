import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'editor_default.dart';
import 'editor_request.dart';
import 'package:apidash/widgets/logo_apidash.dart';

class RequestEditorPane extends ConsumerWidget {
  const RequestEditorPane({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final collection = ref.watch(collectionStateNotifierProvider);

    if (collection == null || collection.isEmpty) {    //NO collection (empty or null) -> Show logo + text
      return const RequestEditorDefault();
    }
    if (selectedId == null) {      //  No selectedId -> Show only the logo
      return const LogoApidash();
    }

    return const RequestEditor();
  }
}
