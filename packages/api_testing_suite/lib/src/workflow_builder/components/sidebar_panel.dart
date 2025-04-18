import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workflow_builder_screen.dart';

class SidebarPanel extends ConsumerWidget {
  final LeftPanelTab selectedTab;
  final ValueChanged<LeftPanelTab> onTabChanged;

  const SidebarPanel({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 280,
      color: const Color(0xFF212121),
      child: Column(
        children: [
          _buildTabBar(context),
          Expanded(
            child: selectedTab == LeftPanelTab.apiComponents
                ? APIComponentList()
                : TemplatesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 48,
      color: const Color(0xFF272727),
      child: Row(
        children: [
          Expanded(
            child: _buildSidebarItem(
              Icons.api,
              'Components',
              selectedTab == LeftPanelTab.apiComponents,
              onTap: () => onTabChanged(LeftPanelTab.apiComponents),
            ),
          ),
          Expanded(
            child: _buildSidebarItem(
              Icons.bookmark,
              'Templates',
              selectedTab == LeftPanelTab.templates,
              onTap: () => onTabChanged(LeftPanelTab.templates),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, bool isSelected,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class APIComponentList extends StatelessWidget {
  const APIComponentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CardItem(
          icon: Icons.api,
          title: 'HTTP Request',
          description: 'Make HTTP requests to APIs',
          onTap: () => _onComponentSelected(context, 'http_request'),
        ),
        CardItem(
          icon: Icons.storage,
          title: 'Data Store',
          description: 'Store and retrieve data',
          onTap: () => _onComponentSelected(context, 'data_store'),
        ),
        CardItem(
          icon: Icons.transform,
          title: 'Data Transformer',
          description: 'Transform and process data',
          onTap: () => _onComponentSelected(context, 'data_transformer'),
        ),
      ],
    );
  }

  void _onComponentSelected(BuildContext context, String componentType) {
    // TODO: @abhinavs1920 Implement component selection logic
  }
}

class TemplatesList extends StatelessWidget {
  const TemplatesList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CardItem(
          icon: Icons.api,
          title: 'API Integration',
          description: 'Template for API integration workflows',
          onTap: () => _onTemplateSelected(context, 'api_integration'),
        ),
        CardItem(
          icon: Icons.storage,
          title: 'Data Processing',
          description: 'Template for data processing workflows',
          onTap: () => _onTemplateSelected(context, 'data_processing'),
        ),
      ],
    );
  }

  void _onTemplateSelected(BuildContext context, String templateId) {
    // TODO: @abhinavs1920 Implement template selection logic
  }
}

class CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const CardItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF272727),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
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
