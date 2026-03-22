import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/dashbot/models/models.dart';
import 'package:apidash/dashbot/providers/providers.dart';

import '../../providers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const screen = Size(1200, 800);

  ProviderContainer newContainer() => createContainer();

  group('DashbotWindowNotifier initial state', () {
    test('defaults match model defaults', () {
      final c = newContainer();
      final state = c.read(dashbotWindowNotifierProvider);
      expect(state, const DashbotWindowModel());
      expect(state.width, 400);
      expect(state.height, 515);
      expect(state.right, 50);
      expect(state.bottom, 100);
      expect(state.isActive, false);
      expect(state.isPopped, true);
      expect(state.isHidden, false);
    });
  });

  group('DashbotWindowNotifier behavior', () {
    test('toggleActive flips flag', () {
      final c = newContainer();
      final notifier = c.read(dashbotWindowNotifierProvider.notifier);
      expect(c.read(dashbotWindowNotifierProvider).isActive, false);
      notifier.toggleActive();
      expect(c.read(dashbotWindowNotifierProvider).isActive, true);
      notifier.toggleActive();
      expect(c.read(dashbotWindowNotifierProvider).isActive, false);
    });

    test('togglePopped flips flag', () {
      final c = newContainer();
      final notifier = c.read(dashbotWindowNotifierProvider.notifier);
      expect(c.read(dashbotWindowNotifierProvider).isPopped, true);
      notifier.togglePopped();
      expect(c.read(dashbotWindowNotifierProvider).isPopped, false);
      notifier.togglePopped();
      expect(c.read(dashbotWindowNotifierProvider).isPopped, true);
    });

    group('updatePosition clamping & math', () {
      test('basic drag left/up updates right & bottom correctly', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        notifier.updatePosition(-100, 50, screen); // left 100, down 50
        final s = c.read(dashbotWindowNotifierProvider);
        expect(s.right, 150); // 50 - (-100)
        expect(s.bottom, 50); // 100 - 50
      });

      test('drag beyond left clamps to max width constraint', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        notifier.updatePosition(-2000, 0, screen); // huge left drag
        final s = c.read(dashbotWindowNotifierProvider);
        // max allowed = screen.width - state.width = 1200 - 400 = 800
        expect(s.right, 800);
      });

      test('drag beyond bottom clamps', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        notifier.updatePosition(
            0, -2000, screen); // huge up drag (dy negative -> move up)
        final s = c.read(dashbotWindowNotifierProvider);
        // bottom increases but capped: screen.height - height = 800 - 515 = 285
        expect(s.bottom, 285);
      });
    });

    group('updateSize clamping & math', () {
      test('normal increase size', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        notifier.updateSize(-100, -50, screen); // grow
        final s = c.read(dashbotWindowNotifierProvider);
        expect(s.width, 500); // 400 - (-100)
        expect(s.height, 565); // 515 - (-50)
      });

      test('shrink below minimum clamps to min (width=400,height=515)', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        notifier.updateSize(999, 999, screen); // attempt overshrink
        final s = c.read(dashbotWindowNotifierProvider);
        expect(s.width, 400);
        expect(s.height, 515);
      });

      test('expand beyond screen clamps to max available', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        notifier.updateSize(-5000, -5000, screen);
        final s = c.read(dashbotWindowNotifierProvider);
        // max width = screen.width - right (initial right=50) => 1150 but min width 400 ensures logic; growth hits clamp
        expect(s.width, 1150);
        // max height = screen.height - bottom (initial bottom=100) => 700
        expect(s.height, 700);
      });
    });

    group('hide/show', () {
      test('hide sets isHidden true only once', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        expect(c.read(dashbotWindowNotifierProvider).isHidden, false);
        notifier.hide();
        expect(c.read(dashbotWindowNotifierProvider).isHidden, true);
        // second hide should not toggle back
        notifier.hide();
        expect(c.read(dashbotWindowNotifierProvider).isHidden, true);
      });

      test('show sets isHidden false only if hidden', () {
        final c = newContainer();
        final notifier = c.read(dashbotWindowNotifierProvider.notifier);
        notifier.hide();
        expect(c.read(dashbotWindowNotifierProvider).isHidden, true);
        notifier.show();
        expect(c.read(dashbotWindowNotifierProvider).isHidden, false);
        // calling show again keeps it false
        notifier.show();
        expect(c.read(dashbotWindowNotifierProvider).isHidden, false);
      });
    });
  });
}
