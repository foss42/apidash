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
  final DartHttpCodeGen dartHttpCodeGen = DartHttpCodeGen();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activeRequestModel = ref.watch(activeRequestModelProvider);
    var codeTheme = Theme.of(context).brightness == Brightness.light
        ? kLightCodeTheme
        : kDarkCodeTheme;
    final textContainerdecoration = BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
              Colors.black)
          : Color.alphaBlend(
              Theme.of(context).colorScheme.surface.withOpacity(0.2),
              Colors.white),
      border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
      borderRadius: kBorderRadius8,
    );

    final code = dartHttpCodeGen.getCode(activeRequestModel!);
    if (code == null) {
      return const ErrorMessage(
        message: "An error was encountered while generating code. $kRaiseIssue",
      );
    } else {
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
                  CopyButton(toCopy: code),
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
                  code: code,
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
}
