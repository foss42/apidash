import 'insomnia_collection.dart';

enum ResourceType {
  workspace,
  environment,
  request_group,
  cookie_jar,
  request,
  websocket_payload,
  api_spec
}

class InsomniaItem {
  const InsomniaItem({
    this.id,
    this.type,
    this.resource,
    this.children,
  });

  final String? id;
  final ResourceType? type;
  final Resource? resource;
  final List<InsomniaItem?>? children;

  factory InsomniaItem.fromInsomniaCollection(
    InsomniaCollection? collection,
  ) {
    if (collection?.resources == null) {
      return InsomniaItem();
    }
    final resources = collection!.resources!;
    final resourceMap = <String, Resource?>{for (var v in resources) v.id!: v};
    Map<String, List<String>> childrenMap = {};
    for (var item in resources) {
      if (item.parentId != null && item.id != null) {
        if (childrenMap.containsKey(item.parentId)) {
          childrenMap[item.parentId]!.add(item.id!);
        } else {
          childrenMap[item.parentId!] = [item.id!];
        }
      }
    }
    var wksp;
    for (var item in resources) {
      if (item.type == ResourceType.workspace.name) {
        wksp = InsomniaItem(
          id: item.id,
          type: ResourceType.workspace,
          resource: item,
          children: getInsomniaItemChildren(
            childrenMap[item.id],
            childrenMap,
            resourceMap,
          ),
        );
        break;
      }
    }
    return wksp;
  }
}

List<InsomniaItem>? getInsomniaItemChildren(
  List<String>? ids,
  Map<String, List<String>> childrenMap,
  Map<String, Resource?> resourceMap,
) {
  if (ids == null) {
    return null;
  }
  List<InsomniaItem> children = [];
  for (var itemId in ids) {
    var resource = resourceMap[itemId];
    ResourceType? type;
    try {
      type = ResourceType.values.byName(resource?.type ?? '');
    } catch (e) {
      type = null;
    }
    if (childrenMap.containsKey(itemId)) {
      children.add(InsomniaItem(
        id: itemId,
        type: type,
        resource: resource,
        children: getInsomniaItemChildren(
          childrenMap[itemId],
          childrenMap,
          resourceMap,
        ),
      ));
    } else {
      children.add(InsomniaItem(
        id: itemId,
        type: type,
        resource: resource,
        children: null,
      ));
    }
  }
  return children;
}
