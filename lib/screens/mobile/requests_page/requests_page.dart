import 'package:flutter/material.dart';
import 'package:inner_drawer/inner_drawer.dart';
import '../../home_page/editor_pane/editor_pane.dart';
import '../../home_page/editor_pane/url_card.dart';
import '../../home_page/editor_pane/details_card/code_pane.dart';
import '../page_base.dart';

class RequestsPage extends StatelessWidget {
  final GlobalKey<InnerDrawerState> innerDrawerKey;

  const RequestsPage({super.key, required this.innerDrawerKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        primary: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.format_list_bulleted_rounded),
          onPressed: () {
            innerDrawerKey.currentState!
                .open(direction: InnerDrawerDirection.start);
          },
        ),
        title: const Text("Requests"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.mode_comment_outlined,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () {
              innerDrawerKey.currentState!
                  .open(direction: InnerDrawerDirection.end);
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: const RequestEditorPane(),
      ),
      bottomNavigationBar: RequestPageBottombar(innerDrawerKey: innerDrawerKey),
    );
  }
}

class RequestPageBottombar extends StatelessWidget {
  const RequestPageBottombar({
    super.key,
    required this.innerDrawerKey,
  });

  final GlobalKey<InnerDrawerState> innerDrawerKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 + MediaQuery.of(context).padding.bottom,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onInverseSurface,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.filledTonal(
            style: IconButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PageBase(
                    title: 'View Code',
                    scaffoldBody: CodePane(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.code_rounded),
          ),
          SendButton(
            onTap: () {
              innerDrawerKey.currentState!
                  .open(direction: InnerDrawerDirection.end);
            },
          ),
        ],
      ),
    );
  }
}
