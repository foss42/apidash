import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/agent_testing_provider.dart';

class ApiKeyInput extends ConsumerStatefulWidget {
  const ApiKeyInput({super.key});

  @override
  ConsumerState<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends ConsumerState<ApiKeyInput> {
  late final TextEditingController _controller;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(agentTestingProvider).apiKey,
    );
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
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: 'Gemini API Key',
        hintText: 'AIza...',
        border: const OutlineInputBorder(),
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscure = !_obscure),
          tooltip: _obscure ? 'Show key' : 'Hide key',
        ),
      ),
      onChanged: (v) =>
          ref.read(agentTestingProvider.notifier).setApiKey(v.trim()),
    );
  }
}