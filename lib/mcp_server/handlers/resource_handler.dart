import 'dart:async';
import 'dart:convert';
import 'package:hive_ce/hive.dart';
import '../../mcp/models.dart';
import '../../mcp/server_core.dart';

class HiveResourceHandler implements ResourceHandler {
  HiveResourceHandler();

  Future<void> init() async {
    // Shared initialization is now handled by ApidashMcpServer
  }

  @override
  Future<List<ResourceDescriptor>> listResources() async {
    await init();
    final dataBox = Hive.box('apidash-data');
    final envBox = Hive.box('apidash-environments');
    final historyBox = Hive.box('apidash-history-meta');

    final List<ResourceDescriptor> resources = [];

    final ids = dataBox.get('ids') as List<dynamic>?;
    if (ids != null) {
      for (var id in ids) {
        final data = dataBox.get(id);
        final name = data is Map ? data['name'] as String? : null;
        resources.add(ResourceDescriptor(
          uri: 'apidash://requests/$id',
          name: name ?? 'Request $id',
          description: name != null ? 'API request: $name' : 'API request',
          mimeType: 'application/json',
        ));
      }
    }

    final envIds = envBox.get('environmentIds') as List<dynamic>?;
    if (envIds != null) {
      for (var id in envIds) {
        final data = envBox.get(id);
        final name = data is Map ? data['name'] as String? : null;
        resources.add(ResourceDescriptor(
          uri: 'apidash://environments/$id',
          name: name ?? 'Environment $id',
          description: name != null ? 'Environment: $name' : 'Environment',
          mimeType: 'application/json',
        ));
      }
    }

    final historyIds = historyBox.get('historyIds') as List<dynamic>?;
    if (historyIds != null) {
      for (var id in historyIds) {
        final data = historyBox.get(id);
        String? name;
        if (data is Map) {
          final timestamp = data['timestamp'] as int?;
          if (timestamp != null) {
            name = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal().toString();
          }
        }
        resources.add(ResourceDescriptor(
          uri: 'apidash://history/$id',
          name: name ?? 'History $id',
          description: name != null ? 'History: $name' : 'History entry',
          mimeType: 'application/json',
        ));
      }
    }

    return resources;
  }

  @override
  Future<Resource?> getResource(String uri) async {
    await init();
    
    String id = uri;
    if (uri.startsWith('apidash://')) {
      final parts = uri.replaceFirst('apidash://', '').split('/');
      if (parts.length >= 2) {
        id = parts[1];
      }
    }

    final dataBox = Hive.box('apidash-data');
    final data = dataBox.get(id);
    if (data != null) {
      return Resource(
        uri: uri,
        text: jsonEncode(data),
        mimeType: 'application/json',
      );
    }

    final envBox = Hive.box('apidash-environments');
    final envData = envBox.get(id);
    if (envData != null) {
      return Resource(
        uri: uri,
        text: jsonEncode(envData),
        mimeType: 'application/json',
      );
    }

    final historyBox = Hive.box('apidash-history-meta');
    final historyData = historyBox.get(id);
    if (historyData != null) {
      final lazyBox = Hive.box('apidash-history-lazy');
      final fullData = lazyBox.get(id);
      final combined = {
        'meta': historyData,
        'details': fullData,
      };
      return Resource(
        uri: uri,
        text: jsonEncode(combined),
        mimeType: 'application/json',
      );
    }

    return null;
  }
}
