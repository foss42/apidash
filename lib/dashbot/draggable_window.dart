import 'package:apidash/dashbot/features/home/view/pages/dashbot_home_page.dart';
import 'package:apidash_design_system/tokens/tokens.dart';
import 'package:flutter/material.dart';

class DraggableChatWindow extends StatefulWidget {
  final VoidCallback onClose;
  final Size screenSize;

  const DraggableChatWindow(
      {super.key, required this.onClose, required this.screenSize});

  @override
  DraggableChatWindowState createState() => DraggableChatWindowState();
}

class DraggableChatWindowState extends State<DraggableChatWindow> {
  double _right = 50;
  double _bottom = 100;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _right =
          (_right - details.delta.dx).clamp(0, widget.screenSize.width - 300);
      _bottom =
          (_bottom - details.delta.dy).clamp(0, widget.screenSize.height - 400);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: _right,
          bottom: _bottom,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 350,
              height: 450,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceBright,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onPanUpdate: _handleDragUpdate,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              kHSpacer8,
                              Image.asset(
                                'assets/dashbot_icon_2.png',
                                width: 38,
                              ),
                              kHSpacer12,
                              Text(
                                'DashBot',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: widget.onClose,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: DashbotHomePage(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
