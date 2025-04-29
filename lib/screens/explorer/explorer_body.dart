import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/models/models.dart';
import 'package:apidash/providers/templates_provider.dart';
import 'package:apidash/screens/explorer/common_widgets/common_widgets.dart';

class ExplorerBody extends ConsumerWidget {
  final Function(ApiTemplate)? onCardTap;

  const ExplorerBody({
    super.key,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesState = ref.watch(templatesProvider);

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ApiSearchBar(
                    hintText: 'Search Explorer',
                    onChanged: (value) {
                      // TODO: Implement search filtering
                    },
                    onClear: () {
                      // TODO: Handle clear action
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: templatesState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : templatesState.error != null
                    ? Center(child: Text('Error: ${templatesState.error}'))
                    : templatesState.templates.isEmpty
                        ? const Center(child: Text('No templates found'))
                        : GridView.builder(
                            padding: const EdgeInsets.all(12),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 384,
                              childAspectRatio: 1.3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: templatesState.templates.length,
                            itemBuilder: (context, index) {
                              final template = templatesState.templates[index];
                              return TemplateCard(
                                template: template,
                                onTap: () => onCardTap?.call(template),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}