import 'package:carbonetx/screens/customer_dashboard/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:carbonetx/components/raised_gradient_button.dart';
import 'package:carbonetx/constants/constants.dart';

Widget submitCardButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  var isButtonDisabled = false;
  var textColor = Colors.white;
  return Builder(builder: (context) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, width * 0.02, 0, width * 0.05),
        child: Align(
          alignment: Alignment.centerRight,
          child: RaisedButton(
            color: Colors.black87,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            splashColor: Colors.purpleAccent,
            elevation: 13,
            disabledColor: Color(0xff3b3b3b),
            onPressed: isButtonDisabled == false
                ? () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      isButtonDisabled = true;
                      textColor = Colors.grey;
                    });
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(
                "SUBMIT",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      );
    });
  });
}
