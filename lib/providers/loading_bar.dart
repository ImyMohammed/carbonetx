import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';

class LoadingOnOff extends ChangeNotifier {
  bool showSpinner = false;
  String loadingMessage;

  void loadingOn() {
    print('toggled');
    showSpinner = true;
    notifyListeners();
  }

  String loadingItem(String loadingMsg) {
    loadingMessage = loadingMsg;
    notifyListeners();
    return loadingMessage;
  }

  void loadingOff() {
    print('toggled');
    showSpinner = false;
    notifyListeners();
  }
}
