import 'package:flutter/material.dart';
import 'package:apidash_core/consts.dart';

class MethodBadge extends StatelessWidget {
  final HTTPVerb method;

  const MethodBadge({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    final color = _getMethodColor(method);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color),
      ),
      child: Text(
        method.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getMethodColor(HTTPVerb method) {
    switch (method) {
      case HTTPVerb.get: return const Color(0xFF10B981);
      case HTTPVerb.post: return const Color(0xFF3B82F6);
      case HTTPVerb.put: return const Color(0xFFF59E0B);
      case HTTPVerb.delete: return const Color(0xFFEF4444);
      case HTTPVerb.patch: return const Color(0xFF8B5CF6);
      case HTTPVerb.head: return const Color(0xFF06B6D4);
      default: return const Color(0xFF6B7280);
    }
  }
}