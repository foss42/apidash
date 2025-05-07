import 'package:apidash_design_system/apidash_design_system.dart';
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
      _showSnackBar('Failed to import API: ${e.toString()}', isError: true);
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
        backgroundColor: isError ? Colors.red.shade400 : Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: isError
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => _importApi(),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              decoration: BoxDecoration(
                color: colors.surfaceVariant.withOpacity(0.2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.api,
                    color: colors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Import OpenAPI Specification',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter the URL of your OpenAPI specification to import',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface.withOpacity(0.8),
                      ),
                    ),
                    kVSpacer20,

                    // Collection Name
                    Text(
                      'Collection Name',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Payment API',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.outline),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        if (value.length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    kVSpacer10,
                    // API URL
                    Text(
                      'OpenAPI Specification URL',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'https://api.example.com/openapi.json',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.outline),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.outline),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.paste, size: 20),
                          onPressed: _pasteFromClipboard,
                          tooltip: 'Paste from clipboard',
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: _validateUrl,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a URL';
                        }
                        if (!_isUrlValid) {
                          return 'Enter a valid HTTP/HTTPS URL';
                        }
                        return null;
                      },
                    ),
                    kHSpacer12,

                    // Supported formats
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Supports OpenAPI 2.0 (Swagger), 3.0, and 3.1 specifications in JSON or YAML format',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Divider
            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  kHSpacer12,
                  ElevatedButton(
                    onPressed: _isLoading || !_isUrlValid ? null : _importApi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.download, size: 18),
                              SizedBox(width: 8),
                              Text('Import'),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}