import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'details_card/details_card.dart';
import 'url_card.dart';

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
    final activeId = ref.watch(activeIdStateProvider);
    if (activeId == null) {
      return const RequestEditorPaneHome();
    } else {
      return Padding(
        padding: kP8,
        child: Column(
          children: const [
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

class RequestEditorPaneHome extends ConsumerWidget {
  const RequestEditorPaneHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 60,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Welcome to API Dash ⚡️",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text(
                  kIntro,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Getting Started",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Text(
                "Click on the ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  String newId =
                      ref.read(collectionStateNotifierProvider.notifier).add();
                  ref
                      .read(activeIdStateProvider.notifier)
                      .update((state) => newId);
                },
                child: const Text(
                  '+ New',
                  style: kTextStyleButton,
                ),
              ),
              Text(
                " button to start drafting a new API request.",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          kVSpacer20,
          kVSpacer10,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Support Channel",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Text(
                "Join our ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FilledButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse("https://bit.ly/heyfoss"));
                },
                icon: const Icon(Icons.discord),
                label: const Text(
                  'Discord Server',
                  style: kTextStyleButton,
                ),
              ),
              Text(
                " and drop a message in the #foss channel.",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          kVSpacer20,
          kVSpacer10,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Report Bug / Request New Feature",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Text(
                "Just raise an issue in our ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FilledButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse("https://github.com/foss42/api-dash"));
                },
                icon: const Icon(Icons.code_rounded),
                label: const Text(
                  'Github Repo',
                  style: kTextStyleButton,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Text(
                "Please support this project by giving it a ",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              FilledButton.icon(
                onPressed: () {
                  launchUrl(Uri.parse("https://github.com/foss42/api-dash"));
                },
                icon: const Icon(Icons.star),
                label: const Text(
                  'Star',
                  style: kTextStyleButton,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
