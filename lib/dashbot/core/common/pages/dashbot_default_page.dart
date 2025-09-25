import 'package:apidash_design_system/apidash_design_system.dart';
import '../../../features/home/view/widgets/home_screen_task_button.dart';
import '../../constants/constants.dart';
import '../../routes/dashbot_routes.dart';
import '../../utils/dashbot_icons.dart';
import 'package:flutter/material.dart';

class DashbotDefaultPage extends StatelessWidget {
  const DashbotDefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        kVSpacer16,
        DashbotIcons.getDashbotIcon1(width: 60),
        kVSpacer20,
        Text(
          'Hello there!',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        kVSpacer10,
        Text(
          'Seems like you haven\'t made any Requests yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          "Why not go ahead and make one?",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        kVSpacer16,
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            HomeScreenTaskButton(
              label: "🤖 Open Chat",
              onPressed: () {
                Navigator.of(context).pushNamed(
                  DashbotRoutes.dashbotChat,
                );
              },
            ),
            HomeScreenTaskButton(
              label: "📥 Import cURL",
              onPressed: () {
                Navigator.of(context).pushNamed(
                  DashbotRoutes.dashbotChat,
                  arguments: ChatMessageType.importCurl,
                );
              },
            ),
            HomeScreenTaskButton(
              label: "📄 Import OpenAPI",
              onPressed: () {
                Navigator.of(context).pushNamed(
                  DashbotRoutes.dashbotChat,
                  arguments: ChatMessageType.importOpenApi,
                );
              },
            ),
          ],
        ),
        kVSpacer16,
      ],
    );
  }
}
