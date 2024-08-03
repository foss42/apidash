import 'package:flutter/material.dart';
import 'package:apidash/consts.dart';

class FilledButtonGroup extends StatelessWidget {
  const FilledButtonGroup({super.key, required this.buttons});

  final List<ButtonData> buttons;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final showLabel = constraints.maxWidth > buttons.length * 110;
      List<Widget> buttonWidgets = buttons
          .map((button) =>
              FilledButtonWidget(buttonData: button, showLabel: showLabel))
          .toList();

      List<Widget> buttonsWithSpacers = [];
      for (int i = 0; i < buttonWidgets.length; i++) {
        buttonsWithSpacers.add(buttonWidgets[i]);
        if (i < buttonWidgets.length - 1) {
          buttonsWithSpacers.add(kHSpacer2);
        }
      }
      return ClipRRect(
        borderRadius: kBorderRadius20,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: buttonsWithSpacers,
        ),
      );
    });
  }
}

class FilledButtonWidget extends StatelessWidget {
  const FilledButtonWidget(
      {super.key, required this.buttonData, this.showLabel = true});

  final ButtonData buttonData;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(buttonData.icon, size: 20);
    final label = Text(
      buttonData.label,
      style: kTextStyleButton,
    );
    return Tooltip(
      message: buttonData.tooltip,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
            minimumSize: const Size(44, 44),
            padding: kPh12,
            shape: const ContinuousRectangleBorder()),
        onPressed: buttonData.onPressed,
        label: showLabel
            ? Row(
                children: [
                  icon,
                  kHSpacer4,
                  label,
                ],
              )
            : icon,
      ),
    );
  }
}
