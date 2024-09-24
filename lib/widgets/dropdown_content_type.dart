import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';

class DropdownButtonContentType extends ConsumerWidget {
  const DropdownButtonContentType({
    super.key,
    this.contentType,
    this.onChanged,
  });

  final ContentType? contentType;
  final void Function(ContentType?)? onChanged;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // Get screen scaling factor based on screen size
    final settings = ref.watch(settingsProvider);
    double scaleFactor = settings.scaleFactor;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<ContentType>(
      focusColor: surfaceColor,
      value: contentType,
      icon: Icon(
        Icons.unfold_more_rounded,
        size: 16 * scaleFactor, // Scaled icon size
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14 * scaleFactor, // Scaled font size
      ),
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      borderRadius: BorderRadius.circular(12 * scaleFactor), // Scaled border radius
      items: ContentType.values
          .map<DropdownMenuItem<ContentType>>((ContentType value) {
        return DropdownMenuItem<ContentType>(
          value: value,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 ), // Scaled padding
            child: Text(
              value.name,
              style: kTextStyleButton.copyWith(
                fontSize: 14 * scaleFactor, // Scaled font size
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
