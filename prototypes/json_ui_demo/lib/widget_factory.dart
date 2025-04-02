import 'package:flutter/material.dart';
import 'schema_parser.dart';

class WidgetFactory {
  static Widget buildWidget(FieldSchema field) {
    final label = field.label ?? field.key;
    final widgetType = field.suggestedWidget;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildFieldByType(widgetType, field),
            if (field.hintText != null && field.hintText!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  field.hintText!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFieldByType(String widgetType, FieldSchema field) {
    switch (widgetType) {
      case 'TextField':
      case 'Text':
        return TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: field.icon != null ? Icon(_getIconData(field.icon!)) : null,
          ),
        );
      case 'Switch':
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              field.label ?? field.key,
              style: const TextStyle(fontSize: 14),
            ),
            Switch(value: false, onChanged: (v) {}),
          ],
        );
      case 'EmailField':
        return TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
        );
      case 'UrlField':
        return TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.link),
          ),
          keyboardType: TextInputType.url,
        );
      case 'ListView':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('[List of items]')],
        );
      case 'Card':
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text('{ ...object... }'),
        );
      default:
        return Text('[Unsupported widget type]');
    }
  }

  static List<Widget> buildWidgetsFromSchema(Schema schema) {
    return schema.fields
        .map((f) => buildWidget(f))
        .toList();
  }

  static IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'email':
        return Icons.email;
      case 'link':
        return Icons.link;
      case 'phone':
        return Icons.phone;
      default:
        return Icons.device_unknown;
    }
  }
}
