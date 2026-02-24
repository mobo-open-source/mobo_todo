import 'package:flutter/material.dart';

class HomeTabProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void reset() {
    if (_currentIndex != 0) {
      _currentIndex = 0;
      notifyListeners();
    }
  }
}
