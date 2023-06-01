import 'package:apidash/utils/convert_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/widgets.dart';
import 'package:apidash/codegen/codegen.dart';
import 'package:apidash/consts.dart';

class CodePane extends ConsumerStatefulWidget {
  const CodePane({super.key});

  @override
  ConsumerState<CodePane> createState() => _CodePaneState();
}

class _CodePaneState extends ConsumerState<CodePane> {
  final Codegen codegen = Codegen();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CodegenLanguage codegenLanguage =
        ref.watch(codegenLanguageStateProvider);

    final activeRequestModel = ref.watch(activeRequestModelProvider);
    final defaultUriScheme =
        ref.watch(settingsProvider.select((value) => value.defaultUriScheme));

    final code =
        codegen.getCode(codegenLanguage, activeRequestModel!, defaultUriScheme);
    if (code == null) {
      return const ErrorMessage(
        message: "An error was encountered while generating code. $kRaiseIssue",
      );
    }
    return ViewCodePane(
      code: code,
    );
  }
}

class ViewCodePane extends ConsumerStatefulWidget {
  const ViewCodePane({
    super.key,
    required this.code,
  });

  final String code;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewCodePaneState();
}

class _ViewCodePaneState extends ConsumerState<ViewCodePane> {
  @override
  Widget build(BuildContext context) {
    var codeTheme = Theme.of(context).brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;
    final textContainerdecoration = BoxDecoration(
      color: Color.alphaBlend(
          (Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.primaryContainer)
              .withOpacity(kForegroundOpacity),
          Theme.of(context).colorScheme.surface),
      border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
      borderRadius: kBorderRadius8,
    );

    return Padding(
      padding: kP10,
      child: Column(
        children: [
          SizedBox(
            height: kHeaderHeight,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Code",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                DropdownButtonCodegenLanguage(
                  codegenLanguage: ref.watch(codegenLanguageStateProvider),
                  onChanged: (CodegenLanguage? value) {
                    ref
                        .read(codegenLanguageStateProvider.notifier)
                        .update((state) => value!);
                  },
                ),
                CopyButton(toCopy: widget.code),
                SaveInDownloadsButton(
                  content: stringToBytes(widget.code),
                  mimeType: "application/vnd.dart",
                )
              ],
            ),
          ),
          kVSpacer10,
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: kP8,
              decoration: textContainerdecoration,
              child: CodeGenPreviewer(
                code: widget.code,
                theme: codeTheme,
                language: 'dart',
                textStyle: kCodeStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
