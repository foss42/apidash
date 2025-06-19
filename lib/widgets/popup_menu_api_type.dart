import 'package:apidash/consts.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class APITypePopupMenu extends StatelessWidget {
  const APITypePopupMenu({
    super.key,
    required this.apiType,
    this.onChanged,
  });

  final APIType? apiType;
  final void Function(APIType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADPopupMenu<APIType>(
      tooltip: "Select API Type",
      width: kIsMobile ? 80 : 100,
      value: apiType?.label,
      values: APIType.values.map((e) => (e, e.label)),
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}
