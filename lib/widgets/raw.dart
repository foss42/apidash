import 'dart:convert';

import 'package:apidash/providers/providers.dart';
import 'package:apidash/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Raw extends StatelessWidget {
  const Raw({super.key, required this.body, this.style});

  final String body;
  final TextStyle? style;

  String? _formatJson(String data, {required ScaffoldMessengerState sm}) {
    try {
      final dynamic parsedJson = json.decode(body);

      return const JsonEncoder.withIndent('  ').convert(parsedJson);
    } catch (e) {
      sm.hideCurrentSnackBar();
      sm.showSnackBar(getSnackBar("Failed to beautify JSON"));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var sm = ScaffoldMessenger.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Consumer(builder: (context, ref, _) {
            return SelectableText(
              ref.watch(beautifyJsonProvider) ?? body,
              style: style,
            );
          }),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Consumer(builder: (context, ref, _) {
            return ref.watch(beautifyJsonProvider) != null
                ? const SizedBox.shrink()
                : ElevatedButton(
                    onPressed: () {
                      ref.read(beautifyJsonProvider.notifier).state =
                          _formatJson(body, sm: sm);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: const Text("Beautify"),
                  );
          }),
        ),
      ],
    );
  }
}
