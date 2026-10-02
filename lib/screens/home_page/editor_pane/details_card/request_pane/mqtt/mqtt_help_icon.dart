import 'package:flutter/material.dart';

/// A small plain-language help affordance for the MQTT request pane.
///
/// Renders the same idiom the app already uses for auth-field help
/// (`EnvAuthField.infoText`): a subtle `help_outline` icon that reveals a
/// short, jargon-free explanation. On desktop the overlay appears on hover
/// (Windows-Explorer style); on touch it appears on tap — both handled by
/// Flutter's [Tooltip].
///
/// Attach it to a control's LABEL or place it as a small ADJACENT icon; never
/// wrap the interactive field/switch itself, so the control's own typing/
/// toggling gesture is never swallowed.
class MqttHelpIcon extends StatelessWidget {
  const MqttHelpIcon(
    this.message, {
    super.key,
    this.size = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 4.0),
  });

  /// The plain-language help text shown in the overlay.
  final String message;

  /// Icon size. Defaults to 14 to match `EnvAuthField`'s inline help icon.
  final double size;

  /// Padding around the icon (keeps the tap target comfortable without
  /// enlarging the visible glyph).
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: const Duration(seconds: 5),
      child: Padding(
        padding: padding,
        child: Icon(
          Icons.help_outline_rounded,
          color: Theme.of(context).colorScheme.primaryFixedDim,
          size: size,
        ),
      ),
    );
  }
}
