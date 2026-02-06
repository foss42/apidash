import 'package:apidash_design_system/ui/design_system_provider.dart';
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
    final ds = DesignSystemProvider.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        kVSpacer16(ds.scaleFactor),
        DashbotIcons.getDashbotIcon1(width: 60*ds.scaleFactor),
        kVSpacer20(ds.scaleFactor),
        Text(
          'Hello there!',
          style: kTextStyleXXLarge(ds.scaleFactor).copyWith(
              fontSize: 22*ds.scaleFactor, fontWeight: FontWeight.w600),
        ),
        kVSpacer10(ds.scaleFactor),
        Text(
          'Seems like you haven\'t made any Requests yet. Why not go ahead and make one?',
          textAlign: TextAlign.center,
          style: kTextStyleMedium(ds.scaleFactor).copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        kVSpacer16(ds.scaleFactor),
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
        kVSpacer16(ds.scaleFactor),
      ],
    );
  }
}
