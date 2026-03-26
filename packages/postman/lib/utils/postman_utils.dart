import '../models/postman_collection.dart';

String substituteVariables(String input, Map<String, String> variables) {
  return input.replaceAllMapped(RegExp(r'\{\{([^{}]+)\}\}'), (match) {
    final key = match.group(1)?.trim();
    if (key == null || key.isEmpty) {
      return match.group(0) ?? '';
    }
    return variables[key] ?? (match.group(0) ?? '');
  });
}

Map<String, String> buildVariableMap(List<Variable>? variables) {
  if (variables == null) {
    return {};
  }
  final map = <String, String>{};
  for (final variable in variables) {
    final key = variable.key;
    if (key == null || key.isEmpty) {
      continue;
    }
    map[key] = variable.value ?? '';
  }
  return map;
}

List<(String?, Request)> getRequestsFromPostmanCollection(
    PostmanCollection? pc) {
  if (pc == null || pc.item == null) {
    return [];
  }
  List<(String?, Request)> requests = [];
  if (pc.item!.length > 0) {
    for (var i in pc.item!) {
      requests.addAll(getRequestsFromPostmanItem(i));
    }
  }
  return requests;
}

List<(String?, Request)> getRequestsFromPostmanItem(Item? item) {
  if (item == null) {
    return [];
  }
  List<(String?, Request)> requests = [];
  if (item.request != null) {
    requests.add((item.name, item.request!));
  } else {
    if (item.item != null && item.item!.length > 0) {
      for (var i in item.item!) {
        var r = getRequestsFromPostmanItem(i);
        requests.addAll(r);
      }
    }
  }
  return requests;
}
