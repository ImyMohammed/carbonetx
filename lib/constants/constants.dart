import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:carbonetx/screens/login_screen.dart';
import 'package:carbonetx/utilities/slide_route.dart';
import 'package:carbonetx/providers/title_data.dart';
import 'package:provider/provider.dart';
import 'package:carbonetx/providers/customer_menu_Navigation.dart';
import 'package:carbonetx/providers/dashboard_info.dart';

final kDarkContrast = Colors.white;
const kDarkColour = Colors.black54;
final kLightContrast = Color(0xFFE8E9EA);

const kYellow = Color(0xffFFC100);
const kCrimson = Color(0xFFFF0362);

final kHintTextStyle = TextStyle(
  color: Colors.black54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: kDarkContrast,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kEmailLabelStyle = TextStyle(
  color: Colors.black45,
  fontWeight: FontWeight.normal,
  fontFamily: 'OpenSans',
);

final kPageTitle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 25,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 1.0,
      color: Colors.black,
    ),
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 1.0,
      color: Colors.black,
    ),
  ],
);

final kDashTitle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 25,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 10.0,
      color: Colors.black,
    ),
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 10.0,
      color: Colors.black,
    ),
  ],
);

final kDashSubtitle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 12,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 10.0,
      color: Colors.black,
    ),
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 10.0,
      color: Colors.black,
    ),
  ],
);

final kBoxDecorationStyle = BoxDecoration(
  color: kDarkContrast,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kAppBackground = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF41357),
      Color(0xFF4D4A4A),
      Color(0xFF212020),
    ],
    stops: [0.15, 0.15, 1],
  ),
);

class LogOutButton extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(FontAwesomeIcons.powerOff),
      onPressed: () {
        Navigator.push(context, SlideRoute(widget: LoginScreen()));
        _auth.signOut();
        FlutterKeychain.remove(key: "sessionID");
        Provider.of<TitleData>(context, listen: false).changeTitle('Dashboard');
        Provider.of<CustomerDashboardData>(context, listen: false)
            .changeStatus(0);
        Provider.of<TitleData>(context, listen: false).changePage(0);
        Provider.of<CustomerDashboardInfoData>(context, listen: false)
            .changeTitle(0);
        Provider.of<DashboardSubtitleData>(context, listen: false)
            .changeInfo(0);
        Toast.show(
          'Logged out.',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Color(0xFF03BEFF),
        );
      },
      color: Colors.white,
    );
  }
}

List<String> images = [
  "images/image1.png",
  "images/image2.png",
  "images/image3.png",
  "images/image4.png",
];

List<String> dashboardTitles = [
  "At home? Work?",
  "Protection Layer",
  "Showroom Shine",
  "Pay with the App"
];

List<String> dashboardSubtitles = [
  "We'll come to your car, whether its parked at home or at work.",
  "Our Carnauba Wax ensures the paintwork is protected too.",
  "Brilliant shine and gloss effect on metal, glass, firbreglass etc, surfaces.",
  "No need to pay in person, we'll be there an gone before you know it."
];

final kBookButton = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 15,
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 1.0,
      color: Colors.black,
    ),
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 1.0,
      color: Colors.black,
    ),
  ],
);

final kAddCarFields = BoxDecoration(
  color: Colors.black54,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
