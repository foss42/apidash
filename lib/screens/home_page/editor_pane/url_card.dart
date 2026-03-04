import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    
    // Watch the global setting
    final showUrlPreview = ref.watch(settingsProvider.select((value) => value.showUrlPreview));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
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
        ),
        // RENDER ONLY IF SETTING IS ENABLED
        if (showUrlPreview) const URLPreviewer(),
      ],
    );
  }
}

class URLPreviewer extends ConsumerWidget {
  const URLPreviewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return const SizedBox.shrink();

    final requestModel = ref.watch(selectedRequestModelProvider);
    if (requestModel == null || requestModel.apiType == APIType.ai) {
      return const SizedBox.shrink();
    }

    final httpRequest = requestModel.httpRequestModel;
    if (httpRequest == null) return const SizedBox.shrink();

    String baseUrl = httpRequest.url ?? "";
    final params = httpRequest.params;
    final isEnabledList = httpRequest.isParamEnabledList;

    // Only show if there are actual params to display
    if (params == null || params.isEmpty) return const SizedBox.shrink();

    // Map<String, List<String>> supports duplicate keys (e.g. ?id=1&id=2)
    // We use List<String> here to satisfy Issue #268 while complying with Copilot's request
    // to use the standard Uri class.
    final Map<String, List<String>> queryParams = {};

    for (int i = 0; i < params.length; i++) {
      // Safety Check: If lists are out of sync, default to true
      final isEnabled = (isEnabledList != null && i < isEnabledList.length)
          ? isEnabledList[i]
          : true;

      if (isEnabled) {
        final p = params[i];
        if (p.name.isNotEmpty) {
          if (!queryParams.containsKey(p.name)) {
            queryParams[p.name] = [];
          }
          queryParams[p.name]!.add(p.value);
        }
      }
    }

    if (queryParams.isEmpty) {
      return const SizedBox.shrink();
    }

    String fullUrl;
    try {
      final Uri baseUri = Uri.parse(baseUrl.trim());
      // The 'queryParameters' argument in Uri.replace accepts Map<String, dynamic>.
      // If the value is an Iterable (List), it automatically generates duplicate keys.
      fullUrl = baseUri.replace(queryParameters: queryParams).toString();
    } catch (e) {
      // Visual Fallback if parsing fails (e.g. user is still typing)
      fullUrl = "$baseUrl${baseUrl.contains('?') ? '&' : '?' }...";
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          Icon(
            Icons.link,
            size: 12,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fullUrl,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: 'monospace',
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // FIX: Added Accessibility (Tooltip + Semantics)
          Tooltip(
            message: 'Copy URL to clipboard',
            child: Semantics(
              button: true,
              label: 'Copy URL to clipboard',
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: fullUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("URL copied to clipboard"),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Icon(
                  Icons.copy,
                  size: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
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
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.aiRequestModel?.url));
    ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.url));
    final requestModel = ref
        .read(collectionStateNotifierProvider.notifier)
        .getRequestModel(selectedId!)!;
    return EnvURLField(
      selectedId: selectedId,
      initialValue: switch (requestModel.apiType) {
        APIType.ai => requestModel.aiRequestModel?.url,
        _ => requestModel.httpRequestModel?.url,
      },
      onChanged: (value) {
        if (requestModel.apiType == APIType.ai) {
          ref.read(collectionStateNotifierProvider.notifier).update(
              aiRequestModel:
                  requestModel.aiRequestModel?.copyWith(url: value));
        } else {
          ref.read(collectionStateNotifierProvider.notifier).update(url: value);
        }
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