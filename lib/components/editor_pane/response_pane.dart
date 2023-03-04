import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResponsePane extends ConsumerStatefulWidget {
  const ResponsePane({super.key});

  @override
  ConsumerState<ResponsePane> createState() => _ResponsePaneState();
}

class _ResponsePaneState extends ConsumerState<ResponsePane> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
