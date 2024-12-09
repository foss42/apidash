import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DropdownButtonProtocol extends StatelessWidget {
  const DropdownButtonProtocol({
    super.key,
    this.protocol,
    this.onChanged,
  });

  final Protocol? protocol;
  final void Function(Protocol?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<Protocol>(
      value: protocol,
      values: Protocol.values.map((e) => (e, e.label)),
      onChanged: onChanged,
      isDense: true,
    );
  }
}
