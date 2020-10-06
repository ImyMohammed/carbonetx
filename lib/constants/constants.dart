import 'package:carbonetx/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const kLightTheme = Colors.black;
final kDarkMode = Color(0xFFE8E9EA);

const kYellow = Color(0xffFFC100);
const kMagenta = Color(0xFFf817ea);

final kHintTextStyle = TextStyle(
  color: Colors.grey,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
    foreground: Paint()..shader = lightThemeGradient,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
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
    ]);

final kEmailLabelStyle = TextStyle(
  color: Colors.black45,
  fontWeight: FontWeight.normal,
  fontFamily: 'OpenSans',
);

final kCardStyle = TextStyle(color: Colors.black, fontFamily: 'Credit Card');

final kPageTitle = TextStyle(
  color: Colors.black,
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

kDashTitle(double fontSize) {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    fontSize: fontSize,
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
    ],
  );
}

kDashSubtitle(double fontSize) {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    fontSize: fontSize,
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
    ],
  );
}

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.black87,
  backgroundBlendMode: BlendMode.hardLight,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black54,
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
      Color(0xFFf0f0f0),
      Color(0xFFffffff),
    ],
    stops: [0.4, 1],
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
        HapticFeedback.mediumImpact();
        Toast.show(
          'Logged out.',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          textColor: Color(0xFF03BEFF),
        );
      },
      color: Colors.black87,
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
  "Stealth Wax & Wash",
  "Protection Layer",
  "Showroom Shine",
  "Pay with the App"
];

List<String> dashboardSubtitles = [
  "We'll come to you, whether your car's parked at home or at work.",
  "The Carbanau Wax formula ensures the paintwork is protected.",
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

final Shader linearGradient = LinearGradient(
  colors: <Color>[Color(0xffffc64c), Color(0xfff817ea)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader lightThemeGradient = LinearGradient(
  colors: <Color>[Color(0xff454545), Color(0xff2e2e2e)],
).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final gradientTheme = LinearGradient(
  colors: <Color>[
    Color(0xffffc64c),
    Color(0xfff817ea),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final gradientCardTheme = LinearGradient(
  colors: <Color>[
    Colors.blue,
    Colors.purpleAccent,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
final inactiveIconTheme = LinearGradient(
  colors: <Color>[
    Colors.grey,
    Colors.grey,
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

final kGradientText = TextStyle(
    foreground: Paint()..shader = linearGradient,
    fontFamily: 'OpenSans',
    fontSize: 18,
    fontWeight: FontWeight.bold);
