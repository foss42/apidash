import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class HistoryRetentionPopupMenu extends StatelessWidget {
  const HistoryRetentionPopupMenu({
    super.key,
    this.value,
    this.onChanged,
  });

  final HistoryRetentionPeriod? value;
  final void Function(HistoryRetentionPeriod? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    const double width = 120;
    return ADPopupMenu<HistoryRetentionPeriod>(
      value: value?.label,
      values: HistoryRetentionPeriod.values.map((e) => (e, e.label)),
      width: width,
      tooltip: "Select retention period",
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}
