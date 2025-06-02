import 'package:apidash/dashbot/core/model/dashbot_window_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashbot_window_notifier.g.dart';

@Riverpod(keepAlive: true)
class DashbotWindowNotifier extends _$DashbotWindowNotifier {
  @override
  DashbotWindowModel build() {
    return const DashbotWindowModel();
  }

  void updatePosition(double dx, double dy, Size screenSize) {
    state = state.copyWith(
      right: (state.right - dx).clamp(0, screenSize.width - state.width),
      bottom: (state.bottom - dy).clamp(0, screenSize.height - state.height),
    );
  }

  void updateSize(double dx, double dy, Size screenSize) {
    final newWidth =
        (state.width - dx).clamp(300, screenSize.width + state.right);
    final newHeight =
        (state.height - dy).clamp(300, screenSize.height + state.bottom);

    state = state.copyWith(
      width: newWidth as double,
      height: newHeight as double,
    );
  }

  void toggleActive() {
    state = state.copyWith(isActive: !state.isActive);
  }
}
