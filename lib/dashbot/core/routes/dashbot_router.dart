import 'package:apidash/dashbot/core/routes/dashbot_routes.dart';
import 'package:apidash/dashbot/core/common/pages/dashbot_default_page.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoute(
  RouteSettings settings,
) {
  switch (settings.name) {
    // case (DashbotRoutes.dashbotHome):
    //   return MaterialPageRoute(
    //     builder: (context) => DashbotHomePage(),
    //   );
    case (DashbotRoutes.dashbotDefault):
      return MaterialPageRoute(
        builder: (context) => DashbotDefaultPage(),
      );
    // case (DashbotRoutes.dashbotChat):
    //   final args = settings.arguments as Map<String, dynamic>?;
    //   final initialPrompt = args?['initialPrompt'] as String;
    //   return MaterialPageRoute(
    //     builder: (context) => ChatScreen(
    //       initialPrompt: initialPrompt,
    //     ),
    //   );
    default:
      return MaterialPageRoute(
        builder: (context) => DashbotDefaultPage(),
      );
  }
}
