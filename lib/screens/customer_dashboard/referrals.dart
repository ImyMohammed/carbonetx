import 'package:carbonetx/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_dashboard_screen.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/utilities/book_button.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carbonetx/data/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carbonetx/utilities/network_Status.dart';

class Referrals extends StatefulWidget {
  static final Referrals _referrals = Referrals._internal();

  @override
  _ReferralsState createState() => _ReferralsState();

  factory Referrals() {
    return _referrals;
  }

  Referrals._internal();
}

class _ReferralsState extends State<Referrals>
    with SingleTickerProviderStateMixin {
  var referralCode = 'Get Code';

  var copyButtonEnabled = false;
  var displayGenerateButton = false;
  var userEmail;

  final _firestore = Firestore.instance;

  void initState() {
    super.initState();
    //NetworkStatus().checkConnectivity(context);

    _getReferralCode();
  }

  _getReferralCode() async {
    referralCode = UserData().referralCode;
    String refCode;
    userEmail = UserData().email;
    refCode = referralCode;
    if (refCode == null) {
      displayGenerateButton = true;
      copyButtonEnabled = false;
      referralCode = 'Get Code';
      if (mounted) setState(() {});
    } else {
      copyButtonEnabled = true;
      displayGenerateButton = false;
      referralCode = refCode;
      if (mounted) setState(() {});
    }
  }

  _checkCode(String code) async {
    print('called');
    String refCode;
    print('ref code $code');
    await UserData().currentUser();
    userEmail = UserData().email;
    print('email is $userEmail');

    final snapShot =
        await Firestore.instance.collection('referrals').document(code).get();

    if (snapShot == null || !snapShot.exists) {
      // Document with id == docId doesn't exist.
      print('Does not exist');
      Provider.of<UserData>(context, listen: true)
          .addReferralCode(userEmail, referralCode);
      Provider.of<UserData>(context, listen: true)
          .addReferralCodeToUser(userEmail, referralCode);
    } else {
      print('Is duplicate');
      referralCode = codeGen();
      _checkCode(referralCode);
    }
  }

  void stream(String code) async {
    await for (var snapshot in _firestore
        .collection('referralCodes')
        .where('code', isEqualTo: code)
        .snapshots()) {
      for (var messages in snapshot.documents) {
        print(messages.data);
      }
    }
  }

  String codeGen() {
    return randomAlpha(1).toUpperCase() +
        randomNumeric(1) +
        randomAlpha(2).toUpperCase() +
        randomNumeric(3) +
        randomAlpha(1).toUpperCase();
  }

  _buildGenerateCode() {
    return Visibility(
      visible: displayGenerateButton,
      child: RaisedButton(
        color: Colors.black45,
        elevation: 5,
        textColor: Colors.white,
        highlightColor: Colors.blue,
        hoverColor: Colors.blue,
        disabledColor: Colors.black45,
        disabledTextColor: Colors.black45,
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        splashColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        onPressed: () {
          print('Apply pressed');

          Toast.show("Pressed", context);
          referralCode = codeGen();
          _checkCode(referralCode);
          HapticFeedback.mediumImpact();
        },
        child: Text(
          'Generate Code',
          style: kBookButton,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: kAppBackground,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
            ),
            PageTitle(),
            Card(
              color: Colors.black54,
              margin: EdgeInsets.fromLTRB(width * 0.15, 30, width * 0.15, 16),
              elevation: 8,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 16, 0, 16),
                    child: GestureDetector(
                      onTap: copyButtonEnabled
                          ? () {
                              Clipboard.setData(
                                  ClipboardData(text: referralCode));
                              Toast.show(
                                'Copied!',
                                context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.TOP,
                                textColor: Colors.greenAccent,
                              );
                              HapticFeedback.mediumImpact();
                            }
                          : null,
                      child: Icon(
                        FontAwesomeIcons.solidClone,
                        size: 20,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: AutoSizeText(
                        '$referralCode',
                        maxLines: 1,
                        minFontSize: 18,
                        maxFontSize: 20,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildGenerateCode()
          ],
        ),
      ),
    );
  }
}
