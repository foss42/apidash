import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DropdownButtonAPIType extends StatelessWidget {
  const DropdownButtonAPIType({
    super.key,
    this.apiType,
    this.onChanged,
  });

  final APIType? apiType;
  final void Function(APIType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<APIType>(
      value: apiType,
      values: APIType.values.map((e) => (e, e.label)),
      onChanged: onChanged,
      isDense: true,
    );
  }
}
