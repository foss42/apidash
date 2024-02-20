import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditorPaneRequestURLCard extends ConsumerWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocol = ref
        .watch(selectedRequestModelProvider.select((value) => value?.protocol));
    return Row(
      children: [
        const Card(child: _DropdownButtonProtocol()),
        Expanded(
          child: Card(
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
              child: protocol == Protocol.http
                  ? const _HTTPURLInput()
                  : const _WebsocketURLInput(),
            ),
          ),
        ),
      ],
    );
  }
}

class _WebsocketURLInput extends StatelessWidget {
  const _WebsocketURLInput();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: URLTextField(),
        ),
        kHSpacer20,
        SizedBox(
          height: 36,
          child: ConnectButton(),
        ),
      ],
    );
  }
}

class _HTTPURLInput extends StatelessWidget {
  const _HTTPURLInput();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _DropdownButtonHTTPMethod(),
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
    );
  }
}

class _DropdownButtonProtocol extends ConsumerWidget {
  const _DropdownButtonProtocol();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocol = ref
        .watch(selectedRequestModelProvider.select((value) => value?.protocol));
    return DropdownButtonProtocol(
      protocol: protocol,
      onChanged: (Protocol? value) {
        final selectedId = ref.read(selectedRequestModelProvider)!.id;
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(selectedId, protocol: value);
      },
    );
  }
}

class _DropdownButtonHTTPMethod extends ConsumerWidget {
  const _DropdownButtonHTTPMethod();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref
        .watch(selectedRequestModelProvider.select((value) => value?.method));
    return DropdownButtonHttpMethod(
      method: method,
      onChanged: (HTTPVerb? value) {
        final selectedId = ref.read(selectedRequestModelProvider)!.id;
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(selectedId, method: value);
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
    final selectedId = ref.watch(selectedIdStateProvider);
    return URLField(
      selectedId: selectedId!,
      initialValue: ref
          .read(collectionStateNotifierProvider.notifier)
          .getRequestModel(selectedId)
          ?.url,
      onChanged: (value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(selectedId, url: value);
      },
    );
  }
}

class ConnectButton extends ConsumerWidget {
  const ConnectButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    return ConnectWebsocketButton(
      selectedId: selectedId,
      sentRequestId: sentRequestId,
      onTap: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .connectWebsocket(selectedId!);
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
    final selectedId = ref.watch(selectedIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    return SendRequestButton(
      selectedId: selectedId,
      sentRequestId: sentRequestId,
      onTap: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .sendRequest(selectedId!);
      },
    );
  }
}
