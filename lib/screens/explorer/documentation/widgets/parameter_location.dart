import 'package:flutter/material.dart';

class ParameterLocation extends StatelessWidget {
  final String location;

  const ParameterLocation({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final color = _getLocationColor(location);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4)),
      child: Text(
        location.toLowerCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getLocationColor(String location) {
    switch (location.toLowerCase()) {
      case 'query': return const Color(0xFF3B82F6);
      case 'path': return const Color(0xFF10B981);
      case 'header': return const Color(0xFF8B5CF6);
      case 'body': return const Color(0xFFF59E0B);
      default: return const Color(0xFF6B7280);
    }
  }
}