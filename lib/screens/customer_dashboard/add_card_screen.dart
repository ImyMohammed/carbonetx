import 'dart:convert';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/data/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeCardElement extends StatefulWidget {
  static final StripeCardElement _stripeCardElement =
      StripeCardElement._internal();

  @override
  _StripeCardElementState createState() => _StripeCardElementState();

  factory StripeCardElement() {
    return _stripeCardElement;
  }

  StripeCardElement._internal();
}

class _StripeCardElementState extends State<StripeCardElement> {
  WebViewController _webViewController;
  String cardFormUrl = 'https://carbonetx-5ba2c.firebaseapp.com';

  @override
  void initState() {
    super.initState();
    print(
        "$cardFormUrl/?email=${UserData().email}&custID=${UserData().stripeID}&userID=${UserData().userId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Add a Card',
          style: TextStyle(
              color: kCrimson,
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: WebView(
          initialUrl:
              "$cardFormUrl/?email=${UserData().email}&custID=${UserData().stripeID}&userID=${UserData().userId}",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController view) {
            _webViewController = view;
          },
        ),
      ),
    );
  }
}
