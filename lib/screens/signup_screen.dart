import 'package:carbonetx/data/user_data.dart';
import 'package:carbonetx/utilities/network_Status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:carbonetx/constants/constants.dart';
import 'package:carbonetx/utilities/firebase_error_handling.dart';
import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:carbonetx/services/stripe.dart';
import 'package:carbonetx/utilities/Gradient_Icon.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;

  FocusNode _firstNameFocus = new FocusNode();
  FocusNode _lastNameFocus = new FocusNode();
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  bool _rememberMe = false;
  String firstName;
  String lastName;
  String email;
  String password;

  Color textColor = Colors.black;

  int curUserId;

  String emailVerified;
  String mobileNumber;
  String mobileNumberVerified;
  String accountType;

  GradientIcon firstNameIcon =
      GradientIcon(FontAwesomeIcons.userAlt, 24, inactiveIconTheme);
  GradientIcon lastNameIcon =
      GradientIcon(FontAwesomeIcons.userAlt, 24, inactiveIconTheme);
  GradientIcon emailIcon =
      GradientIcon(FontAwesomeIcons.solidEnvelope, 24, inactiveIconTheme);
  GradientIcon passwordIcon =
      GradientIcon(FontAwesomeIcons.key, 24, inactiveIconTheme);

  @override
  void initState() {
    super.initState();
    _firstNameFocus.addListener(_firstNameFocusChange);
    _lastNameFocus.addListener(_lastNameFocusChange);
    _emailFocus.addListener(_onEmailFocusChange);
    _passwordFocus.addListener(_passwordFocusChange);
  }

  var _emailController = TextEditingController();
  var _nameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _passwordController = TextEditingController();
  var _mobileNumberController = TextEditingController();

  String errorMessage;
  bool showSpinner = false;

  bool validEmail = false;

  void _firstNameFocusChange() {
    if (_firstNameFocus.hasFocus) {
      firstNameIcon = GradientIcon(FontAwesomeIcons.userAlt, 24, gradientTheme);
    } else {
      firstNameIcon =
          GradientIcon(FontAwesomeIcons.userAlt, 24, inactiveIconTheme);
    }
    setState(() {});
  }

  void _lastNameFocusChange() {
    debugPrint("Focus: " + _lastNameFocus.hasFocus.toString());

    if (_lastNameFocus.hasFocus) {
      lastNameIcon = GradientIcon(FontAwesomeIcons.userAlt, 24, gradientTheme);
      setState(() {});
    } else {
      lastNameIcon =
          GradientIcon(FontAwesomeIcons.userAlt, 24, inactiveIconTheme);
      setState(() {});
    }
  }

  void _onEmailFocusChange() {
    debugPrint("Focus: " + _emailFocus.hasFocus.toString());

    if (_emailFocus.hasFocus) {
      emailIcon =
          GradientIcon(FontAwesomeIcons.solidEnvelope, 24, gradientTheme);
      setState(() {});
    } else {
      emailIcon =
          GradientIcon(FontAwesomeIcons.solidEnvelope, 24, inactiveIconTheme);
      setState(() {});
    }
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

  void _passwordFocusChange() {
    if (_passwordFocus.hasFocus) {
      passwordIcon = GradientIcon(FontAwesomeIcons.key, 24, gradientTheme);
    } else {
      passwordIcon = GradientIcon(FontAwesomeIcons.key, 24, inactiveIconTheme);
    }
  }

  Future<bool> _checkNames() async {
    bool nameValid;
    print('Checking name');
    if (firstName == null || firstName == '') {
      Toast.show(
        'Enter your first name!',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        textColor: Color(0xFFFF0362),
      );
      nameValid = false;
    } else if (lastName == null || lastName == '') {
      Toast.show(
        'Enter your last name!',
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
        textColor: Color(0xFFFF0362),
      );
      nameValid = false;
    } else if (firstName != null && lastName != null) {
      nameValid = true;
    }
    return nameValid;
    print(nameValid);
  }

  Widget _buildBackIcon() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            HapticFeedback.lightImpact();
          },
          child: Icon(
            FontAwesomeIcons.arrowLeft,
            size: 30,
            color: kLightTheme,
          ),
        )
      ],
    );
  }

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            focusNode: _firstNameFocus,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.singleLineFormatter,
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            ],
            controller: _nameController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              firstName = value;
              print(firstName);
              HapticFeedback.lightImpact();
            },
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: firstNameIcon,
              hintText: 'First name',
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLastNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            focusNode: _lastNameFocus,
            inputFormatters: <TextInputFormatter>[
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.singleLineFormatter,
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
            ],
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              lastName = value;
              HapticFeedback.lightImpact();
            },
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: lastNameIcon,
              hintText: 'Last name',
              hintStyle: TextStyle(color: Colors.grey),
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
            autocorrect: false,
            focusNode: _emailFocus,
            inputFormatters: [
              LengthLimitingTextInputFormatter(254),
              FilteringTextInputFormatter.deny(RegExp(r"\s")),
              FilteringTextInputFormatter.deny(RegExp(''))
            ],
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value;
              _emailController.text.replaceAll(RegExp(r"\s "), "");
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
              hintText: 'Enter your Email',
              hintStyle: TextStyle(color: Colors.grey),
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
              HapticFeedback.lightImpact();
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
              hintStyle: TextStyle(color: Colors.grey),
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
            onChanged: (value) {
              password = value;
              HapticFeedback.lightImpact();
            },
            obscureText: true,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: passwordIcon,
              hintText: 'Enter your Password',
              hintStyle: TextStyle(color: Colors.grey),
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
          HapticFeedback.selectionClick();
          if (mounted)
            setState(() {
              showSpinner = true;
            });
          bool nameValid = await _checkNames();
          if (nameValid) {
            try {
              final userLoggedIn = await _auth.createUserWithEmailAndPassword(
                  email: email, password: password);
              print(userLoggedIn.user.uid);
              if (userLoggedIn != null) {
                String stripeId = await StripeServices().createStripeCustomer(
                    email: email,
                    name: '$firstName $lastName',
                    description: 'Account created via CarbonEtx App.');
                String accountId = await StripeServices().createStripeAccount(
                    email: email, firstName: firstName, lastName: lastName);
                await UserData().saveUserDetails(userLoggedIn.user.uid, email,
                    '$firstName $lastName', stripeId, accountId);
                await UserData().getData(userLoggedIn.user.uid);
                HapticFeedback.lightImpact();
                FlutterKeychain.put(key: "carbonetx_email", value: email);
                FlutterKeychain.put(key: "carbonetx_password", value: password);

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
                gravity: Toast.TOP,
                textColor: Colors.greenAccent,
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
            if (mounted)
              setState(() {
                showSpinner = false;
              });
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.black87,
        child: Text(
          'REGISTER',
          style: TextStyle(
              foreground: Paint()..shader = linearGradient,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(0, 0),
                  blurRadius: 5.0,
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(0, 0),
                  blurRadius: 5.0,
                  color: Colors.black,
                ),
              ]),
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
      onTap: () => HapticFeedback.lightImpact(),
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
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Image.asset(
            'images/sheenobiLogo.png',
            width: 250,
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
                              color: kLightTheme,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          _buildNameTF(),
                          SizedBox(height: 10.0),
                          _buildLastNameTF(),
                          SizedBox(height: 10.0),
                          _buildEmailTF(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _buildPasswordTF(),
                          _buildLoginBtn(),
                          _appLogo()
                        ],
                      ),
                    ),
                  ),
                  NetworkStatus(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
