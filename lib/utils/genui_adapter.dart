import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';

/// GenUIAdapter converts a **subset** of A2UI-style specs into Flutter widgets.
///
/// This is intentionally a safe, declarative renderer:
/// - It builds a widget tree from JSON data.
/// - It renders children recursively.
/// - It never executes arbitrary code from the spec.
///
/// Note: This implementation currently supports only a small set of primitives
/// used by API Dash demos, not the full A2UI protocol surface.
class GenUIAdapter {
  GenUIAdapter._();

  static Widget build(Map<String, dynamic> spec) {
    final type = spec['type']?.toString().toLowerCase().trim() ?? 'text';
    switch (type) {
      case 'text':
        return _buildText(spec);
      case 'card':
        return _buildCard(spec);
      case 'row':
        return _buildRow(spec);
      case 'column':
        return _buildColumn(spec);
      case 'button':
        return _buildButton(spec);
      case 'list':
        return _buildList(spec);
      case 'divider':
        return _buildDivider(spec);
      case 'image':
        return _buildImage(spec);
      case 'badge':
        return _buildBadge(spec);
      default:
        return SelectableText(spec.toString(), style: kCodeStyle);
    }
  }

  static Widget _buildText(Map<String, dynamic> spec) {
    return _safeText(spec['text']?.toString() ?? '');
  }

  static Widget _buildCard(Map<String, dynamic> spec) {
    final title = spec['title']?.toString();
    final subtitle = spec['subtitle']?.toString();
    final bodyText = spec['text']?.toString();
    final children = _childrenFromSpec(spec['children']);

    final content = <Widget>[];
    if (title != null && title.isNotEmpty) {
      content.add(
        Text(title, style: kCodeStyle.copyWith(fontWeight: FontWeight.bold)),
      );
    }
    if (subtitle != null && subtitle.isNotEmpty) {
      content.add(const SizedBox(height: 4));
      content.add(Text(subtitle, style: kCodeStyle));
    }
    if (bodyText != null && bodyText.isNotEmpty) {
      content.add(const SizedBox(height: 4));
      content.add(_safeText(bodyText));
    }
    if (children.isNotEmpty) {
      if (content.isNotEmpty) content.add(const SizedBox(height: 8));
      content.addAll(children);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: content,
        ),
      ),
    );
  }

  static Widget _buildRow(Map<String, dynamic> spec) {
    final children = _childrenFromSpec(spec['children']);
    if (children.isEmpty) return const SizedBox.shrink();
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  static Widget _buildColumn(Map<String, dynamic> spec) {
    final children = _childrenFromSpec(spec['children']);
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  static Widget _buildButton(Map<String, dynamic> spec) {
    final label = spec['label']?.toString() ?? '';
    return ElevatedButton(onPressed: () {}, child: Text(label));
  }

  static Widget _buildList(Map<String, dynamic> spec) {
    final items = spec['items'];
    if (items is! List) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: items
          .map((e) => ListTile(dense: true, title: Text(e?.toString() ?? '')))
          .toList(),
    );
  }

  static Widget _buildDivider(Map<String, dynamic> spec) {
    return const Divider(height: 16);
  }

  static Widget _buildImage(Map<String, dynamic> spec) {
    final url = spec['url']?.toString() ?? spec['src']?.toString() ?? '';
    final uri = Uri.tryParse(url);
    final isSafeNetwork =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    if (!isSafeNetwork) return _safeText('<invalid image source>');

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, _, __) => _safeText('<failed to load image>'),
      ),
    );
  }

  static Widget _buildBadge(Map<String, dynamic> spec) {
    final label = spec['label']?.toString() ?? spec['text']?.toString() ?? '';
    if (label.isEmpty) return const SizedBox.shrink();
    return Chip(label: Text(label), visualDensity: VisualDensity.compact);
  }

  static List<Widget> _childrenFromSpec(dynamic childrenSpec) {
    if (childrenSpec is! List) return <Widget>[];
    return childrenSpec
        .whereType<Map>()
        .map<Map<String, dynamic>>((e) => e.cast<String, dynamic>())
        .map(build)
        .toList();
  }

  static Widget _safeText(String text) =>
      SelectableText(text, style: kCodeStyle);
}
