import 'package:flutter/material.dart';

class HomeScreenTaskButton extends StatelessWidget {
  const HomeScreenTaskButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.textAlign = TextAlign.center,
  });

  final String label;
  final VoidCallback onPressed;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
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
        label,
        textAlign: textAlign,
      ),
    );
  }
}
