import '../../features/chat/view/pages/dashbot_chat_page.dart';
import '../../features/chat/models/chat_models.dart';

import 'dashbot_routes.dart';
import '../common/pages/dashbot_default_page.dart';
import '../../features/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';

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
