/*
import 'dart:async';
import 'package:carbonetx/screens/customer_dashboard/account_balance.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_dashboard_screen.dart';
import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:carbonetx/services/stripe.dart';
import 'package:carbonetx/utilities/network_Status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:carbonetx/data/user_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';

class CardWebviewScreen extends StatefulWidget {
  @override
  _CardWebviewScreenState createState() => new _CardWebviewScreenState();
}

class _CardWebviewScreenState extends State<CardWebviewScreen> {
  String cardFormUrl = 'https://carbonetx-5ba2c.firebaseapp.com';

  InAppWebViewController _webViewController;
  String url =
      "https://carbonetx-5ba2c.firebaseapp.com/?email=${UserData().email}&custID=${UserData().stripeID}&userID=${UserData().userId}";
  double progress = 0;

  bool cardSubmitted = false;
  bool finishedSubmit = false;

  Widget _buildBackIcon() {
    return Row(
      children: <Widget>[
        BackButton(
          color: Colors.white,
        )
      ],
    );
  }

  _checkCard() async {
    if (UserData().cardAdded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<CustomerDashboardData>(context, listen: false)
            .cardWarningOff();
        // Add Your Code here.
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(url);

    return MaterialApp(
      color: Colors.black,
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.black87,
              leading: IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                  size: 30,
                  color: kMagenta,
                ),
                onPressed: () async {
                  if (cardSubmitted) {
                    print('Submitted');
                    print('save to FB? $finishedSubmit');
                    if (finishedSubmit) {
                      print('no');

                      await UserData().getCard(UserData().userId);
                      print('Refreshed');
                      Provider.of<CustomerDashboardData>(context, listen: false)
                          .cardChanged();
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    }
                  } else {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                  }
                },
              ),
              title: const Text(
                'Add your card',
                style: TextStyle(
                    fontFamily: 'OpenSans', fontSize: 20, color: kMagenta),
              ),
            ),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: Column(children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: InAppWebView(
                        initialUrl: url,
                        initialOptions: InAppWebViewGroupOptions(
                            crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                        )),
                        onWebViewCreated: (InAppWebViewController controller) {
                          _webViewController = controller;
                        },
                        onLoadStart:
                            (InAppWebViewController controller, String url) {
                          setState(() {
                            this.url = url;
                          });
                        },
                        onLoadStop: (InAppWebViewController controller,
                            String url) async {
                          setState(() {
                            this.url = url;
                            print('Loaded');
                            _webViewController.clearCache();
                            CookieManager().deleteAllCookies();
                            WebStorageManager().android.deleteAllData();
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print("CONSOLE MESSAGE: " + consoleMessage.message);
                          if (consoleMessage.message == "Submit Press") {
                            HapticFeedback.mediumImpact();
                          }
                          if (consoleMessage.message == "Submit Success") {
                            cardSubmitted = true;
                            print('card submitted $cardSubmitted');
                          }
                          if (consoleMessage.message == "savedtoFB") {
                            finishedSubmit = true;
                            print('save to FireBase $finishedSubmit');
                          }
                        },
                        onProgressChanged:
                            (InAppWebViewController controller, int progress) {
                          setState(() {
                            this.progress = progress / 100;
                          });
                        },
                      ),
                    ),
                  ),
                ])),
          ),
          NetworkStatus(),
        ],
      ),
    );
  }
}
*/
