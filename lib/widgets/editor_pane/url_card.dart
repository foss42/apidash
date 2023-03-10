import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import '../styles.dart';
import '../../consts.dart';

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
        borderRadius: border12,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 20,
        ),
        child: Row(
          children: const [
            DropdownButtonHTTPMethod(),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: URLTextField(),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              height: 36,
              child: SendRequestButton(),
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
    final Color color = Theme.of(context).colorScheme.surface;
    final activeId = ref.watch(activeIdStateProvider);
    final collection = ref.read(collectionStateNotifierProvider);
    final idIdx = collection.indexWhere((m) => m.id == activeId);
    final method = ref.watch(
        collectionStateNotifierProvider.select((value) => value[idIdx].method));
    return DropdownButton<HTTPVerb>(
      focusColor: color,
      value: method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      onChanged: (HTTPVerb? value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId!, method: value);
      },
      items: HTTPVerb.values.map<DropdownMenuItem<HTTPVerb>>((HTTPVerb value) {
        return DropdownMenuItem<HTTPVerb>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.name.toUpperCase(),
              style: codeStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: getHTTPMethodColor(value),
              ),
            ),
          ),
        );
      }).toList(),
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
    return TextFormField(
      key: Key("url-${activeId!}"),
      initialValue: ref
          .read(collectionStateNotifierProvider.notifier)
          .getRequestModel(activeId)
          .url,
      style: codeStyle,
      decoration: InputDecoration(
        hintText: "Enter API endpoint like api.foss42.com/country/codes",
        hintStyle: codeStyle.copyWith(color: colorGrey500),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(activeId, url: value);
      },
    );
  }
}

class SendRequestButton extends ConsumerStatefulWidget {
  const SendRequestButton({
    super.key,
  });

  @override
  ConsumerState<SendRequestButton> createState() => _SendRequestButtonState();
}

class _SendRequestButtonState extends ConsumerState<SendRequestButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeId = ref.watch(activeIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    bool disable = sentRequestId != null;
    return FilledButton(
      onPressed: disable
          ? null
          : () async {
              ref
                  .read(sentRequestIdStateProvider.notifier)
                  .update((state) => activeId);
              await Future.delayed(
                const Duration(seconds: 5),
                () {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .sendRequest(activeId!);
                },
              );
              ref
                  .read(sentRequestIdStateProvider.notifier)
                  .update((state) => null);
            },
      child: Row(
        children: [
          Text(
            disable
                ? (activeId == sentRequestId ? "Sending.." : "Busy")
                : "Send",
            style: textStyleButton,
          ),
          if (!disable)
            const SizedBox(
              width: 10,
            ),
          if (!disable)
            const Icon(
              size: 16,
              Icons.send,
            ),
        ],
      ),
    );
  }
}
