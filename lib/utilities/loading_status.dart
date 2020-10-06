import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:io';
import 'package:carbonetx/providers/loading_bar.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  static final LoadingScreen _customerDashboard = LoadingScreen._internal();

  @override
  _LoadingScreenState createState() => new _LoadingScreenState();

  factory LoadingScreen() {
    return _customerDashboard;
  }

  LoadingScreen._internal();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.black54,
      child: Visibility(
        visible:
            Provider.of<LoadingOnOff>(context, listen: true).showSpinner == true
                ? true
                : false,
        child: Center(
          child: Container(
            height: width * 0.5,
            width: width * 0.8,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.black87,
                borderRadius: new BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xFF3A3A39),
                        valueColor: new AlwaysStoppedAnimation<Color>(kMagenta),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
