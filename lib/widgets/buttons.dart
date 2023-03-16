import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButton extends StatefulWidget {
  const CopyButton({super.key, required this.toCopy});

  final String toCopy;
  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: widget.toCopy));
      },
      child: Row(
        children: const [
          Icon(
            Icons.content_copy,
            size: 20,
          ),
          Text("Copy")
        ],
      ),
    );
  }
}
