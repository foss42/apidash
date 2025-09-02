import '../../../../core/utils/dashbot_icons.dart';

import '../../../../core/routes/dashbot_routes.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../chat/models/chat_models.dart';

class DashbotHomePage extends ConsumerStatefulWidget {
  const DashbotHomePage({super.key});

  @override
  ConsumerState<DashbotHomePage> createState() => _DashbotHomePageState();
}

class _DashbotHomePageState extends ConsumerState<DashbotHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          kVSpacer16,
          DashbotIcons.getDashbotIcon1(width: 60),

          kVSpacer16,
          Text(
            'Hello there,',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          Text('How can I help you today?'),
          kVSpacer16,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // TextButton(
              //   onPressed: () {
              // Navigator.of(context).pushNamed(
              //   DashbotRoutes.dashbotChat,
              // );
              //   },
              //   style: TextButton.styleFrom(
              //     side: BorderSide(
              //       color: Theme.of(context).colorScheme.primary,
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 0,
              //       horizontal: 16,
              //     ),
              //   ),
              //   child: const Text("🤖 Chat with Dashbot"),
              // ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.explainResponse,
                  );
                },
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                ),
                child: const Text("🔎 Explain me this response"),
              ),
              // TextButton(
              //   onPressed: () {},
              //   style: TextButton.styleFrom(
              //     side: BorderSide(
              //       color: Theme.of(context).colorScheme.primary,
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 0,
              //       horizontal: 16,
              //     ),
              //   ),
              //   child: const Text("🐞 Help me debug this error"),
              // ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                ),
                child: const Text(
                  "📄 Generate documentation",
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    DashbotRoutes.dashbotChat,
                    arguments: ChatMessageType.generateTest,
                  );
                },
                style: TextButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                ),
                child: const Text("📝 Generate Tests"),
              ),
              // TextButton(
              //   onPressed: () {},
              //   style: TextButton.styleFrom(
              //     side: BorderSide(
              //       color: Theme.of(context).colorScheme.primary,
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       vertical: 0,
              //       horizontal: 16,
              //     ),
              //   ),
              //   child: const Text("📊 Generate Visualizations"),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
