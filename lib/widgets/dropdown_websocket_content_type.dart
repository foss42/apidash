import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

class DropdownButtonContentTypeWebSocket extends StatelessWidget {
  const DropdownButtonContentTypeWebSocket({
    super.key,
    this.contentType,
    this.onChanged,
  });

  final ContentTypeWebSocket? contentType;
  final void Function(ContentTypeWebSocket?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ADDropdownButton<ContentTypeWebSocket>(
      value: contentType,
      values: ContentTypeWebSocket.values.map((e) => (e, e.name)),
      onChanged: onChanged,
      iconSize: 16,
    );
  }
}
