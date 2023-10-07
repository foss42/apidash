import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import '../consts.dart';
import 'markdown.dart';
import 'error_message.dart';

class IntroMessage extends StatefulWidget {
  const IntroMessage({
    super.key,
  });

  @override
  State<IntroMessage> createState() => _IntroMessageState();
}

class _IntroMessageState extends State<IntroMessage> {
  @override
  Widget build(BuildContext context) {
    late String text;
    late final String version;

    Future<void> introData() async {
      text = await rootBundle.loadString('assets/intro.md');
      version = (await PackageInfo.fromPlatform()).version;
    }

    return FutureBuilder(
      future: introData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (Theme.of(context).brightness == Brightness.dark) {
            text = text.replaceAll("{{mode}}", "dark");
          } else {
            text = text.replaceAll("{{mode}}", "light");
          }

          text = text.replaceAll("{{version}}", version);

          return CustomMarkdown(
            data: text,
            padding: kPh60,
          );
        }
        if (snapshot.hasError) {
          return const ErrorMessage(message: "An error occured");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
