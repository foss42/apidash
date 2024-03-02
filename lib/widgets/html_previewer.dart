import 'package:flutter/material.dart';

class HtmlPreviewer extends StatefulWidget {
  const HtmlPreviewer({super.key, required this.htmlContent});
  final String htmlContent;

  @override
  _HtmlPreviewerState createState() => _HtmlPreviewerState();
}

class _HtmlPreviewerState extends State<HtmlPreviewer> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Center(
        child: Text("Some HTML Page"),
      ),
    );
  }
}
