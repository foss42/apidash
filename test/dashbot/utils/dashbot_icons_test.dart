import 'package:apidash/dashbot/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashbotIcons', () {
    test('path getters', () {
      expect(DashbotIcons.dashbotIcon1, 'assets/dashbot/dashbot_icon_1.png');
      expect(DashbotIcons.dashbotIcon2, 'assets/dashbot/dashbot_icon_2.png');
    });

    test('getDashbotIcon1 returns Image.asset with correct dimensions', () {
      final img = DashbotIcons.getDashbotIcon1(width: 24, height: 24);
      expect(img, isA<Image>());
      expect(img.width, 24);
      expect(img.height, 24);
      final provider = img.image;
      expect(provider, isA<AssetImage>());
      expect((provider as AssetImage).assetName, DashbotIcons.dashbotIcon1);
    });

    test('getDashbotIcon2 returns Image.asset', () {
      final img = DashbotIcons.getDashbotIcon2();
      expect(img.image, isA<AssetImage>());
      expect((img.image as AssetImage).assetName, DashbotIcons.dashbotIcon2);
    });
  });
}
