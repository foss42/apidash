import '../models/postman_collection.dart';

/// Extracts all requests from a Postman collection, preserving folder hierarchy
/// in the request names (e.g., "Folder/Subfolder/Request Name").
List<(String?, Request)> getRequestsFromPostmanCollection(
  PostmanCollection? pc, {
  String folderPath = '',
}) {
  if (pc == null || pc.item == null) {
    return [];
  }
  List<(String?, Request)> requests = [];
  if (pc.item!.length > 0) {
    for (var i in pc.item!) {
      requests.addAll(getRequestsFromPostmanItem(i, folderPath: folderPath));
    }
  }
  return requests;
}

/// Recursively extracts requests from a Postman item, tracking the folder path.
/// [folderPath] accumulates the folder hierarchy as items are traversed.
List<(String?, Request)> getRequestsFromPostmanItem(
  Item? item, {
  String folderPath = '',
}) {
  if (item == null) {
    return [];
  }
  List<(String?, Request)> requests = [];
  if (item.request != null) {
    // This is a request item - prepend folder path to the name
    final name = folderPath.isEmpty
        ? item.name
        : (item.name != null ? '$folderPath/${item.name}' : folderPath);
    requests.add((name, item.request!));
  } else {
    // This is a folder item - recurse into children with updated path
    if (item.item != null && item.item!.length > 0) {
      final newPath = folderPath.isEmpty
          ? (item.name ?? '')
          : (item.name != null ? '$folderPath/${item.name}' : folderPath);
      for (var i in item.item!) {
        var r = getRequestsFromPostmanItem(i, folderPath: newPath);
        requests.addAll(r);
      }
    }
  }
  return requests;
}
