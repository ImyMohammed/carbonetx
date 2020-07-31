import 'dart:async';

import 'package:carbonetx/utilities/customer_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:carbonetx/screens/customer_dashboard/customer_dashboard_screen.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/utilities/book_button.dart';
import 'package:carbonetx/utilities/add_number.dart';
import 'package:flutter/services.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carbonetx/data/user_data.dart';
import 'package:carbonetx/providers/loading_bar.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:carbonetx/utilities/network_Status.dart';
import 'package:carbonetx/services/stripe.dart';

class CustomerProfile extends StatefulWidget {
  static final CustomerProfile _customerProfile = CustomerProfile._internal();

  @override
  _CustomerProfileState createState() => _CustomerProfileState();

  factory CustomerProfile() {
    return _customerProfile;
  }

  CustomerProfile._internal();
}

class _CustomerProfileState extends State<CustomerProfile>
    with SingleTickerProviderStateMixin {
  Color verifiedColour;
  IconData verifyIcon;

  String verificationButton = 'SEND';
  String verifyInfo = 'Click SEND to receive SMS code.';

  var _numberController = TextEditingController();
  var _smsController = TextEditingController();

  double width;

  int instance = 0;

  void initState() {
    super.initState();
    //NetworkStatus().checkConnectivity(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoadingOnOff>(context, listen: false).loadingOff();
      // Add Your Code here.
      checkMobNumber();
      print('Uid is ${UserData().userId}');
    });
    instance++;
    print('Instance $instance');
    print(UserData().userId);

    _refresh();
  }

  _refresh() {
    Timer(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  void getWidth() {
    width = MediaQuery.of(context).size.width;
    print(width);
  }

  void checkMobNumber() async {
    if (UserData().mobNumber != 'Enter your Mob No.') {
      verifiedColour = Colors.greenAccent;
      verifyIcon = FontAwesomeIcons.check;
      Provider.of<CustomerDashboardData>(context, listen: false)
          .profileWarningOff();
      setState(() {});
    } else {
      verifiedColour = kYellow;
      verifyIcon = FontAwesomeIcons.exclamationTriangle;
      Provider.of<CustomerDashboardData>(context, listen: false)
          .profileWarningOn();
      setState(() {});
    }
  }

  Future updateMobileNumber(String mobileNumber, String userId) async {
    await Firestore.instance
        .collection('users')
        .document(userId)
        .updateData({'mobileNumber': mobileNumber}).then((value) {});
  }

  createAddNumberAlert() {
    String newNumber = "";
    _numberController.clear();
    print(newNumber);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF3A3A39),
            title: Text(
              'Add your Mobile No.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
            ),
            content: TextField(
              inputFormatters: [
                //WhitelistingTextInputFormatter.digitsOnly,
                BlacklistingTextInputFormatter(RegExp('^(?:[+0]9)?[0-9]{12}'))
              ],
              controller: _numberController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                newNumber = value;
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                hintText: "Enter your Mob No.",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: width != null ? width * 0.040 : 12,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0362)),
                ),
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                minWidth: 100,
                color: Color(0xFFFF0362),
                elevation: 5.0,
                child: UserData().mobNumber == 'Enter your Mob No.'
                    ? Text(
                        'SAVE',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        'UPDATE',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                textColor: Colors.black,
                onPressed: () {
                  print('reset');
                  Navigator.pop(context);
                  print(UserData().mobNumber);
                  print(newNumber.length);
                  if (newNumber == "" || newNumber.length <= 10) {
                    UserData().updateNumber = 'Enter your Mob No.';
                    UserData().addMobileNumber(
                        'Enter your Mob No.', UserData().userId);
                    print('mobile add ${UserData().userId}');

                    newNumber = 'Enter your Mob No.';
                    verifiedColour = kYellow;
                    verifyIcon = FontAwesomeIcons.exclamationTriangle;
                    _numberController.clear();
                    print('cleared');
                    setState(() {});
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Provider.of<CustomerDashboardData>(context, listen: false)
                          .profileWarningOn();

                      // Add Your Code here.
                    });
                  } else {
                    UserData().updateNumber = newNumber;
                    UserData().addMobileNumber(newNumber, UserData().userId);
                    print('Updated');
                    verifyIcon = FontAwesomeIcons.check;
                    verifiedColour = Colors.greenAccent;
                    setState(() {});
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Provider.of<CustomerDashboardData>(context, listen: false)
                          .profileWarningOff();
                      // Add Your Code here.
                    });
                  }
                },
              )
            ],
          );
        });
  }

  mobileVerification([String verificationCode, int forceResendingToken]) {
    String smsCode;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF3A3A39),
            title: Text(
              'Verify your Mobile No.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
            ),
            content: TextField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                BlacklistingTextInputFormatter(RegExp("^(?:[+0]9)?[0-9]{10}"))
              ],
              controller: _smsController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                smsCode = value.trim();
              },
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  FontAwesomeIcons.sms,
                  color: Colors.greenAccent,
                ),
                hintText: "Enter your code",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF0362)),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Center(
                    child: Text('$verifyInfo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white,
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: MaterialButton(
                  minWidth: 100,
                  color: Color(0xFFFF0362),
                  elevation: 5.0,
                  child: Text(
                    '$verificationButton',
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  textColor: Colors.black,
                  onPressed: () {
                    print('Submit');
                    Navigator.pop(context);
                    setState(() {
                      verificationButton = 'SUBMIT';
                      verifyInfo =
                          'Enter code manually if Auto complete fails.';
                    });
                  },
                ),
              )
            ],
          );
        });
  }

  _buildApplyButton() {
    return RaisedButton(
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
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      onPressed: () {
        print('Apply pressed');
        Toast.show("Pressed", context);
/*        StripeServices().createStripeCustomer(
            email: UserData.email,
            name: UserData.name,
            description: 'customer');*/
      },
      child: Text(
        'Apply',
        style: kBookButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getWidth();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kAppBackground,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[LogOutButton()],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              ),
              Stack(children: <Widget>[PageTitle()]),
              Card(
                color: Colors.black54,
                margin: EdgeInsets.fromLTRB(16, 30, 16, 16),
                elevation: 8,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Icon(
                        FontAwesomeIcons.user,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      UserData().name,
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Card(
                color: Colors.black54,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                elevation: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: Icon(
                        Icons.email,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        '${UserData().email}',
                        maxLines: 1,
                        minFontSize: 5,
                        maxFontSize: 18,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                        child: Icon(
                          FontAwesomeIcons.check,
                          size: 20,
                          color: Colors.greenAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('tapped');
                  createAddNumberAlert();
                },
                child: Card(
                  color: Colors.black54,
                  margin: EdgeInsets.fromLTRB(16, 1, 16, 16),
                  elevation: 8,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Icon(
                          FontAwesomeIcons.phone,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        UserData().mobNumber,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          print('Verify');
                          ;
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Icon(
                            verifyIcon,
                            size: 20,
                            color: verifiedColour,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 130, 15, 10),
                child: Text(
                  'Apply to become a crew member and wash cars in your area.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.035,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildApplyButton(),
            ],
          ),
        ),
      ),
    );
  }
}
