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
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<ContentType>(
      focusColor: surfaceColor,
      value: contentType,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      borderRadius: kBorderRadius12,
      items: ContentType.values
          .map<DropdownMenuItem<ContentType>>((ContentType value) {
        return DropdownMenuItem<ContentType>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: Text(
              value.name,
              style: kTextStyleButton,
            ),
          ),
        );
      }).toList(),
    );
  }
}
