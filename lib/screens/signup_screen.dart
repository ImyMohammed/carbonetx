import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/utilities/firebase_error_handling.dart';
import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  FocusNode _focus = new FocusNode();
  final _fireStore = Firestore.instance;

  bool _rememberMe = false;
  String name;
  String email;
  String password;

  Color textColor = Colors.black;

  int curUserId;

  String emailVerified;
  String mobileNumber;
  String mobileNumberVerified;
  String accountType;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  var _emailController = TextEditingController();
  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _mobileNumberController = TextEditingController();

  String errorMessage;
  bool showSpinner = false;

  bool validEmail = false;

  void _onFocusChange() {
    debugPrint("Focus: " + _focus.hasFocus.toString());

    if (email != null) {
      if (EmailValidator.validate(email) != true) {
        Toast.show(
          'Enter valid e-mail example@example.com',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          textColor: Color(0xFFFF0362),
        );
        _emailController.clear();
        email = null;
        HapticFeedback.mediumImpact();
      }
    }
  }

  Widget _buildBackIcon() {
    return Row(
      children: <Widget>[
        BackButton(
          color: Colors.white,
        )
      ],
    );
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(10),
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
              BlacklistingTextInputFormatter.singleLineFormatter,
            ],
            controller: _nameController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              name = value;
            },
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black54,
              ),
              hintText: 'Enter your name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
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
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            focusNode: _focus,
            inputFormatters: [
              LengthLimitingTextInputFormatter(254),
              BlacklistingTextInputFormatter(RegExp(r"\s")),
              BlacklistingTextInputFormatter(RegExp(''))
            ],
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value;
              _emailController.text.replaceAll(RegExp(r"\s "), "");
            },
            style: TextStyle(
              color: textColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black54,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mobile Number',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _mobileNumberController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              mobileNumber = value;
            },
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.black54,
              ),
              hintText: 'Enter your Mob No.',
              hintStyle: kHintTextStyle,
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
            onChanged: (value) {
              password = value;
            },
            obscureText: true,
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
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
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
          if (mounted)
            setState(() {
              showSpinner = true;
            });
          if (name != null) {
            try {
              final userLoggedIn = await _auth.createUserWithEmailAndPassword(
                  email: email, password: password);
              if (userLoggedIn != null) {
                _fireStore.collection('users').document(email).setData({
                  'accountType': 'customer',
                  'email': '$email',
                  'mobileNumber': 'Enter your Mob No.',
                  'name': '$name',
                });
                HapticFeedback.lightImpact();
                FlutterKeychain.put(key: "carbonetx_email", value: email);
                FlutterKeychain.put(key: "carbonetx_password", value: password);
                /*email = null;
                password = null;
                name = null;*/
                Navigator.pushNamed(context, DashboardScreen.id);
                _emailController.clear();
                _nameController.clear();
                _passwordController.clear();
                if (mounted)
                  setState(() {
                    showSpinner = false;
                  });
              }
              setState(() {
                showSpinner = false;
              });
              Toast.show(
                'Registration successful!',
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                textColor: Color(0xFF03BEFF),
              );
            } catch (error) {
              errorMessage = error.toString();
              print(errorMessage);
              firebaseAuthHandler(errorMessage);
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
          } else {
            Toast.show(
              'Enter your name',
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
          'REGISTER',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
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
            progressIndicator: Loading(
              indicator: LineScalePulseOutIndicator(),
              color: kCrimson,
            ),
            inAsyncCall: showSpinner,
            color: Colors.black,
            dismissible: false,
            opacity: 0.7,
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
                        vertical: 70.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildBackIcon(),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          _buildNameTF(),
                          SizedBox(height: 10.0),
                          _buildEmailTF(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildPasswordTF(),
                          _buildLoginBtn(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
