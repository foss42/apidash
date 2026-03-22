import 'package:flutter/widgets.dart';

class DashbotIcons {
  DashbotIcons._();
  static String get dashbotIcon1 => 'assets/dashbot/dashbot_icon_1.png';
  static String get dashbotIcon2 => 'assets/dashbot/dashbot_icon_2.png';

  static Image getDashbotIcon1({double? width, double? height, BoxFit? fit}) {
    return Image.asset(dashbotIcon1, width: width, height: height, fit: fit);
  }

  static Image getDashbotIcon2({double? width, double? height, BoxFit? fit}) {
    return Image.asset(dashbotIcon2, width: width, height: height, fit: fit);
  }
}
