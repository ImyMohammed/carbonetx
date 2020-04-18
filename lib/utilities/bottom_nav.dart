import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/utilities/customer_menu_bar.dart';

class BottomNav extends StatefulWidget {
  final Function callback;

  BottomNav({this.callback});

  @override
  _BottomNavState createState() => new _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  Color _activeColor = Color(0xFF00A6FF);
  Color _inactiveColor = Colors.white;
  Color carIconColor = Color(0xFF00A6FF);
  Color historyIconColor = Colors.white;
  Color referralIconColor = Colors.white;
  Color cardIconColor = Colors.white;
  Color idCardColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0XFF161515),
      elevation: 19,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomerMenuBar(),
      ),
    );
  }
}
