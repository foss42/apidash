import 'package:flutter/material.dart';

class CollectionPane extends StatefulWidget {
  const CollectionPane({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionPane> createState() => _CollectionPaneState();
}

class _CollectionPaneState extends State<CollectionPane> {
  int len = 0;

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
                  setState(() {
                    len += 1;
                  });
                },
                child: const Text('+ New'),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: RequestList(l: len),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestList extends StatefulWidget {
  const RequestList({
    Key? key,
    required this.l,
  }) : super(key: key);

  final int l;

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  List<String> requestItems = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (requestItems.length != widget.l) {
      requestItems = List.generate(widget.l, (index) => "request${index + 1}");
    }
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      itemCount: requestItems.length,
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        if (oldIndex != newIndex) {
          var t = requestItems[oldIndex];
          requestItems[oldIndex] = requestItems[newIndex];
          requestItems[newIndex] = t;
          setState(() {
            requestItems = [...requestItems];
          });
        }
      },
      itemBuilder: (context, index) {
        return ReorderableDragStartListener(
          key: Key(requestItems[index]),
          index: index,
          child: RequestItem(id: requestItems[index]),
        );
      },
    );
  }
}

enum RequestItemMenuOption { delete, duplicate }

class RequestItem extends StatefulWidget {
  const RequestItem({
    required this.id,
    Key? key,
  }) : super(key: key);

  final String id;

  @override
  State<RequestItem> createState() => _RequestItemState();
}

class _RequestItemState extends State<RequestItem> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = Colors.grey.shade50;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 1,
      color: Colors.grey.shade50,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 0,
            top: 5,
            bottom: 5,
          ),
          child: SizedBox(
            height: 22,
            child: Row(
              children: [
                MethodBox(),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    widget.id,
                  ),
                ),
                PopupMenuButton<RequestItemMenuOption>(
                  padding: EdgeInsets.zero,
                  splashRadius: 14,
                  iconSize: 14,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MethodBox extends StatelessWidget {
  const MethodBox({super.key});

  @override
  Widget build(BuildContext context) {
    String text = "get".toUpperCase();
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
