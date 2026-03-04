import 'dart:io';

void main() {
  final source = File('assets/icons/app_icon.ico');
  final target = File('windows/runner/resources/app_icon.ico');

  if (!source.existsSync()) {
    print('Icon file not found in assets.');
    return;
  }

  if (!target.parent.existsSync()) {
    print('Windows runner not found. Run: flutter create --platform=windows .');
    return;
  }

  source.copySync(target.path);
  print('Windows icon updated successfully.');
}