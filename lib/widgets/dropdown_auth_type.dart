import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DropdownButtonAuthTypeSelection extends StatelessWidget {
  const DropdownButtonAuthTypeSelection({
    super.key,
    this.authType,
    this.onChanged,
  });

  final AuthType? authType;
  final void Function(AuthType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<AuthType>(
      value: authType,
      values: AuthType.values.map((e) => (e, e.name)),
      onChanged: onChanged,
      iconSize: 16,
    );
  }
}
