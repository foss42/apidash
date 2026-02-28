import '../models/postman_collection.dart';

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
