import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash_core/apidash_core.dart';
import '../providers/providers.dart';

class FormDataToggle extends ConsumerWidget {
  const FormDataToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final contentType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.bodyContentType));
    final formData = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.formData));
    
    final hasFiles = formData?.any((item) => item.type == FormDataType.file) ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 6),
            const Text('Form Data Type:'),
            SegmentedButton<ContentType>(
              segments: const [
                ButtonSegment<ContentType>(
                  value: ContentType.urlencoded,
                  label: Text('Text Only'),
                  icon: Icon(Icons.text_fields),
                ),
                ButtonSegment<ContentType>(
                  value: ContentType.formdata,
                  label: Text('Include Files'),
                  icon: Icon(Icons.attach_file),
                ),
              ],
              selected: {contentType == ContentType.formdata ? ContentType.formdata : ContentType.urlencoded},
              onSelectionChanged: (Set<ContentType> newSelection) {
                final newContentType = newSelection.first;
                if (newContentType == ContentType.urlencoded && hasFiles) {
                  // Show warning dialog when switching to urlencoded with files
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Warning'),
                      content: const Text(
                        'Switching to "Text Only" mode will remove any file attachments. '
                        'Are you sure you want to continue?'
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref
                                .read(collectionStateNotifierProvider.notifier)
                                .update(id: selectedId!, bodyContentType: newContentType);
                          },
                          child: const Text('Continue'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ref
                      .read(collectionStateNotifierProvider.notifier)
                      .update(id: selectedId!, bodyContentType: newContentType);
                }
              },
            ),
            const SizedBox(width: 6),
          ],
        ),
        if (hasFiles && contentType == ContentType.urlencoded)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Files detected. Switch to "Include Files" mode to support file uploads.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
