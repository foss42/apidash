import 'package:apidash_core/apidash_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/widgets/widgets.dart';

class SendRequestButton extends ConsumerWidget {
  final Function()? onTap;
  const SendRequestButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final isWorking = ref.watch(
      selectedRequestModelProvider.select((value) => value?.isWorking),
    );
    final isStreaming = ref.watch(
      selectedRequestModelProvider.select((value) => value?.isStreaming),
    );

    final apiType = ref.watch(
      selectedRequestModelProvider.select((value) => value?.apiType),
    );

    return SendButton(
      isStreaming: isStreaming ?? false,
      isWorking: isWorking ?? false,
      sendLabel: apiType == APIType.websocket ? "Connect" : kLabelSend,
      activeLabel: apiType == APIType.websocket ? "Disconnect" : null,
      onTap: () {
        onTap?.call();
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
      onCancel: () {
        ref.read(collectionStateNotifierProvider.notifier).cancelRequest();
      },
    );
  }
}
