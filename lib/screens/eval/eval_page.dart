import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../consts.dart';
import '../../widgets/widgets.dart';

import './widgets/benchmark_runner.dart';
import './widgets/dataset_config.dart';
import './widgets/multimodal_eval.dart';

class EvalPage extends ConsumerStatefulWidget {
  const EvalPage({super.key});

  @override
  ConsumerState<EvalPage> createState() => _EvalPageState();
}

class _EvalPageState extends ConsumerState<EvalPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: kPh20t40,
          child: Row(
            children: [
              Text(
                kLabelEvaluation,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
        ),
        const Padding(padding: kPh20, child: Divider(height: 1)),
        Expanded(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: kLabelBenchmarks),
                    Tab(text: kLabelDatasets),
                    Tab(text: kLabelMultimodal),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      const BenchmarkRunner(),
                      const DatasetConfig(),
                      const MultimodalEval(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
