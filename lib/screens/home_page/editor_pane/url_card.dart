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
    if (protocol == ProtocolType.websocket) {
      return const WebSocketCard();
    }
    return const HTTPCard();
  }
}

class HTTPCard extends StatelessWidget {
  const HTTPCard({
    super.key,
  });

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
            DropdownButtonProtocol(),
            kHSpacer20,
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

class WebSocketCard extends StatelessWidget {
  const WebSocketCard({
    super.key,
  });

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
            DropdownButtonProtocol(),
            kHSpacer20,
            Expanded(
              child: URLTextField(),
            ),
            kHSpacer20,
            SizedBox(
              height: 36,
              child: ConnectWebSocketButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownButtonProtocol extends ConsumerWidget {
  const DropdownButtonProtocol({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final protocol = ref
        .watch(selectedRequestModelProvider.select((value) => value?.protocol));
    return DropdownButtonProtocolType(
      protocol: protocol,
      onChanged: (ProtocolType? value) {
        final selectedId = ref.read(selectedRequestModelProvider)!.id;
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(selectedId, protocol: value);
      },
    );
  }
}

class DropdownButtonHTTPMethod extends ConsumerWidget {
  const DropdownButtonHTTPMethod({
    super.key,
  });

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

class ConnectWebSocketButton extends ConsumerWidget {
  const ConnectWebSocketButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final websocketStatus = ref.watch(websocketStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    return ConnectButton(
      selectedId: selectedId,
      sentRequestId: sentRequestId,
      websocketStatus: websocketStatus!,
      onConnect: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .initiateWebSocketConnection(selectedId!);
      },
      onDisconnect: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .closeWebSocketConnection(selectedId!);
      },
    );
  }
}
