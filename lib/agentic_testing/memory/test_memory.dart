import 'memory_entry.dart';

class TestMemory {
  final String endpointUrl;
  final List<MemoryEntry> entries;

  const TestMemory({
    required this.endpointUrl,
    this.entries = const [],
  });

  TestMemory copyWith({
    String? endpointUrl,
    List<MemoryEntry>? entries,
  }) {
    return TestMemory(
      endpointUrl: endpointUrl ?? this.endpointUrl,
      entries: entries ?? this.entries,
    );
  }

  /// Adds a new entry, replacing an existing unverified one for the same rule type if it exists,
  /// or simply appending it if we are acquiring new knowledge.
  TestMemory addOrUpdateEntry(MemoryEntry newEntry) {
    final Map<String, MemoryEntry> latestEntriesMap = {};
    for (var e in entries) {
      latestEntriesMap[e.id] = e;
    }
    latestEntriesMap[newEntry.id] = newEntry;

    return copyWith(entries: latestEntriesMap.values.toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'endpointUrl': endpointUrl,
      'entries': entries.map((e) => e.toJson()).toList(),
    };
  }

  factory TestMemory.fromJson(Map<String, dynamic> json) {
    return TestMemory(
      endpointUrl: json['endpointUrl'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => MemoryEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}