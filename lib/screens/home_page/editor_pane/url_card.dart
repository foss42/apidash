import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../common_widgets/common_widgets.dart';

class EditorPaneRequestURLCard extends ConsumerWidget {
  const EditorPaneRequestURLCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final apiType = ref
        .watch(selectedRequestModelProvider.select((value) => value?.apiType));
    return Card(
      color: kColorTransparent,
      surfaceTintColor: kColorTransparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        borderRadius: kBorderRadius12,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: !context.isMediumWindow ? 20 : 6,
        ),
        child: context.isMediumWindow
            ? Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.webSocket => kSizedBoxEmpty,
                    null => kSizedBoxEmpty,
                  },
                  switch (apiType) {
                    APIType.rest => kHSpacer5,
                    _ => kHSpacer8,
                  },
                  const Expanded(
                    child: URLTextField(),
                  ),
                ],
              )
            : Row(
                children: [
                  switch (apiType) {
                    APIType.rest => const DropdownButtonHTTPMethod(),
                    APIType.graphql => kSizedBoxEmpty,
                    APIType.webSocket => kSizedBoxEmpty,
                    null => kSizedBoxEmpty,
                  },
                  switch (apiType) {
                    APIType.rest => kHSpacer20,
                    _ => kHSpacer8,
                  },
                  switch(apiType){
                  APIType.webSocket => const Expanded(
                    child: URLwebSocketTextField(),
                  ),
                  _ =>  const Expanded(
                    child: URLTextField(),
                  ),


                  },
                  kHSpacer20,
                  switch (apiType) {
                    APIType.rest || APIType.graphql => const SendRequestButton(),
                    APIType.webSocket =>const ConnectionRequestButton(),
                    null => kSizedBoxEmpty,
                  },
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
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(method: value);
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

    return EnvURLField(
      selectedId: selectedId!,
      initialValue: ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.url)),
      // onChanged: (value) {
      //
      //   ref.read(collectionStateNotifierProvider.notifier).update(url: value);
      // },
      onFieldSubmitted: (value) {
        ref.read(collectionStateNotifierProvider.notifier).update(url: value);
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
    );
  }
}

class URLwebSocketTextField extends ConsumerWidget {
  const URLwebSocketTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);

    return EnvURLField(
      selectedId: selectedId!,
      initialValue: ref.watch(selectedRequestModelProvider
          .select((value) => value?.webSocketRequestModel?.url)),
      onChanged: (value) {

        ref.read(collectionStateNotifierProvider.notifier).update(url: value);
      },
      onFieldSubmitted: (value) {
        ref.read(collectionStateNotifierProvider.notifier).sendRequest();
      },
    );
  }
}

class SendRequestButton extends ConsumerWidget {
  final Function()? onTap;
  const SendRequestButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final isWorking = ref.watch(
        selectedRequestModelProvider.select((value) => value?.isWorking));
    return SendButton(
      isWorking: isWorking ?? false,
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


class ConnectionRequestButton extends ConsumerWidget {
  final Function()? onTap;
  const ConnectionRequestButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(selectedIdStateProvider);
    final isConnected = ref.watch(
        selectedRequestModelProvider.select((value) => value?.webSocketRequestModel!.isConnected));
    return ConnectionButton(
      isConnected:isConnected?? false,
      onTap: () {
        onTap?.call();
        ref.read(collectionStateNotifierProvider.notifier).connect();
      },
      onDisconnect: () {
        onTap?.call();
        ref.read(collectionStateNotifierProvider.notifier).disconnect();
        
      },
    );
  }
}