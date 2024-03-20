import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:package_info_plus/package_info_plus.dart';
import '../consts.dart';
import 'markdown.dart';
import 'error_message.dart';

class IntroMessage extends StatelessWidget {
  const IntroMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    late String text;
    late final String version;

    Future<void> introData() async {
      text = await rootBundle.loadString(kAssetIntroMd);
      version = (await PackageInfo.fromPlatform()).version;
    }

    return FutureBuilder(
      future: introData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return const ErrorMessage(message: "An error occured");
        }
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
