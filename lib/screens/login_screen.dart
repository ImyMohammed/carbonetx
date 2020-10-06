import 'package:carbonetx/data/user_data.dart';
import 'package:carbonetx/utilities/Gradient_Icon.dart';
import 'package:carbonetx/utilities/network_Status.dart';
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
import 'package:carbonetx/utilities/Gradient_Icon.dart';

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

  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _resetEmailFocus = new FocusNode();

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

  GradientIcon emailIcon = GradientIcon(
    FontAwesomeIcons.solidEnvelope,
    24,
    inactiveIconTheme,
  );

  GradientIcon passwordIcon = GradientIcon(
    FontAwesomeIcons.key,
    24,
    inactiveIconTheme,
  );

  Icon resetEmailIcon = Icon(
    FontAwesomeIcons.solidEnvelope,
    color: Colors.black,
    size: 24,
  );

  bool checkEmail() {
    bool validEmail = false;
    if (EmailValidator.validate(forgotPasswordEmail) != true) {
      Toast.show(
        'Invalid e-mail: example@example.com',
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
            elevation: 14,
            backgroundColor: Colors.black54,
            title: Text(
              'Reset Your Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: kMagenta,
                fontFamily: 'OpenSans',
              ),
            ),
            content: Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Colors.grey,
                backgroundBlendMode: BlendMode.hardLight,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 0.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: TextField(
                autocorrect: false,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r"\s"))
                ],
                controller: _forgotPasswordController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  forgotPasswordEmail = value;
                  HapticFeedback.lightImpact();
                },
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14.0),
                  prefixIcon: resetEmailIcon,
                  hintText: "Enter your Email",
                  hintStyle: kHintTextStyle,
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
    _emailFocus.addListener(_emailFocusChange);
    _passwordFocus.addListener(_passwordFocusChange);
    _resetEmailFocus.addListener(_resetEmailFocusChange);
  }

  _emailFocusChange() {
    if (_emailFocus.hasFocus) {
      emailIcon =
          GradientIcon(FontAwesomeIcons.solidEnvelope, 24, gradientTheme);
    } else {
      emailIcon =
          GradientIcon(FontAwesomeIcons.solidEnvelope, 24, inactiveIconTheme);
    }
    setState(() {});
  }

  _passwordFocusChange() {
    if (_passwordFocus.hasFocus) {
      passwordIcon = GradientIcon(FontAwesomeIcons.key, 24, gradientTheme);
    } else {
      passwordIcon = GradientIcon(FontAwesomeIcons.key, 24, inactiveIconTheme);
    }
    setState(() {});
  }

  _resetEmailFocusChange() {
    if (_resetEmailFocus.hasFocus) {
      resetEmailIcon = Icon(
        FontAwesomeIcons.solidEnvelope,
        color: kMagenta,
        size: 24,
      );
    } else {
      resetEmailIcon = Icon(
        FontAwesomeIcons.solidEnvelope,
        color: Colors.grey,
        size: 24,
      );
    }
    setState(() {});
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
              autocorrect: false,
              focusNode: _emailFocus,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r"\s"))
              ],
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email = value;
                HapticFeedback.lightImpact();
              },
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: emailIcon,
                suffixIcon: IconButton(
                  onPressed: () => _controller.clear(),
                  icon: Icon(Icons.clear),
                  disabledColor: kMagenta,
                  highlightColor: kMagenta,
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
            autocorrect: false,
            focusNode: _passwordFocus,
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) {
              password = value;
              HapticFeedback.lightImpact();
            },
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: passwordIcon,
                hintText: 'Enter your Password',
                hintStyle: TextStyle(color: Colors.grey)),
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
          HapticFeedback.selectionClick();
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

              var userLoggedIn = await UserData().loadUserProfile();
              if (userLoggedIn != null) {
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
        color: Colors.black87,
        child: Text(
          'LOGIN',
          style: TextStyle(
            foreground: Paint()..shader = linearGradient,
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
                color: kLightTheme,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                  foreground: Paint()..shader = linearGradient,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 2.0,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 2.0,
                      color: Colors.black,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Image.asset(
            'images/sheenobiLogo.png',
            width: 400,
            alignment: Alignment.bottomCenter,
          ),
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
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ModalProgressHUD(
            progressIndicator: CircularProgressIndicator(
              backgroundColor: Color(0xFF3A3A39),
              valueColor: new AlwaysStoppedAnimation<Color>(kMagenta),
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
                                  color: kLightTheme,
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
                              _appLogo(),
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
        NetworkStatus(),
      ],
    );
  }
}
