import 'package:apidash/providers/providers.dart';
import 'package:apidash/screens/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiAuthWidget extends ConsumerWidget {
  const ApiAuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       labelText: 'Key',
          //       border: OutlineInputBorder(),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // child: TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Enter your token',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (value) => ref
            //       .read(collectionStateNotifierProvider.notifier)
            //       .update(token: value),
            // ),
            child: EnvFieldTokenData(
              keyId: "token",
             
              onChanged: (value) => ref
                  .read(collectionStateNotifierProvider.notifier)
                  .update(token: value),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   child: DropdownButtonFormField<String>(
          //     value: 'params',
          //     decoration: InputDecoration(
          //       labelText: 'Add to',
          //       border: OutlineInputBorder(),
          //     ),
          //     items: const [
          //       DropdownMenuItem(
          //         value: 'params',
          //         child: Text('Params'),
          //       ),
          //       DropdownMenuItem(
          //         value: 'headers',
          //         child: Text('Headers'),
          //       ),
          //     ],
          //     onChanged: (value) {},
          //   ),
          // ),
        ],
      ),
    );
  }
}
