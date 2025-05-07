import 'package:apidash/models/api_explorer_models.dart';
import 'package:flutter/material.dart';
import 'api_card.dart';

class ApiGridView extends StatelessWidget {
  final List<ApiCollection> collections;
  final ThemeData theme;

  const ApiGridView({
    super.key,
    required this.collections,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: collections
            .map(
              (collection) => ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 300,
                  maxWidth: 300,
                ),
                child: ApiCard(
                  collection: collection,
                  theme: theme,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
