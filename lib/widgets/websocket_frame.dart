import 'package:apidash/providers/collection_providers.dart';

import 'package:apidash_core/models/websocket_frame_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class WebsocketFrame extends StatefulWidget {
  final WebSocketFrameModel websocketFrame;
  final WidgetRef ref;
  const WebsocketFrame({super.key, required this.websocketFrame,required this.ref});
  
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
      margin:const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding:const EdgeInsets.symmetric(horizontal: 8.0),
        leading: Icon(
         widget.websocketFrame.isSend ? Icons.arrow_upward :Icons.arrow_downward,
        ),
        title: Text(
        widget.websocketFrame.message,
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
          IconButton(onPressed: () {
            widget.ref.read(collectionStateNotifierProvider.notifier).deleteFrame(widget.websocketFrame.id);
          }, icon: const Icon(Icons.delete)),
        ],
        ),
      ),
      ),
    );
  }
}

// import 'package:apidash/providers/collection_providers.dart';
// import 'package:apidash_core/models/websocket_frame_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class WebsocketFrame extends ConsumerWidget {
//   final WebSocketFrameModel websocketFrame;

//   const WebsocketFrame({super.key, required this.websocketFrame});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     bool _isExpanded =  false;

//       void _toggleExpand() {

//       _isExpanded = !_isExpanded;
//     }
  

//     return GestureDetector(
//       onTap: _toggleExpand,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: _isExpanded ? Colors.grey.shade900 : Colors.grey.shade800,
//           border: Border.all(color: Colors.white10),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
//               leading: Icon(
//                 websocketFrame.isSend ? Icons.arrow_upward : Icons.arrow_downward,
//                 color: websocketFrame.isSend ? Colors.green : Colors.red,
//               ),
//               title: Text(
//                 websocketFrame.message,
//                 maxLines: _isExpanded ? null : 1,
//                 overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
//                 style: const TextStyle(color: Colors.white),
//               ),
//               subtitle: Row(
//                 children: [
//                   Icon(
//                     _isExpanded ? Icons.expand_less : Icons.expand_more,
//                     color: Colors.white70,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     _isExpanded ? "Collapse" : "Expand",
//                     style: const TextStyle(color: Colors.white70, fontSize: 12),
//                   ),
//                 ],
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     websocketFrame.formattedTime,
//                     style: const TextStyle(color: Colors.white54, fontSize: 12),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       ref.read(collectionStateNotifierProvider.notifier).deleteFrame(websocketFrame.id);
//                     },
//                     icon: const Icon(Icons.delete, color: Colors.redAccent),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
