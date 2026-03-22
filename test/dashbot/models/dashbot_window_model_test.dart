import 'package:apidash/dashbot/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('DashbotWindowModel', () {
    test('default values', () {
      const model = DashbotWindowModel();
      expect(model.width, 400);
      expect(model.height, 515);
      expect(model.right, 50);
      expect(model.bottom, 100);
      expect(model.isActive, false);
      expect(model.isPopped, true);
      expect(model.isHidden, false);
    });

    test('copyWith changes only specified fields', () {
      const original = DashbotWindowModel();
      final updated = original.copyWith(
        width: 420,
        height: 600,
        isActive: true,
        isHidden: true,
      );

      expect(updated.width, 420);
      expect(updated.height, 600);
      expect(updated.isActive, true);
      expect(updated.isHidden, true);

      // Unchanged fields retain original values
      expect(updated.right, original.right);
      expect(updated.bottom, original.bottom);
      expect(updated.isPopped, original.isPopped);

      // Original remains unchanged
      expect(original.width, 400);
      expect(original.height, 515);
      expect(original.isActive, false);
      expect(original.isHidden, false);
    });

    test('copyWith chaining', () {
      const original = DashbotWindowModel();
      final chained = original
          .copyWith(width: 410)
          .copyWith(right: 80, bottom: 120)
          .copyWith(isPopped: false);

      expect(chained.width, 410);
      expect(chained.right, 80);
      expect(chained.bottom, 120);
      expect(chained.isPopped, false);
      // untouched
      expect(chained.height, original.height);
    });
  });
}
