import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DropdownButtonContentType extends StatelessWidget {
  const DropdownButtonContentType({
    super.key,
    this.contentType,
    this.onChanged,
  });

  final ContentType? contentType;
  final void Function(ContentType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<ContentType>(
      value: contentType,
      values: ContentType.values.map((e) => (e, e.name)),
      onChanged: onChanged,
      iconSize: 16,
    );
  }
}
