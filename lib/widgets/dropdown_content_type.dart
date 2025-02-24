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

  String? _getDisplayName(ContentType type) {
    if (type == ContentType.formdata ||
        type == ContentType.xwwwformurlencoded) {
      return "Form Data";
    }
    return type.name;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTypes = ContentType.values
        .where((type) => type != ContentType.xwwwformurlencoded)
        .toList();

    return ADDropdownButton<ContentType>(
      value: contentType,
      values: filteredTypes.map((e) => (e, _getDisplayName(e))).toList(),
      onChanged: onChanged,
      iconSize: 16,
    );
  }
}
