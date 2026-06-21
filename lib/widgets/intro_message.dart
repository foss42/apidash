import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import '../consts.dart';
import 'markdown.dart';
import 'error_message.dart';

class IntroMessage extends StatefulWidget {
  const IntroMessage({super.key});

  @override
  State<IntroMessage> createState() => _IntroMessageState();
}

class _IntroMessageState extends State<IntroMessage> {
  late Future<void> _introDataFuture;
  late String text;
  late String version;

  @override
  void initState() {
    super.initState();
    _introDataFuture = _loadIntroData();
  }

  Future<void> _loadIntroData() async {
    text = await rootBundle.loadString(kAssetIntroMd, cache: false);
    version = (await PackageInfo.fromPlatform()).version;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _introDataFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return const ErrorMessage(message: "An error occurred");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          String renderedText = text;
          if (Theme.of(context).brightness == Brightness.dark) {
            renderedText = renderedText.replaceAll("{{mode}}", "dark");
          } else {
            renderedText = renderedText.replaceAll("{{mode}}", "light");
          }

          renderedText = renderedText.replaceAll("{{version}}", version);

          return CustomMarkdown(
            data: renderedText,
            padding: EdgeInsets.zero,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
