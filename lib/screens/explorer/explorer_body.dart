import 'package:flutter/material.dart';
import 'package:apidash/services/services.dart';
import 'common_widgets/common_widgets.dart';
import 'package:apidash/models/models.dart';

class ExplorerBody extends StatefulWidget {
  final Function(ApiTemplate)? onCardTap;

  const ExplorerBody({
    super.key,
    this.onCardTap,
  });

  @override
  _ExplorerBodyState createState() => _ExplorerBodyState();
}

class _ExplorerBodyState extends State<ExplorerBody> {
  late Future<List<ApiTemplate>> _templatesFuture;

  @override
  void initState() {
    super.initState();
    _templatesFuture = TemplatesService.loadTemplates();
  }

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
                    // TODO: Implement search filtering
                    // Example: Filter templates by title or tags
                  },
                  onClear: () {
                    // TODO:Handle clear action
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ApiTemplate>>(
              future: _templatesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No templates found'));
                }

                final templates = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 384, 
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return TemplateCard(
                      template: template,
                      onTap: () => widget.onCardTap?.call(template),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}