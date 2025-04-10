// import 'package:apidash_core/apidash_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/node_status.dart';
// import '../models/workflow_node_model.dart';
// import '../models/workflow_connection_model.dart';
// import 'workflow_providers.dart';

// /// Widget that displays a workflow node
// @immutable
// class WorkflowNodeWidget extends StatefulWidget {
//   final WorkflowNodeModel node;
//   final double scale;
//   final Function(double, double) onDragUpdate;
//   final Function(Offset) onConnect;

//   const WorkflowNodeWidget({
//     required this.node,
//     required this.scale,
//     required this.onDragUpdate,
//     required this.onConnect,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<WorkflowNodeWidget> createState() => _WorkflowNodeWidgetState();
// }

// class _WorkflowNodeWidgetState extends State<WorkflowNodeWidget> {
//   Offset _dragOffset = Offset.zero;
//   bool _isDragging = false;

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: widget.node.position.dx * widget.scale + _dragOffset.dx,
//       top: widget.node.position.dy * widget.scale + _dragOffset.dy,
//       child: GestureDetector(
//         onPanStart: (details) {
//           setState(() {
//             _isDragging = true;
//             _dragOffset = details.localPosition;
//           });
//         },
//         onPanUpdate: (details) {
//           if (_isDragging) {
//             setState(() {
//               _dragOffset = details.localPosition;
//             });
//             widget.onDragUpdate(_dragOffset.dx, _dragOffset.dy);
//           }
//         },
//         onPanEnd: (details) {
//           setState(() {
//             _isDragging = false;
//             _dragOffset = Offset.zero;
//           });
//         },
//         child: MouseRegion(
//           onEnter: (_) {
//             setState(() {
//               _isDragging = false;
//               _dragOffset = Offset.zero;
//             });
//           },
//           child: Container(
//             width: 200 * widget.scale,
//             height: 100 * widget.scale,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(
//                 color: widget.node.status.color,
//                 width: 2 * widget.scale,
//               ),
//               borderRadius: BorderRadius.circular(8 * widget.scale),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4 * widget.scale,
//                   offset: Offset(0, 2 * widget.scale),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8 * widget.scale),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.node.nodeType.toString(),
//                           style: TextStyle(
//                             fontSize: 16 * widget.scale,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete, size: 20 * widget.scale),
//                         onPressed: () {
//                           context.read(workflowsNotifierProvider.notifier).removeNode(widget.node.id);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8 * widget.scale),
//                   child: Text(
//                     widget.node.nodeData.toString(),
//                     style: TextStyle(fontSize: 12 * widget.scale),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.all(8 * widget.scale),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.edit, size: 20 * widget.scale),
//                         onPressed: () {
//                           context.read(workflowsNotifierProvider.notifier).selectNode(widget.node.id);
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.connect_without_contact, size: 20 * widget.scale),
//                         onPressed: () {
//                           widget.onConnect(widget.node.position);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
