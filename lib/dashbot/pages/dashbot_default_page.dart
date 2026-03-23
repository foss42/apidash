import 'package:apidash/agentic_testing/widgets/test_generation_panel.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../routes/routes.dart';
import '../utils/utils.dart';
import '../widgets/widgets.dart';

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
          style: kTextStyleXXLarge.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        kVSpacer10,
        Text(
          'Seems like you haven\'t made any Requests yet. Why not go ahead and make one?',
          textAlign: TextAlign.center,
          style: kTextStyleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        kVSpacer16,
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            HomeScreenTaskButton(
              label: 'Open Chat',
              onPressed: () {
                Navigator.of(context).pushNamed(DashbotRoutes.dashbotChat);
              },
            ),
            HomeScreenTaskButton(
              label: 'Import cURL',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  DashbotRoutes.dashbotChat,
                  arguments: ChatMessageType.importCurl,
                );
              },
            ),
            HomeScreenTaskButton(
              label: 'Import OpenAPI',
              onPressed: () {
                Navigator.of(context).pushNamed(
                  DashbotRoutes.dashbotChat,
                  arguments: ChatMessageType.importOpenApi,
                );
              },
            ),
            HomeScreenTaskButton(
              label: 'Agentic Test Prototype',
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (_) {
                    return const Dialog(
                      child: SizedBox(
                        width: 780,
                        height: 640,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: TestGenerationPanel(),
                        ),
                      ),
                    );
                  },
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
