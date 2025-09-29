import 'package:flutter/material.dart';
import '../constants.dart';
import '../pages/pages.dart';
import 'dashbot_routes.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case (DashbotRoutes.dashbotHome):
      return MaterialPageRoute(
        settings: const RouteSettings(name: DashbotRoutes.dashbotHome),
        builder: (context) => DashbotHomePage(),
      );
    case (DashbotRoutes.dashbotDefault):
      return MaterialPageRoute(
        settings: const RouteSettings(name: DashbotRoutes.dashbotDefault),
        builder: (context) => DashbotDefaultPage(),
      );
    case (DashbotRoutes.dashbotChat):
      final arg = settings.arguments;
      ChatMessageType? initialTask;
      if (arg is ChatMessageType) initialTask = arg;
      return MaterialPageRoute(
        settings: const RouteSettings(name: DashbotRoutes.dashbotChat),
        builder: (context) => ChatScreen(initialTask: initialTask),
      );
    default:
      return MaterialPageRoute(
        settings: const RouteSettings(name: DashbotRoutes.dashbotDefault),
        builder: (context) => DashbotDefaultPage(),
      );
  }
}
