import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

class DashbotWindowNotifier extends StateNotifier<DashbotWindowModel> {
  DashbotWindowNotifier() : super(const DashbotWindowModel());

  void updatePosition(double dx, double dy, Size screenSize) {
    state = state.copyWith(
      right: (state.right - dx).clamp(0, screenSize.width - state.width),
      bottom: (state.bottom - dy).clamp(0, screenSize.height - state.height),
    );
  }

  void updateSize(double dx, double dy, Size screenSize) {
    final newWidth =
        (state.width - dx).clamp(400, screenSize.width - state.right);
    final newHeight =
        (state.height - dy).clamp(515, screenSize.height - state.bottom);

    state = state.copyWith(
      width: newWidth.toDouble(),
      height: newHeight.toDouble(),
    );
  }

  void toggleActive() {
    state = state.copyWith(isActive: !state.isActive);
  }

  void togglePopped() {
    state = state.copyWith(isPopped: !state.isPopped);
  }

  void hide() {
    if (!state.isHidden) state = state.copyWith(isHidden: true);
  }

  void show() {
    if (state.isHidden) state = state.copyWith(isHidden: false);
  }
}

final dashbotWindowNotifierProvider =
    StateNotifierProvider<DashbotWindowNotifier, DashbotWindowModel>((ref) {
  return DashbotWindowNotifier();
});
