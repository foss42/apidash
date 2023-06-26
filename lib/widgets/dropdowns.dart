import 'package:flutter/material.dart';
import 'package:apidash/utils/utils.dart';
import 'package:apidash/consts.dart';

class DropdownButtonHttpMethod extends StatefulWidget {
  const DropdownButtonHttpMethod({
    super.key,
    this.method,
    this.onChanged,
  });

  final HTTPVerb? method;
  final void Function(HTTPVerb? value)? onChanged;

  @override
  State<DropdownButtonHttpMethod> createState() =>
      _DropdownButtonHttpMethodState();
}

class _DropdownButtonHttpMethodState extends State<DropdownButtonHttpMethod> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<HTTPVerb>(
      focusColor: surfaceColor,
      value: widget.method,
      icon: const Icon(Icons.unfold_more_rounded),
      elevation: 4,
      underline: Container(
        height: 0,
      ),
      borderRadius: kBorderRadius12,
      onChanged: widget.onChanged,
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

class DropdownButtonContentType extends StatefulWidget {
  const DropdownButtonContentType({
    super.key,
    this.contentType,
    this.onChanged,
  });

  final ContentType? contentType;
  final void Function(ContentType?)? onChanged;

  @override
  State<DropdownButtonContentType> createState() =>
      _DropdownButtonContentTypeState();
}

class _DropdownButtonContentTypeState extends State<DropdownButtonContentType> {
  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<ContentType>(
      focusColor: surfaceColor,
      value: widget.contentType,
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
      onChanged: widget.onChanged,
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

class DropdownButtonCodegenLanguage extends StatefulWidget {
  const DropdownButtonCodegenLanguage({
    Key? key,
    this.codegenLanguage,
    this.onChanged,
  }) : super(key: key);

  @override
  State<DropdownButtonCodegenLanguage> createState() =>
      _DropdownButtonCodegenLanguageState();
  final CodegenLanguage? codegenLanguage;
  final void Function(CodegenLanguage?)? onChanged;
}

class _DropdownButtonCodegenLanguageState
    extends State<DropdownButtonCodegenLanguage> {
  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return DropdownButton<CodegenLanguage>(
      focusColor: surfaceColor,
      value: widget.codegenLanguage,
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
      onChanged: widget.onChanged,
      borderRadius: kBorderRadius12,
      items: CodegenLanguage.values
          .map<DropdownMenuItem<CodegenLanguage>>((CodegenLanguage value) {
        return DropdownMenuItem<CodegenLanguage>(
          value: value,
          child: Padding(
            padding: kPs8,
            child: SizedBox(
              width: MediaQuery.of(context).size.width <1315?MediaQuery.of(context).size.width * 0.1:MediaQuery.of(context).size.width * 0.09,
              child: Text(
                value.label,
                style: kTextStyleButton,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}