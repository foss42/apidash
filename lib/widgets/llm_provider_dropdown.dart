import 'package:flutter/material.dart';

class LlmProviderDropdown extends StatefulWidget {
  const LlmProviderDropdown({super.key});

  @override
  LlmProviderDropdownState createState() => LlmProviderDropdownState();
}

class LlmProviderDropdownState extends State<LlmProviderDropdown> {
  LlmProvider? _selectedProvider;

  final List<LlmProvider> _providers = [
    LlmProvider(
      type: "LOCAL",
      name: 'Ollama',
      subtitle: 'Run LLMs locally on your machine',
      logo: 'assets/dashbot_icon_1.png',
    ),
    LlmProvider(
      type: "REMOTE",
      name: 'Gemini',
      subtitle: 'You local LLM provider',
      logo: 'assets/dashbot_icon_1.png',
    ),
    LlmProvider(
      type: "REMOTE",
      name: 'OpenAI',
      subtitle: 'You local LLM provider',
      logo: 'assets/dashbot_icon_1.png',
    ),
    LlmProvider(
      type: "REMOTE",
      name: 'Anthropic',
      subtitle: 'You local LLM provider',
      logo: 'assets/dashbot_icon_1.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedProvider = _providers.first;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<LlmProvider>(
      initialValue: _selectedProvider,
      onSelected: (LlmProvider item) {
        setState(() {
          _selectedProvider = item;
        });
      },
      itemBuilder: (BuildContext context) => _providers.map((LlmProvider item) {
        return PopupMenuItem<LlmProvider>(
          value: item,
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(item.logo),
            ),
            title: Text(item.name),
            subtitle: Text(item.subtitle),
            dense: true,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
        );
      }).toList(),
      offset: Offset(0, 60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(_selectedProvider!.logo),
        ),
        title: Text(_selectedProvider!.name),
        subtitle: Text(_selectedProvider!.subtitle),
        trailing: Icon(Icons.arrow_drop_down),
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class LlmProvider {
  final String type;
  final String name;
  final String subtitle;
  final String logo;

  LlmProvider({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.logo,
  });
}
