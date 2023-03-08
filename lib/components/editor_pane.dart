import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import 'editor_pane/url_card.dart';
import 'editor_pane/details_card.dart';

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
      return const RequestEditorPaneHome();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: const [
            EditorPaneRequestURLCard(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: EditorPaneRequestDetailsCard(),
            ),
          ],
        ),
      );
    }
  }
}

class RequestEditorPaneHome extends StatelessWidget {
  const RequestEditorPaneHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Welcome to API Dash!",
              style: Theme.of(context).textTheme.headlineLarge),
          Text("Click on the +New button to create a new request draft",
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
