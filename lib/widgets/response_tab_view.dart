import 'package:apidash_design_system/apidash_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apidash/consts.dart';
import 'package:apidash/models/assertion_model.dart';
import 'package:apidash/providers/assertion_providers.dart';
import 'tab_label.dart';

class ResponseTabView extends StatefulWidget {
  const ResponseTabView({super.key, this.selectedId, required this.children});

  final String? selectedId;
  final List<Widget> children;
  @override
  State<ResponseTabView> createState() => _ResponseTabViewState();
}

class _ResponseTabViewState extends State<ResponseTabView>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 3,
      animationDuration: kTabAnimationDuration,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          key: Key(widget.selectedId!),
          controller: _controller,
          labelPadding: kPh2,
          overlayColor: kColorTransparentState,
          onTap: (index) {},
          tabs: [
            const TabLabel(text: kLabelResponseBody),
            const TabLabel(text: kLabelHeaders),
            // Assertions tab with live pass/fail badge
            _AssertionsTabLabel(requestId: widget.selectedId),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.children,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Assertions tab label that shows a live `pass/total` badge after running.
class _AssertionsTabLabel extends ConsumerWidget {
  const _AssertionsTabLabel({this.requestId});

  final String? requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suite = requestId != null
        ? ref.watch(assertionSuitesProvider)[requestId]
        : null;

    final hasResults = suite != null &&
        suite.rules.isNotEmpty &&
        suite.rules.any((r) => r.status != AssertionStatus.pending);

    if (!hasResults) {
      return const TabLabel(text: kLabelAssertions);
    }

    final passed = suite.passCount;
    final total = suite.rules.length;
    final allPass = passed == total;

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(kLabelAssertions),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: allPass ? Colors.green : Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$passed/$total',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
