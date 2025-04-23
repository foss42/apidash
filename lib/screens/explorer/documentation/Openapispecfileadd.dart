import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:flutter/services.dart';

class AddApiDialog extends ConsumerStatefulWidget {
  const AddApiDialog({super.key});

  @override
  ConsumerState<AddApiDialog> createState() => _AddApiDialogState();
}

class _AddApiDialogState extends ConsumerState<AddApiDialog> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isUrlValid = false;

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _validateUrl(String value) {
    setState(() {
      if (value.isEmpty) {
        _isUrlValid = false;
        return;
      }

      try {
        final uri = Uri.parse(value);
        _isUrlValid =
            uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
      } catch (_) {
        _isUrlValid = false;
      }
    });
  }

 
  Future<void> _importApi() async {
    if (!_formKey.currentState!.validate() || !mounted) return;

    final url = _urlController.text.trim();
    final name = _nameController.text.trim();

    setState(() => _isLoading = true);

    try {
      await ref.read(apiExplorerProvider.notifier).addCollectionFromUrl(url, ref);
      
      if (!mounted) return;
      Navigator.pop(context);
      
      _showSnackBar('API imported successfully!', isError: false);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error importing API: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? _getMethodColor('DELETE').withOpacity(0.9)
            : _getMethodColor('GET').withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        dismissDirection: DismissDirection.horizontal,
        action: isError
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const AddApiDialog(),
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      _urlController.text = clipboardData!.text!;
      _validateUrl(_urlController.text);
    }
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.blue;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      case 'PATCH':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.api_rounded,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add API Specification',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Import an OpenAPI specification from a URL',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Collection name field
                    _buildSectionHeader(
                      context,
                      title: 'Collection Name',
                      icon: Icons.collections_bookmark,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'My API Collection',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor:
                            theme.colorScheme.surfaceVariant.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLength: 40,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value != null && value.length > 3) return null;
                        return 'Please enter a name with at least 3 characters';
                      },
                    ),
                    const SizedBox(height: 20),

                    // URL field
                    _buildSectionHeader(
                      context,
                      title: 'API Spec URL',
                      icon: Icons.link,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'https://example.com/api-spec.yaml',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor:
                            theme.colorScheme.surfaceVariant.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.content_paste),
                          tooltip: 'Paste from clipboard',
                          onPressed: _pasteFromClipboard,
                        ),
                        errorMaxLines: 2,
                      ),
                      maxLength: 200,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onChanged: _validateUrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a URL';
                        }
                        if (!_isUrlValid) {
                          return 'Please enter a valid URL starting with http:// or https://';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          _isUrlValid ? _importApi() : null,
                    ),
                    const SizedBox(height: 8),

                    // Info text
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.secondary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Supports OpenAPI 2.0, 3.0, and 3.1 formats (JSON/YAML)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _isLoading || !_isUrlValid ? null : _importApi,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      backgroundColor: _getMethodColor('POST'),
                    ),
                    icon: _isLoading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.download),
                    label: const Text('Import'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
