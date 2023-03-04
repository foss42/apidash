import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';
import '../components/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final MultiSplitViewController _controller = MultiSplitViewController(
    areas: [
      Area(size: 300, minimalSize: 200),
      Area(minimalWeight: 0.7),
    ],
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Multi Split View Example')),
      body: Column(
        children: [
          Expanded(
            child: MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerThickness: 4,
                dividerPainter: DividerPainters.background(
                  color: Colors.grey.shade200,
                  highlightedColor: Colors.grey.shade400,
                  animationEnabled: false,
                ),
              ),
              child: MultiSplitView(
                controller: _controller,
                children: [
                  CollectionPane(),
                  Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
