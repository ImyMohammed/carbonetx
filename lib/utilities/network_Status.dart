import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'dart:io';

class NetworkStatus extends StatefulWidget {
  @override
  _NetworkStatusState createState() => _NetworkStatusState();
}

class _NetworkStatusState extends State<NetworkStatus> {
  var connectivityResult;
  bool isConnected = true;
  bool internetConnected;
  bool toggleLoader = false;
  bool networkAlertActive = false;
  String status = 'No Connection!';

  double width;
  double height;

  Future<bool> checkInternet() async {
    bool internetStatus;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetStatus = true;
      }
    } on SocketException catch (_) {
      internetStatus = false;
      networkAlertActive = true;
    }

    return internetStatus;
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  void toggleAlert() {
    toggleLoader = !toggleLoader;
  }

  checkConnectivity() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    internetConnected = await checkInternet();

    checkInternet();

    if (connectivityResult == ConnectivityResult.mobile &&
        internetConnected == true) {
      isConnected = true;

      if (networkAlertActive == true) {
        status = isConnected == true ? 'Connected' : 'No Connection';
        setState(() {});
        Timer(Duration(seconds: 2), () {
          networkAlertActive = false;
          toggleLoader = false;
          setState(() {});
          // Navigator.pop(context);
        });
      }
    }
    if (connectivityResult == ConnectivityResult.wifi &&
        internetConnected == true) {
      isConnected = true;
      if (networkAlertActive == true) {
        status = isConnected == true ? 'Connected' : 'No Connection';
        setState(() {});
        Timer(Duration(seconds: 2), () {
          networkAlertActive = false;
          toggleLoader = false;
          setState(() {});

          // Navigator.pop(context);
        });
      }
    }
    if (connectivityResult == ConnectivityResult.none ||
        internetConnected == false) {
      if (networkAlertActive != true) {}
      isConnected = false;
      status = isConnected == true ? 'Connected' : 'No Connection';
      toggleLoader = true;
      setState(() {});
    }

    Timer(Duration(seconds: 1), () async {
      await checkConnectivity();
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.black54,
      child: Visibility(
        visible: toggleLoader == false ? false : true,
        child: Center(
          child: Container(
            height: height * 0.30,
            width: width * 0.8,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xffffc64c), Color(0xfff817ea)],
                ),
                borderRadius: new BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 40, 8, 20),
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                    child: isConnected == false
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Color(0xFF3A3A39),
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          )
                        : Icon(
                            FontAwesomeIcons.check,
                            color: Colors.greenAccent,
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
