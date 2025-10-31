import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class RequestEditorDefault extends ConsumerWidget {
  const RequestEditorDefault({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Opacity(
              opacity: 0.1,
              child: const FlutterLogo(
                size: 400,
              ),
            // TODO: Replace FlutterLogo with apidash_logo
            // child: Image.asset(
            //   'assets/apidash_logo.png',
            //   width: X,
            //   height: X,
            // ),
            // OR use SVG :
            // child: SvgPicture.asset(
            //   'assets/apidash_logo.svg',
            //   width: X,
            //   height: X,
            // ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Click  ",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(collectionStateNotifierProvider.notifier).add();
                      },
                      child: const Text(
                        kLabelPlusNew,
                        style: kTextStyleButton,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: "  to start drafting a new API request.",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
