import 'package:apidash_core/apidash_core.dart';
import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/providers/providers.dart';
import 'package:apidash/consts.dart';

class EditRequestAuthentication extends ConsumerWidget {
  const EditRequestAuthentication({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) {
      return const Center(
        child: Text("No request selected"),
      );
    }

    final authType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.authType ?? AuthType.none));

    return Column(
      children: [
        const SizedBox(
          height: kHeaderHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Authentication Type:",
              ),
              SizedBox(width: 8),
              DropdownButtonAuthType(),
            ],
          ),
        ),
        Expanded(
          child: authType == AuthType.apiKey 
              ? const ApiKeyAuthForm()
              : const Center(
                  child: Text(
                    "No authentication selected",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
        ),
      ],
    );
  }
}

/// Dropdown widget for selecting the authentication type
class DropdownButtonAuthType extends ConsumerWidget {
  const DropdownButtonAuthType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    if (selectedId == null) return const SizedBox.shrink();

    final authType = ref.watch(selectedRequestModelProvider
        .select((value) => value?.httpRequestModel?.authType ?? AuthType.none));

    return ADDropdownButton<AuthType>(
      value: authType,
      values: [AuthType.none, AuthType.apiKey].map((e) => (e, e.name)),
      onChanged: (AuthType? value) {
        if (value != null) {
          Map<String, dynamic> initialParams = {};
          if (value == AuthType.apiKey) {
            initialParams = {
              'key': '',
              'name': '',
              'addTo': 'header',
            };
          }
          ref.read(collectionStateNotifierProvider.notifier).update(
                id: selectedId,
                authType: value,
                authParams: initialParams,
              );
        }
      },
      iconSize: 16,
    );
  }
}

/// Custom TextField widget to manage TextEditingController lifecycle
class AuthTextField extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final int? minLines;
  final int? maxLines;

  const AuthTextField({
    required this.initialValue,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.minLines,
    this.maxLines,
    super.key,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant AuthTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      obscureText: widget.obscureText,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? 1,
    );
  }
}

/// Form for API Key Authentication
class ApiKeyAuthForm extends ConsumerWidget {
  const ApiKeyAuthForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedIdStateProvider);
    final authParams = ref.watch(selectedRequestModelProvider
            .select((value) => value?.httpRequestModel?.authParams)) ?? {};
    final keyValue = authParams['key'] as String? ?? '';
    final keyName = authParams['name'] as String? ?? '';
    final addTo = authParams['addTo'] as String? ?? 'header';

    return SingleChildScrollView(
      child: Padding(
        padding: kPh4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'API Key Authentication',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              key: Key('$selectedId-apikey-key'),
              initialValue: keyValue,
              onChanged: (value) {
                final newParams = Map<String, dynamic>.from(authParams);
                newParams['key'] = value;
                if (addTo == 'header') {
                  final List<NameValueModel> headerRows = [
                    NameValueModel(name: keyName, value: value)
                  ];
                  final List<bool> isHeaderEnabledList = [true];
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    headers: headerRows,
                    isHeaderEnabledList: isHeaderEnabledList,
                  );
                } else if (addTo == 'query') {
                  final List<NameValueModel> paramRows = [
                    NameValueModel(name: keyName, value: value)
                  ];
                  final List<bool> isParamEnabledList = [true];
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    params: paramRows,
                    isParamEnabledList: isParamEnabledList,
                  );
                }
                ref.read(collectionStateNotifierProvider.notifier).update(
                  id: selectedId,
                  authParams: newParams,
                );
              },
              labelText: 'Key',
              hintText: 'Enter your API key',
            ),
            const SizedBox(height: 16),
            AuthTextField(
              key: Key('$selectedId-apikey-name'),
              initialValue: keyName,
              onChanged: (value) {
                final newParams = Map<String, dynamic>.from(authParams);
                newParams['name'] = value;
                if (addTo == 'header') {
                  final List<NameValueModel> headerRows = [
                    NameValueModel(name: value, value: keyValue)
                  ];
                  final List<bool> isHeaderEnabledList = [true];
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    headers: headerRows,
                    isHeaderEnabledList: isHeaderEnabledList,
                  );
                } else if (addTo == 'query') {
                  final List<NameValueModel> paramRows = [
                    NameValueModel(name: value, value: keyValue)
                  ];
                  final List<bool> isParamEnabledList = [true];
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    params: paramRows,
                    isParamEnabledList: isParamEnabledList,
                  );
                }
                ref.read(collectionStateNotifierProvider.notifier).update(
                  id: selectedId,
                  authParams: newParams,
                );
              },
              labelText: 'Key Name',
              hintText: 'e.g. X-API-Key, api_key',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: Key('$selectedId-apikey-addto'),
              decoration: const InputDecoration(
                labelText: 'Add to',
                border: OutlineInputBorder(),
              ),
              value: addTo,
              items: const [
                DropdownMenuItem(value: 'header', child: Text('Header')),
                DropdownMenuItem(value: 'query', child: Text('Query Parameter')),
              ],
              onChanged: (value) {
                if (value != null) {
                  final newParams = Map<String, dynamic>.from(authParams);
                  newParams['addTo'] = value;
                  if (value == 'header') {
                    final List<NameValueModel> headerRows = [
                      NameValueModel(name: keyName, value: keyValue)
                    ];
                    final List<bool> isHeaderEnabledList = [true];
                    ref.read(collectionStateNotifierProvider.notifier).update(
                      headers: headerRows,
                      isHeaderEnabledList: isHeaderEnabledList,
                      params: [],
                      isParamEnabledList: [],
                    );
                  } else if (value == 'query') {
                    final List<NameValueModel> paramRows = [
                      NameValueModel(name: keyName, value: keyValue)
                    ];
                    final List<bool> isParamEnabledList = [true];
                    ref.read(collectionStateNotifierProvider.notifier).update(
                      params: paramRows,
                      isParamEnabledList: isParamEnabledList,
                      headers: [],
                      isHeaderEnabledList: [],
                    );
                  }
                  ref.read(collectionStateNotifierProvider.notifier).update(
                    id: selectedId,
                    authParams: newParams,
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'The API key will be automatically added to your request.',
                      style: TextStyle(
                        fontSize: 13,
                      ),
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