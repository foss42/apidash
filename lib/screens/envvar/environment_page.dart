import 'package:flutter/material.dart';
import 'package:apidash/widgets/widgets.dart';
import 'environments_pane.dart';

class EnvironmentPage extends StatelessWidget {
  const EnvironmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: DashboardSplitView(
            sidebarWidget: EnvironmentsPane(),
            mainWidget: SizedBox(),
          ),
        ),
      ],
    );
  }
}
