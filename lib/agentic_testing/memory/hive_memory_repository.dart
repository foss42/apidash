import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart'; // Fixed: using hive_ce instead of hive
import 'memory_repository_interface.dart';
import 'test_memory.dart';

const String kAgenticMemoryBox = "apidash-agentic-memory";

class HiveMemoryRepository implements MemoryRepository {
  late final Box _box;
  bool _isInitialized = false;

  @override
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      if (!Hive.isBoxOpen(kAgenticMemoryBox)) {
        _box = await Hive.openBox(kAgenticMemoryBox);
      } else {
        _box = Hive.box(kAgenticMemoryBox);
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint("ERROR OPENING AGENTIC MEMORY HIVE BOX: $e");
      rethrow;
    }
  }

  @override
  Future<TestMemory?> getMemoryForEndpoint(String url) async {
    if (!_isInitialized) await init();
    try {
      final rawData = _box.get(url);
      if (rawData == null) return null;
      
      final Map<String, dynamic> jsonMap = jsonDecode(jsonEncode(rawData));
      return TestMemory.fromJson(jsonMap);
    } catch (e) {
      debugPrint("ERROR READING AGENTIC MEMORY FOR URL $url: $e");
      return null;
    }
  }

  @override
  Future<void> saveMemory(TestMemory memory) async {
    if (!_isInitialized) await init();
    try {
      await _box.put(memory.endpointUrl, memory.toJson());
    } catch (e) {
      debugPrint("ERROR SAVING AGENTIC MEMORY: $e");
    }
  }

  @visibleForTesting
  Future<void> clearAll() async {
    if (!_isInitialized) await init();
    await _box.clear();
  }
}