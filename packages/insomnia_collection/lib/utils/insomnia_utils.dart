


import 'package:insomnia_collection/models/insomnia_collection.dart';

List<(String?, Resource)> getRequestsFromInsomniaCollection(
    InsomniaCollection? ic) {
  if (ic == null || ic.resources == null) {
    return [];
  }
  List<(String?, Resource)> requests = [];
  if (ic.resources!.length > 0) {
    for (var i in ic.resources!) {
      requests.addAll(getRequestsFromInsomniaResource(i));
    }
  }
  return requests;
}

List<(String?, Resource)> getRequestsFromInsomniaResource(Resource? resource) {
  if (resource == null) {
    return [];
  }
  List<(String?, Resource)> requests = [];
  if (resource.type != null || resource.type == 'request') {
    requests.add((resource.name, resource));
  } else {
    print('Resource type is not request');
  }
  return requests;
}