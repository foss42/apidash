import 'package:apidash/dashbot/features/home/view/pages/dashbot_chat_page.dart';
import 'package:apidash_design_system/tokens/measurements.dart';
import 'package:flutter/material.dart';

class DashbotHomePage extends StatelessWidget {
  const DashbotHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/dashbothome',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
              builder: (context) => _buildHomePageContent(context));
        } else if (settings.name == '/dashbotchat') {
          return MaterialPageRoute(builder: (context) => const ChatScreen());
        }
        return null;
      },
    );
  }

  Widget _buildHomePageContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          kVSpacer16,
          Image.asset(
            'assets/dashbot_icon_1.png',
            width: 60,
          ),
          kVSpacer16,
          Text(
            'Hello there,',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text('How can I help you today?'),
          kVSpacer16,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/dashbotchat');
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
                child: Text(
                  "🔎 Explain me this response",
                ),
              ),
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
                child: Text("🐞 Help me debug this error"),
              ),
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
                child: Text(
                  "📄 Generate documentation",
                  textAlign: TextAlign.center,
                ),
              ),
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
                child: Text("📝 Generate Tests"),
              ),
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
                child: Text("📊 Generate Visualizations"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
