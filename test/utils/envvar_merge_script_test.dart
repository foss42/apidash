import 'package:apidash/utils/envvar_utils.dart';
import 'package:apidash_core/apidash_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mergeScriptEnvironmentValues disabled variable preservation', () {
    test(
      'preserves enabled: false when script updates a disabled variable key',
      () {
        final originalValues = [
          const EnvironmentVariableModel(
            key: 'DISABLED_TOKEN',
            value: 'old-secret',
            type: EnvironmentVariableType.secret,
            enabled: false,
          ),
          const EnvironmentVariableModel(
            key: 'ENABLED_URL',
            value: 'https://old.example.com',
            enabled: true,
          ),
        ];

        final merged = mergeScriptEnvironmentValues(
          originalValues: originalValues,
          updatedEnvironment: {
            'DISABLED_TOKEN': 'new-secret',
            'ENABLED_URL': 'https://new.example.com',
            'ADDED_BY_SCRIPT': 42,
          },
        );

        final disabledVar = merged.firstWhere((v) => v.key == 'DISABLED_TOKEN');
        expect(disabledVar.value, 'new-secret');
        expect(disabledVar.enabled, isFalse);
        expect(disabledVar.type, EnvironmentVariableType.secret);

        final enabledVar = merged.firstWhere((v) => v.key == 'ENABLED_URL');
        expect(enabledVar.value, 'https://new.example.com');
        expect(enabledVar.enabled, isTrue);

        final addedVar = merged.firstWhere((v) => v.key == 'ADDED_BY_SCRIPT');
        expect(addedVar.value, '42');
        expect(addedVar.enabled, isTrue);
      },
    );

    test(
      'preserves untouched disabled variable and removes unset enabled variable',
      () {
        final originalValues = [
          const EnvironmentVariableModel(
            key: 'KEPT_DISABLED',
            value: 'still-here',
            enabled: false,
          ),
          const EnvironmentVariableModel(
            key: 'UNSET_ENABLED',
            value: 'bye',
            enabled: true,
          ),
        ];

        final merged = mergeScriptEnvironmentValues(
          originalValues: originalValues,
          updatedEnvironment: const {},
        );

        expect(merged, hasLength(1));
        expect(merged.single.key, 'KEPT_DISABLED');
        expect(merged.single.enabled, isFalse);
      },
    );
  });
}
