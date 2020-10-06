import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpiryDataFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  var monthLeft;
  var monthRight;
  var yearLeft;
  var yearRight;

  TextEditingValue _lastResValue;
  TextEditingValue _lastNewValue;

  ExpiryDataFormatter({
    @required this.mask,
    @required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int selectionIndex = newValue.selection.end;

    monthLeft = newValue.text.length == 1
        ? int.parse(newValue.text.substring(0, 1))
        : monthLeft;
    monthRight = newValue.text.length == 2
        ? int.parse(newValue.text.substring(1, 2))
        : null;
    yearLeft = newValue.text.length == 4
        ? int.parse(newValue.text.substring(3, 4))
        : null;
    yearRight = newValue.text.length == 5
        ? int.parse(newValue.text.substring(4, 5))
        : null;

    print('Month Left: $monthLeft');
    print('Month Right: $monthRight');
    print('Year Left: $yearLeft');
    print('Year Left: $yearRight');

    print('oldvalue ${oldValue.text}');
    print('newvalue ${newValue.text}');

    var newVal = int.parse(newValue.text);
    var oldVal = int.parse(oldValue.text);

    if (newValue.text.length == 1) {
      print('Month Left: $monthLeft');
      print('Month Right: $monthRight');
      print('Year Left: $yearLeft');
      print('Year Left: $yearRight');
    }
    TextEditingValue formatEditUpdate(
        TextEditingValue oldValue, TextEditingValue newValue) {
      if (_lastResValue == oldValue && newValue == _lastNewValue) {
        return _lastResValue;
      }
      _lastNewValue = newValue;
      return _lastResValue;
    }
    //return newValue;
  }
}
