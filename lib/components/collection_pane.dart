import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../consts.dart';

class CollectionPane extends ConsumerStatefulWidget {
  const CollectionPane({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CollectionPane> createState() => _CollectionPaneState();
}

class _CollectionPaneState extends ConsumerState<CollectionPane> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  String newId =
                      ref.read(collectionStateNotifierProvider.notifier).add();
                  ref
                      .read(activeItemIdStateProvider.notifier)
                      .update((state) => newId);
                },
                child: const Text('+ New'),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Expanded(
            child: SingleChildScrollView(
              child: RequestList(),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestList extends ConsumerStatefulWidget {
  const RequestList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RequestList> createState() => _RequestListState();
}

class _RequestListState extends ConsumerState<RequestList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final requestItems = ref.watch(collectionStateNotifierProvider);
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      itemCount: requestItems.length,
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        if (oldIndex != newIndex) {
          ref
              .read(collectionStateNotifierProvider.notifier)
              .reorder(oldIndex, newIndex);
        }
      },
      itemBuilder: (context, index) {
        return ReorderableDragStartListener(
          key: Key(requestItems[index].id),
          index: index,
          child: RequestItem(
              id: requestItems[index].id, requestModel: requestItems[index]),
        );
      },
    );
  }
}

enum RequestItemMenuOption { delete, duplicate }

class RequestItem extends ConsumerStatefulWidget {
  const RequestItem({
    required this.id,
    required this.requestModel,
    Key? key,
  }) : super(key: key);

  final String id;
  final RequestModel requestModel;

  @override
  ConsumerState<RequestItem> createState() => _RequestItemState();
}

class _RequestItemState extends ConsumerState<RequestItem> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = Colors.grey.shade50;
  }

  @override
  Widget build(BuildContext context) {
    final activeRequest = ref.watch(activeItemIdStateProvider);
    bool isActiveId = activeRequest == widget.id;
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: isActiveId ? 2 : 0,
      color: isActiveId ? Colors.grey.shade300 : _color,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          ref
              .read(activeItemIdStateProvider.notifier)
              .update((state) => widget.id);
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: isActiveId ? 0 : 20,
            top: 5,
            bottom: 5,
          ),
          child: SizedBox(
            height: 22,
            child: Row(
              children: [
                MethodBox(method: widget.requestModel.method),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    widget.requestModel.id,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
                Visibility(
                  visible: isActiveId,
                  child: PopupMenuButton<RequestItemMenuOption>(
                    padding: EdgeInsets.zero,
                    splashRadius: 14,
                    iconSize: 14,
                    onSelected: (RequestItemMenuOption item) {
                      if (item == RequestItemMenuOption.delete) {
                        ref
                            .read(activeItemIdStateProvider.notifier)
                            .update((state) => null);
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .remove(widget.id);
                      }
                      if (item == RequestItemMenuOption.duplicate) {
                        ref
                            .read(collectionStateNotifierProvider.notifier)
                            .duplicate(widget.id);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<RequestItemMenuOption>>[
                      const PopupMenuItem<RequestItemMenuOption>(
                        value: RequestItemMenuOption.delete,
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem<RequestItemMenuOption>(
                        value: RequestItemMenuOption.duplicate,
                        child: Text('Duplicate'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MethodBox extends StatelessWidget {
  const MethodBox({super.key, required this.method});
  final HTTPVerb method;

  @override
  Widget build(BuildContext context) {
    String text = method.name.toUpperCase();
    if (method == HTTPVerb.delete) {
      text = "DEL";
    }
    return SizedBox(
      width: 25,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
