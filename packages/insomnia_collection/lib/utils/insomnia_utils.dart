import '../models/models.dart';

List<(String?, Resource)> getRequestsFromInsomniaCollection(
        InsomniaCollection? ic) =>
    getItemByTypeFromInsomniaCollection(ic, ResourceType.request.name);

List<(String?, Resource)> getEnvironmentsFromInsomniaCollection(
        InsomniaCollection? ic) =>
    getItemByTypeFromInsomniaCollection(ic, ResourceType.environment.name);

List<(String?, Resource)> getItemByTypeFromInsomniaCollection(
  InsomniaCollection? ic,
  String type,
) {
  if (ic?.resources == null || ic!.resources!.length == 0) {
    return [];
  }
  List<(String?, Resource)> requests = [];
  for (var item in ic.resources!) {
    if (item.type != null && item.type == type) {
      requests.add((item.name, item));
    }
  }
  return requests;
}
