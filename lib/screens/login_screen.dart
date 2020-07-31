import 'package:carbonetx/data/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading/indicator.dart';
import 'package:loading/indicator/ball_grid_pulse_indicator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/utilities/firebase_error_handling.dart';
import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:carbonetx/screens/signup_screen.dart';
import 'package:toast/toast.dart';
import 'package:carbonetx/utilities/slide_route.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:connectivity/connectivity.dart';
import 'package:carbonetx/services/stripe.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  var connectivityResult;
  bool isConnected;

  String retrievedEmail;
  String email;
  String password;
  String errorMessage;
  bool showSpinner = false;
  String forgotPasswordEmail;

  Future _getEmail() async {
    var retrievedEmail = await FlutterKeychain.get(key: "carbonetx_email");
    if (retrievedEmail != null) {
      _controller.text = retrievedEmail;
      email = retrievedEmail;
    }
  }

  /* Future _getPassword() async {
    var retrievedEmail = await FlutterKeychain.get(key: "carbonetx_password");
    if (retrievedEmail != null) {
      _controller.text = retrievedEmail;
      email = retrievedEmail;
    }
  }*/

  Future _getSession() async {
    var sessionID = await FlutterKeychain.get(key: "sessionID");
    if (sessionID != null) {
      print(sessionID);
    } else {
      print('No session');
    }
  }

  var _controller = TextEditingController();
  var _passwordController = TextEditingController();

  var _forgotPasswordController = TextEditingController();

  bool checkEmail() {
    bool validEmail = false;
    if (EmailValidator.validate(forgotPasswordEmail) != true) {
      Toast.show(
        'Enter a valid e-mail example@example.com',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        textColor: Color(0xFFFF0362),
      );
    } else {
      validEmail = true;
    }
    return validEmail;
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xFF3A3A39),
            title: Text(
              'Reset Your Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
            ),
            content: TextField(
              inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
              controller: _forgotPasswordController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                forgotPasswordEmail = value;
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
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: "Enter your Email",
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
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: MaterialButton(
                  minWidth: 100,
                  color: Color(0xFFFF0362),
                  elevation: 5.0,
                  child: Text(
                    'RESET',
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
                    if (forgotPasswordEmail != null) {
                      if (checkEmail() == true) {
                        _auth.sendPasswordResetEmail(
                            email: forgotPasswordEmail);
                        Toast.show(
                          'Reset link sent to $forgotPasswordEmail',
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.TOP,
                          textColor: Colors.lightBlue,
                        );
                        forgotPasswordEmail = null;
                        _forgotPasswordController.clear();
                      }
                    }
                    _forgotPasswordController.clear();
                    forgotPasswordEmail = null;
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    _getEmail();
    _getSession();
    _checkConnectivity();
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
      Toast.show(
        'No Network!',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        textColor: Color(0xFFFF0362),
      );
      HapticFeedback.mediumImpact();
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Opacity(
          opacity: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60,
            child: TextField(
              inputFormatters: [BlacklistingTextInputFormatter(RegExp(r"\s"))],
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
                HapticFeedback.lightImpact();
              },
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black54,
                ),
                suffixIcon: IconButton(
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                  disabledColor: Colors.black,
                  highlightColor: Colors.black,
                ),
                hintText: "Enter your Email",
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) {
              password = value;
              HapticFeedback.lightImpact();
            },
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black54,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          print('Forgot Password Button Pressed');
          createAlertDialog(context);
          HapticFeedback.mediumImpact();
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          print('Login Button Pressed');
          HapticFeedback.mediumImpact();
          if (mounted)
            setState(() {
              showSpinner = true;
            });
          try {
            final userLoggedIn = await _auth.signInWithEmailAndPassword(
                email: email, password: password);

            if (userLoggedIn != null) {
              await FlutterKeychain.put(key: "carbonetx_email", value: email);
              await FlutterKeychain.put(
                  key: "carbonetx_password", value: password);
              password = null;
              await UserData().getData(userLoggedIn.user.uid);
              Navigator.push(context, SlideRoute(widget: DashboardScreen()));
              _passwordController.clear();
              Toast.show(
                'Login successful!',
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.TOP,
                textColor: Colors.greenAccent,
              );
            }
            if (mounted)
              setState(() {
                showSpinner = false;
              });
          } catch (error) {
            errorMessage = error.toString();
            print(errorMessage);

            if (mounted)
              setState(() {
                showSpinner = false;
              });

            var message = firebaseAuthHandler(errorMessage);
            Toast.show(
              message,
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              textColor: Color(0xFFFF0362),
            );
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black54,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        //Route route = MaterialPageRoute(builder: (context) => SignupScreen());
        Navigator.push(context, SlideRoute(widget: SignupScreen()));
        HapticFeedback.mediumImpact();
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: kLightContrast,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: kLightContrast,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: kAppBackground,
          child: _appLogo(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            progressIndicator: CircularProgressIndicator(
              backgroundColor: Color(0xFF3A3A39),
              valueColor: new AlwaysStoppedAnimation<Color>(kCrimson),
            ),
            inAsyncCall: showSpinner,
            color: Colors.black,
            dismissible: true,
            opacity: 0.7,
            child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        color: Colors.transparent,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                            vertical: 120.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Login',
                                style: TextStyle(
                                  color: kLightContrast,
                                  fontFamily: 'OpenSans',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              _buildEmailTF(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _buildPasswordTF(),
                              _buildForgotPasswordBtn(),
                              _buildLoginBtn(),
                              _buildSignupBtn(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
