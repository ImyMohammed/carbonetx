import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/screens/login_screen.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:carbonetx/utilities/slide_route.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:toast/toast.dart';
import 'package:carbonetx/utilities/firebase_error_handling.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:carbonetx/providers/dashboard_info.dart';

class LaunchScreen extends StatefulWidget {
  static const String id = 'launch_screen';

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  String sessionID;

  var connectivityResult;
  bool isConnected;

  @override
  void initState() {
    super.initState();
    showSpinner = true;

    _checkConnectivity();
    _login();
  }

  _checkConnectivity() async {
    connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      print('Connected data');
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print('Connected wifi');
      isConnected = true;
    } else {
      print('Not connected');
      isConnected = false;
    }
  }

  Future _getEmail() async {
    var retrievedEmail = await FlutterKeychain.get(key: "carbonetx_email");
    if (retrievedEmail != null) {
      email = retrievedEmail;
      print(email);
    }
  }

  Future _getPassword() async {
    var retrievedPassword =
        await FlutterKeychain.get(key: "carbonetx_password");
    if (retrievedPassword != null) {
      password = retrievedPassword;
    }
  }

  Future _getSession() async {
    var userSessionID = await FlutterKeychain.get(key: "sessionID");
    if (userSessionID != null) {
      print(userSessionID);
      sessionID = userSessionID;
    } else {
      print('No session');
    }
  }

  Future _login() async {
    await _getEmail();
    await _getPassword();
    await _getSession();

    if (sessionID != null && isConnected != false) {
      try {
        final userLoggedIn = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        // final user = await _auth.currentUser();
        if (userLoggedIn != null) {
          Navigator.push(context, SlideRoute(widget: DashboardScreen()));
          Toast.show(
            'Welcome Back!',
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            textColor: Color(0xFF03BEFF),
          );
          HapticFeedback.mediumImpact();
        }
        if (mounted)
          setState(() {
            showSpinner = false;
          });
      } catch (error) {
        var errorMessage = error.toString();
        print(errorMessage);

        /*  if (mounted)
          setState(() {
            showSpinner = false;
          });*/

        var message = firebaseAuthHandler(errorMessage);
        Toast.show(
          message,
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Color(0xFFFF0362),
        );
      }
    } else {
      _goToLogin();
    }
  }

  Future _goToLogin() async {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        showSpinner = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    });
  }

  Widget _appLogo() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(140, 100, 140, 20),
        child: Image.asset(
          'images/carbonEtxLogo.png',
          width: 100,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      progressIndicator: Loading(
        indicator: LineScalePulseOutIndicator(),
        color: kCrimson,
      ),
      inAsyncCall: showSpinner,
      color: Colors.black,
      dismissible: false,
      opacity: 0.7,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: kAppBackground,
        child: _appLogo(),
      ),
    ));
  }
}
