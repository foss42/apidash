import 'package:apidash/models/api_catalog.dart';
import 'package:flutter/material.dart';
import 'package:apidash_core/apidash_core.dart';
import 'api_card.dart';

class ApiGridView extends StatelessWidget {
  final List<ApiCatalogModel> catalogs;
  final ThemeData theme;

  const ApiGridView({
    super.key,
    required this.catalogs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: catalogs
            .map(
              (catalog) => ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 300,
                  maxWidth: 300,
                ),
                child: ApiCard(
                  theme: theme, catalog: catalog,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}