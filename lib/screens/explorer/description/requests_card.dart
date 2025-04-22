import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const RequestCard({
    super.key,
    required this.title,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}