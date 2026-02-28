import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingSlide extends StatelessWidget {
  final BuildContext context;
  final String assetPath;
  final double assetSize;
  final String title;
  final String description;

  const OnboardingSlide({
    required this.context,
    required this.assetPath,
    required this.assetSize,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 75.0),
          child: Center(
            child: Lottie.asset(
              assetPath,
              renderCache: RenderCache.drawingCommands,
              width: assetSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: kTextStyleButton.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 70,
            )
          ],
        ),
      ],
    );
  }
}
