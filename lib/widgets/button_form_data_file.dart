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
    return FilledButton.tonalIcon(
      icon: const Icon(
        Icons.snippet_folder_rounded,
        size: 20,
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(kDataTableRowHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      onPressed: onPressed,
      label: Text(
        (initialValue == null || initialValue!.isEmpty)
            ? kLabelSelectFile
            : initialValue!,
        overflow: TextOverflow.ellipsis,
        style: kFormDataButtonLabelTextStyle,
      ),
    );
  }
}
