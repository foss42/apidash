import 'package:apidash_core/models/websocket_frame_model.dart';
import 'package:flutter/material.dart';


class WebsocketFrame extends StatefulWidget {
  final WebSocketFrameModel websocketFrame;
  const WebsocketFrame({super.key, required this.websocketFrame});
  
  @override
  State<WebsocketFrame> createState() => _WebsocketFrameState();
}

class _WebsocketFrameState extends State<WebsocketFrame> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
        leading: Icon(
        Icons.arrow_upward,
        ),
        title: Text(
        widget.websocketFrame.message + " " + widget.websocketFrame.formattedTime,
        maxLines: _isExpanded ? null : 1,
        overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        subtitle: Icon(
        _isExpanded ? Icons.expand_less : Icons.expand_more,
        ),
        trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.websocketFrame.formattedTime),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
        ],
        ),
      ),
      ),
    );
  }
}