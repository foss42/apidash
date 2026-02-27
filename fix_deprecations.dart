import 'dart:io';

void main() {
  final dir = Directory('test');
  int replacements = 0;

  if (!dir.existsSync()) return;

  for (var entity in dir.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = entity.readAsStringSync();
      String newContent = content
          .replaceAll('window.devicePixelRatio', 'view.devicePixelRatio')
          .replaceAll('window.physicalSizeTestValue', 'view.physicalSize')
          .replaceAll(
              'window.clearPhysicalSizeTestValue', 'view.resetPhysicalSize')
          .replaceAll('window.clearDevicePixelRatioTestValue',
              'view.resetDevicePixelRatio')
          .replaceAll('devicePixelRatioTestValue', 'view.devicePixelRatio')
          .replaceAll('tester.binding.window', 'tester.view')
          .replaceAll('.window', '.view');

      if (content != newContent) {
        entity.writeAsStringSync(newContent);
        replacements++;
      }
    }
  }
  print('Replaced in $replacements files');
}
