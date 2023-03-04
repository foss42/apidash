import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class RequestEditorPane extends ConsumerStatefulWidget {
  const RequestEditorPane({
    Key? key,
  }) : super(key: key);

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
    final activeId = ref.watch(activeItemIdStateProvider);
    if (activeId == null) {
      return Text("Select One");
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(),
          ],
        ),
      );
    }
  }
}
