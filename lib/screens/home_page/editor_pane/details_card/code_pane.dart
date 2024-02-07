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

    final selectedRequestModel = ref.watch(selectedRequestModelProvider);
    final defaultUriScheme =
        ref.watch(settingsProvider.select((value) => value.defaultUriScheme));

    final code = codegen.getCode(
        codegenLanguage, selectedRequestModel!, defaultUriScheme);
    if (code == null) {
      return const ErrorMessage(
        message: "An error was encountered while generating code. $kRaiseIssue",
      );
    }
    return ViewCodePane(
      code: code,
      codegenLanguage: codegenLanguage,
      onChangedCodegenLanguage: (CodegenLanguage? value) {
        ref.read(codegenLanguageStateProvider.notifier).state = value!;
      },
    );
  }
}
