import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DefaultUriSchemePopupMenu extends StatelessWidget {
  const DefaultUriSchemePopupMenu({
    super.key,
    this.value,
    this.onChanged,
  });

  final SupportedUriSchemes? value;
  final void Function(SupportedUriSchemes? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final double width = context.isCompactWindow ? 90 : 110;
    return ADPopupMenu<SupportedUriSchemes>(
      value: value?.name,
      values: SupportedUriSchemes.values.map((e) => (e, e.name)),
      width: width,
      tooltip: "Select Default URI Scheme",
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}

class DefaultWsSchemePopupMenu extends StatelessWidget {
  const DefaultWsSchemePopupMenu({
    super.key,
    this.value,
    this.onChanged,
  });

  final SupportedWsSchemes? value;
  final void Function(SupportedWsSchemes? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final double width = context.isCompactWindow ? 90 : 110;
    return ADPopupMenu<SupportedWsSchemes>(
      value: value?.name,
      values: SupportedWsSchemes.values.map((e) => (e, e.name)),
      width: width,
      tooltip: "Select Default WebSocket Scheme",
      onChanged: onChanged,
      isOutlined: true,
    );
  }
}
