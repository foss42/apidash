String jsonToPyDict(String jsonString) {
  Map<String, String> replaceWithMap = {
    "null": "None",
    "true": "True",
    "false": "False"
  };
  String pyDict = jsonString;
  for (var k in replaceWithMap.keys) {
    RegExp regExp = RegExp(k + r'(?=([^"]*"[^"]*")*[^"]*$)');
    pyDict = pyDict.replaceAllMapped(regExp, (match) {
      return replaceWithMap[match.group(0)] ?? match.group(0)!;
    });
  }
  return pyDict;
}
