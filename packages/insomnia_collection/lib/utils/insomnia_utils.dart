


import 'package:insomnia_collection/models/insomnia_collection.dart';
import 'package:insomnia_collection/models/insomnia_environment.dart';

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

List<EnvironmentVariable> getEnvironmentVariablesFromInsomniaEnvironment(
    InsomniaEnvironment? ev) {
  if (ev == null || ev.resources == null) {
    return [];
  }
  List<EnvironmentVariable> envVariables = [];
  if (ev.resources!.length > 0) {
    for (var envvar in ev.resources!) {
      envVariables.add(envvar);
    }
  }
  return envVariables;
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

