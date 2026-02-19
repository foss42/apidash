import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:apidash_design_system/ui/design_system_provider.dart';
import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import '../consts.dart';

class EnvironmentPopupMenu extends StatelessWidget {
  const EnvironmentPopupMenu({
    super.key,
    this.value,
    this.options,
    this.onChanged,
  });

  final EnvironmentModel? value;
  final void Function(EnvironmentModel? value)? onChanged;
  final List<EnvironmentModel>? options;

  @override
  Widget build(BuildContext context) {
    final ds = DesignSystemProvider.of(context);
    final double width = context.isCompactWindow ? 100 : 130;

    return ADPopupMenu<EnvironmentModel?>(
      value: value == null
          ? "Select Env."
          : value?.id == kGlobalEnvironmentId
              ? "Global"
              : getEnvironmentTitle(value?.name),
      values: options?.map((e) => (
                e,
                (e.id == kGlobalEnvironmentId)
                    ? "Global"
                    : getEnvironmentTitle(e.name).clip(30)
              )) ??
          [],
      width: width*ds.scaleFactor,
      tooltip: "Select Environment",
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}
