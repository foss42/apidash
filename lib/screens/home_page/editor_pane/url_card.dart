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
          children: getWidgets(protocol!),
        ),
      ),
    );
  }

  List<Widget> getWidgets(ProtocolType protocol) {
    final List<Widget> httpURLWidgets = [
      const DropdownButtonProtocol(),
      kHSpacer20,
      const DropdownButtonHTTPMethod(),
      kHSpacer20,
      const Expanded(
        child: URLTextField(),
      ),
      kHSpacer20,
      const SizedBox(
        height: 36,
        child: SendButton(),
      ),
    ];
    final List<Widget> mqttv3URLWidgets = [
      const DropdownButtonProtocol(),
      kHSpacer20,
      const Expanded(
        child: URLTextField(),
      ),
      kHSpacer20,
      VerticalDivider(
        thickness: 1,
        width: 1,
        color: Colors.white,
      ),
      Expanded(child: ClientIdField()),
      const SizedBox(
        height: 36,
        child: ConnectButton(),
      ),
    ];
    switch (protocol) {
      case ProtocolType.http:
        return httpURLWidgets;
      case ProtocolType.mqttv3:
        return mqttv3URLWidgets;
      default:
        return httpURLWidgets;
    }
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
      protocolType: protocol,
      onChanged: (ProtocolType? value) {
        final selectedId = ref.read(selectedRequestModelProvider)!.id;
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(selectedId, protocol: value);
        print('protocol: $value');
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

class ConnectButton extends ConsumerWidget {
  const ConnectButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final sentRequestId = ref.watch(sentRequestIdStateProvider);
    final connectionState = ref.watch(realtimeConnectionStateProvider);
    return ConnectRequestButton(
      selectedId: selectedId,
      sentRequestId: sentRequestId,
      onConnect: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .connectToBroker(selectedId!);
      },
      onDisconnect: () {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .disconnectFromBroker(selectedId!);
      },
      connectionState: connectionState!,
      // onTap: () {
      //   ref
      //       .read(collectionStateNotifierProvider.notifier)
      //       .sendRequest(selectedId!);
      // },
    );
  }
}

class ClientIdField extends StatelessWidget {
  const ClientIdField({
    super.key,
    this.selectedId,
    this.initialValue,
    this.onChanged,
  });

  final String? selectedId;
  final String? initialValue;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key("url-$selectedId"),
      initialValue: initialValue,
      style: kCodeStyle,
      decoration: InputDecoration(
        hintText: kHintTextClientIdCard,
        hintStyle: kCodeStyle.copyWith(
          color: Theme.of(context).colorScheme.outline.withOpacity(
                kHintOpacity,
              ),
        ),
        border: InputBorder.none,
      ),
      onChanged: onChanged,
    );
  }
}
