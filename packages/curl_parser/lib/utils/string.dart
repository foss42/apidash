import 'package:shlex/shlex.dart' as shlex;

List<String> splitAsCommandLineArgs(String command) {
  return shlex.split(command);
}
