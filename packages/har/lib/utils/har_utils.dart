import '../models/har_log.dart';

List<(String?, Request)> getRequestsFromHarLog(HarLog? hl) {
  if (hl == null || hl.log == null || hl.log?.entries == null) {
    return [];
  }
  List<(String?, Request)> requests = [];
  if (hl.log?.entries?.isNotEmpty ?? false)
    for (var entry in hl.log!.entries!) {
      requests.addAll(getRequestsFromHarLogEntry(entry));
    }
  return requests;
}

List<(String?, Request)> getRequestsFromHarLogEntry(Entry? entry) {
  if (entry == null) {
    return [];
  }
  List<(String?, Request)> requests = [];
  if (entry.request != null) {
    requests.add((entry.startedDateTime, entry.request!));
  }
  return requests;
}
