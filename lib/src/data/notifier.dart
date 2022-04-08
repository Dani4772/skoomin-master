import 'package:flutter/material.dart';

class Notifier extends ChangeNotifier {
  bool _enable = false;

  void change(bool enable) {
    _enable = enable;
    notifyListeners();
  }

  bool get enable => _enable;
}
