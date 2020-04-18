import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomerDashboardData extends ChangeNotifier {
  bool pageOneActive = true;
  bool pageTwoActive = false;
  bool pageThreeActive = false;
  bool pageFourActive = false;
  bool pageFiveActive = false;

  bool profileWarning = true;

  Color activeColor = Color(0xFF00A6FF);
  Color inactiveColor = Colors.white;

  Color pageOneColor = Color(0xFF00A6FF);
  Color pageTwoColor = Colors.white;
  Color pageThreeColor = Colors.white;
  Color pageFourColor = Colors.white;
  Color pageFiveColor = Colors.white;

  var pageList = [true, false, false, false, false];

  var colors = [
    Color(0xFF00A6FF),
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white
  ];

  void changeStatus(int index) {
    for (int i = 0; i <= 4; i++) {
      colors[i] = inactiveColor;
    }
    colors[index] = activeColor;

    notifyListeners();
  }

  void toggleWarning() {
    profileWarning = !profileWarning;
    notifyListeners();
  }

  void profileWarningOff() {
    profileWarning = false;
    notifyListeners();
  }

  void profileWarningOn() {
    profileWarning = true;
    notifyListeners();
  }
}
