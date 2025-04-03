import 'dart:developer' show log;

import 'package:apidash/dashbot/features/home/view/pages/dashbot_chat_page.dart';
import 'package:apidash/dashbot/features/home/view/pages/dashbot_default_page.dart';
import 'package:apidash/dashbot/features/home/view/pages/dashbot_home_page.dart';
import 'package:apidash/models/request_model.dart' show RequestModel;
import 'package:apidash/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashbotDashboard extends ConsumerStatefulWidget {
  const DashbotDashboard({super.key});

  @override
  ConsumerState<DashbotDashboard> createState() => _DashbotDashboardState();
}

class _DashbotDashboardState extends ConsumerState<DashbotDashboard> {
  @override
  Widget build(BuildContext context) {
    final RequestModel? currentRequest = ref.read(selectedRequestModelProvider);
    log("Cuurent request: $currentRequest");
    log("Is Working: ${currentRequest?.isWorking}");
    log("Status Code: ${currentRequest?.responseStatus}");
    log("Desc: ${currentRequest?.description}");
    log("Message: ${currentRequest?.message}");
    return Navigator(
      initialRoute: currentRequest?.responseStatus == null
          ? '/dashbotdefault'
          : '/dashbothome',
      onGenerateRoute: (settings) {
        if (settings.name == '/dashbothome') {
          return MaterialPageRoute(
            builder: (context) => DashbotHomePage(
              requestModel: currentRequest!,
            ),
          );
        } else if (settings.name == '/dashbotdefault') {
          return MaterialPageRoute(
            builder: (context) => DashbotDefaultPage(),
          );
        } else if (settings.name == '/dashbotchat') {
          final args = settings.arguments as Map<String, dynamic>?;
          final initialPrompt = args?['initialPrompt'] as String?;
          return MaterialPageRoute(
            builder: (context) => ChatScreen(
              initialPrompt: initialPrompt,
            ),
          );
        }
        return null;
      },
    );
  }
}
