import 'package:flutter/material.dart';
import 'package:apidash_design_system/apidash_design_system.dart'; 

class MethodChip extends StatelessWidget {
  final String method;

  const MethodChip({super.key, required this.method});

  Color _getMethodColor() {
    switch (method.toUpperCase()) {
      case 'GET':
        return kColorHttpMethodGet;
      case 'HEAD':
        return kColorHttpMethodHead;
      case 'POST':
        return kColorHttpMethodPost;
      case 'PUT':
        return kColorHttpMethodPut;
      case 'PATCH':
        return kColorHttpMethodPatch;
      case 'DELETE':
        return kColorHttpMethodDelete;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getMethodColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getMethodColor(),
          width: 1.5,
        ),
      ),
      child: Text(
        method.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _getMethodColor(),
          fontSize: 12,
        ),
      ),
    );
  }
}