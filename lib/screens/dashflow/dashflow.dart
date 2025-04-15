import 'package:apidash/screens/dashflow/dashflow_builder/dashflow_builder.dart';
import 'package:apidash/screens/dashflow/workflow_pane.dart';
import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';

class DashflowPage extends StatelessWidget {
  const DashflowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
            children: [
              Expanded(
                child: DashboardSplitView(
                  sidebarWidget: WorkflowPane(),
                  mainWidget: DashflowBuilder(),
                ),
              ),
            ],
          );
  }
}