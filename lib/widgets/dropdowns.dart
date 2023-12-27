import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class DropdownButtonHttpMethod extends StatelessWidget {
  const DropdownButtonHttpMethod({
    super.key,
    this.method,
    this.onChanged,
  });

  final HTTPVerb? method;
  final void Function(HTTPVerb? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<HTTPVerb>(
      focusColor: surfaceColor,
      value: method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      borderRadius: kBorderRadius12,
      onChanged: onChanged,
      items: HTTPVerb.values.map<DropdownMenuItem<HTTPVerb>>((HTTPVerb value) {
        return DropdownMenuItem<HTTPVerb>(
          value: value,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value.name.toUpperCase(),
              style: kCodeStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: getHTTPMethodColor(
                  value,
                  brightness: Theme.of(context).brightness,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DropdownButtonContentType extends StatelessWidget {
  const DropdownButtonContentType({
    super.key,
    this.contentType,
    this.onChanged,
  });

  final ContentType? contentType;
  final void Function(ContentType?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<ContentType>(
      focusColor: surfaceColor,
      value: contentType,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      borderRadius: kBorderRadius12,
      items: ContentType.values
          .map<DropdownMenuItem<ContentType>>((ContentType value) {
        return DropdownMenuItem<ContentType>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: Text(
              value.name,
              style: kTextStyleButton,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DropdownButtonFormData extends StatefulWidget {
  const DropdownButtonFormData({
    super.key,
    this.formDataType,
    this.onChanged,
  });

  final FormDataType? formDataType;
  final void Function(FormDataType?)? onChanged;

  @override
  State<DropdownButtonFormData> createState() => _DropdownButtonFormData();
}

class _DropdownButtonFormData extends State<DropdownButtonFormData> {
  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<FormDataType>(
      dropdownColor: surfaceColor,
      focusColor: surfaceColor,
      value: widget.formDataType,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      underline: const IgnorePointer(),
      onChanged: widget.onChanged,
      borderRadius: kBorderRadius12,
      items: FormDataType.values
          .map<DropdownMenuItem<FormDataType>>((FormDataType value) {
        return DropdownMenuItem<FormDataType>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: Text(
              value.name,
              style: kTextStyleButton,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DropdownButtonCodegenLanguage extends StatelessWidget {
  const DropdownButtonCodegenLanguage({
    super.key,
    this.codegenLanguage,
    this.onChanged,
  });

  final CodegenLanguage? codegenLanguage;
  final void Function(CodegenLanguage?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<CodegenLanguage>(
      focusColor: surfaceColor,
      value: codegenLanguage,
      icon: const Icon(
        Icons.unfold_more_rounded,
        size: 16,
      ),
      elevation: 4,
      style: kCodeStyle.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
      underline: Container(
        height: 0,
      ),
      onChanged: onChanged,
      borderRadius: kBorderRadius12,
      items: CodegenLanguage.values
          .map<DropdownMenuItem<CodegenLanguage>>((CodegenLanguage value) {
        return DropdownMenuItem<CodegenLanguage>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: Text(
              value.label,
              style: kTextStyleButton,
            ),
          ),
        );
      }).toList(),
    );
  }
}
