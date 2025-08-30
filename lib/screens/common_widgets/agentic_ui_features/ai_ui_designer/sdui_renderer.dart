import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stac/stac.dart' as stac;

class StacRenderer extends StatefulWidget {
  final String stacRepresentation;
  final VoidCallback onError;
  const StacRenderer(
      {super.key, required this.stacRepresentation, required this.onError});

  @override
  State<StacRenderer> createState() => _StacRendererState();
}

class _StacRendererState extends State<StacRenderer> {
  Map? sduiCode;

  @override
  void initState() {
    super.initState();
    try {
      sduiCode = jsonDecode(widget.stacRepresentation);
    } catch (e) {
      widget.onError();
    }
  }

  @override
  Widget build(BuildContext context) {
    // return SingleChildScrollView(
    //   child: SelectableText(sduiCode?.toString() ?? "<NONE>"),
    // );
    if (sduiCode == null || sduiCode!.isEmpty) {
      return Container();
    }
    return stac.StacApp(
      title: 'Component Preview',
      homeBuilder: (context) => Material(
        color: Colors.transparent,
        child: stac.Stac.fromJson(sduiCode!.cast<String, dynamic>(), context),
      ),
    );
  }
}
