import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class FormDataFileButton extends StatelessWidget {
  const FormDataFileButton({
    super.key,
    this.onPressed,
    this.initialValue,
  });

  final VoidCallback? onPressed;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    return ADFilledButton(
      icon: Icons.snippet_folder_rounded,
      iconSize: kButtonIconSizeLarge,
      label: (initialValue == null || initialValue!.isEmpty)
          ? kLabelSelectFile
          : initialValue!,
      labelTextStyle: kFormDataButtonLabelTextStyle(ds.scaleFactor),
      buttonStyle: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(kDataTableRowHeight),
        shape: const RoundedRectangleBorder(
          borderRadius: kBorderRadius6,
        ),
      ),
      isTonal: true,
      onPressed: onPressed,
    );
  }
}
