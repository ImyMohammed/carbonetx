import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/screens/login_screen.dart';
import 'package:loading/loading.dart';
import 'package:carbonetx/utilities/slide_route.dart';
import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:toast/toast.dart';
import 'package:carbonetx/utilities/firebase_error_handling.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:carbonetx/providers/dashboard_info.dart';
import 'package:carbonetx/data/user_data.dart';

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

    _login();
  }

  Future _login() async {
    var hasSession = await UserData().getSession();

    if (hasSession != null && isConnected != false) {
      try {
        var userLoggedIn = await UserData().loadUserProfile();

        if (userLoggedIn != null) {
          print('Got to dashboard');
          await Future.delayed(const Duration(milliseconds: 1000), () {});
          Navigator.push(context, SlideRoute(widget: DashboardScreen()));
          Toast.show(
            'Welcome Back!',
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
            textColor: Colors.greenAccent,
          );
          HapticFeedback.mediumImpact();
        }
      } catch (error) {
        var errorMessage = error.toString();
        print(errorMessage);

        var message = firebaseAuthHandler(errorMessage);
        Toast.show(
          message,
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Color(0xFFFF0362),
        );
        await _goToLogin();
      }
    } else {
      await _goToLogin();
    }
  }

  Future _goToLogin() async {
    await Future.delayed(const Duration(milliseconds: 4000), () {
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
      child: Center(
        child: Image.asset(
          'images/sheenobiLogo.png',
          width: 300,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            backgroundColor: Color(0xFF3A3A39),
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xfff817ea)),
          ),
          inAsyncCall: showSpinner,
          color: Colors.black,
          dismissible: false,
          opacity: 0,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: _appLogo(),
            decoration: kAppBackground,
          ),
        ));
  }
}
