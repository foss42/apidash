import 'package:flutter/material.dart';
import 'method_pane.dart';
import 'description_pane.dart';

class DescriptionBody extends StatelessWidget {
  const DescriptionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3, 
            child: const MethodPane(),
          ),
          const Expanded(
            child: DescriptionPane(),
          ),
        ],
      ),
    );
  }
}