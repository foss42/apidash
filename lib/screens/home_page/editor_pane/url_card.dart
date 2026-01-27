import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import '../../common_widgets/common_widgets.dart';
import 'expanded_url_editor.dart';

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
                    APIType.ai => const AIModelSelector(),
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
                    APIType.ai => const AIModelSelector(),
                    null => kSizedBoxEmpty,
                  },
                  switch (apiType) {
                    APIType.rest => kHSpacer20,
                    _ => kHSpacer8,
                  },
                  const Expanded(
                    child: URLTextField(),
                  ),
                  kHSpacer20,
                  const SizedBox(
                    height: 36,
                    child: SendRequestButton(),
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
        ref
            .read(collectionStateNotifierProvider.notifier)
            .update(method: value);
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
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedIdStateProvider);
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.aiRequestModel?.url));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.url));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;
    
    final initialValue = switch (requestModel.apiType) {
      APIType.ai => requestModel.aiRequestModel?.url,
      _ => requestModel.httpRequestModel?.url,
    };

    void updateUrl(String value) {
      if (requestModel.apiType == APIType.ai) {
        ref.read(collectionStateNotifierProvider.notifier).update(
            aiRequestModel:
                requestModel.aiRequestModel?.copyWith(url: value));
      } else {
        ref.read(collectionStateNotifierProvider.notifier).update(url: value);
      }
    }

    return GestureDetector(
      onScaleUpdate: (details) async {
        if (details.scale > 1.5 && !_isNavigating) {
          _isNavigating = true;
          // HapticFeedback.mediumImpact(); // Optional: Add haptic feedback
          await showDialog(
            context: context,
            builder: (context) => ExpandedURLEditor(
              selectedId: selectedId,
              initialValue: initialValue,
              onChanged: updateUrl,
              onFieldSubmitted: (value) {
                 updateUrl(value);
                 ref.read(collectionStateNotifierProvider.notifier).sendRequest();
              },
            ),
          );
          if (mounted) {
            setState(() {
              _isNavigating = false;
            });
          }
        }
      },
      child: EnvURLField(
        selectedId: selectedId,
        initialValue: initialValue,
        onChanged: updateUrl,
        onFieldSubmitted: (value) {
          ref.read(collectionStateNotifierProvider.notifier).sendRequest();
        },
      ),
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
    final isStreaming = ref.watch(
        selectedRequestModelProvider.select((value) => value?.isStreaming));

    return SendButton(
      isStreaming: isStreaming ?? false,
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
