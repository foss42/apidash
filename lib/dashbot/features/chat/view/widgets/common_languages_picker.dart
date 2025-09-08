import 'package:flutter/material.dart';

class CommonLanguageButton extends StatelessWidget {
  const CommonLanguageButton({
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

class CommonLanguagesPicker extends StatelessWidget {
  const CommonLanguagesPicker({
    super.key,
    required this.languages,
    required this.onSelected,
  });

  final List<String> languages;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final langs = languages.length > 6 ? languages.take(6).toList() : languages;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final l in langs)
          CommonLanguageButton(
            label: l,
            onPressed: () => onSelected(l),
          ),
      ],
    );
  }
}
