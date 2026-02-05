import 'package:flutter/material.dart';

class ZoomController extends ChangeNotifier {
  double _zoom = 1.0;
  double get zoom => _zoom;

  void zoomIn() {
    _zoom = (_zoom + 0.5).clamp(0.5, 2.0);
    print("Zoom level after zooming in: $_zoom");
    notifyListeners();
  }

  void zoomOut() {
    _zoom = (_zoom - 0.5).clamp(0.5, 2.0);
    print(  "Zoom level after zooming out: $_zoom");
    notifyListeners();
  }
}
