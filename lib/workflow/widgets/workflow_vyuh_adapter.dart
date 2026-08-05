import 'package:apidash/workflow/models/workflow_models.dart';
import 'package:apidash/workflow/widgets/workflow_node_layout.dart';
import 'package:flutter/material.dart';
import 'package:vyuh_node_flow/vyuh_node_flow.dart';

/// Lean [WorkflowDocument] → ephemeral Vyuh graph. Never write this shape to disk.
class WorkflowVyuhAdapter {
  const WorkflowVyuhAdapter._();

  static String structureFingerprint(WorkflowDocument doc) {
    final nodes = [
      for (final n in doc.graph.nodes)
        '${n.id}:${n.type.name}:${n.position.x.toStringAsFixed(1)},${n.position.y.toStringAsFixed(1)}',
    ].join('|');
    final edges = [
      for (final e in doc.graph.edges)
        '${e.id}:${e.source}>${e.target}:${workflowHandleToPortId(e.sourceHandle)}>${workflowHandleToPortId(e.targetHandle)}',
    ].join('|');
    return '${doc.id}#$nodes#$edges';
  }

  static NodeGraph<String, void> toGraph(WorkflowDocument doc) {
    return NodeGraph<String, void>(
      nodes: [for (final node in doc.graph.nodes) _toNode(node)],
      connections: [
        for (final edge in doc.graph.edges)
        Connection(
          id: edge.id,
          sourceNodeId: edge.source,
          sourcePortId: workflowHandleToPortId(edge.sourceHandle),
          targetNodeId: edge.target,
          targetPortId: workflowHandleToPortId(edge.targetHandle),
          label: ConnectionLabel.center(text: '×', id: 'detach'),
        ),
      ],
    );
  }

  static Node<String> _toNode(WorkflowGraphNode node) {
    final size = WorkflowNodeLayout.sizeFor(node);
    return Node<String>(
      id: node.id,
      type: node.type.name,
      position: Offset(node.position.x, node.position.y),
      size: size,
      data: node.id,
      ports: portsFor(node, size),
    );
  }

  /// Port ids match disk `out` / `in` strings. Y uses node height fractions
  /// (Vyuh port `offset.dy` = center).
  static List<Port> portsFor(WorkflowGraphNode node, Size size) {
    Port out(String id, String name, double yFrac) => Port(
          id: id,
          name: name,
          position: PortPosition.right,
          type: PortType.output,
          offset: Offset(0, size.height * yFrac),
          multiConnections: true,
          showLabel: true,
        );
    Port inn(String id, String name, double yFrac) => Port(
          id: id,
          name: name,
          position: PortPosition.left,
          type: PortType.input,
          offset: Offset(0, size.height * yFrac),
          multiConnections: true,
          showLabel: true,
        );

    return switch (node.type) {
      WorkflowNodeType.manualStart => [out('next', 'Next', 0.5)],
      WorkflowNodeType.request => [
          inn('in', 'Send', 0.66),
          out('success', 'Success', 0.58),
          out('failure', 'Fail', 0.72),
        ],
      WorkflowNodeType.condition => [
          inn('in', 'In', 0.55),
          out('then', 'True', 0.4),
          out('else', 'False', 0.68),
        ],
      WorkflowNodeType.loop => [
          inn('in', 'In', 0.42),
          out('next', 'Each', 0.32),
          out('done', 'Done', 0.62),
          // both: receive Sequence from below, or stretch down to add Sequence.
          Port(
            id: 'list',
            name: 'Seq',
            position: PortPosition.bottom,
            type: PortType.both,
            offset: Offset(size.width * 0.5, 0),
            multiConnections: false,
            showLabel: true,
          ),
        ],
      WorkflowNodeType.delay => [
          inn('in', 'In', 0.5),
          out('next', 'Next', 0.5),
        ],
      WorkflowNodeType.sequence => [
          Port(
            id: 'next',
            name: 'Next',
            position: PortPosition.top,
            type: PortType.both,
            offset: Offset(size.width * 0.5, 0),
            multiConnections: false,
            showLabel: true,
          ),
        ],
    };
  }
}

String workflowHandleToPortId(WorkflowEdgeHandle handle) => switch (handle) {
      WorkflowEdgeHandle.elseBranch => 'else',
      WorkflowEdgeHandle.inPort => 'in',
      WorkflowEdgeHandle.loopDone => 'done',
      WorkflowEdgeHandle.loopList => 'list',
      _ => handle.name,
    };

WorkflowEdgeHandle workflowPortIdToHandle(String portId) => switch (portId) {
      'else' => WorkflowEdgeHandle.elseBranch,
      'in' => WorkflowEdgeHandle.inPort,
      'done' => WorkflowEdgeHandle.loopDone,
      'list' => WorkflowEdgeHandle.loopList,
      'next' => WorkflowEdgeHandle.next,
      'success' => WorkflowEdgeHandle.success,
      'failure' => WorkflowEdgeHandle.failure,
      'then' => WorkflowEdgeHandle.then,
      _ => WorkflowEdgeHandle.next,
    };
