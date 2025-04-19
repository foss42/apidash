import 'package:flutter/material.dart';
import '../explorer/common_widgets/api_search_bar.dart';

class ExplorerBody extends StatelessWidget {
  const ExplorerBody({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6, 
                child: ApiSearchBar(
                  hintText: 'Search Explorer',
                  onChanged: (value) {
                    // TODO: Handle search input
                  },
                  onClear: () {
                    // TODO:Handle clear action
                  },
                ),
              ),
            ),
          ),
          // Content area
          const Expanded(
            child: Center(
              child: Text(
                'Explorer Body Content',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}