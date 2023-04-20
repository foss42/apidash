import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditorPaneRequestURLCard extends StatefulWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  State<EditorPaneRequestURLCard> createState() =>
      _EditorPaneRequestURLCardState();
}

class _EditorPaneRequestURLCardState extends State<EditorPaneRequestURLCard> {
  @override
  void initState() {
    super.initState();
  }

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
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 20,
        ),
        child: Row(
          children: const [
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
          ],
        ),
      ),
    );
  }
}

class DropdownButtonHTTPMethod extends ConsumerStatefulWidget {
  const DropdownButtonHTTPMethod({
    super.key,
  });

  @override
  ConsumerState<DropdownButtonHTTPMethod> createState() =>
      _DropdownButtonHTTPMethodState();
}

class _DropdownButtonHTTPMethodState
    extends ConsumerState<DropdownButtonHTTPMethod> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final method =
        ref.watch(activeRequestModelProvider.select((value) => value?.method));
    return DropdownButtonHttpMethod(
      method: method,
      onChanged: (HTTPVerb? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, method: value);
      },
    );
  }
}

class URLTextField extends ConsumerStatefulWidget {
  const URLTextField({
    super.key,
  });

  @override
  ConsumerState<URLTextField> createState() => _URLTextFieldState();
}

class _URLTextFieldState extends ConsumerState<URLTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    return URLField(
      activeId: activeId!,
      initialValue: ref
          .read(collectionStateNotifierProvider.notifier)
          .getRequestModel(activeId)
          .url,
      onChanged: (value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId, url: value);
      },
    );
  }
}

class SendButton extends ConsumerStatefulWidget {
  const SendButton({
    super.key,
  });

  @override
  ConsumerState<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends ConsumerState<SendButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
