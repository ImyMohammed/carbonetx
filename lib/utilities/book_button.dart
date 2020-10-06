import 'package:flutter/material.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_dashboard_screen.dart';

class BookButton extends StatefulWidget {
  @override
  _BookButtonState createState() => _BookButtonState();
}

class _BookButtonState extends State<BookButton>
    with SingleTickerProviderStateMixin {
  Color buttonColor = Colors.black87;

  AnimationController _animationController;
  Animation _colorTween;

// ···

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _colorTween = ColorTween(begin: Colors.black54, end: Colors.blueAccent)
        .animate(_animationController);

    _animationController.addListener(() {
      setState(() {
        print(_colorTween.value);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        elevation: 5,
        color: buttonColor,
        textColor: Colors.white,
        splashColor: kMagenta,
        disabledColor: Colors.white,
        disabledTextColor: Colors.white,
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        clipBehavior: Clip.antiAlias,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          if (CustomerDashboard.regSelected == null) {
            Toast.show("Select a car", context,
                textColor: kMagenta, gravity: Toast.TOP);
          } else {
            Toast.show("Pressed", context);
          }
        },
        child: Text(
          'Book',
          style: kBookButton,
        ),
      ),
    );
  }
}
