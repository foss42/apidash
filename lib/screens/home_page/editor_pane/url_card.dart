import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/consts.dart';

class EditorPaneRequestURLCard extends StatelessWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile =
        kIsMobile && MediaQuery.sizeOf(context).width < kMinWindowSize.width;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
        borderRadius: kBorderRadius12,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: !isMobile ? 20 : 6,
        ),
        child: isMobile
            ? const Row(
                children: [
                  DropdownButtonHTTPMethod(),
                  kHSpacer5,
                  Expanded(
                    child: URLTextField(),
                  ),
                  SizedBox.shrink(),
                ],
              )
            : const Row(
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
                  )
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
    final method = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.method));
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
          ?.httpRequestModel
          ?.url,
      onChanged: (value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(selectedId, url: value);
      },
      onFieldSubmitted: (value) {
        ref
            .read(collectionStateNotifierProvider.notifier)
            .sendRequest(selectedId);
      },
    );
  }
}

class SendButton extends ConsumerWidget {
  final Function()? onTap;
  const SendButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final isWorking = ref.watch(
        selectedRequestModelProvider.select((value) => value?.isWorking));

    return SendRequestButton(
      isWorking: isWorking ?? false,
      onTap: () {
        onTap?.call();
        ref
            .read(collectionStateNotifierProvider.notifier)
            .sendRequest(selectedId!);
      },
    );
  }
}
