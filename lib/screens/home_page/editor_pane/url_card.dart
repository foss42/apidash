import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';

class EditorPaneRequestURLCard extends StatelessWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        borderRadius: kBorderRadius12,
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 20,
        ),
        child: Row(
          children: [
            DropdownButtonHTTPMethod(),
            kHSpacer20,
            Expanded(
              child: URLTextField(),
            ),
            kHSpacer20,
            SizedBox(
              height: 36,
              child: SendButton(),
            ),
            kHSpacer20,
            DropdownButtonHTTPMethod(),
          ],
        ),
      ),
    );
  }
}

class DropdownButtonHTTPMethod extends ConsumerWidget {
  const DropdownButtonHTTPMethod({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method =
        ref.watch(activeRequestModelProvider.select((value) => value?.method));
    return DropdownButtonHttpMethod(
      method: method,
      onChanged: (HTTPVerb? value) {
        final activeId = ref.read(activeRequestModelProvider)!.id;
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId, method: value);
      },
    );
  }
}

class EnvironmentChangeDropDown extends ConsumerWidget {
  const EnvironmentChangeDropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method =
        ref.watch(activeRequestModelProvider.select((value) => value?.method));
    return DropdownButtonHttpMethod(
      method: method,
      onChanged: (HTTPVerb? value) {
        final activeId = ref.read(activeRequestModelProvider)!.id;
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId, method: value);
      },
    );
  }
}

class URLTextField extends ConsumerWidget {
  const URLTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdStateProvider);
    return MultiTriggerAutocomplete(
      initialValue: TextEditingValue(
        text: ref
                .read(collectionStateNotifierProvider.notifier)
                .getRequestModel(activeId!)
                ?.url ??
            '',
      ),
      autocompleteTriggers: [
        // Add the triggers you want to use for autocomplete
        AutocompleteTrigger(
          trigger: '{{',
          optionsViewBuilder: (context, autocompleteQuery, controller) {
            print(autocompleteQuery.query);
            return SizedBox(
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  children: const [
                    ListTile(
                      title: Text("TEst"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
      fieldViewBuilder: (context, textEditingController, focusNode) {
        return URLField(
          activeId: activeId,
          // initialValue: ,
          onChanged: (value) {
            ref
                .read(collectionStateNotifierProvider.notifier)
                .update(activeId, url: value);
          },
          focusNode: focusNode,
          controller: textEditingController,
        );
      },
    );
  }
}

class SendButton extends ConsumerWidget {
  const SendButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    return SendRequestButton(
      activeId: activeId,
      sentRequestId: sentRequestId,
      onTap: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .sendRequest(activeId!);
      },
    );
  }
}
