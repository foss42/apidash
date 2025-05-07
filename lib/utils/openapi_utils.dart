bool isValidOpenApiSpec(Map<String, dynamic> spec) {
  return (spec.containsKey('openapi') || spec.containsKey('swagger')) &&
      spec['paths'] is Map &&
      spec['info'] is Map &&
      (spec['info'] as Map).containsKey('title');
}
bool isOpenApiFile(String filename) {
  return filename.endsWith('.json') || 
         filename.endsWith('.yaml') ||
         filename.endsWith('.yml');
}