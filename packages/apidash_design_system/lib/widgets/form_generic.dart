import 'package:flutter/material.dart';

/// Field configuration for the [GenericForm].
class GenericFormField {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final bool required;
  final String? Function(String?)? validator;

  GenericFormField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.required = false,
    this.validator,
  });
}

/// A generic form that can be used throughout the application.
class GenericForm extends StatelessWidget {
  final List<GenericFormField> fields;
  final double fieldSpacing;
  
  const GenericForm({
    super.key,
    required this.fields,
    this.fieldSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _buildFormFields(),
    );
  }

  List<Widget> _buildFormFields() {
    final List<Widget> formFields = [];

    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      
      formFields.add(
        TextField(
          controller: field.controller,
          decoration: InputDecoration(
            labelText: field.labelText + (field.required ? ' *' : ''),
            hintText: field.hintText,
          ),
          obscureText: field.obscureText,
        ),
      );

      // Add spacing between fields (except after the last one)
      if (i < fields.length - 1) {
        formFields.add(SizedBox(height: fieldSpacing));
      }
    }

    return formFields;
  }
}
