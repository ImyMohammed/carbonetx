import 'package:carbonetx/utilities/Gradient_Icon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/utilities/customer_menu_bar.dart';
import 'package:carbonetx/constants/constants.dart';

class BottomNav extends StatefulWidget {
  final Function callback;

  BottomNav({this.callback});

  @override
  _BottomNavState createState() => new _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20,
      color: Color(0xff1f1f1f),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CustomerMenuBar(),
      ),
    );
  }
}
