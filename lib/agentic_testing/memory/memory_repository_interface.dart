import 'test_memory.dart';

abstract class MemoryRepository {
  Future<void> init();
  Future<TestMemory?> getMemoryForEndpoint(String url);
  Future<void> saveMemory(TestMemory memory);
}