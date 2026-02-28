import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DropdownButtonFormData extends StatelessWidget {
  const DropdownButtonFormData({
    super.key,
    this.formDataType,
    this.onChanged,
  });

  final FormDataType? formDataType;
  final void Function(FormDataType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<FormDataType>(
      value: formDataType,
      values: FormDataType.values.map((e) => (e, e.name)),
      onChanged: onChanged,
      iconSize: 16,
    );
  }
}
