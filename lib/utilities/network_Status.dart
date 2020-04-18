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
  _NetworkStatusState createState() => new _NetworkStatusState();
}

class _NetworkStatusState extends State<NetworkStatus> {
  var connectivityResult;
  bool isConnected = true;
  bool internetConnected;

  bool networkAlertActive = false;
  String status = 'Not Connection!';

  Future<bool> checkInternet() async {
    bool internetStatus;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        internetStatus = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      internetStatus = false;
    }

    return internetStatus;
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  checkConnectivity() async {
    connectivityResult = await (Connectivity().checkConnectivity());
    internetConnected = await checkInternet();

    checkInternet();

    if (connectivityResult == ConnectivityResult.mobile &&
        internetConnected == true) {
      isConnected = true;

      if (networkAlertActive == true) {
        networkAlertActive = false;
        status = isConnected == true ? 'Connected' : 'No Connection';
        Toast.show(
          'Reconnected!',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          textColor: Colors.greenAccent,
        );
        HapticFeedback.mediumImpact();
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }
    }
    if (connectivityResult == ConnectivityResult.wifi &&
        internetConnected == true) {
      isConnected = true;
      if (networkAlertActive == true) {
        networkAlertActive = false;
        status = isConnected == true ? 'Connected' : 'No Connection';

        Toast.show(
          'Reconnected!',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          textColor: Colors.greenAccent,
        );
        HapticFeedback.mediumImpact();
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      }
    }
    if (connectivityResult == ConnectivityResult.none ||
        internetConnected == false) {
      print('Not connected');
      print(networkAlertActive);
      if (networkAlertActive != true) {}
      isConnected = false;
      status = isConnected == true ? 'Connected' : 'No Connection';
    }

    setState(() {});

    Timer(Duration(seconds: 3), () {
      checkConnectivity();
    });
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: Visibility(
        visible: isConnected == true ? false : true,
        child: Center(
          child: Container(
            height: width * 0.5,
            width: width * 0.8,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.black87, Colors.black87]),
                borderRadius: new BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
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
                              valueColor:
                                  new AlwaysStoppedAnimation<Color>(kCrimson),
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
