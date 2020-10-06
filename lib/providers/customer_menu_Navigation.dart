import 'package:carbonetx/constants/constants.dart';
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
  bool cardWarning = true;

  bool cardChange = false;

  Color activeColor = Color(0xFF00A6FF);
  Color inactiveColor = Colors.grey;

  Color pageOneColor = Color(0xFF00A6FF);
  Color pageTwoColor = Colors.grey;
  Color pageThreeColor = Colors.grey;
  Color pageFourColor = Colors.grey;
  Color pageFiveColor = Colors.grey;

  var pageList = [true, false, false, false, false];

  var colors = [
    gradientTheme,
    inactiveIconTheme,
    inactiveIconTheme,
    inactiveIconTheme,
    inactiveIconTheme
  ];

  void changeStatus(int index) {
    for (int i = 0; i <= 4; i++) {
      colors[i] = inactiveIconTheme;
    }
    colors[index] = gradientTheme;

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

  void cardWarningOff() {
    cardWarning = false;
    notifyListeners();
  }

  void cardWarningOn() {
    cardWarning = true;
    notifyListeners();
  }

  void cardChanged() {
    cardChange = true;
    notifyListeners();
  }
}
