import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

expDatePopup(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  var _dateTime = DateTime.now();
  var minExpDate = DateTime(_dateTime.year, 0, 0, 0, 0, 0, 0, 0);
  var maxExpDate = DateTime(_dateTime.year + 50, 0, 0, 0, 0, 0, 0, 0);
  return Builder(builder: (context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: width,
        height: height * 0.4,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: DatePickerWidget(
            initialDateTime: _dateTime,
            minDateTime: minExpDate,
            maxDateTime: maxExpDate,
            dateFormat: 'MM-yyyy',
            onChange: (date, time) {
              print(date);
              print(time);
              HapticFeedback.selectionClick();
            },
            pickerTheme: DateTimePickerTheme(
              backgroundColor: Colors.transparent,
              itemTextStyle: TextStyle(
                color: Colors.black,
              ),
              cancelTextStyle: TextStyle(),
            ),
            onCancel: () {},
            onConfirm: (date, time) {
              print(date);
              print(time);
              HapticFeedback.selectionClick();
            },
          ),
        ),
      );
    });
  });
}

Widget expiryDatePicker(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;

  var _dateTime = DateTime.now();
  var minExpDate = DateTime(_dateTime.year, 0, 0, 0, 0, 0, 0, 0);
  var maxExpDate = DateTime(_dateTime.year + 50, 0, 0, 0, 0, 0, 0, 0);

  return Builder(builder: (context) {
    print(_dateTime);
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        width: width,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: DatePickerWidget(
            initialDateTime: _dateTime,
            minDateTime: minExpDate,
            maxDateTime: maxExpDate,
            dateFormat: 'MM-yyyy',
            onChange: (date, time) {
              print(date);
              print(time);
              HapticFeedback.selectionClick();
            },
            pickerTheme: DateTimePickerTheme(
              backgroundColor: Colors.transparent,
              itemTextStyle: TextStyle(
                color: Colors.black,
              ),
              cancelTextStyle: TextStyle(),
            ),
            onCancel: () {},
            onConfirm: (date, time) {
              print(date);
              print(time);
              HapticFeedback.selectionClick();
            },
          ),
        ),
      );
    });
  });
}
