import 'package:test/test.dart';
import 'package:better_networking/utils/platform_utils.dart';

void main() {
  group('PlatformUtils', () {
    test('should detect platform types correctly', () {
      // Note: These tests will behave differently based on the platform running the tests
      // In a real CI environment, you might want to mock these or run platform-specific tests

      expect(PlatformUtils.isDesktop, isA<bool>());
      expect(PlatformUtils.isMobile, isA<bool>());
      expect(PlatformUtils.isWeb, isA<bool>());
      expect(PlatformUtils.shouldUseLocalhostCallback, isA<bool>());
    });

    test('should have mutually exclusive platform types', () {
      // At most one of these should be true (could be none if running on an unknown platform)
      final platformCount = [
        PlatformUtils.isDesktop,
        PlatformUtils.isMobile,
        PlatformUtils.isWeb,
      ].where((x) => x).length;

      expect(platformCount, lessThanOrEqualTo(1));
    });

    test('shouldUseLocalhostCallback should match isDesktop', () {
      expect(
        PlatformUtils.shouldUseLocalhostCallback,
        equals(PlatformUtils.isDesktop),
      );
    });
  });
}
