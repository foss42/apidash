import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../consts.dart';

class OverlayWidgetTemplate {
  OverlayEntry? _overlay;
  BuildContext context;
  OverlayState? _overlayState;

  OverlayWidgetTemplate({required this.context}) {
    _overlayState = Overlay.of(context);
  }

  void show({required Widget widget, Alignment alignment = Alignment.topRight, EdgeInsets? margin}) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => Positioned(
          top: margin?.top ?? 20,
          right: margin?.right ?? 20,
          child: Material(
            color: Colors.transparent, // Ensure transparent background for the overlay
            child: widget,
          ),
        ),
      );
      _overlayState!.insert(_overlay!);
    }
  }

  void hide() {
    if (_overlay != null) {
      _overlay?.remove();
      _overlay = null;
    }
  }
}

class SavingOverlay extends StatelessWidget {
  final bool saveCompleted;
  const SavingOverlay({super.key, required this.saveCompleted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: kPh60v60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                  saveCompleted ? kAssetSavedLottie : kAssetSavingLottie,
                  width: 40,
                  height: 40),
              kHSpacer20,
              Text(
                saveCompleted ? kLabelSaved : kLabelSaving,
                style: const TextStyle(
                  fontSize: kDefaultFontSize,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
