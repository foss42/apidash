import 'package:flutter/material.dart';
import 'canvas_ui_constants.dart';

class CanvasStyles {
  // Method badge styles
  static EdgeInsets methodBadgePadding = EdgeInsets.symmetric(
    horizontal: CanvasUIConstants.methodBadgePaddingHorizontal, 
    vertical: CanvasUIConstants.methodBadgePaddingVertical
  );
  
  static BorderRadius methodBadgeBorderRadius = BorderRadius.circular(
    CanvasUIConstants.methodBadgeBorderRadius
  );
  
  static const TextStyle methodBadgeTextStyle = TextStyle(
    color: Colors.white,
    fontSize: CanvasUIConstants.methodBadgeFontSize,
    fontWeight: FontWeight.bold,
  );

  // Node styles  
  static BoxShadow nodeShadow = BoxShadow(
    color: const Color(0xff171433).withOpacity(0.1),
    spreadRadius: 1,
    blurRadius: 3,
    offset: const Offset(0, 2),
  );
  
  static BorderRadius nodeBorderRadius = BorderRadius.circular(
    CanvasUIConstants.nodeBorderRadius
  );
  
  static const TextStyle nodeHeaderTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle nodeContentTextStyle = TextStyle(
    fontSize: CanvasUIConstants.nodeContentFontSize,
    color: Color(0xFF757575), // Colors.grey[700]
  );
  
  // Header container decorations
  static BoxDecoration requestHeaderDecoration = BoxDecoration(
    color: Colors.blue.shade700,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
    ),
  );
  
  static BoxDecoration processingHeaderDecoration = BoxDecoration(
    color: Colors.green.shade700,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(6),
      topRight: Radius.circular(6),
    ),
  );

  // Method-specific colors
  static Color methodBadgeColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
  
  // Node border colors
  static Color getBorderColor(String nodeId, String? sourceNodeId, bool isConnectionMode) {
    if (sourceNodeId == nodeId) {
      return Colors.blue;
    }
    
    if (isConnectionMode) {
      return Colors.purple;
    }
    
    return Colors.grey.shade300;
  }
  
  // Node background gradients
  static List<Color> getNodeGradient(String nodeId, String? sourceNodeId, bool isConnectionMode) {
    if (sourceNodeId == nodeId) {
      return [Colors.blue[300]!, Colors.blue[100]!];
    } else if (isConnectionMode) {
      return [Colors.purple[100]!, Colors.purple[50]!];
    } else {
      return [Colors.white, const Color(0xFFF5F5F5)];
    }
  }
}
