import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
    final Future<String> intro = rootBundle.loadString('assets/intro.md');

    return FutureBuilder(
      future: intro,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if ((snapshot.connectionState == ConnectionState.done) &&
            snapshot.hasData) {
          String text = snapshot.data!;
          if (Theme.of(context).brightness == Brightness.dark) {
            text = text.replaceAll("{{mode}}", "dark");
          } else {
            text = text.replaceAll("{{mode}}", "light");
          }
          return CustomMarkdown(data: text);
        }
        if (snapshot.hasError) {
          return const ErrorMessage(message: "An error occured");
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
