import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apidash/consts.dart';

class IntroMessage extends StatefulWidget {
  const IntroMessage({
    super.key,
    required this.isDarkMode,
    this.onNew,
    this.onModeToggle,
  });

  final bool isDarkMode;
  final void Function()? onNew;
  final void Function()? onModeToggle;

  @override
  State<IntroMessage> createState() => _IntroMessageState();
}

class _IntroMessageState extends State<IntroMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 60,
      ),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Welcome to API Dash ⚡️",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text(
                  kIntro,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          kVSpacer10,
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Please support this project by giving us a ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: FilledButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse(kGitUrl));
                          },
                          icon: const Icon(Icons.star),
                          label: const Text(
                            'Star on GitHub',
                            style: kTextStyleButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Getting Started",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Click on the ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: ElevatedButton(
                          onPressed: widget.onNew,
                          child: const Text(
                            '+ New',
                            style: kTextStyleButton,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: " button to start drafting a new API request.",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          kVSpacer10,
          Row(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: "Choose your theme now: ",
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: ElevatedButton.icon(
                        onPressed: widget.onModeToggle,
                        icon: widget.isDarkMode
                            ? const Icon(Icons.dark_mode)
                            : const Icon(Icons.light_mode),
                        label: Text(
                          widget.isDarkMode ? "Dark" : "Light",
                          style: kTextStyleButton,
                        ),
                      ),
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          kVSpacer20,
          kVSpacer10,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Support Channel",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Join our ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: FilledButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse(kDiscordUrl));
                          },
                          icon: const Icon(Icons.discord),
                          label: const Text(
                            'Discord Server',
                            style: kTextStyleButton,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: " and drop a message in the #foss channel.",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          kVSpacer20,
          kVSpacer10,
          Row(
            children: [
              Expanded(
                child: Text(
                  "Report Bug / Request New Feature",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          kVSpacer20,
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Just raise an issue in our ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: FilledButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse(kGitUrl));
                          },
                          icon: const Icon(Icons.code_rounded),
                          label: const Text(
                            'Github Repo',
                            style: kTextStyleButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
