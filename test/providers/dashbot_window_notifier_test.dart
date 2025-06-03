import 'dart:developer';
import 'dart:ui';

import 'package:apidash/dashbot/core/model/dashbot_window_model.dart';
import 'package:apidash/dashbot/core/providers/dashbot_window_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  const testScreenSize = Size(1200, 800);

  group("DashbotWindowNotifier - ", () {
    test(
        'given dashbot window model when instatiated then initial values must match the default values',
        () {
      final container = createContainer();

      final initialState = container.read(dashbotWindowNotifierProvider);

      expect(initialState, const DashbotWindowModel());
      expect(initialState.width, 350);
      expect(initialState.height, 450);
      expect(initialState.right, 50);
      expect(initialState.bottom, 100);
      expect(initialState.isActive, false);
    });

    group('Position updates', () {
      test(
          'given dashbot window notifier when position is updated 100px to the left and 50px down then then values must be 150 and 50',
          () {
        final container = createContainer();
        final notifier = container.read(dashbotWindowNotifierProvider.notifier);

        // Drag 100px left and 50px down
        notifier.updatePosition(-100, 50, testScreenSize);

        final state = container.read(dashbotWindowNotifierProvider);
        expect(state.right, 50 - (-100)); // 50 - (-100) = 150
        expect(state.bottom, 100 - 50); // 100 - 50 = 50
      });

      test('Drag beyond left boundary', () {
        final container = createContainer();
        final notifier = container.read(dashbotWindowNotifierProvider.notifier);

        // Try to drag 1200px left (dx positive when moving right in coordinates)
        notifier.updatePosition(-1200, 0, testScreenSize);

        final state = container.read(dashbotWindowNotifierProvider);
        expect(state.right,
            850); // 50 - (-1200) = 1250 → not within bounds max is screen width(1200) - width(350) = 850
      });

      test('Drag beyond bottom boundary', () {
        final container = createContainer();
        final notifier = container.read(dashbotWindowNotifierProvider.notifier);

        // Move to bottom edge
        notifier.updatePosition(0, -700, testScreenSize);

        final state = container.read(dashbotWindowNotifierProvider);
        // 100 - (-700) = 800 → but max is screenHeight(800) - height(450) = 350
        expect(state.bottom, 350);
      });
    });
  });
}
