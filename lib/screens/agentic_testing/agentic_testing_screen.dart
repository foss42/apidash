import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/agentic_testing_provider.dart';
import 'widgets/native_test_dashboard.dart';

class AgenticTestingScreen extends ConsumerStatefulWidget {
  const AgenticTestingScreen({super.key});

  @override
  ConsumerState<AgenticTestingScreen> createState() => _AgenticTestingScreenState();
}

class _AgenticTestingScreenState extends ConsumerState<AgenticTestingScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  void _handleSubmit() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    if (_apiKeyController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please configure API Key and Target URL first.")),
      );
      return;
    }

    ref.read(agenticDashboardProvider.notifier).generateTestPlan(
      prompt, _apiKeyController.text.trim(), _urlController.text.trim(),
    );
    _promptController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(agenticDashboardProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _apiKeyController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Gemini API Key",
                      border: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outlineVariant)),
                      prefixIcon: const Icon(Icons.key),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: "Target API URL",
                      border: OutlineInputBorder(borderSide: BorderSide(color: colorScheme.outlineVariant)),
                      prefixIcon: const Icon(Icons.link),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: dashboardState.isAiThinking
                  ? const Center(child: CircularProgressIndicator())
                  : dashboardState.error != null
                  ? Center(child: Text(dashboardState.error!, style: TextStyle(color: colorScheme.error)))
                  : NativeTestDashboard(targetUrl: _urlController.text.trim()),
            ),

            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surfaceContainer,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      decoration: const InputDecoration(
                        hintText: "Type your Agentic API testing goal here...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      onSubmitted: (_) => _handleSubmit(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: colorScheme.primary),
                    onPressed: _handleSubmit,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}