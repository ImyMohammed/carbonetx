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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carbonetx/utilities/Gradient_Icon.dart';
import 'package:carbonetx/components/raised_gradient_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  IconData idVerification;
  Color iDColour;

  String verificationButton = 'SEND';
  String verifyInfo = 'Click SEND to receive SMS code.';

  var _numberController = TextEditingController(text: '+44');
  var _smsController = TextEditingController();

  double width;
  double height;

  int instance = 0;

  String emailButtonText = 'Send';
  bool emailVerified = false;
  bool emailSent = false;

  void initState() {
    super.initState();
    //NetworkStatus().checkConnectivity(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoadingOnOff>(context, listen: false).loadingOff();
      // Add Your Code here.
      checkMobNumber();
      checkIdVerification();
      print('Uid is ${UserData().userId}');
    });
    instance++;
    print('Instance $instance');
    print(UserData().userId);
    _refresh();
  }

  Future<bool> _checkEmail() async {
    emailVerified = FirebaseAuth.instance.currentUser.emailVerified;
    setState(() {});
    return emailVerified;
  }

  _refresh() {
    Timer(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {});
      }
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

  void checkIdVerification() async {
    if (UserData().isIdVerified) {
      iDColour = Colors.greenAccent;
      idVerification = FontAwesomeIcons.check;
    } else {
      iDColour = kYellow;
      idVerification = FontAwesomeIcons.exclamationTriangle;
    }
  }

  Future updateMobileNumber(String mobileNumber, String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'mobileNumber': mobileNumber}).then((value) {});
  }

  _sendVerificationEmail() {
    BuildContext dialogContext;
    return showDialog(
      context: context,
      builder: (context) {
        String contentText = 'Send verification email to ${UserData().email}?';
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Color(0xffe6e6e6),
            title: Text(
              'Verify Email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * 0.05,
                color: Colors.black87,
                fontFamily: 'OpenSans',
              ),
            ),
            content: Container(
              height: height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(contentText,
                      maxLines: 5,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          fontFamily: 'OpenSans',
                          fontSize: width * 0.045)),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedGradientButton(
                  width: width * 0.35,
                  height: height * 0.1,
                  gradient: gradientTheme,
                  child: MaterialButton(
                    color: Colors.transparent,
                    splashColor: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        emailButtonText,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    print(FirebaseAuth.instance.currentUser.emailVerified);
                    if (!emailSent) {
                      ActionCodeSettings actionHandler = ActionCodeSettings(
                          handleCodeInApp: true,
                          url: 'https://carbonetx.page.link');
                      FirebaseAuth.instance.currentUser
                          .sendEmailVerification(actionHandler)
                          .then((value) => print('sent'));
                      setState(() {
                        contentText =
                            "Email sent! Click the link in the email to verify then press confirm.";
                        print(contentText);
                        emailButtonText = 'Confirm';
                        emailSent = true;
                      });
                    } else {
                      await _checkEmail();
                      Navigator.pop(context);
                    }
                  }),
            ],
          );
        });
      },
    );
  }

  createAddNumberAlert() {
    var maskFormatter = new MaskTextInputFormatter(
        mask: '+44z#########',
        filter: {"#": RegExp(r'[0-9]'), "z": RegExp(r'[1-9]')});
    String newNumber = "";
    _numberController.clear();
    print(newNumber);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xffe6e6e6),
            title: Text(
              'Add your Mobile No.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * 0.05,
                color: Colors.black87,
                fontFamily: 'OpenSans',
              ),
            ),
            content: Container(
              height: height * 0.2,
              child: Column(
                children: [
                  Spacer(),
                  Card(
                    color: Colors.black87,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, height * 0.005, 0, height * 0.005),
                      child: TextField(
                        inputFormatters: [
                          //WhitelistingTextInputFormatter.digitsOnly,
                          maskFormatter,
                          FilteringTextInputFormatter.deny(
                              RegExp('^(?:[+0]9)?[0-9]{12}'))
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
                          fontSize: width * 0.045,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: GradientIcon(FontAwesomeIcons.phone,
                              width * 0.055, gradientTheme),
                          hintText: "+44",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            actions: <Widget>[
              RaisedGradientButton(
                width: width * 0.35,
                height: height * 0.1,
                gradient: gradientTheme,
                child: UserData().mobNumber == 'Enter your Mob No.'
                    ? Text(
                        'SAVE',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        'UPDATE',
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.04,
                          color: Colors.black,
                        ),
                      ),
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
    BuildContext dialogContext;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Color(0xffe6e6e6),
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
                FilteringTextInputFormatter.deny(RegExp("^(?:[+0]9)?[0-9]{10}"))
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
      },
    );
  }

  _buildApplyButton() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
        color: Colors.black87,
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
          HapticFeedback.selectionClick();
/*        StripeServices().createStripeCustomer(
              email: UserData.email,
              name: UserData.name,
              description: 'customer');*/
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Apply',
                style: kBookButton,
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(10, 0, 0, 0)),
            Icon(
              FontAwesomeIcons.lock,
              size: 18,
              color: kMagenta,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                      },
                      child: Icon(
                        FontAwesomeIcons.cog,
                        size: width * 0.08,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              ),
              Center(child: Text('My Profile', style: kPageTitle)),
              Card(
                color: Colors.black87,
                margin: EdgeInsets.fromLTRB(5, 30, 5, 16),
                elevation: 8,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                      child: GradientIcon(
                        FontAwesomeIcons.user,
                        18,
                        gradientTheme,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        UserData().name,
                        maxLines: 1,
                        minFontSize: 3,
                        maxFontSize: 18,
                        style: TextStyle(
                            foreground: Paint()..shader = linearGradient,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!FirebaseAuth.instance.currentUser.emailVerified) {
                    _sendVerificationEmail();
                    HapticFeedback.selectionClick();
                  }
                },
                child: Card(
                  color: Colors.black87,
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 16),
                  elevation: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                        child: GradientIcon(
                            FontAwesomeIcons.envelope, 18, gradientTheme),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          '${UserData().email}',
                          maxLines: 1,
                          minFontSize: 5,
                          maxFontSize: 18,
                          style: TextStyle(
                              foreground: Paint()..shader = linearGradient,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 15, 0),
                          child:
                              FirebaseAuth.instance.currentUser.emailVerified ==
                                      true
                                  ? Icon(
                                      FontAwesomeIcons.check,
                                      size: 20,
                                      color: Colors.greenAccent,
                                    )
                                  : Icon(
                                      FontAwesomeIcons.exclamationTriangle,
                                      size: 20,
                                      color: Colors.amberAccent,
                                    ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('tapped');
                  createAddNumberAlert();
                },
                child: Card(
                  color: Colors.black87,
                  margin: EdgeInsets.fromLTRB(5, 1, 5, 16),
                  elevation: 8,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GradientIcon(
                          FontAwesomeIcons.phone,
                          18,
                          gradientTheme,
                        ),
                      ),
                      AutoSizeText(
                        (UserData().mobNumber) != null
                            ? (UserData().mobNumber)
                            : 'Enter your Mob No.',
                        maxLines: 1,
                        minFontSize: 5,
                        maxFontSize: 18,
                        style: TextStyle(
                            foreground: Paint()..shader = linearGradient,
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          print('Verify');
                          mobileVerification();
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: GestureDetector(
                            onTap: () {
                              print('verify');
                              HapticFeedback.selectionClick();
                            },
                            child: Icon(
                              verifyIcon,
                              size: 20,
                              color: verifiedColour,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('tapped');
                },
                child: Card(
                  color: Colors.black87,
                  margin: EdgeInsets.fromLTRB(5, 1, 5, 16),
                  elevation: 8,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: GradientIcon(
                          FontAwesomeIcons.addressCard,
                          18,
                          gradientTheme,
                        ),
                      ),
                      Text(
                        'ID Verification',
                        style: TextStyle(
                            foreground: Paint()..shader = linearGradient,
                            fontFamily: 'OpenSans',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          print('Verify');
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Icon(
                            idVerification,
                            size: 20,
                            color: iDColour,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.fromLTRB(5, 1, 5, 16),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: AutoSizeText(
                    'Apply to become a crew member and wash cars in your area.',
                    maxFontSize: 20,
                    minFontSize: 10,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.035,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  children: [Spacer(), _buildApplyButton(), Spacer()],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
