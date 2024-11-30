import 'package:shlex/shlex.dart' as shlex;

List<String> splitAsCommandLineArgs(String command) {
  return shlex.split(command);
}

String? clean(String? url) {
  return url?.replaceAll('"', '').replaceAll("'", '');
}
