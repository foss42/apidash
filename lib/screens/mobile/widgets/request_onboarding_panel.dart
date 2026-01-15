import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_slide.dart';

class RequestOnboardingPanel extends StatelessWidget {
  const RequestOnboardingPanel({super.key});

  static const sampleUrl = "https://jsonplaceholder.typicode.com/posts";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OnboardingSlide(
          context: context,
          assetPath: "assets/sending.json",
          assetSize: 260,
          title: "Create your first API request",
          description:
              "Get started by selecting or creating a request from the left panel.\n\nYou can try this sample API:",
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Clipboard.setData(const ClipboardData(text: sampleUrl));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Sample URL copied to clipboard")),
            );
          },
          child: Text(
            sampleUrl,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Steps:\n1. Click + New\n2. Enter API URL\n3. Press Send",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
